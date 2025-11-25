#pragma once

#define NUM_MAX_NVL_PEERS 8
#define NUM_MAX_RDMA_PEERS 20
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
#define NUM_TIMEOUT_CYCLES 20000000000ull  // 20G cycles ~= 10s
#endif

#define LOW_LATENCY_SEND_PHASE 1
#define LOW_LATENCY_RECV_PHASE 2

// Assert macros for XPU
#define EP_STATIC_ASSERT(condition, message) static_assert(condition, message)
#define EP_HOST_ASSERT(condition) assert(condition)

#include <cassert>
#include <cstdint>

// Define int4 for SYCL (CUDA has this builtin)
struct int4 {
    int x, y, z, w;
};

namespace deep_ep {

#ifndef TOPK_IDX_BITS
#define TOPK_IDX_BITS 64
#endif

#define INT_BITS_T2(bits) int##bits##_t
#define INT_BITS_T(bits) INT_BITS_T2(bits)
typedef INT_BITS_T(TOPK_IDX_BITS) topk_idx_t;  // int32_t or int64_t
#undef INT_BITS_T
#undef INT_BITS_T2

// Helper functions that exist in CUDA
template<typename T>
inline constexpr T ceil_div(T a, T b) {
    return (a + b - 1) / b;
}

template<typename T>
inline constexpr T align_up(T val, T alignment) {
    return ceil_div(val, alignment) * alignment;
}

template<typename T>
inline constexpr T align_down(T val, T alignment) {
    return (val / alignment) * alignment;
}

}  // namespace deep_ep

