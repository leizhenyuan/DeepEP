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

#include <sycl/sycl.hpp>
#include <cstdint>
#include <cassert>

// SYCL版本的断言宏定义
#define EP_HOST_ASSERT(condition) assert(condition)
#define EP_STATIC_ASSERT(condition, message) static_assert(condition, message)

// XPU version type definitions
typedef struct { int x, y, z, w; } int4;  // SYCL equivalent of CUDA int4

// Utility functions for XPU
template<typename T>
constexpr T ceil_div(T numerator, T denominator) {
    return (numerator + denominator - 1) / denominator;
}

namespace deep_ep {

#ifndef TOPK_IDX_BITS
#define TOPK_IDX_BITS 64
#endif

#define INT_BITS_T2(bits) int##bits##_t
#define INT_BITS_T(bits) INT_BITS_T2(bits)
typedef INT_BITS_T(TOPK_IDX_BITS) topk_idx_t;  // int32_t or int64_t
#undef INT_BITS_T
#undef INT_BITS_T2

// Unified type aliases for cross-platform API
// todo DataType should not be nullptr_t, currently for build pass
using StreamType = sycl::queue;
using DataType = std::nullptr_t;

}  // namespace deep_ep


