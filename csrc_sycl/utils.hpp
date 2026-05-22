// PORTED_FROM: csrc/kernels/utils.cuh
// Utility functions: memory ordering, atomics, sub-group ops, math, barriers.
#pragma once

#include "configs.hpp"
#include "exception.hpp"

#if defined(__SYCL_DEVICE_ONLY__) && defined(__SPIR__)
#include "lsc.hpp"
#endif

// ============================================================
// UNROLLED_WARP_COPY — Sub-group cooperative copy macro
// ============================================================
// PORTED_FROM: csrc/kernels/utils.cuh:5
// Replaces warp-cooperative copy with sub-group-cooperative copy.
// LD_FUNC and ST_FUNC take a pointer and return/accept the value.

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

namespace deep_ep {

// ============================================================
// VecInt type trait (unchanged from CUDA)
// ============================================================
// PORTED_FROM: csrc/kernels/utils.cuh:35

template <int kBytes>
struct VecInt {};
template <>
struct VecInt<1> { using vec_t = int8_t; };
template <>
struct VecInt<2> { using vec_t = int16_t; };
template <>
struct VecInt<4> { using vec_t = int; };
template <>
struct VecInt<8> { using vec_t = int64_t; };
template <>
struct VecInt<16> { using vec_t = int4; };

// ============================================================
// PatternVisitor (unchanged from CUDA)
// ============================================================
// PORTED_FROM: csrc/kernels/utils.cuh:53

template <typename FuncT>
struct PatternVisitor {
    FuncT func;
    explicit PatternVisitor(FuncT&& func) : func(std::forward<FuncT>(func)) {}
    auto operator[](const uint32_t& i) { return func(i); }
};

// ============================================================
// Memory Fence Functions
// ============================================================
// MEMORY_MODEL_FIX: PTX fence instructions → sycl::atomic_fence
// PORTED_FROM: csrc/kernels/utils.cuh:62-70

// fence.acq_rel.sys → atomic_fence(acq_rel, system)
inline void memory_fence() {
    sycl::atomic_fence(sycl::memory_order::acq_rel, sycl::memory_scope::system);
}

// fence.acq_rel.gpu → atomic_fence(acq_rel, device)
inline void memory_fence_gpu() {
    sycl::atomic_fence(sycl::memory_order::acq_rel, sycl::memory_scope::device);
}

// fence.acq_rel.cta → atomic_fence(acq_rel, work_group)
inline void memory_fence_cta() {
    sycl::atomic_fence(sycl::memory_order::acq_rel, sycl::memory_scope::work_group);
}

// ============================================================
// Store Functions (Release / Relaxed)
// ============================================================
// MEMORY_MODEL_FIX: PTX st.release/st.relaxed → atomic_fence + volatile store
// PORTED_FROM: csrc/kernels/utils.cuh:72-80

// st.relaxed.sys.global.s32 → volatile store (relaxed has no ordering guarantee)
inline void st_relaxed_sys_global(const int* ptr, int val) {
    *(volatile int*)ptr = val;
}

// st.release.sys.global.s32 → fence(release, system) + volatile store
inline void st_release_sys_global(const int* ptr, int val) {
    sycl::atomic_fence(sycl::memory_order::release, sycl::memory_scope::system);
    *(volatile int*)ptr = val;
}

// st.release.cta.s32 → fence(release, work_group) + volatile store
inline void st_release_cta(const int* ptr, int val) {
    sycl::atomic_fence(sycl::memory_order::release, sycl::memory_scope::work_group);
    *(volatile int*)ptr = val;
}

// ============================================================
// Load Functions (Acquire / Volatile)
// ============================================================
// MEMORY_MODEL_FIX: PTX ld.acquire/ld.volatile → volatile load + atomic_fence
// PORTED_FROM: csrc/kernels/utils.cuh:82-114

// ld.acquire.sys.global.s32 → volatile load + fence(acquire, system)
inline int ld_acquire_sys_global(const int* ptr) {
    int ret = *(volatile const int*)ptr;
    sycl::atomic_fence(sycl::memory_order::acquire, sycl::memory_scope::system);
    return ret;
}

// ld.acquire.sys.global.u64 → volatile load + fence(acquire, system)
inline uint64_t ld_acquire_sys_global(const uint64_t* ptr) {
    uint64_t ret = *(volatile const uint64_t*)ptr;
    sycl::atomic_fence(sycl::memory_order::acquire, sycl::memory_scope::system);
    return ret;
}

// ld.acquire.gpu.global.s32 → volatile load + fence(acquire, device)
inline int ld_acquire_global(const int* ptr) {
    int ret = *(volatile const int*)ptr;
    sycl::atomic_fence(sycl::memory_order::acquire, sycl::memory_scope::device);
    return ret;
}

// ld.acquire.cta.s32 → volatile load + fence(acquire, work_group)
inline int ld_acquire_cta(const int* ptr) {
    int ret = *(volatile const int*)ptr;
    sycl::atomic_fence(sycl::memory_order::acquire, sycl::memory_scope::work_group);
    return ret;
}

// ============================================================
// Atomic RMW with Fence
// ============================================================
// MEMORY_MODEL_FIX: PTX atom.add.release → fence + atomic_ref or __atomic_*
// PORTED_FROM: csrc/kernels/utils.cuh:116-126

// atom.add.release.sys.global.s32 — system-scope fetch_add with release ordering
// HIGH_RISK: System-scope atomic over PCIe IPC.
// On NVIDIA H100 (NVLink), system-scope atomics are natively cache-coherent across GPUs.
// On Intel B60/B70, GPU↔GPU is PCIe P2P only (no NVLink). The question is:
//   1. Does __atomic_fetch_add with __ATOMIC_SEQ_CST generate a system-scope atomic
//      instruction on Intel GPU? Or does it only generate a device-scope atomic?
//   2. Does sycl::atomic_fence(system) flush/invalidate caches so the write is visible
//      to a remote GPU reading the same IPC-mapped memory over PCIe?
// If either answer is "no", this atomic will NOT be visible to remote GPUs, breaking
// the barrier_block and all cross-GPU synchronization.
// VERIFICATION NEEDED: Run a two-GPU IPC atomic test on real B60/B70 hardware.
inline int atomic_add_release_sys_global(const int* ptr, int value) {
    sycl::atomic_fence(sycl::memory_order::release, sycl::memory_scope::system);
    return __atomic_fetch_add(const_cast<int*>(ptr), value, __ATOMIC_SEQ_CST);
}

// atom.add.release.gpu.global.s32 — device-scope fetch_add with release ordering
inline int atomic_add_release_global(const int* ptr, int value) {
    sycl::atomic_fence(sycl::memory_order::release, sycl::memory_scope::device);
    sycl::atomic_ref<int, sycl::memory_order::acq_rel, sycl::memory_scope::device,
                     sycl::access::address_space::global_space> ref(*const_cast<int*>(ptr));
    return ref.fetch_add(value);
}

// ============================================================
// Non-Allocating Load/Store (Cache Hints)
// ============================================================
// MEMORY_MODEL_FIX: PTX ld.relaxed.gpu.global.L1::no_allocate → plain load
// On Intel BMG, cache hints are performance-only; correctness uses plain loads.
// TODO: Replace with tvisa lscLoad/lscStore with CacheCtrl for performance tuning.
// PORTED_FROM: csrc/kernels/utils.cuh:128-230

inline uint8_t ld_na_relaxed(const uint8_t* ptr) { return *(volatile const uint8_t*)ptr; }
inline uint16_t ld_na_relaxed(const uint16_t* ptr) { return *(volatile const uint16_t*)ptr; }
inline uint32_t ld_na_relaxed(const uint32_t* ptr) { return *(volatile const uint32_t*)ptr; }
inline uint64_t ld_na_relaxed(const uint64_t* ptr) { return *(volatile const uint64_t*)ptr; }

// ld.volatile.global → volatile pointer dereference
// PORTED_FROM: csrc/kernels/utils.cuh:168-190

inline int ld_volatile_global(const int* ptr) { return *(volatile const int*)ptr; }
inline float ld_volatile_global(const float* ptr) { return *(volatile const float*)ptr; }
inline int64_t ld_volatile_global(const int64_t* ptr) { return *(volatile const int64_t*)ptr; }
inline int64_t ld_volatile_global(const uint64_t* ptr) { return static_cast<int64_t>(*(volatile const uint64_t*)ptr); }


template <typename dtype_t>
inline dtype_t ld_nc_global(const dtype_t* ptr) {
#if defined(__SYCL_DEVICE_ONLY__) && defined(__SPIR__)
    // Use tvisa lscLoad with L1UC_L3C cache control for L1 bypass
    if constexpr (sizeof(dtype_t) == 1 || sizeof(dtype_t) == 2 ||
                  sizeof(dtype_t) == 4 || sizeof(dtype_t) == 8) {
        // Scalar load: d8c32 / d16c32 / d32 / d64 with L1 uncached
        dtype_t val;
        lscLoad<32, CacheCtrl::L1UC_L3C>(val, const_cast<void*>(static_cast<const void*>(ptr)));
        return val;
    } else if constexpr (sizeof(dtype_t) == 16) {
        // 128-bit load (e.g. int4): decompose into d64x2 with L1 uncached
        int64_t tmp[2];
        lscLoad<32, CacheCtrl::L1UC_L3C>(tmp, const_cast<void*>(static_cast<const void*>(ptr)));
        return *reinterpret_cast<const dtype_t*>(tmp);
    } else {
        // Unsupported size: plain load fallback
        return *ptr;
    }
#else
    return *ptr;
#endif
}

// st.relaxed.gpu.global.L1::no_allocate — non-allocating store
// PORTED_FROM: csrc/kernels/utils.cuh:249-275

inline void st_na_relaxed(const uint8_t* ptr, uint8_t val) { *(volatile uint8_t*)const_cast<uint8_t*>(ptr) = val; }
inline void st_na_relaxed(const uint16_t* ptr, uint16_t val) { *(volatile uint16_t*)const_cast<uint16_t*>(ptr) = val; }
inline void st_na_relaxed(const uint32_t* ptr, uint32_t val) { *(volatile uint32_t*)const_cast<uint32_t*>(ptr) = val; }
inline void st_na_relaxed(const int* ptr, int val) { *(volatile int*)const_cast<int*>(ptr) = val; }
inline void st_na_relaxed(const int4* ptr, int4 val) {
    *(volatile int4*)const_cast<int4*>(ptr) = val;
}

// st.release.gpu.global.L1::no_allocate — non-allocating store with release
// PORTED_FROM: csrc/kernels/utils.cuh:277-289

inline void st_na_release(const int* ptr, int val) {
    sycl::atomic_fence(sycl::memory_order::release, sycl::memory_scope::device);
    *(volatile int*)const_cast<int*>(ptr) = val;
}

inline void st_na_release(const uint32_t* ptr, uint32_t val) {
    sycl::atomic_fence(sycl::memory_order::release, sycl::memory_scope::device);
    *(volatile uint32_t*)const_cast<uint32_t*>(ptr) = val;
}

inline void st_na_release(const uint64_t* ptr, uint64_t val) {
    sycl::atomic_fence(sycl::memory_order::release, sycl::memory_scope::device);
    *(volatile uint64_t*)const_cast<uint64_t*>(ptr) = val;
}

// st.global.L1::no_allocate — non-allocating store (plain)
// PORTED_FROM: csrc/kernels/utils.cuh:293-330

template <typename dtype_t>
inline void st_na_global(const dtype_t* ptr, const dtype_t& value) {
    *const_cast<dtype_t*>(ptr) = value;
}

// ============================================================
// Math Approximation Functions
// ============================================================
// PORTED_FROM: csrc/kernels/utils.cuh:299-308
// MEMORY_MODEL_FIX: PTX lg2.approx/ex2.approx → sycl::log2/exp2

inline float log2f_approx(const float& x) {
    return sycl::log2(x);
}

inline float exp2f_approx(const float& x) {
    return sycl::exp2(x);
}

// ============================================================
// Sub-Group (Warp) Intrinsics
// ============================================================
// MEMORY_MODEL_FIX: PTX warp ops → SYCL sub_group ops
// PORTED_FROM: csrc/kernels/utils.cuh:310-330

// mov.s32 %0, %laneid → sub_group::get_local_linear_id()
inline uint32_t get_lane_id(sycl::sub_group sg) {
    return static_cast<uint32_t>(sg.get_local_linear_id());
}

// elect.sync → sub_group leader (lane 0)
// MEMORY_MODEL_FIX: SM90 elect.sync randomly selects one lane in converged warps.
// On Intel BMG, we use lane 0 as the leader. This is correct for converged sub_groups.
inline uint32_t elect_one_sync(sycl::sub_group sg) {
    return sg.get_local_linear_id() == 0 ? 1 : 0;
}

// __shfl_sync(mask, val, src_lane) → sg.shuffle(val, src_lane)
template <typename T>
inline T shfl_sync(sycl::sub_group sg, T val, int src_lane) {
    return sycl::select_from_group(sg, val, src_lane);
}

// __shfl_xor_sync(mask, val, lane_mask) → shuffle_xor
template <typename T>
inline T shfl_xor_sync(sycl::sub_group sg, T val, int lane_mask) {
    // SYCL has sycl::permute_group_by_xor
    return sycl::permute_group_by_xor(sg, val, lane_mask);
}

// __all_sync(mask, pred) → sycl::all_of_group(sg, pred)
inline bool all_sync(sycl::sub_group sg, bool pred) {
    return sycl::all_of_group(sg, pred);
}

// __any_sync(mask, pred) → sycl::any_of_group(sg, pred)
inline bool any_sync(sycl::sub_group sg, bool pred) {
    return sycl::any_of_group(sg, pred);
}

// __syncwarp() → group_barrier(sub_group)
inline void syncwarp(sycl::sub_group sg) {
    sycl::group_barrier(sg);
}

// __ldg(ptr) — read-only cache load (CUDA texture cache). In SYCL: plain load.
template <typename T>
inline T ldg(const T* ptr) {
    return *ptr;
}

// ============================================================
// Broadcast (warp-level)
// ============================================================
// PORTED_FROM: csrc/kernels/utils.cuh:453-463

template <typename dtype_t>
inline dtype_t broadcast(sycl::sub_group sg, dtype_t& ptr, int src_lane_idx) {
    EP_STATIC_ASSERT(sizeof(dtype_t) % sizeof(int) == 0, "");
    auto send_int_values = reinterpret_cast<int*>(&ptr);
    int recv_int_values[sizeof(dtype_t) / sizeof(int)];
    #pragma unroll
    for (int i = 0; i < static_cast<int>(sizeof(dtype_t) / sizeof(int)); ++i)
        recv_int_values[i] = sycl::select_from_group(sg, send_int_values[i], src_lane_idx);
    return *reinterpret_cast<dtype_t*>(recv_int_values);
}

// ============================================================
// Reduction Functions
// ============================================================
// PORTED_FROM: csrc/kernels/utils.cuh:558-640

template <typename T>
struct ReduceSum {
    T operator()(T a, T b) const { return a + b; }
};
template <typename T>
struct ReduceMax {
    T operator()(T a, T b) const { return a > b ? a : b; }
};
template <typename T>
struct ReduceMin {
    T operator()(T a, T b) const { return a < b ? a : b; }
};
template <typename T>
struct ReduceAnd {
    T operator()(T a, T b) const { return a & b; }
};
template <typename T>
struct ReduceOr {
    T operator()(T a, T b) const { return a | b; }
};

// Unified reduction using sub_group shuffle_xor
template <int kNumLanesPerGroup, bool kIntergroupReduce, typename T, typename Op>
inline T warp_reduce(sycl::sub_group sg, T value, Op op) {
    EP_STATIC_ASSERT(kNumLanesPerGroup == 32 || kNumLanesPerGroup == 16 || kNumLanesPerGroup == 8 ||
                     kNumLanesPerGroup == 4  || kNumLanesPerGroup == 2  || kNumLanesPerGroup == 1,
                     "Invalid number of lanes");
    if constexpr (kIntergroupReduce) {
        if constexpr (kNumLanesPerGroup <= 1)
            value = op(value, sycl::permute_group_by_xor(sg, value, 1));
        if constexpr (kNumLanesPerGroup <= 2)
            value = op(value, sycl::permute_group_by_xor(sg, value, 2));
        if constexpr (kNumLanesPerGroup <= 4)
            value = op(value, sycl::permute_group_by_xor(sg, value, 4));
        if constexpr (kNumLanesPerGroup <= 8)
            value = op(value, sycl::permute_group_by_xor(sg, value, 8));
        if constexpr (kNumLanesPerGroup <= 16)
            value = op(value, sycl::permute_group_by_xor(sg, value, 16));
    } else {
        if constexpr (kNumLanesPerGroup >= 32)
            value = op(value, sycl::permute_group_by_xor(sg, value, 16));
        if constexpr (kNumLanesPerGroup >= 16)
            value = op(value, sycl::permute_group_by_xor(sg, value, 8));
        if constexpr (kNumLanesPerGroup >= 8)
            value = op(value, sycl::permute_group_by_xor(sg, value, 4));
        if constexpr (kNumLanesPerGroup >= 4)
            value = op(value, sycl::permute_group_by_xor(sg, value, 2));
        if constexpr (kNumLanesPerGroup >= 2)
            value = op(value, sycl::permute_group_by_xor(sg, value, 1));
    }
    return value;
}

template <int kNumLanesPerGroup = 32, bool kIntergroupReduce = false, typename T>
inline T warp_reduce_sum(sycl::sub_group sg, T value) {
    return warp_reduce<kNumLanesPerGroup, kIntergroupReduce, T>(sg, value, ReduceSum<T>{});
}

template <int kNumLanesPerGroup = 32, bool kIntergroupReduce = false, typename T>
inline T warp_reduce_max(sycl::sub_group sg, T value) {
    return warp_reduce<kNumLanesPerGroup, kIntergroupReduce, T>(sg, value, ReduceMax<T>{});
}

template <int kNumLanesPerGroup = 32, bool kIntergroupReduce = false, typename T>
inline T warp_reduce_min(sycl::sub_group sg, T value) {
    return warp_reduce<kNumLanesPerGroup, kIntergroupReduce, T>(sg, value, ReduceMin<T>{});
}

// ============================================================
// System-Scope Atomics (IPC / Cross-GPU memory)
// ============================================================
// MEMORY_MODEL_FIX: CUDA atomicAdd_system → fence(system) + __atomic_fetch_add
// HIGH_RISK: System-scope atomics over PCIe IPC.
// CONTEXT: DeepEP uses system-scope atomics on IPC-mapped memory for cross-GPU
// synchronization (barrier_block). On NVIDIA, atomicAdd_system is a single PTX
// instruction (atom.add.sys) that is hardware-coherent across NVLink.
// On Intel B60/B70, there is no NVLink. GPU↔GPU communication uses PCIe P2P,
// which is NOT cache-coherent by default. We emulate system-scope atomics with:
//   sycl::atomic_fence(seq_cst, system)  — flush/invalidate GPU caches
//   __atomic_fetch_add(ptr, val, SEQ_CST) — compiler built-in atomic
//   sycl::atomic_fence(seq_cst, system)  — ensure result is visible system-wide
// RISK: If the Intel GPU runtime/hardware does not honor system-scope fences
// for PCIe-mapped IPC memory, the remote GPU may see stale cached values.
// This would cause barrier_block to hang or produce incorrect synchronization.
// VERIFICATION NEEDED: Test with two GPUs sharing IPC memory over PCIe.
// PORTED_FROM: csrc/kernels/utils.cuh (implicit, used by barrier_block)

inline int atomicAdd_system(int* ptr, int val) {
    sycl::atomic_fence(sycl::memory_order::seq_cst, sycl::memory_scope::system);
    int old = __atomic_fetch_add(ptr, val, __ATOMIC_SEQ_CST);
    sycl::atomic_fence(sycl::memory_order::seq_cst, sycl::memory_scope::system);
    return old;
}

inline int atomicSub_system(int* ptr, int val) {
    sycl::atomic_fence(sycl::memory_order::seq_cst, sycl::memory_scope::system);
    int old = __atomic_fetch_sub(ptr, val, __ATOMIC_SEQ_CST);
    sycl::atomic_fence(sycl::memory_order::seq_cst, sycl::memory_scope::system);
    return old;
}

// ============================================================
// Device-Scope Atomics (sycl::atomic_ref)
// ============================================================
// PORTED_FROM: Various CUDA atomicAdd/atomicCAS calls

template <typename T>
inline T atomicAdd_device(T* ptr, T val) {
    sycl::atomic_ref<T, sycl::memory_order::relaxed, sycl::memory_scope::device,
                     sycl::access::address_space::global_space> ref(*ptr);
    return ref.fetch_add(val);
}

template <typename T>
inline T atomicMax_device(T* ptr, T val) {
    sycl::atomic_ref<T, sycl::memory_order::relaxed, sycl::memory_scope::device,
                     sycl::access::address_space::global_space> ref(*ptr);
    return ref.fetch_max(val);
}

template <typename T>
inline bool atomicCAS_device(T* ptr, T& expected, T desired) {
    sycl::atomic_ref<T, sycl::memory_order::acq_rel, sycl::memory_scope::device,
                     sycl::access::address_space::global_space> ref(*ptr);
    return ref.compare_exchange_strong(expected, desired);
}

// ============================================================
// Work-Group-Scope Atomics on Local Memory (for locks)
// ============================================================
// MEMORY_MODEL_FIX: PTX atom.acquire.cta.shared::cta.cas → atomic_ref<..., work_group, local_space>
// PORTED_FROM: csrc/kernels/utils.cuh:540-554

inline int atomic_cas_cta_acquire(int* addr, int x, int y) {
    sycl::atomic_ref<int, sycl::memory_order::acq_rel, sycl::memory_scope::work_group,
                     sycl::access::address_space::local_space> ref(*addr);
    int expected = x;
    ref.compare_exchange_strong(expected, y,
                                sycl::memory_order::acquire, sycl::memory_order::relaxed);
    return expected;  // Returns old value (= x if CAS succeeded, actual value if failed)
}

inline int atomic_exch_cta_release(int* addr, int x) {
    sycl::atomic_ref<int, sycl::memory_order::acq_rel, sycl::memory_scope::work_group,
                     sycl::access::address_space::local_space> ref(*addr);
    return ref.exchange(x, sycl::memory_order::release);
}

inline void acquire_lock(int* mutex) {
    while (atomic_cas_cta_acquire(mutex, 0, 1) != 0)
        ;
}

inline void release_lock(int* mutex) {
    atomic_exch_cta_release(mutex, 0);
}

// ============================================================
// Barrier Block (Cross-GPU IPC Barrier)
// ============================================================
// PORTED_FROM: csrc/kernels/utils.cuh:517-546
// HIGH_RISK: This is the MOST CRITICAL correctness item for the Intel port.
// barrier_block is the cross-GPU synchronization primitive used throughout DeepEP.
// It works by:
//   1. Each GPU atomically increments its OWN signal slot (via IPC-mapped memory)
//   2. Each GPU atomically decrements the signal slot on EVERY OTHER GPU
//   3. Each GPU spins until its signal slots all reach zero
// This requires that atomicAdd_system/atomicSub_system on IPC-mapped memory are
// visible to ALL GPUs in the system. On NVIDIA (NVLink), this is guaranteed by
// hardware cache coherence. On Intel B60/B70 (PCIe), we rely on:
//   - sycl::atomic_fence(seq_cst, system) to flush GPU L1/L2 caches
//   - __atomic_fetch_add/__atomic_fetch_sub with SEQ_CST ordering
//   - ld_volatile_global (volatile load) for spin-wait polling
// If ANY of these do not provide system-wide visibility over PCIe, the barrier
// will hang (GPU spins forever waiting for a value that was written but not flushed).
// VERIFICATION NEEDED: Two-GPU IPC barrier test on real B60/B70 hardware.
// MEMORY_MODEL_FIX: atomicAdd_system/atomicSub_system + volatile polling

template <int kNumRanks, bool kSyncOnly = false>
inline void barrier_block(int** barrier_signal_ptrs, int rank, sycl::nd_item<1> item) {
    auto thread_id = static_cast<int>(item.get_local_id(0));
    auto sg = item.get_sub_group();

    // For non-sync-only cases, prior memory operations must be visible at system scope
    if constexpr (!kSyncOnly) {
        memory_fence();
        sycl::group_barrier(item.get_group());
    }

    // Add self-ranks, sub other ranks
    if (thread_id < kNumRanks) {
        atomicAdd_system(barrier_signal_ptrs[rank] + thread_id, FINISHED_SUM_TAG);
        atomicSub_system(barrier_signal_ptrs[thread_id] + rank, FINISHED_SUM_TAG);
    }
    EP_DEVICE_ASSERT(kNumRanks <= static_cast<int>(item.get_local_range(0)));

    // Spin-wait for all signals to reach zero
    // HIGH_RISK: No clock64() equivalent on SYCL; using iteration counter for timeout.
    uint64_t timeout_counter = 0;
    while (true) {
        auto value = thread_id < kNumRanks ? ld_volatile_global(barrier_signal_ptrs[rank] + thread_id) : 0;
        if (all_sync(sg, value <= 0))
            break;

        if (++timeout_counter > NUM_TIMEOUT_CYCLES / 1000) {
            // Approximate timeout — adjust divisor based on actual clock rate
            if (thread_id < kNumRanks) {
                sycl::ext::oneapi::experimental::printf(
                    "DeepEP timeout check failed: rank = %d, thread = %d, value = %d\n",
                    rank, thread_id, value);
            }
            break;  // Cannot trap; break out
        }
    }
    sycl::group_barrier(item.get_group());
}

// ============================================================
// Math Utilities
// ============================================================
// PORTED_FROM: csrc/kernels/utils.cuh:441-451

template <typename dtype_t>
constexpr dtype_t ceil_div(dtype_t a, dtype_t b) {
    return (a + b - 1) / b;
}

template <typename dtype_t>
constexpr dtype_t align_up(dtype_t a, dtype_t b) {
    return ceil_div<dtype_t>(a, b) * b;
}

template <typename dtype_t>
constexpr dtype_t align_down(dtype_t a, dtype_t b) {
    return a / b * b;
}

inline void get_channel_task_range(int num_tokens, int num_sms, int sm_id,
                                   int& token_start_idx, int& token_end_idx) {
    int num_tokens_per_sm = ceil_div(num_tokens, num_sms);
    token_start_idx = sycl::min(num_tokens_per_sm * sm_id, num_tokens);
    token_end_idx = sycl::min(token_start_idx + num_tokens_per_sm, num_tokens);
}

template <typename dtype_a_t, typename dtype_b_t>
inline dtype_b_t pack2(const dtype_a_t& x, const dtype_a_t& y) {
    EP_STATIC_ASSERT(sizeof(dtype_a_t) * 2 == sizeof(dtype_b_t), "Invalid dtypes");
    dtype_b_t packed;
    auto unpacked_ptr = reinterpret_cast<dtype_a_t*>(&packed);
    unpacked_ptr[0] = x;
    unpacked_ptr[1] = y;
    return packed;
}

template <typename dtype_a_t, typename dtype_b_t>
inline void unpack2(const dtype_b_t& packed, dtype_a_t& x, dtype_a_t& y) {
    EP_STATIC_ASSERT(sizeof(dtype_a_t) * 2 == sizeof(dtype_b_t), "Invalid dtypes");
    auto unpacked_ptr = reinterpret_cast<const dtype_a_t*>(&packed);
    x = unpacked_ptr[0];
    y = unpacked_ptr[1];
}

// ============================================================
// FP8 Utilities
// ============================================================
// PORTED_FROM: csrc/kernels/utils.cuh:466-507

constexpr float kFP8Margin = 1e-4;
constexpr float kFinfoAmaxE4M3 = 448.0f;
constexpr float kFinfoAmaxInvE4M3 = 1 / 448.0f;

inline float fast_pow2(int x) {
    uint32_t bits_x = (x + 127) << 23;
    return *reinterpret_cast<float*>(&bits_x);
}

inline int fast_log2_ceil(float x) {
    auto bits_x = *reinterpret_cast<uint32_t*>(&x);
    auto exp_x = (bits_x >> 23) & 0xff;
    auto man_bits = bits_x & ((1 << 23) - 1);
    return exp_x - 127 + (man_bits != 0);
}

inline void calculate_fp8_scales(float amax, float& scale, float& scale_inv, bool round_scale) {
    if (round_scale) {
        auto exp_scale_inv = fast_log2_ceil(amax * kFinfoAmaxInvE4M3);
        scale = fast_pow2(-exp_scale_inv);
        scale_inv = fast_pow2(exp_scale_inv);
    } else {
        scale_inv = amax * kFinfoAmaxInvE4M3;
        scale = kFinfoAmaxE4M3 / amax;
    }
}

template <bool kIsUE8M0, typename out_dtype_t = std::conditional_t<kIsUE8M0, uint8_t, float>>
inline out_dtype_t extract_required_scale_format(float value) {
    if constexpr (kIsUE8M0) {
        return static_cast<uint8_t>((*reinterpret_cast<uint32_t*>(&value)) >> 23);
    } else {
        return value;
    }
}

//   NBarrier nb_sender, nb_forwarder;
//   nb_sender.init(kNumSenderWarps + 1);     // all sub-groups call init
//   nb_forwarder.init(NUM_MAX_NVL_PEERS + 1);
//   ...
//   if (is_sender) nb_sender.sync();         // only sender sub-groups
//   if (is_forwarder) nb_forwarder.sync();   // only forwarder sub-groups

#if defined(__SYCL_DEVICE_ONLY__) && defined(__SPIR__)

struct __namedBarrier;

extern SYCL_EXTERNAL __namedBarrier __attribute__((opencl_local)) *
named_barrier_init(int count);

extern SYCL_EXTERNAL void work_group_named_barrier(
    __namedBarrier __attribute__((opencl_local)) *, unsigned int);

#endif // __SYCL_DEVICE_ONLY__ && __SPIR__

constexpr unsigned int CLK_LOCAL_MEM_FENCE  = 0x1;
constexpr unsigned int CLK_GLOBAL_MEM_FENCE = 0x2;

class NBarrier {
#if defined(__SYCL_DEVICE_ONLY__) && defined(__SPIR__)
    __namedBarrier __attribute__((opencl_local)) * handle_ = nullptr;
#endif

public:
    inline void init([[maybe_unused]] int count) {
#if defined(__SYCL_DEVICE_ONLY__) && defined(__SPIR__)
        handle_ = named_barrier_init(count);
#endif
    }

    inline void sync([[maybe_unused]] unsigned int flags = CLK_LOCAL_MEM_FENCE) {
#if defined(__SYCL_DEVICE_ONLY__) && defined(__SPIR__)
        work_group_named_barrier(handle_, flags);
#endif
    }
};

// ============================================================
// __ffs equivalent (find first set bit, 1-indexed, 0 if none)
// ============================================================

inline int ffs_compat(uint32_t x) {
    if (x == 0) return 0;
    int n = 1;
    if ((x & 0xFFFF) == 0) { n += 16; x >>= 16; }
    if ((x & 0xFF) == 0)   { n += 8;  x >>= 8; }
    if ((x & 0xF) == 0)    { n += 4;  x >>= 4; }
    if ((x & 0x3) == 0)    { n += 2;  x >>= 2; }
    if ((x & 0x1) == 0)    { n += 1; }
    return n;
}

}  // namespace deep_ep
