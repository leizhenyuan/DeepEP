// ============================================================================
// Named Barrier (nbarrier) 测试文件
// ============================================================================
//
// Intel GPU Named Barrier 详解：
//
// 1. 什么是 Named Barrier？
//    Named barrier 是 Intel GPU ISA 原生的同步原语（opcode 0x60），允许
//    workgroup 内任意子集的 sub-group（硬件线程）进行同步。
//    与 CUDA 的 bar.sync 等价。
//
// 2. 关键概念：
//    - barrier id: 0-31，每个 workgroup 最多 32 个命名屏障
//    - n_threads: 参与同步的 sub-group 数量（不是 work-item 数）
//    - signal: 通知 "我到达了同步点"
//    - wait: 阻塞直到所有参与者都 signal
//    - type: 0=producer-consumer, 1=producer-only, 2=consumer-only
//
// 3. 操作模式：
//    a) Baseline form: nbarrier.signal <id> <n_threads>
//       所有参与线程既是 producer 也是 consumer
//       n_producers = n_consumers = n_threads
//
//    b) General form: nbarrier.signal <id> <type> <n_producers> <n_consumers>
//       显式指定 producer/consumer 角色和数量
//
//    c) Wait: nbarrier.wait <id>
//       只有 consumer 线程需要 wait
//
// 4. 使用约束：
//    - 必须先调用 named_barrier_init<N>() 声明使用 N 个屏障
//    - 所有参与线程必须使用相同的 id、n_threads/n_producers/n_consumers
//    - barrier id 在所有线程 wait 完成后可以被复用
//    - 只能在 thread-group (workgroup) execution model 下使用
//
// 5. 与 item.barrier() / sub_group.barrier() 的区别：
//    - item.barrier(): 同步整个 workgroup 的所有 work-item
//    - sub_group.barrier(): 只同步一个 sub-group 内的 work-item
//    - nbarrier: 同步跨越多个 sub-group 的任意子集
//
// 编译命令：
//    icpx -fsycl -O2 test_nbarrier.cpp -o test_nbarrier
//
// 如果需要 AOT 编译到 BMG：
//    icpx -fsycl -fsycl-targets=intel_gpu_bmg -O2 test_nbarrier.cpp -o test_nbarrier
//
// ============================================================================

#include <sycl/sycl.hpp>
#include <iostream>
#include <vector>
#include <cstring>
#include <cassert>
#include <cstdlib>

// Sub-group size: Intel GPUs support 16 or 32
// BMG (Battlemage) typically uses 16 or 32
#define SG_SZ 16

// ============================================================================
// Named Barrier 工具函数
// ============================================================================

// 初始化命名屏障数量，必须在 kernel 开头调用
// N: 需要的命名屏障数量 (1-32)
//
// 这个函数告诉 IGC 编译器为此 kernel 分配 N 个命名屏障资源。
// 编译器会将此信息编码到 kernel 的 INTERFACE_DESCRIPTOR_DATA 中。
template <int N>
static inline void named_barrier_init() {
#if defined(__SYCL_DEVICE_ONLY__)
    // IGC 编译器识别此伪指令，在 kernel metadata 中设置 barrier count
    asm volatile ("\n"
        "named_barrier_init %0\n"
        :: "i"(N)
    );
#endif
}

// Baseline signal: 所有参与者都是 producer-consumer
// id: barrier id (0-31)
// n_threads: 参与的 sub-group 数量
//
// 语义：当前 sub-group 已到达同步点。
//       当所有 n_threads 个 sub-group 都 signal 后，wait 会返回。
//
// 注意：n_threads 是 sub-group 数量，不是 work-item 数量！
//       例如 4 个 sub-group 参与，n_threads = 4
static inline void nbarrier_signal(uint8_t id, uint8_t n_threads) {
#if defined(__SYCL_DEVICE_ONLY__)
    asm volatile (
        "nbarrier.signal %0 %1\n"
        :: "rw"(id), "rw"(n_threads)
    );
#endif
}

// Wait on a named barrier
// id: barrier id (0-31)
//
// 语义：阻塞当前 sub-group，直到 barrier id 上的所有 producer
//       和 consumer 都完成了 signal。
//
// 只有 consumer 线程才能调用 wait。
// 在 baseline form 中，所有线程都是 producer-consumer，所以都 signal+wait。
static inline void nbarrier_wait(uint8_t id) {
#if defined(__SYCL_DEVICE_ONLY__)
    asm volatile (
        "nbarrier.wait %0\n"
        :: "rw"(id)
    );
#endif
}

// General signal: 显式指定 type, n_producers, n_consumers
// id: barrier id (0-31)
// type: 0=producer-consumer, 1=producer-only, 2=consumer-only
// n_producers: producer sub-group 数量
// n_consumers: consumer sub-group 数量
//
// 使用场景：当 producer 和 consumer 数量不同时。
// 例如：1 个 producer 写数据，4 个 consumer 读数据
//       producer: nbarrier_signal_general(id, 1, 1, 4)
//       每个consumer: nbarrier_signal_general(id, 2, 1, 4)  然后 nbarrier_wait(id)
static inline void nbarrier_signal_general(uint8_t id, uint8_t type,
                                           uint8_t n_producers, uint8_t n_consumers) {
#if defined(__SYCL_DEVICE_ONLY__)
    asm volatile (
        "nbarrier.signal %0 %1 %2 %3\n"
        :: "rw"(id), "rw"(type), "rw"(n_producers), "rw"(n_consumers)
    );
#endif
}

// ============================================================================
// 辅助函数
// ============================================================================

static void print_separator(const char* title) {
    std::cout << "\n========================================" << std::endl;
    std::cout << "  " << title << std::endl;
    std::cout << "========================================" << std::endl;
}

// ============================================================================
// Test 1: 基本同步 — 所有 sub-group 在同一个 barrier 上同步
// ============================================================================
//
// 场景：workgroup 内所有 sub-group 在一个 named barrier 上做全局同步
// 等价于 item.barrier()，但用 nbarrier 实现
//
// 验证：
//   Phase 1: 每个 sub-group 写入 SLM[sg_id] = sg_id + 1
//   Barrier
//   Phase 2: 每个 sub-group 读取 SLM[(sg_id + 1) % n_sg]
//   如果 barrier 正确，读到的值 == (sg_id + 1) % n_sg + 1
//
struct Test1_BasicSync {
    int* output;  // global memory output for verification
    
    void operator() [[sycl::reqd_sub_group_size(SG_SZ)]] (sycl::nd_item<1> item) const {
#if defined(__SYCL_DEVICE_ONLY__)
        auto sg = item.get_sub_group();
        auto sg_id = sg.get_group_id()[0];
        auto sg_lid = sg.get_local_linear_id();
        auto n_sg = sg.get_group_range()[0];
        auto group_id = item.get_group(0);

        // 分配 1 个 named barrier
        named_barrier_init<1>();
        
        // 使用 SLM (Shared Local Memory) 作为通信媒介
        // 这里用 output 数组的 group 段代替 SLM 来简化
        int* group_buf = output + group_id * n_sg * 2;  // 每个 group 的缓冲区
        
        // Phase 1：每个 sub-group 的 lane 0 写入
        if (sg_lid == 0) {
            group_buf[sg_id] = sg_id + 1;
        }
        
        // 用 named barrier 同步所有 sub-group
        // n_threads = 总的 sub-group 数量
        nbarrier_signal(0, static_cast<uint8_t>(n_sg));
        nbarrier_wait(0);
        
        // Phase 2：每个 sub-group 读取相邻 sub-group 写入的值
        if (sg_lid == 0) {
            int read_idx = (sg_id + 1) % n_sg;
            int value = group_buf[read_idx];
            // 将结果写入 output 的后半部分
            group_buf[n_sg + sg_id] = value;
        }
#endif
    }
};

bool run_test1(sycl::queue& q, int n_subgroups) {
    print_separator("Test 1: Basic Sync (all sub-groups, 1 barrier)");
    
    int n_groups = 1;
    int total_wis = n_groups * n_subgroups * SG_SZ;
    int buf_size = n_groups * n_subgroups * 2;  // n_sg writes + n_sg reads per group
    
    int* output = sycl::malloc_device<int>(buf_size, q);
    q.memset(output, 0, buf_size * sizeof(int)).wait();
    
    std::cout << "  Config: " << n_groups << " group(s), "
              << n_subgroups << " sub-groups, "
              << SG_SZ << " lanes/sub-group" << std::endl;
    
    try {
        q.submit([&](sycl::handler& h) {
            h.parallel_for(
                sycl::nd_range<1>(sycl::range<1>(total_wis), sycl::range<1>(n_subgroups * SG_SZ)),
                Test1_BasicSync{output}
            );
        }).wait();
    } catch (sycl::exception const& e) {
        std::cerr << "  SYCL exception: " << e.what() << std::endl;
        sycl::free(output, q);
        return false;
    }
    
    // 验证结果
    std::vector<int> host_out(buf_size);
    q.memcpy(host_out.data(), output, buf_size * sizeof(int)).wait();
    sycl::free(output, q);
    
    bool pass = true;
    for (int g = 0; g < n_groups; ++g) {
        for (int sg = 0; sg < n_subgroups; ++sg) {
            int read_idx = (sg + 1) % n_subgroups;
            int expected = read_idx + 1;
            int actual = host_out[g * n_subgroups * 2 + n_subgroups + sg];
            if (actual != expected) {
                std::cerr << "  FAIL: group=" << g << " sg=" << sg
                          << " expected=" << expected << " got=" << actual << std::endl;
                pass = false;
            }
        }
    }
    
    std::cout << "  Result: " << (pass ? "PASS" : "FAIL") << std::endl;
    return pass;
}

// ============================================================================
// Test 2: 独立分组同步 — 不同 sub-group 子集使用不同的 barrier
// ============================================================================
//
// 场景：将 workgroup 的 sub-group 分成 N_BARRIERS 组，
//       每组在自己的 barrier 上独立同步
// 这是 DeepEP dispatch kernel 最需要的模式：
//       sender 和 receiver 独立同步
//
// 验证：
//   Phase 1: group K 的 sub-group 写入 SLM[K * group_size + local_id] = value
//   Barrier K
//   Phase 2: group K 的 sub-group 读取同组其他 sub-group 写入的值
//
struct Test2_IndependentGroups {
    int* output;
    int n_barriers;
    
    void operator() [[sycl::reqd_sub_group_size(SG_SZ)]] (sycl::nd_item<1> item) const {
#if defined(__SYCL_DEVICE_ONLY__)
        auto sg = item.get_sub_group();
        auto sg_id = sg.get_group_id()[0];
        auto sg_lid = sg.get_local_linear_id();
        auto n_sg = sg.get_group_range()[0];
        
        // 初始化 n_barriers 个命名屏障
        // 注意：模板参数必须是编译时常量，这里用 4 作为最大值
        named_barrier_init<4>();
        
        // 将 sub-group 分成 n_barriers 个组
        int sgs_per_barrier = n_sg / n_barriers;
        int my_barrier_id = sg_id / sgs_per_barrier;
        int my_local_sg_id = sg_id % sgs_per_barrier;
        
        // 确保 barrier id 在范围内
        if (my_barrier_id >= n_barriers) return;
        
        // Phase 1: 写入
        if (sg_lid == 0) {
            output[my_barrier_id * sgs_per_barrier + my_local_sg_id] = 
                my_barrier_id * 100 + my_local_sg_id + 1;
        }
        
        // 在自己组的 barrier 上同步
        nbarrier_signal(static_cast<uint8_t>(my_barrier_id), 
                       static_cast<uint8_t>(sgs_per_barrier));
        nbarrier_wait(static_cast<uint8_t>(my_barrier_id));
        
        // Phase 2: 读取同组相邻 sub-group 的值
        if (sg_lid == 0) {
            int read_idx = (my_local_sg_id + 1) % sgs_per_barrier;
            int value = output[my_barrier_id * sgs_per_barrier + read_idx];
            // 写入验证区
            output[n_sg + sg_id] = value;
        }
#endif
    }
};

bool run_test2(sycl::queue& q, int n_subgroups, int n_barriers) {
    print_separator("Test 2: Independent Groups (multiple barriers)");
    
    int buf_size = n_subgroups * 2;
    int total_wis = n_subgroups * SG_SZ;
    
    int* output = sycl::malloc_device<int>(buf_size, q);
    q.memset(output, 0, buf_size * sizeof(int)).wait();
    
    std::cout << "  Config: " << n_subgroups << " sub-groups, "
              << n_barriers << " barriers, "
              << (n_subgroups / n_barriers) << " sub-groups/barrier" << std::endl;
    
    try {
        q.submit([&](sycl::handler& h) {
            h.parallel_for(
                sycl::nd_range<1>(sycl::range<1>(total_wis), sycl::range<1>(total_wis)),
                Test2_IndependentGroups{output, n_barriers}
            );
        }).wait();
    } catch (sycl::exception const& e) {
        std::cerr << "  SYCL exception: " << e.what() << std::endl;
        sycl::free(output, q);
        return false;
    }
    
    std::vector<int> host_out(buf_size);
    q.memcpy(host_out.data(), output, buf_size * sizeof(int)).wait();
    sycl::free(output, q);
    
    int sgs_per_barrier = n_subgroups / n_barriers;
    bool pass = true;
    for (int sg = 0; sg < n_subgroups; ++sg) {
        int barrier_id = sg / sgs_per_barrier;
        int local_id = sg % sgs_per_barrier;
        int read_idx = (local_id + 1) % sgs_per_barrier;
        int expected = barrier_id * 100 + read_idx + 1;
        int actual = host_out[n_subgroups + sg];
        if (actual != expected) {
            std::cerr << "  FAIL: sg=" << sg << " barrier=" << barrier_id
                      << " expected=" << expected << " got=" << actual << std::endl;
            pass = false;
        }
    }
    
    std::cout << "  Result: " << (pass ? "PASS" : "FAIL") << std::endl;
    return pass;
}

// ============================================================================
// Test 3: Producer-Consumer 模式
// ============================================================================
//
// 场景：模拟 dispatch kernel 的 sender-receiver 模式
//   - Producer sub-groups: 写入数据到 buffer
//   - Consumer sub-groups: 等待数据就绪后读取
//
// 这直接对应 DeepEP dispatch 中：
//   - sender warp 写入 channel buffer
//   - receiver warp 等待数据到达后接收
//
// 使用 nbarrier 替代当前的 ld_volatile + spin-wait 轮询
//
struct Test3_ProducerConsumer {
    int* shared_buffer;  // 生产者写，消费者读
    int* output;         // 消费者验证结果
    int n_producers;     // producer sub-group 数量
    int n_consumers;     // consumer sub-group 数量
    int data_per_producer;  // 每个 producer 写多少个 int
    
    void operator() [[sycl::reqd_sub_group_size(SG_SZ)]] (sycl::nd_item<1> item) const {
#if defined(__SYCL_DEVICE_ONLY__)
        auto sg = item.get_sub_group();
        auto sg_id = sg.get_group_id()[0];
        auto sg_lid = sg.get_local_linear_id();
        auto n_sg = sg.get_group_range()[0];
        
        named_barrier_init<1>();
        
        bool is_producer = (sg_id < static_cast<uint32_t>(n_producers));
        int total_participants = n_producers + n_consumers;
        
        if (is_producer) {
            // ===== Producer: 写入数据 =====
            int base = sg_id * data_per_producer;
            for (int i = static_cast<int>(sg_lid); i < data_per_producer; i += SG_SZ) {
                // 写入 magic value: producer_id * 1000 + offset
                shared_buffer[base + i] = sg_id * 1000 + i;
            }
        }
        
        // 所有 producer 和 consumer 在 barrier 上同步
        // Baseline form: 所有参与者 signal + wait
        nbarrier_signal(0, static_cast<uint8_t>(total_participants));
        nbarrier_wait(0);
        
        if (!is_producer) {
            // ===== Consumer: 读取并验证数据 =====
            int consumer_id = sg_id - n_producers;
            // 每个 consumer 读取对应 producer 的数据
            int producer_to_read = consumer_id % n_producers;
            int base = producer_to_read * data_per_producer;
            
            int errors = 0;
            for (int i = static_cast<int>(sg_lid); i < data_per_producer; i += SG_SZ) {
                int expected = producer_to_read * 1000 + i;
                int actual = shared_buffer[base + i];
                if (actual != expected) errors++;
            }
            
            // Lane 0 汇总错误数
            // 使用 sub-group reduce
            errors = sycl::reduce_over_group(sg, errors, sycl::plus<int>());
            
            if (sg_lid == 0) {
                // 0 = no errors, >0 = has errors
                output[consumer_id] = errors;
            }
        }
#endif
    }
};

bool run_test3(sycl::queue& q, int n_producers, int n_consumers) {
    print_separator("Test 3: Producer-Consumer Pattern");
    
    int data_per_producer = 64;  // 每个 producer 写 64 个 int
    int buffer_size = n_producers * data_per_producer;
    int n_total = n_producers + n_consumers;
    int total_wis = n_total * SG_SZ;
    
    int* shared_buffer = sycl::malloc_device<int>(buffer_size, q);
    int* output = sycl::malloc_device<int>(n_consumers, q);
    q.memset(shared_buffer, 0, buffer_size * sizeof(int)).wait();
    q.memset(output, -1, n_consumers * sizeof(int)).wait();
    
    std::cout << "  Config: " << n_producers << " producers, "
              << n_consumers << " consumers, "
              << data_per_producer << " ints/producer" << std::endl;
    
    try {
        q.submit([&](sycl::handler& h) {
            h.parallel_for(
                sycl::nd_range<1>(sycl::range<1>(total_wis), sycl::range<1>(total_wis)),
                Test3_ProducerConsumer{shared_buffer, output, n_producers, n_consumers, data_per_producer}
            );
        }).wait();
    } catch (sycl::exception const& e) {
        std::cerr << "  SYCL exception: " << e.what() << std::endl;
        sycl::free(shared_buffer, q);
        sycl::free(output, q);
        return false;
    }
    
    std::vector<int> host_out(n_consumers);
    q.memcpy(host_out.data(), output, n_consumers * sizeof(int)).wait();
    sycl::free(shared_buffer, q);
    sycl::free(output, q);
    
    bool pass = true;
    for (int i = 0; i < n_consumers; ++i) {
        if (host_out[i] != 0) {
            std::cerr << "  FAIL: consumer " << i << " found " << host_out[i] << " errors" << std::endl;
            pass = false;
        }
    }
    
    std::cout << "  Result: " << (pass ? "PASS" : "FAIL") << std::endl;
    return pass;
}

// ============================================================================
// Test 4: 多阶段流水线 (Pipeline) — nbarrier 复用
// ============================================================================
//
// 场景：模拟 dispatch kernel 的多阶段同步：
//   Phase 0: notify (统计 token 分布)
//   Phase 1: dispatch (发送数据)
//   Phase 2: combine (合并结果)
//
// 每个 phase 结束后用 nbarrier 同步，然后复用同一个 barrier
// 这验证了 "barrier id 在所有线程 wait 完成后可以被复用" 的语义
//
struct Test4_Pipeline {
    int* buffer;   // 工作缓冲区
    int* output;   // 最终结果
    int n_phases;  // 流水线阶段数
    
    void operator() [[sycl::reqd_sub_group_size(SG_SZ)]] (sycl::nd_item<1> item) const {
#if defined(__SYCL_DEVICE_ONLY__)
        auto sg = item.get_sub_group();
        auto sg_id = sg.get_group_id()[0];
        auto sg_lid = sg.get_local_linear_id();
        auto n_sg = sg.get_group_range()[0];
        
        named_barrier_init<1>();
        
        for (int phase = 0; phase < n_phases; ++phase) {
            // 每个 sub-group 在 Phase 中写入 buffer[sg_id] += phase_contribution
            if (sg_lid == 0) {
                buffer[sg_id] += (phase + 1) * (sg_id + 1);
            }
            
            // 同步：复用 barrier 0
            nbarrier_signal(0, static_cast<uint8_t>(n_sg));
            nbarrier_wait(0);
            
            // 每个 sub-group 读取所有其他 sub-group 的值，计算 checksum
            // （验证所有写入在 barrier 后可见）
            if (sg_lid == 0 && phase == n_phases - 1) {
                int sum = 0;
                for (uint32_t i = 0; i < n_sg; ++i) {
                    sum += buffer[i];
                }
                output[sg_id] = sum;
            }
        }
#endif
    }
};

bool run_test4(sycl::queue& q, int n_subgroups, int n_phases) {
    print_separator("Test 4: Multi-phase Pipeline (barrier reuse)");
    
    int total_wis = n_subgroups * SG_SZ;
    
    int* buffer = sycl::malloc_device<int>(n_subgroups, q);
    int* output = sycl::malloc_device<int>(n_subgroups, q);
    q.memset(buffer, 0, n_subgroups * sizeof(int)).wait();
    q.memset(output, 0, n_subgroups * sizeof(int)).wait();
    
    std::cout << "  Config: " << n_subgroups << " sub-groups, "
              << n_phases << " phases" << std::endl;
    
    try {
        q.submit([&](sycl::handler& h) {
            h.parallel_for(
                sycl::nd_range<1>(sycl::range<1>(total_wis), sycl::range<1>(total_wis)),
                Test4_Pipeline{buffer, output, n_phases}
            );
        }).wait();
    } catch (sycl::exception const& e) {
        std::cerr << "  SYCL exception: " << e.what() << std::endl;
        sycl::free(buffer, q);
        sycl::free(output, q);
        return false;
    }
    
    std::vector<int> host_out(n_subgroups);
    q.memcpy(host_out.data(), output, n_subgroups * sizeof(int)).wait();
    sycl::free(buffer, q);
    sycl::free(output, q);
    
    // 计算期望值
    // 每个 sg_id 在 n_phases 个阶段累积: sum over phase of (phase+1)*(sg_id+1)
    // = (sg_id + 1) * sum(1..n_phases)
    // = (sg_id + 1) * n_phases * (n_phases + 1) / 2
    // 总和 = sum over sg_id of above = n_phases*(n_phases+1)/2 * sum(1..n_subgroups)
    //       = n_phases*(n_phases+1)/2 * n_subgroups*(n_subgroups+1)/2
    int expected_sum = 0;
    for (int sg = 0; sg < n_subgroups; ++sg) {
        expected_sum += (sg + 1) * n_phases * (n_phases + 1) / 2;
    }
    
    bool pass = true;
    for (int sg = 0; sg < n_subgroups; ++sg) {
        if (host_out[sg] != expected_sum) {
            std::cerr << "  FAIL: sg=" << sg << " expected=" << expected_sum
                      << " got=" << host_out[sg] << std::endl;
            pass = false;
        }
    }
    
    std::cout << "  Result: " << (pass ? "PASS" : "FAIL") << std::endl;
    return pass;
}

// ============================================================================
// Test 5: Sender/Receiver 分组同步 (模拟 dispatch kernel 的核心模式)
// ============================================================================
//
// 直接模拟 dispatch kernel 的关键架构：
//   - 偶数 sub-group: sender，将数据复制到 channel buffer
//   - 奇数 sub-group: receiver，从 channel buffer 读取数据
//   - 每对 (sender, receiver) 使用独立的 barrier
//
// 这对应 dispatch kernel 中：
//   sm_id % 2 == 0 → sender
//   sm_id % 2 == 1 → receiver
//
struct Test5_SenderReceiver {
    int* channel_buffers;  // 模拟 dispatch 的 channel buffer
    int* output;           // 接收验证结果
    int items_per_channel; // 每个 channel 传输的数据量
    
    void operator() [[sycl::reqd_sub_group_size(SG_SZ)]] (sycl::nd_item<1> item) const {
#if defined(__SYCL_DEVICE_ONLY__)
        auto sg = item.get_sub_group();
        auto sg_id = sg.get_group_id()[0];
        auto sg_lid = sg.get_local_linear_id();
        auto n_sg = sg.get_group_range()[0];
        
        // 每对 sender+receiver 使用一个 barrier
        int n_channels = n_sg / 2;
        named_barrier_init<4>();  // 最多 4 个 channel 对
        
        bool is_sender = (sg_id % 2 == 0);
        int channel_id = sg_id / 2;
        uint8_t barrier_id = static_cast<uint8_t>(channel_id);
        
        if (channel_id >= n_channels) return;
        
        int* my_buffer = channel_buffers + channel_id * items_per_channel;
        
        if (is_sender) {
            // Sender: 写入数据到 channel buffer
            for (int i = static_cast<int>(sg_lid); i < items_per_channel; i += SG_SZ) {
                my_buffer[i] = channel_id * 10000 + i;
            }
        }
        
        // Sender 和对应的 Receiver 在同一个 barrier 上同步
        // 每个 barrier 有 2 个参与者（1 sender + 1 receiver）
        nbarrier_signal(barrier_id, 2);
        nbarrier_wait(barrier_id);
        
        if (!is_sender) {
            // Receiver: 从 channel buffer 读取并验证
            int errors = 0;
            for (int i = static_cast<int>(sg_lid); i < items_per_channel; i += SG_SZ) {
                int expected = channel_id * 10000 + i;
                if (my_buffer[i] != expected) errors++;
            }
            
            errors = sycl::reduce_over_group(sg, errors, sycl::plus<int>());
            if (sg_lid == 0) {
                output[channel_id] = errors;
            }
        }
#endif
    }
};

bool run_test5(sycl::queue& q, int n_channels) {
    print_separator("Test 5: Sender/Receiver Pattern (dispatch-like)");
    
    int items_per_channel = 128;
    int n_subgroups = n_channels * 2;  // sender + receiver per channel
    int total_wis = n_subgroups * SG_SZ;
    int buffer_size = n_channels * items_per_channel;
    
    int* channel_buffers = sycl::malloc_device<int>(buffer_size, q);
    int* output = sycl::malloc_device<int>(n_channels, q);
    q.memset(channel_buffers, 0, buffer_size * sizeof(int)).wait();
    q.memset(output, -1, n_channels * sizeof(int)).wait();
    
    std::cout << "  Config: " << n_channels << " channels (sender/receiver pairs), "
              << items_per_channel << " items/channel" << std::endl;
    
    try {
        q.submit([&](sycl::handler& h) {
            h.parallel_for(
                sycl::nd_range<1>(sycl::range<1>(total_wis), sycl::range<1>(total_wis)),
                Test5_SenderReceiver{channel_buffers, output, items_per_channel}
            );
        }).wait();
    } catch (sycl::exception const& e) {
        std::cerr << "  SYCL exception: " << e.what() << std::endl;
        sycl::free(channel_buffers, q);
        sycl::free(output, q);
        return false;
    }
    
    std::vector<int> host_out(n_channels);
    q.memcpy(host_out.data(), output, n_channels * sizeof(int)).wait();
    sycl::free(channel_buffers, q);
    sycl::free(output, q);
    
    bool pass = true;
    for (int i = 0; i < n_channels; ++i) {
        if (host_out[i] != 0) {
            std::cerr << "  FAIL: channel " << i << " found " << host_out[i] << " errors" << std::endl;
            pass = false;
        }
    }
    
    std::cout << "  Result: " << (pass ? "PASS" : "FAIL") << std::endl;
    return pass;
}

// ============================================================================
// Test 6: 大规模同步 — 多 barrier + 多 sub-group (接近 dispatch kernel 规模)
// ============================================================================
//
// 模拟 rank=4 的 dispatch kernel 配置：
//   - 4 组 sender（每组多个 sub-group），共享数据到 4 个 rank 的 buffer
//   - 4 组 receiver（每组多个 sub-group），接收来自各 rank 的数据
//   - 每个 sender-receiver 组内用一个 barrier 同步
//
struct Test6_MultiRankSync {
    int* buffers;       // [n_ranks * data_per_rank]
    int* output;        // [n_ranks] error counts
    int n_ranks;
    int sgs_per_rank;
    int data_per_rank;
    
    void operator() [[sycl::reqd_sub_group_size(SG_SZ)]] (sycl::nd_item<1> item) const {
#if defined(__SYCL_DEVICE_ONLY__)
        auto sg = item.get_sub_group();
        auto sg_id = sg.get_group_id()[0];
        auto sg_lid = sg.get_local_linear_id();
        
        named_barrier_init<4>();
        
        // 每个 rank 有 sgs_per_rank 个 sender + sgs_per_rank 个 receiver
        // 总 sub-group = n_ranks * sgs_per_rank * 2
        int rank_group_size = sgs_per_rank * 2;
        int my_rank = sg_id / rank_group_size;
        int my_local_id = sg_id % rank_group_size;
        bool is_sender = (my_local_id < sgs_per_rank);
        int my_sg_in_rank = is_sender ? my_local_id : (my_local_id - sgs_per_rank);
        
        if (my_rank >= n_ranks) return;
        
        uint8_t barrier_id = static_cast<uint8_t>(my_rank);
        int* rank_buffer = buffers + my_rank * data_per_rank;
        
        if (is_sender) {
            // 每个 sender sub-group 写入自己的部分
            int per_sg = data_per_rank / sgs_per_rank;
            int start = my_sg_in_rank * per_sg;
            for (int i = static_cast<int>(sg_lid); i < per_sg; i += SG_SZ) {
                rank_buffer[start + i] = my_rank * 100000 + start + i;
            }
        }
        
        // 同组的所有 sender + receiver 同步
        nbarrier_signal(barrier_id, static_cast<uint8_t>(rank_group_size));
        nbarrier_wait(barrier_id);
        
        if (!is_sender) {
            // 每个 receiver sub-group 验证自己的部分
            int per_sg = data_per_rank / sgs_per_rank;
            int start = my_sg_in_rank * per_sg;
            int errors = 0;
            for (int i = static_cast<int>(sg_lid); i < per_sg; i += SG_SZ) {
                int expected = my_rank * 100000 + start + i;
                if (rank_buffer[start + i] != expected) errors++;
            }
            errors = sycl::reduce_over_group(sg, errors, sycl::plus<int>());
            if (sg_lid == 0) {
                // Atomic add to output (multiple receiver SGs per rank)
                auto ref = sycl::atomic_ref<int, sycl::memory_order::relaxed,
                                            sycl::memory_scope::device,
                                            sycl::access::address_space::global_space>(output[my_rank]);
                ref.fetch_add(errors);
            }
        }
#endif
    }
};

bool run_test6(sycl::queue& q, int n_ranks, int sgs_per_rank) {
    print_separator("Test 6: Multi-rank Sync (dispatch-scale)");
    
    int data_per_rank = sgs_per_rank * SG_SZ * 4;  // 可被 sgs_per_rank 和 SG_SZ 整除
    int buffer_size = n_ranks * data_per_rank;
    int n_subgroups = n_ranks * sgs_per_rank * 2;
    int total_wis = n_subgroups * SG_SZ;
    
    int* buffers = sycl::malloc_device<int>(buffer_size, q);
    int* output = sycl::malloc_device<int>(n_ranks, q);
    q.memset(buffers, 0, buffer_size * sizeof(int)).wait();
    q.memset(output, 0, n_ranks * sizeof(int)).wait();
    
    std::cout << "  Config: " << n_ranks << " ranks, "
              << sgs_per_rank << " sub-groups/rank/role, "
              << data_per_rank << " ints/rank" << std::endl;
    
    try {
        q.submit([&](sycl::handler& h) {
            h.parallel_for(
                sycl::nd_range<1>(sycl::range<1>(total_wis), sycl::range<1>(total_wis)),
                Test6_MultiRankSync{buffers, output, n_ranks, sgs_per_rank, data_per_rank}
            );
        }).wait();
    } catch (sycl::exception const& e) {
        std::cerr << "  SYCL exception: " << e.what() << std::endl;
        sycl::free(buffers, q);
        sycl::free(output, q);
        return false;
    }
    
    std::vector<int> host_out(n_ranks);
    q.memcpy(host_out.data(), output, n_ranks * sizeof(int)).wait();
    sycl::free(buffers, q);
    sycl::free(output, q);
    
    bool pass = true;
    for (int r = 0; r < n_ranks; ++r) {
        if (host_out[r] != 0) {
            std::cerr << "  FAIL: rank " << r << " found " << host_out[r] << " errors" << std::endl;
            pass = false;
        }
    }
    
    std::cout << "  Result: " << (pass ? "PASS" : "FAIL") << std::endl;
    return pass;
}

// ============================================================================
// Main
// ============================================================================

int main(int argc, char* argv[]) {
    std::cout << "Named Barrier (nbarrier) Test Suite" << std::endl;
    std::cout << "Sub-group size: " << SG_SZ << std::endl;
    
    // 选择设备
    sycl::queue q;
    try {
        q = sycl::queue(sycl::gpu_selector_v, 
                        sycl::property_list{sycl::property::queue::in_order{}});
    } catch (...) {
        std::cerr << "No GPU device found, using default device." << std::endl;
        q = sycl::queue(sycl::property_list{sycl::property::queue::in_order{}});
    }
    
    auto dev = q.get_device();
    std::cout << "Device: " << dev.get_info<sycl::info::device::name>() << std::endl;
    std::cout << "Max work-group size: " << dev.get_info<sycl::info::device::max_work_group_size>() << std::endl;
    auto sg_sizes = dev.get_info<sycl::info::device::sub_group_sizes>();
    std::cout << "Supported sub-group sizes:";
    for (auto s : sg_sizes) std::cout << " " << s;
    std::cout << std::endl;
    
    int pass_count = 0, fail_count = 0;
    auto record = [&](bool pass) { pass ? pass_count++ : fail_count++; };
    
    // Test 1: 基本同步 - 4 和 8 个 sub-group
    record(run_test1(q, 4));
    record(run_test1(q, 8));
    
    // Test 2: 独立分组 - 8 个 sub-group 分成 2 组和 4 组
    record(run_test2(q, 8, 2));
    record(run_test2(q, 8, 4));
    
    // Test 3: Producer-Consumer
    record(run_test3(q, 2, 2));   // 2 producers, 2 consumers
    record(run_test3(q, 4, 4));   // 4 producers, 4 consumers
    
    // Test 4: 多阶段流水线
    record(run_test4(q, 4, 3));   // 4 sub-groups, 3 phases
    record(run_test4(q, 8, 5));   // 8 sub-groups, 5 phases
    
    // Test 5: Sender/Receiver (dispatch-like)
    record(run_test5(q, 2));      // 2 channels
    record(run_test5(q, 4));      // 4 channels
    
    // Test 6: Multi-rank sync
    record(run_test6(q, 2, 2));   // 2 ranks, 2 SGs per rank per role
    record(run_test6(q, 4, 2));   // 4 ranks, 2 SGs per rank per role
    
    // Summary
    std::cout << "\n========================================" << std::endl;
    std::cout << "  Summary: " << pass_count << " passed, " << fail_count << " failed" << std::endl;
    std::cout << "========================================" << std::endl;
    
    return fail_count > 0 ? 1 : 0;
}
