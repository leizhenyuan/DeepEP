#pragma once

#include "configs.h"

// Include template utilities
namespace {
    template <typename T>
    constexpr T align_up(T value, T alignment) {
        return (value + alignment - 1) / alignment * alignment;
    }
}

namespace deep_ep {

struct Config {
    int num_sms;
    int num_max_nvl_chunked_send_tokens;
    int num_max_nvl_chunked_recv_tokens;
    int num_max_rdma_chunked_send_tokens;
    int num_max_rdma_chunked_recv_tokens;

    Config(int num_sms,
           int num_max_nvl_chunked_send_tokens,
           int num_max_nvl_chunked_recv_tokens,
           int num_max_rdma_chunked_send_tokens,
           int num_max_rdma_chunked_recv_tokens)
        : num_sms(num_sms),
          num_max_nvl_chunked_send_tokens(num_max_nvl_chunked_send_tokens),
          num_max_nvl_chunked_recv_tokens(num_max_nvl_chunked_recv_tokens),
          num_max_rdma_chunked_send_tokens(num_max_rdma_chunked_send_tokens),
          num_max_rdma_chunked_recv_tokens(num_max_rdma_chunked_recv_tokens) {
        EP_HOST_ASSERT(num_sms >= 0);
        EP_HOST_ASSERT(num_max_nvl_chunked_send_tokens > 0 and num_max_nvl_chunked_recv_tokens > 0);
        EP_HOST_ASSERT(num_max_nvl_chunked_send_tokens < num_max_nvl_chunked_recv_tokens);
        EP_HOST_ASSERT(num_max_rdma_chunked_send_tokens > 0 and num_max_rdma_chunked_recv_tokens > 0);

        // Ceil up RDMA buffer size
        this->num_max_rdma_chunked_recv_tokens = align_up<int>(num_max_rdma_chunked_recv_tokens, num_max_rdma_chunked_send_tokens);
        EP_HOST_ASSERT(num_max_rdma_chunked_send_tokens < num_max_rdma_chunked_recv_tokens);
        // NOTES: this assertion is related to RDMA lazy head update, we must ensure senders always have space to push
        EP_HOST_ASSERT(num_max_rdma_chunked_send_tokens <= num_max_rdma_chunked_recv_tokens / 2);
    }

    // XPU version: simplified buffer size hints
    // For now, return placeholder values since XPU doesn't support NVLink/NVSHMEM yet
    size_t get_nvl_buffer_size_hint(size_t hidden_bytes, int num_ranks) const {
        // TODO: Implement XPU-specific buffer size calculation
        // For now, return a reasonable default
        const int num_channels = num_sms / 2;
        size_t num_bytes = num_channels * num_ranks * num_max_nvl_chunked_recv_tokens * hidden_bytes;
        num_bytes = ((num_bytes + 127) / 128) * 128;
        return num_bytes;
    }

    size_t get_rdma_buffer_size_hint(int64_t hidden_bytes, int num_ranks) const {
        // XPU version: simplified RDMA buffer calculation
        // For now, return a reasonable default
        const int num_channels = num_sms / 2;
        size_t num_bytes = num_channels * num_ranks * num_max_rdma_chunked_recv_tokens * hidden_bytes;
        num_bytes = ((num_bytes + 127) / 128) * 128;
        return num_bytes;
    }
};

// XPU version: simplified low-latency buffer hint
inline size_t get_low_latency_rdma_size_hint(int num_max_dispatch_tokens_per_rank, 
                                              int hidden, 
                                              int num_ranks, 
                                              int num_experts) {
    // TODO: Implement XPU-specific low-latency buffer size calculation
    // For now, return a reasonable default based on message sizes
    size_t num_bytes_per_msg = hidden + 64;  // hidden + some overhead
    size_t num_bytes = num_max_dispatch_tokens_per_rank * num_experts * num_bytes_per_msg * 4;
    return ((num_bytes + NUM_BUFFER_ALIGNMENT_BYTES) / NUM_BUFFER_ALIGNMENT_BYTES) * NUM_BUFFER_ALIGNMENT_BYTES;
}

}  // namespace deep_ep
