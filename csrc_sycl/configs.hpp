// PORTED_FROM: csrc/kernels/configs.cuh
// Shared configuration constants and types for the DeepEP SYCL port.
#pragma once

#include <sycl/sycl.hpp>
#include <cstdint>

// ============================================================
// Configuration Constants
// ============================================================

#define NUM_MAX_NVL_PEERS 2
#define NUM_MAX_RDMA_PEERS 20

// Type that can hold NUM_MAX_NVL_PEERS bools packed as bytes.
// Must satisfy: sizeof(nvl_rank_mask_t) == NUM_MAX_NVL_PEERS * sizeof(bool).
// Used to load is_token_in_rank[nvl_rank_0..nvl_rank_N] in one shot.
#if NUM_MAX_NVL_PEERS == 8
using nvl_rank_mask_t = uint64_t;
#elif NUM_MAX_NVL_PEERS == 4
using nvl_rank_mask_t = uint32_t;
#elif NUM_MAX_NVL_PEERS == 2
using nvl_rank_mask_t = uint16_t;
#elif NUM_MAX_NVL_PEERS == 1
using nvl_rank_mask_t = uint8_t;
#else
#error "Unsupported NUM_MAX_NVL_PEERS value"
#endif
#define NUM_WORKSPACE_BYTES (32 * 1024 * 1024)
#define NUM_MAX_LOCAL_EXPERTS 1024
#define NUM_BUFFER_ALIGNMENT_BYTES 128

#define FINISHED_SUM_TAG 1024
#define NUM_WAIT_NANOSECONDS 500

#ifndef ENABLE_FAST_DEBUG
#define NUM_CPU_TIMEOUT_SECS 100
#define NUM_TIMEOUT_CYCLES 200000000000ull  // 200G cycles ~= 100s
#else
#define NUM_CPU_TIMEOUT_SECS 10
#define NUM_TIMEOUT_CYCLES 20000000000ull   // 20G cycles ~= 10s
#endif

#define LOW_LATENCY_SEND_PHASE 1
#define LOW_LATENCY_RECV_PHASE 2

// Intel BMG sub-group size (confirmed = 32)
#define SUBGROUP_SIZE 32

// ============================================================
// CUDA-compatible Vector Types for SYCL
// ============================================================

struct int2 {
    int x, y;
};

struct int4 {
    int x, y, z, w;
    // Volatile assignment needed for st_na_relaxed(volatile int4* ptr, int4 val)
    volatile int4& operator=(const int4& rhs) volatile {
        x = rhs.x; y = rhs.y; z = rhs.z; w = rhs.w;
        return *this;
    }
};

// ============================================================
// Namespace and Types
// ============================================================

namespace deep_ep {

#ifndef TOPK_IDX_BITS
#define TOPK_IDX_BITS 64
#endif

#define INT_BITS_T2(bits) int##bits##_t
#define INT_BITS_T(bits) INT_BITS_T2(bits)
typedef INT_BITS_T(TOPK_IDX_BITS) topk_idx_t;  // int32_t or int64_t
#undef INT_BITS_T
#undef INT_BITS_T2

}  // namespace deep_ep

// ============================================================
// ishmem Headers (conditional)
// ============================================================

#ifndef DISABLE_ISHMEM
#include <ishmem.h>
#include <ishmemx.h>
#endif
