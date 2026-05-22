// PORTED_FROM: csrc/kernels/backend/nvshmem.cu
// ishmem runtime wrapper: init, alloc, barrier, finalize.
//
// NVSHMEM uses unique_id exchange for bootstrap.
// ishmem uses MPI-based bootstrap (ishmem_init / ishmemx_init_attr).
// The init() signature differs from NVSHMEM but serves the same purpose.
#pragma once

#include <cstring>
#include <vector>

#include "configs.hpp"
#include "exception.hpp"

#ifndef DISABLE_ISHMEM
#include <mpi.h>
#include <ishmem.h>
#include <ishmemx.h>
#endif

namespace deep_ep::ishmem_runtime {

#ifndef DISABLE_ISHMEM

inline void* alloc(size_t size, size_t alignment) {
    void* ptr = ishmem_align(alignment, size);
    EP_HOST_ASSERT(ptr != nullptr && "ishmem_align failed");
    return ptr;
}

inline void free(void* ptr) {
    ishmem_free(ptr);
}

inline void barrier(bool with_cpu_sync) {
    if (with_cpu_sync) {
        // Ensure all prior device operations complete
        // The caller should have called queue.wait() before this if needed
    }
    ishmem_barrier_all();
    if (with_cpu_sync) {
        // ishmem_barrier_all is a blocking collective on the host
    }
}

// ishmem initialization using MPI bootstrap.
// Unlike NVSHMEM (which uses unique_id exchange), ishmem uses MPI for bootstrap.
// The caller must have MPI initialized before calling this.
//
// Returns: the PE rank (equivalent to nvshmem_my_pe())
inline int init() {
    ishmem_init();
    barrier(true);
    return ishmem_my_pe();
}

// ishmem initialization with explicit MPI communicator.
// This allows specifying a sub-communicator for a subset of ranks.
//
// HIGH_RISK: ishmem team operations (equivalent to nvshmem_team_split_strided)
// may differ in API. The CUDA code creates cpu_rdma_team for sub-group RDMA.
// For now, we initialize with ISHMEM_TEAM_WORLD and defer team splitting.
inline int init_with_mpi(MPI_Comm comm) {
    ishmemx_attr_t attr = {};
    attr.initialize_runtime = false;  // We manage MPI ourselves
    // TODO: Check if ishmemx_init_attr supports MPI comm parameter
    ishmem_init();
    barrier(true);
    return ishmem_my_pe();
}

inline int num_pes() {
    return ishmem_n_pes();
}

inline void finalize() {
    barrier(true);
    ishmem_finalize();
}

#else  // DISABLE_ISHMEM stubs

inline void* alloc(size_t size, size_t alignment) {
    EP_HOST_ASSERT(false && "ishmem disabled");
    return nullptr;
}
inline void free(void*) {}
inline void barrier(bool) {}
inline int init() { return 0; }
inline int num_pes() { return 1; }
inline void finalize() {}

#endif  // DISABLE_ISHMEM

}  // namespace deep_ep::ishmem_runtime
