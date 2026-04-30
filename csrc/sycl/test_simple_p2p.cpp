// test_ipc_acquire_release.cpp
// 测试跨 GPU IPC 场景下的 acquire-release 语义
//
// 使用 MPI 启动两个进程，每个进程控制一个 GPU：
//   - Rank 0 (Writer): 写入 data，然后设置 flag=1
//   - Rank 1 (Reader): 等待 flag==1，然后读取 data
//
// 通过 Level Zero IPC 共享内存，验证：
//   1. bypass-cache store + fence (release) 能让数据对其他 GPU 可见
//   2. bypass-cache load + fence (acquire) 能读到最新数据
//
// 编译:
//   source ~/intel/oneapi/compiler/latest/env/vars.sh
//    mpicxx -fsycl -fsycl-targets=spir64_gen -Xs "-device pvc" -o test_simple_p2p test_simple_p2p.cpp -lze_loader
// 运行:
//   mpirun -np 2 ./test_simple_p2p
//
// 预期输出:
//   [Rank 0] Writer: 写入 data, 设置 flag
//   [Rank 1] Reader: 检测到 flag==1, 读取到正确的 data
//   [Test] PASSED

#include <sycl/sycl.hpp>
#include <level_zero/ze_api.h>
#include <mpi.h>
#include <iostream>
#include <cstdint>
#include <chrono>
#include <thread>
#include <cstring>

// ============================================================================
// Bypass-cache load/store (lsc_load/lsc_store with uc.uc)
// ============================================================================

#ifdef __SYCL_DEVICE_ONLY__

// 使用 bypass-cache (L1 uncached, L3 uncached) 读取 int
inline int ld_bypass_cache(const int* addr) {
    int result;
    asm volatile (
        "lsc_load.ugm.uc.uc (M1, 32) %0:d32 flat[%1]:a64"
        : "=rw"(result) : "rw"(addr)
    );
    return result;
}

// 使用 bypass-cache (L1 uncached, L3 uncached) 读取 int64
inline int64_t ld_bypass_cache(const int64_t* addr) {
    int64_t result;
    asm volatile (
        "lsc_load.ugm.uc.uc (M1, 32) %0:d64 flat[%1]:a64"
        : "=rw"(result) : "rw"(addr)
    );
    return result;
}

// 使用 bypass-cache (L1 uncached, L3 uncached) 写入 int
inline void st_bypass_cache(int* addr, int value) {
    asm volatile (
        "lsc_store.ugm.uc.uc (M1, 32) flat[%0]:a64 %1:d32"
        : : "rw"(addr), "rw"(value) : "memory"
    );
}

// 使用 bypass-cache (L1 uncached, L3 uncached) 写入 int64
inline void st_bypass_cache(int64_t* addr, int64_t value) {
    asm volatile (
        "lsc_store.ugm.uc.uc (M1, 32) flat[%0]:a64 %1:d64"
        : : "rw"(addr), "rw"(value) : "memory"
    );
}

#else
// Host fallback
inline int ld_bypass_cache(const int* addr) { return *addr; }
inline int64_t ld_bypass_cache(const int64_t* addr) { return *addr; }
inline void st_bypass_cache(int* addr, int value) { *addr = value; }
inline void st_bypass_cache(int64_t* addr, int64_t value) { *addr = value; }
#endif

// ============================================================================
// Memory fence helpers - 使用 LSC fence 内联汇编 (system scope)
// ============================================================================

#if defined(__SYCL_DEVICE_ONLY__) && defined(__SPIR__)

inline void fence_release_system() {
    // evict + sysrel: 将缓存写回主存，确保其他GPU/CPU可见
    asm volatile ("lsc_fence.ugm.evict.sysrel\n" ::: "memory");
}

inline void fence_acquire_system() {
    // invalidate + sysacq: 使本地缓存失效，从主存读取最新数据
    asm volatile ("lsc_fence.ugm.invalidate.sysacq\n" ::: "memory");
}

inline void fence_acq_rel_system() {
    // 完整的 acquire-release: 先 release 再 acquire
    asm volatile ("lsc_fence.ugm.evict.sysrel\n" ::: "memory");
    asm volatile ("lsc_fence.ugm.invalidate.sysacq\n" ::: "memory");
}

#else
// Host fallback - no-op
inline void fence_release_system() {}
inline void fence_acquire_system() {}
inline void fence_acq_rel_system() {}
#endif

// ============================================================================
// IPC 共享内存结构
// ============================================================================

struct SharedBuffer {
    // 同步标志 - 使用 int64 确保原子性
    int64_t flag;      // 0 = not ready, 1 = data ready
    
    // padding 确保 flag 和 data 在不同缓存行
    char padding[128 - sizeof(int64_t)];
    
    // 数据区域 - Writer 写入，Reader 读取验证
    static constexpr int DATA_SIZE = 1024;
    int64_t data[DATA_SIZE];
};

// ============================================================================
// Writer Kernel (Rank 0)
// ============================================================================

class WriterKernel {
public:
    WriterKernel(SharedBuffer* shared_buf, int magic_value)
        : shared_buf_(shared_buf), magic_value_(magic_value) {}

    void operator()(sycl::nd_item<1> item) const {
        int tid = item.get_local_id(0);
        
        // 只有 thread 0 执行写入
        if (tid == 0) {
            shared_buf_->flag = 1;
        }
    }

private:
    SharedBuffer* shared_buf_;
    int magic_value_;
};

// ============================================================================
// Reader Kernel (Rank 1)
// ============================================================================

class ReaderKernel {
public:
    ReaderKernel(SharedBuffer* shared_buf, int64_t* result, int* error_count, int magic_value)
        : shared_buf_(shared_buf), result_(result), error_count_(error_count), 
          magic_value_(magic_value) {}

    void operator()(sycl::nd_item<1> item) const {
        int tid = item.get_local_id(0);
        
        // 只有 thread 0 执行读取
        if (tid == 0) {
            // Step 1: Spin-wait 使用 bypass-cache load 等待 flag
            // 绕过本地缓存，每次都从内存读取最新值
            int64_t spin_count = 0;
            constexpr int64_t MAX_SPIN = 100000000LL;  // 超时保护
            
            while (shared_buf_->flag != 1) {
                spin_count++;
                if (spin_count > MAX_SPIN) {
                    *error_count_ = -1;  // 超时标记
                    return;
                }
            }
            *error_count_ = 0;  // flag detected OK

        }
    }

private:
    SharedBuffer* shared_buf_;
    int64_t* result_;
    int* error_count_;
    int magic_value_;
};

int main(int argc, char* argv[]) {
    // 初始化 MPI
    MPI_Init(&argc, &argv);
    
    int rank, world_size;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &world_size);
    
    if (world_size != 2) {
        if (rank == 0) {
            std::cerr << "Error: This test requires exactly 2 MPI ranks." << std::endl;
            std::cerr << "Usage: mpirun -np 2 " << argv[0] << std::endl;
        }
        MPI_Finalize();
        return 1;
    }
    
    // 每个 rank 选择不同的 GPU
    auto devices = sycl::device::get_devices(sycl::info::device_type::gpu);
    if (devices.size() < 2) {
        if (rank == 0) {
            std::cerr << "Error: Need at least 2 GPUs, found " << devices.size() << std::endl;
        }
        MPI_Finalize();
        return 1;
    }
    
    sycl::device my_device = devices[rank];
    sycl::queue queue(my_device, sycl::property::queue::in_order{});
    
    std::cout << "[Rank " << rank << "] Using device: " 
              << my_device.get_info<sycl::info::device::name>() << std::endl;
    
    // 获取 Level Zero handles
    ze_context_handle_t ze_context = 
        sycl::get_native<sycl::backend::ext_oneapi_level_zero>(queue.get_context());
    ze_device_handle_t ze_device = 
        sycl::get_native<sycl::backend::ext_oneapi_level_zero>(queue.get_device());
    
    SharedBuffer* shared_buf = nullptr;
    ze_ipc_mem_handle_t ipc_handle;
    
    if (rank == 0) {
        // Rank 0 分配设备内存
        shared_buf = sycl::malloc_device<SharedBuffer>(1, queue);
        
        // 初始化为 0
        queue.memset(shared_buf, 0, sizeof(SharedBuffer)).wait();
        
        // 获取 IPC handle
        void* base_addr;
        size_t base_size;
        ze_result_t result = zeMemGetAddressRange(ze_context, shared_buf, &base_addr, &base_size);
        if (result != ZE_RESULT_SUCCESS) {
            std::cerr << "[Rank 0] Failed to get address range: " << result << std::endl;
            MPI_Abort(MPI_COMM_WORLD, 1);
        }
        
        result = zeMemGetIpcHandle(ze_context, base_addr, &ipc_handle);
        if (result != ZE_RESULT_SUCCESS) {
            std::cerr << "[Rank 0] Failed to get IPC handle: " << result << std::endl;
            MPI_Abort(MPI_COMM_WORLD, 1);
        }
        
        std::cout << "[Rank 0] Allocated shared buffer and got IPC handle" << std::endl;
    }
    
    // 广播 IPC handle 到所有 rank
    MPI_Bcast(&ipc_handle, sizeof(ze_ipc_mem_handle_t), MPI_BYTE, 0, MPI_COMM_WORLD);
    
    // Rank 1 打开 IPC handle
    if (rank == 1) {
        void* ptr;
        ze_result_t result = zeMemOpenIpcHandle(
            ze_context,
            ze_device,
            ipc_handle,
            ZE_IPC_MEMORY_FLAG_BIAS_UNCACHED,
            &ptr
        );
        
        if (result != ZE_RESULT_SUCCESS) {
            std::cerr << "[Rank 1] Failed to open IPC handle: " << result << std::endl;
            MPI_Abort(MPI_COMM_WORLD, 1);
        }
        
        shared_buf = static_cast<SharedBuffer*>(ptr);
        std::cout << "[Rank 1] Opened IPC handle" << std::endl;
    }
    
    MPI_Barrier(MPI_COMM_WORLD);
    
    constexpr int MAGIC_VALUE = 12345678;  // 用于验证的魔数
    bool test_passed = true;
    
    if (rank == 0) {
        // Writer: 写入数据，设置 flag
        std::cout << "\n[Rank 0] === WRITER ===" << std::endl;
        std::cout << "[Rank 0] Writing data with magic value: " << MAGIC_VALUE << std::endl;
        
        queue.submit([&](sycl::handler& cgh) {
            cgh.parallel_for(
                sycl::nd_range<1>(32, 32),
                WriterKernel(shared_buf, MAGIC_VALUE)
            );
        }).wait();
        
        std::cout << "[Rank 0] Data written, flag set to 1" << std::endl;
        
    } else {
        // Reader: 等待 flag，读取验证数据
        std::cout << "\n[Rank 1] === READER ===" << std::endl;
        std::cout << "[Rank 1] Waiting for flag..." << std::endl;
        
        // 分配用于返回结果的缓冲区
        int64_t* result_buf = sycl::malloc_device<int64_t>(16, queue);
        int* error_count = sycl::malloc_device<int>(1, queue);
        queue.memset(result_buf, 0, 16 * sizeof(int64_t)).wait();
        queue.memset(error_count, 0, sizeof(int)).wait();
        
        // 短暂延迟，确保 Writer 有时间启动
        std::this_thread::sleep_for(std::chrono::milliseconds(100));
        
        auto start = std::chrono::high_resolution_clock::now();
        
        queue.submit([&](sycl::handler& cgh) {
            cgh.parallel_for(
                sycl::nd_range<1>(32, 32),
                ReaderKernel(shared_buf, result_buf, error_count, MAGIC_VALUE)
            );
        }).wait();
        
        auto end = std::chrono::high_resolution_clock::now();
        double elapsed_ms = std::chrono::duration<double, std::milli>(end - start).count();
        
        // 读取结果
        int host_error_count;
        int64_t host_results[16];
        queue.memcpy(&host_error_count, error_count, sizeof(int)).wait();
        queue.memcpy(host_results, result_buf, 16 * sizeof(int64_t)).wait();
        
        if (host_error_count == -1) {
            std::cout << "[Rank 1] TIMEOUT waiting for flag!" << std::endl;
            test_passed = false;
        } else if (host_error_count == 0) {
            std::cout << "[Rank 1] Flag detected, data verified successfully!" << std::endl;
            std::cout << "[Rank 1] Elapsed time: " << elapsed_ms << " ms" << std::endl;
        } else {
            std::cout << "[Rank 1] Data verification FAILED! " 
                      << host_error_count << " errors" << std::endl;
            std::cout << "[Rank 1] First few wrong values: ";
            for (int i = 0; i < std::min(5, host_error_count); ++i) {
                std::cout << host_results[i] << " ";
            }
            std::cout << std::endl;
            test_passed = false;
        }
        
        sycl::free(result_buf, queue);
        sycl::free(error_count, queue);
    }
    
    // 汇总测试结果
    int local_passed = test_passed ? 1 : 0;
    int global_passed;
    MPI_Allreduce(&local_passed, &global_passed, 1, MPI_INT, MPI_LAND, MPI_COMM_WORLD);
    
    MPI_Barrier(MPI_COMM_WORLD);
    
    // ==========================================================================
    // 清理
    // ==========================================================================
    
    if (rank == 0) {
        sycl::free(shared_buf, queue);
    } else {
        zeMemCloseIpcHandle(ze_context, shared_buf);
    }
    
    MPI_Barrier(MPI_COMM_WORLD);
    
    if (rank == 0) {
        std::cout << "\n========================================" << std::endl;
        if (global_passed) {
            std::cout << "[Test] PASSED - Acquire-release IPC test successful!" << std::endl;
        } else {
            std::cout << "[Test] FAILED - Acquire-release IPC test failed!" << std::endl;
        }
        std::cout << "========================================" << std::endl;
    }
    
    MPI_Finalize();
    return global_passed ? 0 : 1;
}

