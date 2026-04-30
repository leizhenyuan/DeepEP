#pragma once

#include <cstdint>

namespace deep_ep {

// ============================================================================
// Buffer wrapper class for SYCL (similar to CUDA buffer.cuh)
// 用于管理全局内存指针和偏移量
// ============================================================================

template <typename dtype_t>
struct Buffer {
private:
    uint8_t* ptr;

public:
    int64_t total_bytes;

    Buffer() : ptr(nullptr), total_bytes(0) {}

    // 构造函数：从全局指针分配内存区域
    // gbl_ptr: 输入/输出参数，会被更新到下一个可用位置
    // num_elems: 元素数量
    // offset: 起始偏移量（元素单位）
    Buffer(void*& gbl_ptr, int64_t num_elems, int64_t offset = 0) {
        total_bytes = num_elems * sizeof(dtype_t);
        ptr = static_cast<uint8_t*>(gbl_ptr) + offset * sizeof(dtype_t);
        gbl_ptr = static_cast<uint8_t*>(gbl_ptr) + total_bytes;
    }

    // 同时更新另一个全局指针
    Buffer advance_also(void*& gbl_ptr) {
        gbl_ptr = static_cast<uint8_t*>(gbl_ptr) + total_bytes;
        return *this;
    }

    // 获取底层buffer指针
    dtype_t* buffer() { return reinterpret_cast<dtype_t*>(ptr); }

    // 获取底层buffer指针（const版本）
    const dtype_t* buffer() const { return reinterpret_cast<const dtype_t*>(ptr); }

    // 数组下标访问
    dtype_t& operator[](int64_t idx) { return buffer()[idx]; }
    const dtype_t& operator[](int64_t idx) const { return buffer()[idx]; }
};

// ============================================================================
// AsymBuffer - 非对称缓冲区（用于多rank场景）
// ============================================================================

template <typename dtype_t, int kNumRanks = 1>
struct AsymBuffer {
private:
    uint8_t* ptrs[kNumRanks];
    int64_t num_bytes;

public:
    int64_t total_bytes;

    // 单rank构造函数
    AsymBuffer(void*& gbl_ptr, int64_t num_elems, int num_ranks, int sm_id = 0, int num_sms = 1, int64_t offset = 0) {
        static_assert(kNumRanks == 1, "This constructor is for single rank only");
        num_bytes = num_elems * sizeof(dtype_t);

        int64_t per_channel_bytes = num_bytes * num_ranks;
        total_bytes = per_channel_bytes * num_sms;
        ptrs[0] = static_cast<uint8_t*>(gbl_ptr) + per_channel_bytes * sm_id + num_bytes * offset;
        gbl_ptr = static_cast<uint8_t*>(gbl_ptr) + total_bytes;
    }

    // 多rank构造函数
    AsymBuffer(void** gbl_ptrs, int64_t num_elems, int num_ranks, int sm_id = 0, int num_sms = 1, int64_t offset = 0) {
        static_assert(kNumRanks > 1, "This constructor is for multiple ranks");
        num_bytes = num_elems * sizeof(dtype_t);

        int64_t per_channel_bytes = num_bytes * num_ranks;
        total_bytes = per_channel_bytes * num_sms;
        for (int i = 0; i < kNumRanks; ++i) {
            ptrs[i] = static_cast<uint8_t*>(gbl_ptrs[i]) + per_channel_bytes * sm_id + num_bytes * offset;
            gbl_ptrs[i] = static_cast<uint8_t*>(gbl_ptrs[i]) + total_bytes;
        }
    }

    // 按偏移量前进
    void advance(int64_t shift) {
        #pragma unroll
        for (int i = 0; i < kNumRanks; ++i)
            ptrs[i] = ptrs[i] + shift * sizeof(dtype_t);
    }

    // 同时更新另一个全局指针
    AsymBuffer advance_also(void*& gbl_ptr) {
        gbl_ptr = static_cast<uint8_t*>(gbl_ptr) + total_bytes;
        return *this;
    }

    // 同时更新多个全局指针
    template <int kNumAlsoRanks>
    AsymBuffer advance_also(void** gbl_ptrs) {
        for (int i = 0; i < kNumAlsoRanks; ++i)
            gbl_ptrs[i] = static_cast<uint8_t*>(gbl_ptrs[i]) + total_bytes;
        return *this;
    }

    // 获取buffer指针（单rank场景）
    dtype_t* buffer(int idx = 0) {
        static_assert(kNumRanks == 1, "`buffer` is only available for single rank case");
        return reinterpret_cast<dtype_t*>(ptrs[0] + num_bytes * idx);
    }

    // 获取指定rank的buffer指针（多rank场景）
    dtype_t* buffer_by(int rank_idx, int idx = 0) {
        static_assert(kNumRanks > 1, "`buffer_by` is only available for multiple rank case");
        return reinterpret_cast<dtype_t*>(ptrs[rank_idx] + num_bytes * idx);
    }
};

}  // namespace deep_ep
