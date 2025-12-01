#pragma once

#include <sycl/sycl.hpp>
#include <cstdint>
#include <algorithm>

namespace deep_ep {

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

inline void get_channel_task_range(int num_tokens, int num_sms, int sm_id, 
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
inline T warp_reduce_sum(T value, sycl::nd_item<1>& item) {
    auto sg = item.get_sub_group();
    return sycl::reduce_over_group(sg, value, sycl::plus<T>());
}

// Warp规约最大值
template <typename T>
inline T warp_reduce_max(T value, sycl::nd_item<1>& item) {
    auto sg = item.get_sub_group();
    return sycl::reduce_over_group(sg, value, sycl::maximum<T>());
}

// Warp规约最小值
template <typename T>
inline T warp_reduce_min(T value, sycl::nd_item<1>& item) {
    auto sg = item.get_sub_group();
    return sycl::reduce_over_group(sg, value, sycl::minimum<T>());
}

// 选举单线程执行（类似CUDA的elect_one_sync）
inline bool elect_one_sync(sycl::nd_item<1>& item) {
    auto sg = item.get_sub_group();
    return sg.get_local_linear_id() == 0;
}

// 获取lane ID（sub-group内的线程索引）
inline int get_lane_id(sycl::nd_item<1>& item) {
    auto sg = item.get_sub_group();
    return static_cast<int>(sg.get_local_linear_id());
}

// Warp内广播
template <typename T>
inline T warp_broadcast(T value, int src_lane, sycl::nd_item<1>& item) {
    auto sg = item.get_sub_group();
    return sycl::group_broadcast(sg, value, src_lane);
}

// Warp内shuffle
template <typename T>
inline T warp_shuffle(T value, int src_lane, sycl::nd_item<1>& item) {
    auto sg = item.get_sub_group();
    return sycl::select_from_group(sg, value, src_lane);
}

// Warp内shuffle xor
template <typename T>
inline T warp_shuffle_xor(T value, int mask, sycl::nd_item<1>& item) {
    auto sg = item.get_sub_group();
    int lane_id = static_cast<int>(sg.get_local_linear_id());
    int target_lane = lane_id ^ mask;
    return sycl::select_from_group(sg, value, target_lane);
}

// ============================================================================
// 内存操作
// ============================================================================

// 全局内存fence（系统范围）
inline void memory_fence_system() {
    sycl::atomic_fence(sycl::memory_order::acq_rel, sycl::memory_scope::system);
}

// 全局内存fence（设备范围）
inline void memory_fence_device() {
    sycl::atomic_fence(sycl::memory_order::acq_rel, sycl::memory_scope::device);
}

// 工作组内存fence
inline void memory_fence_workgroup() {
    sycl::atomic_fence(sycl::memory_order::acq_rel, sycl::memory_scope::work_group);
}

// ============================================================================
// 原子操作封装
// ============================================================================

// 原子加法（系统范围）
inline int atomic_add_system(int* ptr, int value) {
    auto atomic_ref = sycl::atomic_ref<int, 
                                       sycl::memory_order::relaxed,
                                       sycl::memory_scope::system,
                                       sycl::access::address_space::global_space>(*ptr);
    return atomic_ref.fetch_add(value);
}

// 原子减法（系统范围）
inline int atomic_sub_system(int* ptr, int value) {
    auto atomic_ref = sycl::atomic_ref<int,
                                       sycl::memory_order::relaxed,
                                       sycl::memory_scope::system,
                                       sycl::access::address_space::global_space>(*ptr);
    return atomic_ref.fetch_sub(value);
}

// 原子加法（release语义，系统范围）
// 注意：SYCL atomic_ref的默认顺序必须是relaxed/acq_rel/seq_cst，
// 但我们可以在fetch_add调用时指定release语义
inline int atomic_add_release_system(int* ptr, int value) {
    auto atomic_ref = sycl::atomic_ref<int,
                                       sycl::memory_order::acq_rel,
                                       sycl::memory_scope::system,
                                       sycl::access::address_space::global_space>(*ptr);
    return atomic_ref.fetch_add(value, sycl::memory_order::release);
}

// 原子加法（设备范围）
inline int atomic_add_device(int* ptr, int value) {
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
template <typename T>
inline T ld_volatile_global(const T* ptr) {
    auto atomic_ref = sycl::atomic_ref<T,
                                       sycl::memory_order::relaxed,
                                       sycl::memory_scope::system,
                                       sycl::access::address_space::global_space>(
        *const_cast<T*>(ptr));
    return atomic_ref.load();
}

// Acquire语义加载（模拟CUDA的ld.acquire.sys.global）
template <typename T>
inline T ld_acquire_sys_global(const T* ptr) {
    auto atomic_ref = sycl::atomic_ref<T,
                                       sycl::memory_order::acquire,
                                       sycl::memory_scope::system,
                                       sycl::access::address_space::global_space>(
        *const_cast<T*>(ptr));
    return atomic_ref.load();
}

// Release语义存储（模拟CUDA的st.release.sys.global）
template <typename T>
inline void st_release_sys_global(T* ptr, T value) {
    auto atomic_ref = sycl::atomic_ref<T,
                                       sycl::memory_order::release,
                                       sycl::memory_scope::system,
                                       sycl::access::address_space::global_space>(*ptr);
    atomic_ref.store(value);
}

// Relaxed语义存储（模拟CUDA的st.relaxed.sys.global）
template <typename T>
inline void st_relaxed_sys_global(T* ptr, T value) {
    auto atomic_ref = sycl::atomic_ref<T,
                                       sycl::memory_order::relaxed,
                                       sycl::memory_scope::system,
                                       sycl::access::address_space::global_space>(*ptr);
    atomic_ref.store(value);
}

// 普通全局内存加载（类似__ldg，使用只读cache）
template <typename T>
inline T ld_nc_global(const T* ptr) {
    return *ptr;  // SYCL编译器会自动优化
}

// 普通全局内存存储（Non-allocating）
template <typename T>
inline void st_na_global(T* ptr, T value) {
    *ptr = value;
}

// ============================================================================
// Barrier操作
// ============================================================================

// 注意：FINISHED_SUM_TAG 和 NUM_TIMEOUT_CYCLES 已在 configs.h 中定义为宏
// #define FINISHED_SUM_TAG 1024
// #define NUM_TIMEOUT_CYCLES 200000000000ull

// 跨GPU Barrier同步
// 注意：这个函数需要根据实际的ISHMEM实现来调整
template <int kNumRanks, bool kResetBarrier = false>
inline void barrier_block(int** barrier_signal_ptrs, int rank, sycl::nd_item<1>& item) {
    auto thread_id = static_cast<int>(item.get_local_id(0));
    auto sg = item.get_sub_group();

    // 内存fence确保之前的操作可见
    if constexpr (!kResetBarrier) {
        memory_fence_system();
        item.barrier(sycl::access::fence_space::local_space);
    }

    // 原子操作更新barrier信号
    if (thread_id < kNumRanks) {
        // 对自己的barrier信号加1
        atomic_add_system(barrier_signal_ptrs[rank] + thread_id, FINISHED_SUM_TAG);
        // 对其他rank的barrier信号减1
        atomic_sub_system(barrier_signal_ptrs[thread_id] + rank, FINISHED_SUM_TAG);
    }

    // 等待所有信号归零
    // 注意：SYCL中没有直接的clock64()等效，这里简化处理
    bool done = false;
    while (!done) {
        int value = (thread_id < kNumRanks) ? ld_volatile_global(barrier_signal_ptrs[rank] + thread_id) : 0;
        
        // Sub-group内all同步检查
        bool all_done = sycl::all_of_group(sg, value <= 0);
        
        // 工作组内同步检查
        item.barrier(sycl::access::fence_space::local_space);
        
        // 简化的检查：假设第一个sub-group的结果代表整体
        if (thread_id == 0) {
            done = all_done;
        }
        done = sycl::group_broadcast(item.get_group(), done, 0);
    }

    item.barrier(sycl::access::fence_space::local_space);
}

// ============================================================================
// 向量类型（模拟CUDA的int4等）
// ============================================================================

struct alignas(16) int4 {
    int x, y, z, w;
};

struct alignas(8) int2 {
    int x, y;
};

// ============================================================================
// Pack/Unpack工具
// ============================================================================

template <typename dtype_a_t, typename dtype_b_t>
inline dtype_b_t pack2(const dtype_a_t& x, const dtype_a_t& y) {
    static_assert(sizeof(dtype_a_t) * 2 == sizeof(dtype_b_t), "Invalid dtypes");
    dtype_b_t packed;
    auto unpacked_ptr = reinterpret_cast<dtype_a_t*>(&packed);
    unpacked_ptr[0] = x;
    unpacked_ptr[1] = y;
    return packed;
}

template <typename dtype_a_t, typename dtype_b_t>
inline void unpack2(const dtype_b_t& packed, dtype_a_t& x, dtype_a_t& y) {
    static_assert(sizeof(dtype_a_t) * 2 == sizeof(dtype_b_t), "Invalid dtypes");
    auto unpacked_ptr = reinterpret_cast<const dtype_a_t*>(&packed);
    x = unpacked_ptr[0];
    y = unpacked_ptr[1];
}

}  // namespace deep_ep
