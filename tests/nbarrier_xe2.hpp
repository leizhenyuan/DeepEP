// tvisa named_barrier API for Xe2/BMG — RECOMMENDED MODIFICATION
// File: gateway.hpp (or new file: nbarrier.hpp)
//
// Key design constraints on Xe2:
//   1. NBarrierCnt kernel metadata MUST be set — only via IGC processing named_barrier_init
//   2. Raw asm nbarrier.signal/wait CANNOT work — IGC duplicates asm into divergent branches
//   3. work_group_named_barrier generates correct convergent nbarrier.signal + wait
//   4. nbarrier 0 = work-group barrier; user named barriers start from ID=1

#pragma once

#if defined(__SYCL_DEVICE_ONLY__) && defined(__SPIR__)

// ── OpenCL named barrier declarations (IGC resolves these) ──────────────
struct __namedBarrier;

extern SYCL_EXTERNAL __namedBarrier __attribute__((opencl_local)) *
named_barrier_init(int count);

extern SYCL_EXTERNAL void work_group_named_barrier(
    __namedBarrier __attribute__((opencl_local)) *, unsigned int);

// ── Memory fence flags (from OpenCL cl_mem_fence_flags) ─────────────────
constexpr unsigned int CLK_LOCAL_MEM_FENCE  = 0x1;
constexpr unsigned int CLK_GLOBAL_MEM_FENCE = 0x2;

// ── NBarrier wrapper for DeepEP ─────────────────────────────────────────
// Usage:
//   NBarrier nb;
//   nb.init(n_sub_groups);       // call once per work-group, all lanes
//   ...
//   nb.sync();                   // signal + wait (combined), all lanes
//   nb.sync(CLK_GLOBAL_MEM_FENCE);  // with global memory fence
//
// For multiple named barriers (up to 31):
//   NBarrier nb1, nb2;
//   nb1.init(n_sub_groups);
//   nb2.init(n_sub_groups);
//   ... nb1.sync(); ... nb2.sync(); ...
//
class NBarrier {
    __namedBarrier __attribute__((opencl_local)) * handle_ = nullptr;

public:
    // Initialize the named barrier. Must be called by ALL lanes in the work-group.
    // count = number of sub-groups participating in this barrier.
    inline void init(int count) {
        handle_ = named_barrier_init(count);
    }

    // Signal + wait (combined). Must be called by ALL lanes in the work-group
    // at a convergence point (not inside divergent branches).
    // flags: CLK_LOCAL_MEM_FENCE and/or CLK_GLOBAL_MEM_FENCE
    inline void sync(unsigned int flags = CLK_LOCAL_MEM_FENCE) {
        work_group_named_barrier(handle_, flags);
    }
};

// ── Convenience function for simple single-barrier pattern ──────────────
// Call once per kernel: initializes + returns barrier handle
inline NBarrier nbarrier_create(int sub_group_count) {
    NBarrier nb;
    nb.init(sub_group_count);
    return nb;
}

#endif // __SYCL_DEVICE_ONLY__ && __SPIR__
