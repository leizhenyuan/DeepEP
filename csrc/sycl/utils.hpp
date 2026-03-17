#pragma once

#include <sycl/sycl.hpp>
#include <cstdint>
#include <algorithm>

namespace deep_ep {

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

SYCL_EXTERNAL inline void get_channel_task_range(int num_tokens, int num_sms, int sm_id, 
                                          int& token_start_idx, int& token_end_idx) {
    int num_tokens_per_sm = ceil_div(num_tokens, num_sms);
    token_start_idx = sycl::min(num_tokens_per_sm * sm_id, num_tokens);
    token_end_idx = sycl::min(token_start_idx + num_tokens_per_sm, num_tokens);
}

template <typename T>
SYCL_EXTERNAL inline T warp_reduce_sum(T value, sycl::nd_item<1>& item) {
    auto sg = item.get_sub_group();
    return sycl::reduce_over_group(sg, value, sycl::plus<T>());
}

template <typename T>
SYCL_EXTERNAL inline T warp_reduce_max(T value, sycl::nd_item<1>& item) {
    auto sg = item.get_sub_group();
    return sycl::reduce_over_group(sg, value, sycl::maximum<T>());
}

template <typename T>
SYCL_EXTERNAL inline T warp_reduce_min(T value, sycl::nd_item<1>& item) {
    auto sg = item.get_sub_group();
    return sycl::reduce_over_group(sg, value, sycl::minimum<T>());
}

SYCL_EXTERNAL inline bool elect_one_sync(sycl::nd_item<1>& item) {
    auto sg = item.get_sub_group();
    return sg.get_local_linear_id() == 0;
}

SYCL_EXTERNAL inline int get_lane_id(sycl::nd_item<1>& item) {
    auto sg = item.get_sub_group();
    return static_cast<int>(sg.get_local_linear_id());
}

template <typename T>
SYCL_EXTERNAL inline T warp_broadcast(T value, int src_lane, sycl::nd_item<1>& item) {
    auto sg = item.get_sub_group();
    return sycl::group_broadcast(sg, value, src_lane);
}

template <typename T>
SYCL_EXTERNAL inline T warp_shuffle(T value, int src_lane, sycl::nd_item<1>& item) {
    auto sg = item.get_sub_group();
    return sycl::select_from_group(sg, value, src_lane);
}

template <typename T>
SYCL_EXTERNAL inline T warp_shuffle_xor(T value, int mask, sycl::nd_item<1>& item) {
    auto sg = item.get_sub_group();
    int lane_id = static_cast<int>(sg.get_local_linear_id());
    int target_lane = lane_id ^ mask;
    return sycl::select_from_group(sg, value, target_lane);
}

SYCL_EXTERNAL inline void memory_fence_system() {
    sycl::atomic_fence(sycl::memory_order::acq_rel, sycl::memory_scope::system);
}

SYCL_EXTERNAL inline void memory_fence_device() {
    sycl::atomic_fence(sycl::memory_order::acq_rel, sycl::memory_scope::device);
}

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

SYCL_EXTERNAL inline int atomic_add_system_cas(int* ptr, int value) {
    auto atomic_ref = sycl::atomic_ref<int,
                                       sycl::memory_order::seq_cst,
                                       sycl::memory_scope::system,
                                       sycl::access::address_space::global_space>(*ptr);
    int old_val = atomic_ref.load();
    while (!atomic_ref.compare_exchange_weak(old_val, old_val + value)) {
    }
    return old_val;
}

SYCL_EXTERNAL inline int atomic_sub_system_cas(int* ptr, int value) {
    auto atomic_ref = sycl::atomic_ref<int,
                                       sycl::memory_order::seq_cst,
                                       sycl::memory_scope::system,
                                       sycl::access::address_space::global_space>(*ptr);
    int old_val = atomic_ref.load();
    while (!atomic_ref.compare_exchange_weak(old_val, old_val - value)) {
    }
    return old_val;
}

SYCL_EXTERNAL inline int atomic_add_release_system(int* ptr, int value) {
    auto atomic_ref = sycl::atomic_ref<int,
                                       sycl::memory_order::acq_rel,
                                       sycl::memory_scope::system,
                                       sycl::access::address_space::global_space>(*ptr);
    return atomic_ref.fetch_add(value, sycl::memory_order::release);
}

SYCL_EXTERNAL inline int atomic_add_device(int* ptr, int value) {
    auto atomic_ref = sycl::atomic_ref<int,
                                       sycl::memory_order::relaxed,
                                       sycl::memory_scope::device,
                                       sycl::access::address_space::global_space>(*ptr);
    return atomic_ref.fetch_add(value);
}

template <typename T>
SYCL_EXTERNAL inline T ld_acquire_sys_global(const T* ptr) {
    auto atomic_ref = sycl::atomic_ref<T,
                                       sycl::memory_order::acq_rel,
                                       sycl::memory_scope::system,
                                       sycl::access::address_space::global_space>(
        *const_cast<T*>(ptr));
    return atomic_ref.load(sycl::memory_order::acquire);
}

template <typename T>
SYCL_EXTERNAL inline void st_release_sys_global(T* ptr, T value) {
    auto atomic_ref = sycl::atomic_ref<T,
                                       sycl::memory_order::acq_rel,
                                       sycl::memory_scope::system,
                                       sycl::access::address_space::global_space>(*ptr);
    atomic_ref.store(value, sycl::memory_order::release);
}

template <typename T>
SYCL_EXTERNAL inline void st_relaxed_sys_global(T* ptr, T value) {
    auto atomic_ref = sycl::atomic_ref<T,
                                       sycl::memory_order::relaxed,
                                       sycl::memory_scope::system,
                                       sycl::access::address_space::global_space>(*ptr);
    atomic_ref.store(value);
}

template <typename T>
SYCL_EXTERNAL inline T ld_nc_global(const T* ptr) {
    return *ptr;  // SYCL编译器会自动优化
}

template <typename T>
SYCL_EXTERNAL inline void st_na_global(T* ptr, T value) {
    *ptr = value;
}

#ifdef __SYCL_DEVICE_ONLY__

// ---- uncached load (lsc_load.ugm.uc.uc = L1 uncached, L3 uncached) ----

inline int ld_volatile_global(const int* addr) {
    int result;
    asm volatile (
        "lsc_load.ugm.uc.uc (M1, 32) %0:d32 flat[%1]:a64"
        : "=rw"(result) : "rw"(addr)
    );
    return result;
}

inline int64_t ld_volatile_global(const int64_t* addr) {
    int64_t result;
    asm volatile (
        "lsc_load.ugm.uc.uc (M1, 32) %0:d64 flat[%1]:a64"
        : "=rw"(result) : "rw"(addr)
    );
    return result;
}


inline void st_volatile_global(int* addr, int value) {
    asm volatile (
        "lsc_store.ugm.uc.uc (M1, 32) flat[%0]:a64 %1:d32"
        : : "rw"(addr), "rw"(value) : "memory"
    );
}

inline void st_volatile_global(int64_t* addr, int64_t value) {
    asm volatile (
        "lsc_store.ugm.uc.uc (M1, 32) flat[%0]:a64 %1:d64"
        : : "rw"(addr), "rw"(value) : "memory"
    );
}

#else
// todo: Host fallback 感觉应该添加一个runtime error
inline int ld_volatile_global(const int* addr) { return *addr; }
inline int64_t ld_volatile_global(const int64_t* addr) { return *addr; }
inline void st_volatile_global(int* addr, int value) { *addr = value; }
inline void st_volatile_global(int64_t* addr, int64_t value) { *addr = value; }
#endif

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

SYCL_EXTERNAL inline int ld_acquire_system(int* ptr) {
    auto atomic_ref = sycl::atomic_ref<int,
                                       sycl::memory_order::acq_rel,
                                       sycl::memory_scope::system,
                                       sycl::access::address_space::global_space>(*ptr);
    return atomic_ref.load(sycl::memory_order::acquire);
}

SYCL_EXTERNAL inline int atomic_add_system_strong(int* ptr, int value) {
    sycl::atomic_fence(sycl::memory_order::seq_cst, sycl::memory_scope::system);
    
    auto atomic_ref = sycl::atomic_ref<int,
                                       sycl::memory_order::seq_cst,
                                       sycl::memory_scope::system,
                                       sycl::access::address_space::global_space>(*ptr);
    
    int old_val = atomic_ref.fetch_add(value);
    
    sycl::atomic_fence(sycl::memory_order::seq_cst, sycl::memory_scope::system);
    
    return old_val;
}

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

SYCL_EXTERNAL inline void atomic_store_global(int* ptr, int value) {
    auto atomic_ref = sycl::atomic_ref<int,
                                       sycl::memory_order::seq_cst,
                                       sycl::memory_scope::system,
                                       sycl::access::address_space::global_space>(*ptr);
    atomic_ref.store(value);
}

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
// barrier_block_bypass: 使用 bypass-cache load (lsc_load.ugm.uc.uc) 的 barrier
// ============================================================================
// 算法与 CUDA 原版 barrier_block 一致：
//   1. atomicAdd_system 到自身槽位 ptrs[rank][thread_id] += FINISHED_SUM_TAG
//   2. atomicSub_system 到对端槽位 ptrs[thread_id][rank] -= FINISHED_SUM_TAG
//   3. 用 bypass-cache volatile load 轮询 ptrs[rank][thread_id] 直到 <= 0
//
// 关键优势：
//   - ld_volatile_global 使用 lsc_load.ugm.uc.uc 硬件级绕过 L1/L3 缓存，
//     确保每次读到内存中最新值，等价于 CUDA 的 ld.volatile.global
//   - 比 CAS-based barrier 更轻量、更接近 CUDA 原版语义
// ============================================================================
template <int kNumRanks, bool kSyncOnly = false>
SYCL_EXTERNAL inline void barrier_block_bypass(int** barrier_signal_ptrs, int rank,
                                                sycl::nd_item<1>& item,
                                                const sycl::stream* debug_stream = nullptr) {
    auto thread_id = static_cast<int>(item.get_local_id(0));

    // 确保之前的内存操作对 system scope 可见
    if constexpr (!kSyncOnly) {
        memory_fence_system();
        item.barrier(sycl::access::fence_space::local_space);
    }

    // Add to self slot, sub from peer slot
    if (thread_id < kNumRanks) {
        atomic_add_system(barrier_signal_ptrs[rank] + thread_id, FINISHED_SUM_TAG);
        atomic_sub_system(barrier_signal_ptrs[thread_id] + rank, FINISHED_SUM_TAG);
    }

    // Spin-wait: 使用 bypass-cache load (lsc_load.ugm.uc.uc) 轮询
    if (thread_id < kNumRanks) {
        while (ld_volatile_global(barrier_signal_ptrs[rank] + thread_id) > 0) {
            // spin — bypass cache 确保每次读到最新值
        }
    }

    item.barrier(sycl::access::fence_space::local_space);
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

    if (thread_id < kNumRanks) {
        *debug_stream << "[Rank " << rank << "][Thread " << thread_id << "]" << sycl::endl;
    }
    
    if constexpr (!kSyncOnly) {
        sycl::atomic_fence(sycl::memory_order::acq_rel, sycl::memory_scope::system);
        item.barrier(sycl::access::fence_space::local_space);
    }

    size_t add_spins = 0;
    size_t sub_spins = 0;

    if (thread_id < kNumRanks) {
        // ========== Step 1: Put signal to self slot (0 -> rank * 1000 + thread_id) ==========
        int* self_ptr = barrier_signal_ptrs[rank] + thread_id;
        sycl::atomic_ref<int,
                         sycl::memory_order::acq_rel,
                         sycl::memory_scope::system> self_ref(*self_ptr);

        int add_tag = rank * 1000 + thread_id;
        self_ref.store(add_tag, sycl::memory_order::acq_rel);
    }
    sycl::atomic_fence(sycl::memory_order::seq_cst, sycl::memory_scope::system);
    item.barrier(sycl::access::fence_space::local_space);
    sycl::atomic_fence(sycl::memory_order::seq_cst, sycl::memory_scope::system);
    bool self_done = (thread_id < kNumRanks) ? false : true;  

    if (thread_id < kNumRanks) {
        // ========== Step 2: Wait signal from other slot (FINISHED_SUM_TAG -> 0) ==========
        int* other_ptr = barrier_signal_ptrs[thread_id] + rank;
        sycl::atomic_ref<int,
                         sycl::memory_order::acq_rel,
                         sycl::memory_scope::system> other_ref(*other_ptr);
        int sub_tag = thread_id * 1000 + rank;

        for (size_t i = 0; ; ++i) {

            if (i % 100000 == 0) {
                sycl::atomic_fence(sycl::memory_order::seq_cst, sycl::memory_scope::system);
            }

            sub_tag = thread_id * 1000 + rank;
            if (other_ref.load(sycl::memory_order::acquire) == sub_tag) {
                self_done = true;
                *debug_stream << "[Rank " << rank << "][Thread " << thread_id 
                             << "] SUB_OTHER SUCCESS: [" << thread_id << "][" << rank 
                             << "] " << sub_tag << " -> 0"
                             << ", spins=" << i 
                             << ", self_done=" << (self_done ? 1 : 0) << sycl::endl;
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

    item.barrier(sycl::access::fence_space::local_space);
    
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
// barrier_block_noatomic: 不使用 atomic RMW，仅用 release-store + acquire-load
// ============================================================================
// 原理：每个地址 ptrs[X][Y] 只有一个 writer（Rank X, thread Y）和一个 reader
// （Rank Y, thread X），因此不需要 atomic RMW（如 CAS/Add/Sub）。
// 只需保证跨设备可见性：
//   - store 用 release + system scope（穿透缓存，确保之前的数据写入可见）
//   - load 用 acquire + system scope（绕过缓存，读到最新值）
//
// 关于可重复性：使用 epoch 单调递增，避免固定 tag 只能用一次的问题。
// epoch 由调用者维护，每次 barrier 调用时 +1。
// 初始时所有 signal 槽位应为 0，首次调用 epoch=1。
//
// 注意：epoch 使用 int64_t，即使每秒 10 亿次调用也需要 ~292 年才溢出。
// 如果使用 int（~21 亿次溢出），几十亿次调用后会 wrap 产生假匹配。
// ============================================================================
template <int kNumRanks, bool kSyncOnly = false>
SYCL_EXTERNAL inline void barrier_block_noatomic(int64_t** barrier_signal_ptrs, int rank,
                                                  int64_t epoch,
                                                  sycl::nd_item<1>& item,
                                                  const sycl::stream* debug_stream = nullptr) {
    auto thread_id = static_cast<int>(item.get_local_id(0));

    // Step 0: 确保之前的数据写入对 system scope 可见
    if constexpr (!kSyncOnly) {
        sycl::atomic_fence(sycl::memory_order::acq_rel, sycl::memory_scope::system);
        item.barrier(sycl::access::fence_space::local_space);
    }

    // Step 1: 写信号到自己的槽位 ptrs[rank][thread_id]
    // 只有一个 writer，不需要 atomic RMW，release-store 即可
    if (thread_id < kNumRanks) {
        st_release_sys_global<int64_t>(barrier_signal_ptrs[rank] + thread_id, epoch);
    }

    // fence + local barrier 确保 store 已发出
    sycl::atomic_fence(sycl::memory_order::acq_rel, sycl::memory_scope::system);
    item.barrier(sycl::access::fence_space::local_space);

    // Step 2: 轮询远端槽位 ptrs[thread_id][rank]，等待远端 rank 写入 epoch
    // 只有一个 reader，不需要 atomic RMW，acquire-load 即可
    if (thread_id < kNumRanks) {
        while (ld_acquire_sys_global<int64_t>(barrier_signal_ptrs[thread_id] + rank) != epoch) {
            // spin — acquire load 绕过缓存，每次读到最新值
        }
    }

    item.barrier(sycl::access::fence_space::local_space);
}

// 与上面相同，但使用 ld_volatile_global（硬件级 bypass cache）替代 acquire-load
// 在 Intel GPU 上对应 lsc_load.ugm.uc.uc，可能比 atomic_ref acquire load 更轻量
template <int kNumRanks, bool kSyncOnly = false>
SYCL_EXTERNAL inline void barrier_block_uncached(int64_t** barrier_signal_ptrs, int rank,
                                                  int64_t epoch,
                                                  sycl::nd_item<1>& item,
                                                  const sycl::stream* debug_stream = nullptr) {
    auto thread_id = static_cast<int>(item.get_local_id(0));

    if constexpr (!kSyncOnly) {
        sycl::atomic_fence(sycl::memory_order::acq_rel, sycl::memory_scope::system);
        item.barrier(sycl::access::fence_space::local_space);
    }

    // release-store 信号
    if (thread_id < kNumRanks) {
        st_release_sys_global<int64_t>(barrier_signal_ptrs[rank] + thread_id, epoch);
    }

    sycl::atomic_fence(sycl::memory_order::acq_rel, sycl::memory_scope::system);
    item.barrier(sycl::access::fence_space::local_space);

    // volatile/uncached load 轮询远端
    // 注意：ld_volatile_global 目前只支持 int，这里用 acquire load 替代
    if (thread_id < kNumRanks) {
        while (ld_acquire_sys_global<int64_t>(barrier_signal_ptrs[thread_id] + rank) != epoch) {
            // spin — acquire load with system scope
        }
    }

    item.barrier(sycl::access::fence_space::local_space);
}

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

SYCL_EXTERNAL inline int4 make_int4(int x, int y, int z, int w) {
    int4 result;
    result.x = x;
    result.y = y;
    result.z = z;
    result.w = w;
    return result;
}

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