#pragma once

#include <sycl/sycl.hpp>
#include <cstdint>
#include <algorithm>

namespace deep_ep {

// ============================================================================
// Warp级别数据拷贝宏（模拟CUDA的UNROLLED_WARP_COPY）
// ============================================================================

#define UNROLLED_WARP_COPY(UNROLL_FACTOR, LANE_ID, N, DST, SRC, LD_FUNC, ST_FUNC)                                                     \
    {                                                                                                                                 \
        constexpr int kLoopStride = 32 * (UNROLL_FACTOR);                                                                             \
        typename std::remove_reference<decltype(LD_FUNC((SRC) + 0))>::type unrolled_values[(UNROLL_FACTOR)];                          \
        auto __src = (SRC);                                                                                                           \
        auto __dst = (DST);                                                                                                           \
        for (int __i = (LANE_ID); __i < ((N) / kLoopStride) * kLoopStride; __i += kLoopStride) {                                      \
            _Pragma("unroll") for (int __j = 0; __j < (UNROLL_FACTOR); ++__j) unrolled_values[__j] = LD_FUNC(__src + __i + __j * 32); \
            _Pragma("unroll") for (int __j = 0; __j < (UNROLL_FACTOR); ++__j) ST_FUNC(__dst + __i + __j * 32, unrolled_values[__j]);  \
        }                                                                                                                             \
        {                                                                                                                             \
            int __i = ((N) / kLoopStride) * kLoopStride + (LANE_ID);                                                                  \
            _Pragma("unroll") for (int __j = 0; __j < (UNROLL_FACTOR); ++__j) {                                                       \
                if (__i + __j * 32 < (N)) {                                                                                           \
                    unrolled_values[__j] = LD_FUNC(__src + __i + __j * 32);                                                           \
                }                                                                                                                     \
            }                                                                                                                         \
            _Pragma("unroll") for (int __j = 0; __j < (UNROLL_FACTOR); ++__j) {                                                       \
                if (__i + __j * 32 < (N)) {                                                                                           \
                    ST_FUNC(__dst + __i + __j * 32, unrolled_values[__j]);                                                            \
                }                                                                                                                     \
            }                                                                                                                         \
        }                                                                                                                             \
    }

// ============================================================================
// 数学工具函数
// ============================================================================

template <typename dtype_t>
inline constexpr dtype_t ceil_div(dtype_t a, dtype_t b) {
    return (a + b - 1) / b;
}

template <typename dtype_t>
inline constexpr dtype_t align_up(dtype_t a, dtype_t b) {
    return ceil_div<dtype_t>(a, b) * b;
}

template <typename dtype_t>
inline constexpr dtype_t align_down(dtype_t a, dtype_t b) {
    return a / b * b;
}

// ============================================================================
// Channel任务分配
// ============================================================================

SYCL_EXTERNAL inline void get_channel_task_range(int num_tokens, int num_sms, int sm_id, 
                                          int& token_start_idx, int& token_end_idx) {
    int num_tokens_per_sm = ceil_div(num_tokens, num_sms);
    token_start_idx = sycl::min(num_tokens_per_sm * sm_id, num_tokens);
    token_end_idx = sycl::min(token_start_idx + num_tokens_per_sm, num_tokens);
}

// ============================================================================
// Sub-group (Warp) 操作
// ============================================================================

// Warp规约求和
template <typename T>
SYCL_EXTERNAL inline T warp_reduce_sum(T value, sycl::nd_item<1>& item) {
    auto sg = item.get_sub_group();
    return sycl::reduce_over_group(sg, value, sycl::plus<T>());
}

// Warp规约最大值
template <typename T>
SYCL_EXTERNAL inline T warp_reduce_max(T value, sycl::nd_item<1>& item) {
    auto sg = item.get_sub_group();
    return sycl::reduce_over_group(sg, value, sycl::maximum<T>());
}

// Warp规约最小值
template <typename T>
SYCL_EXTERNAL inline T warp_reduce_min(T value, sycl::nd_item<1>& item) {
    auto sg = item.get_sub_group();
    return sycl::reduce_over_group(sg, value, sycl::minimum<T>());
}

// 选举单线程执行（类似CUDA的elect_one_sync）
SYCL_EXTERNAL inline bool elect_one_sync(sycl::nd_item<1>& item) {
    auto sg = item.get_sub_group();
    return sg.get_local_linear_id() == 0;
}

// 获取lane ID（sub-group内的线程索引）
SYCL_EXTERNAL inline int get_lane_id(sycl::nd_item<1>& item) {
    auto sg = item.get_sub_group();
    return static_cast<int>(sg.get_local_linear_id());
}

// Warp内广播
template <typename T>
SYCL_EXTERNAL inline T warp_broadcast(T value, int src_lane, sycl::nd_item<1>& item) {
    auto sg = item.get_sub_group();
    return sycl::group_broadcast(sg, value, src_lane);
}

// Warp内shuffle
template <typename T>
SYCL_EXTERNAL inline T warp_shuffle(T value, int src_lane, sycl::nd_item<1>& item) {
    auto sg = item.get_sub_group();
    return sycl::select_from_group(sg, value, src_lane);
}

// Warp内shuffle xor
template <typename T>
SYCL_EXTERNAL inline T warp_shuffle_xor(T value, int mask, sycl::nd_item<1>& item) {
    auto sg = item.get_sub_group();
    int lane_id = static_cast<int>(sg.get_local_linear_id());
    int target_lane = lane_id ^ mask;
    return sycl::select_from_group(sg, value, target_lane);
}

// ============================================================================
// 内存操作
// ============================================================================

// 全局内存fence（系统范围）
SYCL_EXTERNAL inline void memory_fence_system() {
    sycl::atomic_fence(sycl::memory_order::acq_rel, sycl::memory_scope::system);
}

// 全局内存fence（设备范围）
SYCL_EXTERNAL inline void memory_fence_device() {
    sycl::atomic_fence(sycl::memory_order::acq_rel, sycl::memory_scope::device);
}

// 工作组内存fence
SYCL_EXTERNAL inline void memory_fence_workgroup() {
    sycl::atomic_fence(sycl::memory_order::acq_rel, sycl::memory_scope::work_group);
}

// todo: 或许这里可以考虑更轻量化的ordering
SYCL_EXTERNAL inline int atomic_add_system(int* ptr, int value) {
    auto atomic_ref = sycl::atomic_ref<int, 
                                    sycl::memory_order::seq_cst,
                                    sycl::memory_scope::system,
                                    sycl::access::address_space::global_space>(*ptr);
    return atomic_ref.fetch_add(value);
}

SYCL_EXTERNAL inline int atomic_sub_system(int* ptr, int value) {
    auto atomic_ref = sycl::atomic_ref<int,
                                       sycl::memory_order::seq_cst,
                                       sycl::memory_scope::system,
                                       sycl::access::address_space::global_space>(*ptr);
    return atomic_ref.fetch_sub(value);
}

// CAS-based atomic add（强制读取最新值）
SYCL_EXTERNAL inline int atomic_add_system_cas(int* ptr, int value) {
    auto atomic_ref = sycl::atomic_ref<int,
                                       sycl::memory_order::seq_cst,
                                       sycl::memory_scope::system,
                                       sycl::access::address_space::global_space>(*ptr);
    int old_val = atomic_ref.load();
    while (!atomic_ref.compare_exchange_weak(old_val, old_val + value)) {
        // CAS 失败时，old_val 会被自动更新为当前实际值
        // 继续循环直到成功
    }
    return old_val;
}

// CAS-based atomic sub（强制读取最新值）
SYCL_EXTERNAL inline int atomic_sub_system_cas(int* ptr, int value) {
    auto atomic_ref = sycl::atomic_ref<int,
                                       sycl::memory_order::seq_cst,
                                       sycl::memory_scope::system,
                                       sycl::access::address_space::global_space>(*ptr);
    int old_val = atomic_ref.load();
    while (!atomic_ref.compare_exchange_weak(old_val, old_val - value)) {
        // CAS 失败时，old_val 会被自动更新为当前实际值
    }
    return old_val;
}

// 原子加法（release语义，系统范围）
// 注意：SYCL atomic_ref的默认顺序必须是relaxed/acq_rel/seq_cst，
// 但我们可以在fetch_add调用时指定release语义
SYCL_EXTERNAL inline int atomic_add_release_system(int* ptr, int value) {
    auto atomic_ref = sycl::atomic_ref<int,
                                       sycl::memory_order::acq_rel,
                                       sycl::memory_scope::system,
                                       sycl::access::address_space::global_space>(*ptr);
    return atomic_ref.fetch_add(value, sycl::memory_order::release);
}

// 原子加法（设备范围）
SYCL_EXTERNAL inline int atomic_add_device(int* ptr, int value) {
    auto atomic_ref = sycl::atomic_ref<int,
                                       sycl::memory_order::relaxed,
                                       sycl::memory_scope::device,
                                       sycl::access::address_space::global_space>(*ptr);
    return atomic_ref.fetch_add(value);
}

// ============================================================================
// 加载/存储操作
// ============================================================================

// Volatile加载（模拟CUDA的ld.volatile.global）
// template <typename T>
// SYCL_EXTERNAL inline T ld_volatile_global(const T* ptr) {
//     auto atomic_ref = sycl::atomic_ref<T,
//                                        sycl::memory_order::relaxed,
//                                        sycl::memory_scope::system,
//                                        sycl::access::address_space::global_space>(
//         *const_cast<T*>(ptr));
//     return atomic_ref.load();
// }

// Acquire语义加载（模拟CUDA的ld.acquire.sys.global）
template <typename T>
SYCL_EXTERNAL inline T ld_acquire_sys_global(const T* ptr) {
    auto atomic_ref = sycl::atomic_ref<T,
                                       sycl::memory_order::acq_rel,
                                       sycl::memory_scope::system,
                                       sycl::access::address_space::global_space>(
        *const_cast<T*>(ptr));
    return atomic_ref.load(sycl::memory_order::acquire);
}

// Release语义存储（模拟CUDA的st.release.sys.global）
template <typename T>
SYCL_EXTERNAL inline void st_release_sys_global(T* ptr, T value) {
    auto atomic_ref = sycl::atomic_ref<T,
                                       sycl::memory_order::acq_rel,
                                       sycl::memory_scope::system,
                                       sycl::access::address_space::global_space>(*ptr);
    atomic_ref.store(value, sycl::memory_order::release);
}

// Relaxed语义存储（模拟CUDA的st.relaxed.sys.global）
template <typename T>
SYCL_EXTERNAL inline void st_relaxed_sys_global(T* ptr, T value) {
    auto atomic_ref = sycl::atomic_ref<T,
                                       sycl::memory_order::relaxed,
                                       sycl::memory_scope::system,
                                       sycl::access::address_space::global_space>(*ptr);
    atomic_ref.store(value);
}

// 普通全局内存加载（类似__ldg，使用只读cache）
template <typename T>
SYCL_EXTERNAL inline T ld_nc_global(const T* ptr) {
    return *ptr;  // SYCL编译器会自动优化
}

// 普通全局内存存储（Non-allocating）
template <typename T>
SYCL_EXTERNAL inline void st_na_global(T* ptr, T value) {
    *ptr = value;
}

// Device-only function: LSC uncached load
// #ifdef __SYCL_DEVICE_ONLY__
// inline int ld_volatile_global(const int* addr) {
//     int result;
//     asm volatile (
//         "lsc_load.ugm.uc.uc (M1, 1) %0:d32 flat[%1]:a64"
//         : "=rw"(result) : "rw"(addr)
//     );
//     return result;
// }
// #else
// // todo: Host fallback 感觉应该添加一个runtime error
// inline int ld_volatile_global(const int* addr) {
//     return *addr;
// }
// #endif

// 在 barrier_block 中，用 CAS-based load 验证
SYCL_EXTERNAL inline int ld_volatile_global_cas(int* ptr) {
    auto atomic_ref = sycl::atomic_ref<int,
                                       sycl::memory_order::seq_cst,
                                       sycl::memory_scope::system,
                                       sycl::access::address_space::global_space>(*ptr);
    int val = atomic_ref.load();
    // 强制同步
    atomic_ref.compare_exchange_strong(val, val);
    return val;
}

// Acquire-Release 同步的 atomic add
// 先 acquire 读取当前值，确保看到其他 rank 的写入
// 然后 release 写入，确保对其他 rank 可见
SYCL_EXTERNAL inline int atomic_add_system_acq_rel(int* ptr, int value) {
    auto atomic_ref = sycl::atomic_ref<int,
                                       sycl::memory_order::acq_rel,
                                       sycl::memory_scope::system,
                                       sycl::access::address_space::global_space>(*ptr);
    
    // 先用 acquire 读取当前值
    int old_val = atomic_ref.load(sycl::memory_order::acquire);
    
    // 用 release 语义的 CAS 写入
    while (!atomic_ref.compare_exchange_weak(old_val, old_val + value,
                                              sycl::memory_order::acq_rel,
                                              sycl::memory_order::acquire)) {
        // CAS 失败时，old_val 会被更新为最新值（acquire 语义）
    }
    return old_val;
}

// Acquire-Release 同步的 atomic sub
SYCL_EXTERNAL inline int atomic_sub_system_acq_rel(int* ptr, int value) {
    auto atomic_ref = sycl::atomic_ref<int,
                                       sycl::memory_order::acq_rel,
                                       sycl::memory_scope::system,
                                       sycl::access::address_space::global_space>(*ptr);
    
    int old_val = atomic_ref.load(sycl::memory_order::acquire);
    
    while (!atomic_ref.compare_exchange_weak(old_val, old_val - value,
                                              sycl::memory_order::acq_rel,
                                              sycl::memory_order::acquire)) {
    }
    return old_val;
}

// Acquire 语义的 load（用于轮询等待）
SYCL_EXTERNAL inline int ld_acquire_system(int* ptr) {
    auto atomic_ref = sycl::atomic_ref<int,
                                       sycl::memory_order::acq_rel,
                                       sycl::memory_scope::system,
                                       sycl::access::address_space::global_space>(*ptr);
    return atomic_ref.load(sycl::memory_order::acquire);
}


// 最强语义的 atomic add system
// 模拟 CUDA: atomicAdd_system() 或 atom.add.sys
SYCL_EXTERNAL inline int atomic_add_system_strong(int* ptr, int value) {
    // 1. 先执行 system-wide fence，确保之前的写入对所有人可见
    sycl::atomic_fence(sycl::memory_order::seq_cst, sycl::memory_scope::system);
    
    // 2. 创建 system scope 的 atomic_ref，使用最强的 seq_cst 顺序
    auto atomic_ref = sycl::atomic_ref<int,
                                       sycl::memory_order::seq_cst,
                                       sycl::memory_scope::system,
                                       sycl::access::address_space::global_space>(*ptr);
    
    // 3. 执行原子加法
    int old_val = atomic_ref.fetch_add(value);
    
    // 4. 再次 fence，确保这次写入对所有人可见
    sycl::atomic_fence(sycl::memory_order::seq_cst, sycl::memory_scope::system);
    
    return old_val;
}

// 最强语义的 atomic sub system
SYCL_EXTERNAL inline int atomic_sub_system_strong(int* ptr, int value) {
    sycl::atomic_fence(sycl::memory_order::seq_cst, sycl::memory_scope::system);
    
    auto atomic_ref = sycl::atomic_ref<int,
                                       sycl::memory_order::seq_cst,
                                       sycl::memory_scope::system,
                                       sycl::access::address_space::global_space>(*ptr);
    
    int old_val = atomic_ref.fetch_sub(value);
    
    sycl::atomic_fence(sycl::memory_order::seq_cst, sycl::memory_scope::system);
    
    return old_val;
}

// 最强语义的 atomic load system
SYCL_EXTERNAL inline int atomic_load_system_strong(int* ptr) {
    sycl::atomic_fence(sycl::memory_order::seq_cst, sycl::memory_scope::system);
    
    auto atomic_ref = sycl::atomic_ref<int,
                                       sycl::memory_order::seq_cst,
                                       sycl::memory_scope::system,
                                       sycl::access::address_space::global_space>(*ptr);
    
    int val = atomic_ref.load();
    
    sycl::atomic_fence(sycl::memory_order::seq_cst, sycl::memory_scope::system);
    
    return val;
}


// 跨GPU Barrier同步
template <int kNumRanks, bool kResetBarrier = false>
SYCL_EXTERNAL inline void barrier_block(int** barrier_signal_ptrs, int rank, sycl::nd_item<1>& item, const sycl::stream* debug_stream = nullptr) {
    auto thread_id = static_cast<int>(item.get_local_id(0));
    auto sg = item.get_sub_group();
    auto sm_id = static_cast<int>(item.get_group(0));
    auto lane_id = static_cast<int>(sg.get_local_linear_id());

    if constexpr (!kResetBarrier) {
        memory_fence_system();
        item.barrier(sycl::access::fence_space::local_space);
    }
    // *debug_stream << "[barrier_block] Rank " << rank << ", SM " << sm_id 
    //                  << ", thread " << thread_id << ": ENTERED" << sycl::endl;



    if (thread_id < kNumRanks) {
            // 每个 rank 先写入一个 "ready" 信号
            atomic_add_system_strong(barrier_signal_ptrs[rank] + thread_id, 1);
            
            // 等待所有 rank 都就绪（等待 self 位置被所有人写入）
            int ready_count;
            do {
                ready_count = atomic_load_system_strong(barrier_signal_ptrs[rank] + thread_id);
            } while (ready_count < 100);  // 等待所有 rank 都写入了
            
        *debug_stream << "Rank:" << rank << "Begin barrier wait at thread " << thread_id 
                    << ", ready_count=" << ready_count << sycl::endl;
        // 使用最强语义的原子操作
        atomic_sub_system_strong(barrier_signal_ptrs[thread_id] + rank, FINISHED_SUM_TAG + 1);
        atomic_add_system_strong(barrier_signal_ptrs[rank] + thread_id, FINISHED_SUM_TAG - 1 - kNumRanks);
        
        // 轮询等待
        int my_signal;
        int spin_count = 0;
        const int MAX_SPIN = 1000000;
        
        do {
            my_signal = atomic_load_system_strong(barrier_signal_ptrs[rank] + thread_id);
            spin_count++;
        } while (my_signal > 0 && spin_count < MAX_SPIN);
        
        *debug_stream << "[barrier_block] Rank " << rank << ", thread " << thread_id 
                    << ": Final signal=" << my_signal 
                    << ", spins=" << spin_count << sycl::endl;
    }

    item.barrier(sycl::access::fence_space::local_space);

    unsigned long long timeout_count = 0;
    // sycl 没有device clock，用这个比较笨的方法作为替代
    const unsigned long long MAX_TIMEOUT = 100000000ull;  // 1亿次循环
    bool done = false;

    // int ii = 0;
    // while (ii < 1) {  // 避免死循环
    //     // 每个线程读取自己负责的值
    //     int my_value = (thread_id < kNumRanks) ? *(barrier_signal_ptrs[rank] + thread_id) : 0;
        
    //     // 使用 all_of_group 检查所有线程的 my_value <= 0
    //     done = sycl::all_of_group(item.get_group(), my_value <= 0);
        
    //     // Work-group 同步
    //     item.barrier(sycl::access::fence_space::local_space);
        
    //     if (thread_id < kNumRanks and ii == 100000 -1) {
    //         *debug_stream << "[barrier_block signals] Rank " << rank << ", SM " << sm_id 
    //                  << ", thread " << thread_id 
    //                  << ": Checking done=" << done 
    //                  << ", my_value=" << my_value 
    //                  << ", barrier signals=" << *(barrier_signal_ptrs[rank] + thread_id)
    //                  << sycl::endl;
    //     }
        
        
    //     done = true;
    //     ii++;
        // timeout_count++;
        // if (timeout_count > MAX_TIMEOUT) {
        //     if (thread_id == 0 && debug_stream != nullptr) {
        //         *debug_stream << "[BARRIER TIMEOUT] Rank " << rank 
        //                      << ", SM " << sm_id 
        //                      << ": barrier_signal values = ";
        //         for (int i = 0; i < kNumRanks; i++) {
        //             *debug_stream << *(barrier_signal_ptrs[rank] + i) << " ";
        //         }
        //         *debug_stream << sycl::endl;
        //     }
        //     break;
        // }
    // }

    // item.barrier(sycl::access::fence_space::local_space);

    if (thread_id == 0 && debug_stream != nullptr) {
        *debug_stream << "[barrier_block] Rank " << rank << ", SM " << sm_id << " EXITED" << sycl::endl;
    }
}

SYCL_EXTERNAL inline int atomic_add_global_cas(int* ptr, int value) {
    auto atomic_ref = sycl::atomic_ref<int,
                                       sycl::memory_order::seq_cst,
                                       sycl::memory_scope::system,
                                       sycl::access::address_space::global_space>(*ptr);
    int old_val = atomic_ref.load();
    while (!atomic_ref.compare_exchange_weak(old_val, old_val + value)) {
        // CAS 失败时，old_val 会自动更新为当前实际值
    }
    return old_val;
}

// 通用 atomic sub：读取当前值，减去 value，返回旧值
SYCL_EXTERNAL inline int atomic_sub_global_cas(int* ptr, int value) {
    auto atomic_ref = sycl::atomic_ref<int,
                                       sycl::memory_order::seq_cst,
                                       sycl::memory_scope::system,
                                       sycl::access::address_space::global_space>(*ptr);
    int old_val = atomic_ref.load();
    while (!atomic_ref.compare_exchange_weak(old_val, old_val - value)) {
        // CAS 失败时，old_val 会自动更新为当前实际值
    }
    return old_val;
}

// 通用 atomic store：原子存储
SYCL_EXTERNAL inline void atomic_store_global(int* ptr, int value) {
    auto atomic_ref = sycl::atomic_ref<int,
                                       sycl::memory_order::seq_cst,
                                       sycl::memory_scope::system,
                                       sycl::access::address_space::global_space>(*ptr);
    atomic_ref.store(value);
}

// 通用 atomic load：原子读取
SYCL_EXTERNAL inline int atomic_load_global(int* ptr) {
    auto atomic_ref = sycl::atomic_ref<int,
                                       sycl::memory_order::seq_cst,
                                       sycl::memory_scope::system,
                                       sycl::access::address_space::global_space>(*ptr);
    return atomic_ref.load();
}

template <int kNumRanks>
SYCL_EXTERNAL inline void barrier_verify_kernel(int** barrier_signal_ptrs, int rank,
                                                sycl::nd_item<1>& item,
                                                const sycl::stream* debug_stream = nullptr) {
    auto thread_id = static_cast<int>(item.get_local_id(0));
    
    if (thread_id == 0 && debug_stream) {
        *debug_stream << "[Rank " << rank << "] barrier_verify_kernel ENTER" << sycl::endl;
    }

    int loop_count = 0;
    constexpr int MAX_LOOPS = 10000000;
    constexpr int LOG_INTERVAL = 8000000;
    
    while (true) {
        int value = 0;
        if (thread_id < kNumRanks) {
            auto self_ref = sycl::atomic_ref<int,
                                             sycl::memory_order::seq_cst,
                                             sycl::memory_scope::system>(*(barrier_signal_ptrs[rank] + thread_id));
            value = self_ref.load(sycl::memory_order::seq_cst);
        }
        
        bool my_done = (value == 0) || thread_id >= kNumRanks;
        bool all_done = sycl::all_of_group(item.get_group(), my_done);
        
        if (debug_stream && thread_id < kNumRanks && (loop_count % LOG_INTERVAL == 0) && loop_count > 0) {
            *debug_stream << "[Rank " << rank << "][Thread " << thread_id 
                         << "] VERIFY: loop=" << loop_count 
                         << ", value=" << value << sycl::endl;
        }
        
        if (all_done) {
            if (debug_stream && thread_id < kNumRanks && loop_count > 0) {
                *debug_stream << "[Rank " << rank << "][Thread " << thread_id 
                             << "] VERIFIED: value=" << value 
                             << ", loops=" << loop_count << sycl::endl;
            }
            break;
        }
        
        loop_count++;
        if (loop_count > MAX_LOOPS) {
            if (debug_stream && thread_id < kNumRanks) {
                *debug_stream << "[Rank " << rank << "][Thread " << thread_id 
                             << "] VERIFY TIMEOUT! value=" << value << sycl::endl;
            }
            break;
        }
    }
    
    item.barrier(sycl::access::fence_space::local_space);
    
    if (thread_id == 0 && debug_stream) {
        *debug_stream << "[Rank " << rank << "] barrier_verify_kernel EXIT" << sycl::endl;
    }
}

// ============================================================================
// Uncached Load (绕过缓存)
// ============================================================================

// 使用 volatile 指针绕过缓存
inline int ld_volatile_global(const int* addr) {
    return *const_cast<volatile int*>(addr);
}



template <int kNumRanks, bool kSyncOnly = false>
SYCL_EXTERNAL inline void barrier_block_cas(int** barrier_signal_ptrs, int rank, 
                                            sycl::nd_item<1>& item, 
                                            const sycl::stream* debug_stream = nullptr) {

    auto thread_id = static_cast<int>(item.get_local_id(0));
    auto sg = item.get_sub_group();
    auto sg_size = 32;
    auto lane_id = thread_id % sg_size;
    auto sg_id = thread_id / sg_size;
    
    constexpr size_t MAX_SPIN = 10000000;
    
    // if (lane_id == 0 && debug_stream && sg_id < kNumRanks) {
    //     *debug_stream << "[Rank " << rank << "][Thread " << thread_id 
    //                  << "] sg_id=" << sg_id << ", lane_id=" << lane_id << sycl::endl;
    // }
    if (thread_id < kNumRanks) {
        *debug_stream << "[Rank " << rank << "][Thread " << thread_id 
                     << "] sg_id=" << sg_id << ", lane_id=" << lane_id << sycl::endl;
    }
    
    if constexpr (!kSyncOnly) {
        sycl::atomic_fence(sycl::memory_order::acq_rel, sycl::memory_scope::system);
        item.barrier(sycl::access::fence_space::local_space);
    }

    size_t add_spins = 0;
    size_t sub_spins = 0;

    // if (sg_id < kNumRanks && lane_id == 0) {
    if (thread_id < kNumRanks) {
        // ========== Step 1: Put signal to self slot (0 -> rank * 1000 + thread_id) ==========
        int* self_ptr = barrier_signal_ptrs[rank] + thread_id;
        sycl::atomic_ref<int,
                         sycl::memory_order::acq_rel,
                         sycl::memory_scope::system> self_ref(*self_ptr);

        int add_tag = rank * 1000 + thread_id;
        for (size_t i = 0; i < MAX_SPIN; ++i) {
            int expected = 0;
            if (self_ref.compare_exchange_strong(expected, add_tag)) {
                break;
            }
            add_spins = i;
        }
        
        if (debug_stream) {
            *debug_stream << "[Rank " << rank << "][Thread " << thread_id 
                         << "] ADD_SELF: [" << rank << "][" << thread_id 
                         << "] 0 -> " << add_tag 
                         << ", spins=" << add_spins << sycl::endl;
        }
    }
    
    item.barrier(sycl::access::fence_space::global_space);

    bool self_done = (thread_id < kNumRanks && lane_id == 0) ? false : true;  
  
    if (thread_id < kNumRanks) {
        // ========== Step 2: Wait signal from other slot (FINISHED_SUM_TAG -> 0) ==========
        int* other_ptr = barrier_signal_ptrs[thread_id] + rank;
        sycl::atomic_ref<int,
                         sycl::memory_order::acq_rel,
                         sycl::memory_scope::system> other_ref(*other_ptr);
        int sub_tag = thread_id * 1000 + rank;
        for (size_t i = 0; i < MAX_SPIN; ++i) {
            sub_tag = thread_id * 1000 + rank;
            if (other_ref.compare_exchange_strong(sub_tag, 0)) {
                self_done = true;
                break;
            }
            sub_spins = i;
        }
        
        if (debug_stream) {
            *debug_stream << "[Rank " << rank << "][Thread " << thread_id 
                         << "] SUB_OTHER: [" << thread_id << "][" << rank 
                         << "] " << sub_tag << " -> 0"
                         << ", spins=" << sub_spins 
                         << ", self_done=" << (self_done ? 1 : 0) << sycl::endl;
        }
    }

    item.barrier(sycl::access::fence_space::global_space);
    
    // ========== Step 3: Group all check - 所有线程都 done 才算成功 ==========
    bool all_done = sycl::all_of_group(item.get_group(), self_done);
    
    if (!all_done) {
        if (thread_id == 0 && debug_stream) {
            *debug_stream << "[Rank " << rank << "] BARRIER FAILED! Not all threads done." << sycl::endl;
        }
        // 打印失败的线程
        if (!self_done && debug_stream) {
            *debug_stream << "[Rank " << rank << "][sg " << sg_id 
                         << "] TIMEOUT: sub_spins=" << sub_spins << sycl::endl;
        }
        item.barrier(sycl::access::fence_space::local_space);
        return;
    }
    
    if (thread_id == 0 && debug_stream) {
        *debug_stream << "[Rank " << rank << "] barrier_block_cas EXIT: SUCCESS" << sycl::endl;
    }
}

// ============================================================================
// IPC Address Mapping Test - Write Kernel (LOCAL ONLY)
// 简化测试: 每个 Rank 只写入自己本地分配的内存，不访问 IPC 映射
// 写入位置: barrier_signal_ptrs[rank] + thread_id (rank 是自己的 rank)
// 写入值: rank * 1000 + thread_id
// ============================================================================
template <int kNumRanks>
SYCL_EXTERNAL inline void barrier_block_write(int** barrier_signal_ptrs, int rank, 
                                               sycl::nd_item<1>& item, 
                                               const sycl::stream* debug_stream = nullptr) {
    auto thread_id = static_cast<int>(item.get_local_id(0));
    
    // 只有 thread 0 打印基地址信息
    if (thread_id == 0 && debug_stream) {
        *debug_stream << "[Rank " << rank << "] === LOCAL WRITE TEST ===" << sycl::endl;
        *debug_stream << "[Rank " << rank << "] Writing to LOCAL memory only (barrier_signal_ptrs[" 
                     << rank << "])" << sycl::endl;
        *debug_stream << "[Rank " << rank << "] Local ptr = " 
                     << (void*)barrier_signal_ptrs[rank] << sycl::endl;
    }
    
    item.barrier(sycl::access::fence_space::local_space);
    
    // 每个线程只写入自己 rank 的本地内存
    if (thread_id < kNumRanks) {
        int* write_ptr = barrier_signal_ptrs[rank] + thread_id;
        int write_value = rank * 1000 + thread_id;
        
        // 直接写入，不使用原子操作（本地内存）
        *write_ptr = write_value;
        
        if (debug_stream) {
            *debug_stream << "[Rank " << rank << "][Thread " << thread_id 
                         << "] WRITE: value=" << write_value << sycl::endl;
        }
    }
    
    item.barrier(sycl::access::fence_space::local_space);
    
    if (thread_id == 0 && debug_stream) {
        *debug_stream << "[Rank " << rank << "] LOCAL WRITE TEST COMPLETE" << sycl::endl;
    }
}

// ============================================================================
// IPC Address Mapping Test - Read Kernel
// 测试: 每个 Rank 读取 barrier_signal_ptrs[thread_id] + rank 的值
// 写入时: Rank X 的 Thread Y 写入 barrier_signal_ptrs[X] + Y = X * 1000 + Y
// 读取时: Rank X 的 Thread Y 读取 barrier_signal_ptrs[Y] + X，期望值 = Y * 1000 + X
// ============================================================================
template <int kNumRanks>
SYCL_EXTERNAL inline void barrier_block_read(int** barrier_signal_ptrs, int rank, 
                                              sycl::nd_item<1>& item, 
                                              const sycl::stream* debug_stream = nullptr) {
    auto thread_id = static_cast<int>(item.get_local_id(0));
    
    if (thread_id == 0 && debug_stream) {
        *debug_stream << "[Rank " << rank << "] === IPC READ TEST START ===" << sycl::endl;
        *debug_stream << "[Rank " << rank << "] Reading barrier_signal_ptrs[thread_id] + rank" << sycl::endl;
        for (int i = 0; i < kNumRanks; ++i) {
            *debug_stream << "[Rank " << rank << "] barrier_signal_ptrs[" << i << "] = " 
                         << (void*)barrier_signal_ptrs[i] << sycl::endl;
        }
    }
    
    item.barrier(sycl::access::fence_space::local_space);
    
    // 每个 thread_id < kNumRanks 的线程读取 barrier_signal_ptrs[thread_id] + rank
    // 期望值: thread_id * 1000 + rank (由 Rank=thread_id 的 Thread=rank 写入)
    if (thread_id < kNumRanks) {
        int* read_ptr = barrier_signal_ptrs[thread_id] + rank;
        int expected_value = thread_id * 1000 + rank;
        
        if (debug_stream) {
            *debug_stream << "[Rank " << rank << "][Thread " << thread_id 
                         << "] Attempting to read barrier_signal_ptrs[" << thread_id << "] + " << rank << "..." << sycl::endl;
            *debug_stream << "[Rank " << rank << "][Thread " << thread_id 
                         << "] read_ptr = " << (void*)read_ptr << sycl::endl;
        }
        
        // 直接读取
        int read_value = *read_ptr;
        
        bool correct = (read_value == expected_value);
        
        if (debug_stream) {
            *debug_stream << "[Rank " << rank << "][Thread " << thread_id 
                         << "] READ: value=" << read_value 
                         << " expected=" << expected_value
                         << " " << (correct ? "CORRECT" : "MISMATCH!") << sycl::endl;
        }
    }
    
    item.barrier(sycl::access::fence_space::local_space);
    
    if (thread_id == 0 && debug_stream) {
        *debug_stream << "[Rank " << rank << "] === IPC READ TEST COMPLETE ===" << sycl::endl;
    }
}

struct alignas(16) int4 {
    int x, y, z, w;
};

struct alignas(8) int2 {
    int x, y;
};


template <typename dtype_a_t, typename dtype_b_t>
SYCL_EXTERNAL inline dtype_b_t pack2(const dtype_a_t& x, const dtype_a_t& y) {
    static_assert(sizeof(dtype_a_t) * 2 == sizeof(dtype_b_t), "Invalid dtypes");
    dtype_b_t packed;
    auto unpacked_ptr = reinterpret_cast<dtype_a_t*>(&packed);
    unpacked_ptr[0] = x;
    unpacked_ptr[1] = y;
    return packed;
}

template <typename dtype_a_t, typename dtype_b_t>
SYCL_EXTERNAL inline void unpack2(const dtype_b_t& packed, dtype_a_t& x, dtype_a_t& y) {
    static_assert(sizeof(dtype_a_t) * 2 == sizeof(dtype_b_t), "Invalid dtypes");
    auto unpacked_ptr = reinterpret_cast<const dtype_a_t*>(&packed);
    x = unpacked_ptr[0];
    y = unpacked_ptr[1];
}

}  // namespace deep_ep
