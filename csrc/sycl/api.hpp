#pragma once

#include <vector>
#include "configs.h"
namespace deep_ep {

// Internode runtime
namespace internode {

std::vector<uint8_t> get_unique_id();

int init(const std::vector<uint8_t>& root_unique_id_val, int rank, int num_ranks, bool low_latency_mode);

void* alloc(size_t size, size_t alignment);

void free(void* ptr);

void barrier();

void finalize();

}  // namespace internode

// Layout kernels
namespace layout {

void get_dispatch_layout(const topk_idx_t* topk_idx,
                         int* num_tokens_per_rank,
                         int* num_tokens_per_rdma_rank,
                         int* num_tokens_per_expert,
                         bool* is_token_in_rank,
                         int num_tokens,
                         int num_topk,
                         int num_ranks,
                         int num_experts,
                         deep_ep::StreamType stream);

}  // namespace layout

}  // namespace deep_ep
