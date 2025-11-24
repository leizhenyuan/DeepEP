#include <iostream>
#include <vector>
#include <random>
#include <cstring>
#include <cstdint>

// Define types and constants before including layout
#define NUM_MAX_NVL_PEERS 8
using topk_idx_t = int32_t;

#include "layout.hpp"

// CPU reference implementation
void compute_layout_cpu(const topk_idx_t* topk_idx,
                        int* num_tokens_per_rank,
                        int* num_tokens_per_rdma_rank,
                        int* num_tokens_per_expert,
                        bool* is_token_in_rank,
                        int num_tokens,
                        int num_topk,
                        int num_ranks,
                        int num_experts) {
    int num_expert_per_rank = num_experts / num_ranks;
    int num_rdma_ranks = std::max(1, num_ranks / NUM_MAX_NVL_PEERS);
    
    // Initialize outputs
    std::memset(num_tokens_per_rank, 0, num_ranks * sizeof(int));
    std::memset(num_tokens_per_rdma_rank, 0, num_rdma_ranks * sizeof(int));
    std::memset(num_tokens_per_expert, 0, num_experts * sizeof(int));
    std::memset(is_token_in_rank, 0, num_tokens * num_ranks * sizeof(bool));
    
    // Compute statistics
    for (int token_idx = 0; token_idx < num_tokens; ++token_idx) {
        std::vector<bool> visited_ranks(num_ranks, false);
        std::vector<bool> visited_rdma_ranks(num_rdma_ranks, false);
        
        for (int k = 0; k < num_topk; ++k) {
            int expert_idx = topk_idx[token_idx * num_topk + k];
            
            // Count tokens per expert
            num_tokens_per_expert[expert_idx]++;
            
            // Determine which rank this expert belongs to
            int rank_idx = expert_idx / num_expert_per_rank;
            int rdma_rank_idx = rank_idx / NUM_MAX_NVL_PEERS;
            
            // Mark that this token is in this rank
            if (!visited_ranks[rank_idx]) {
                visited_ranks[rank_idx] = true;
                is_token_in_rank[token_idx * num_ranks + rank_idx] = true;
                num_tokens_per_rank[rank_idx]++;
            }
            
            // Mark RDMA rank
            if (!visited_rdma_ranks[rdma_rank_idx]) {
                visited_rdma_ranks[rdma_rank_idx] = true;
                num_tokens_per_rdma_rank[rdma_rank_idx]++;
            }
        }
    }
}

bool compare_results(const int* xpu_result, const int* cpu_result, int size, const std::string& name) {
    bool match = true;
    for (int i = 0; i < size; ++i) {
        if (xpu_result[i] != cpu_result[i]) {
            if (match) {
                std::cout << "\n❌ Mismatch in " << name << ":" << std::endl;
                match = false;
            }
            std::cout << "  [" << i << "] XPU=" << xpu_result[i] 
                     << ", CPU=" << cpu_result[i] << std::endl;
        }
    }
    return match;
}

bool compare_bool_results(const bool* xpu_result, const bool* cpu_result, int size, const std::string& name) {
    bool match = true;
    int mismatch_count = 0;
    for (int i = 0; i < size; ++i) {
        if (xpu_result[i] != cpu_result[i]) {
            if (match) {
                std::cout << "\n❌ Mismatch in " << name << ":" << std::endl;
                match = false;
            }
            if (mismatch_count < 10) {  // Show first 10 mismatches
                std::cout << "  [" << i << "] XPU=" << (xpu_result[i] ? "true" : "false")
                         << ", CPU=" << (cpu_result[i] ? "true" : "false") << std::endl;
            }
            mismatch_count++;
        }
    }
    if (mismatch_count > 10) {
        std::cout << "  ... and " << (mismatch_count - 10) << " more mismatches" << std::endl;
    }
    return match;
}

void test_case(int num_tokens, int num_topk, int num_experts, int num_ranks, sycl::queue& q) {
    std::cout << "\n========================================" << std::endl;
    std::cout << "Testing: tokens=" << num_tokens << ", topk=" << num_topk 
              << ", experts=" << num_experts << ", ranks=" << num_ranks << std::endl;
    
    // Validate parameters
    if (num_experts % num_ranks != 0) {
        std::cout << "⚠️  Skipped: num_experts must be divisible by num_ranks" << std::endl;
        return;
    }
    
    int num_rdma_ranks = std::max(1, num_ranks / NUM_MAX_NVL_PEERS);
    
    // Generate random topk_idx on CPU
    std::mt19937 rng(42);
    std::uniform_int_distribution<int> dist(0, num_experts - 1);
    
    std::vector<topk_idx_t> topk_idx_host(num_tokens * num_topk);
    for (auto& val : topk_idx_host) {
        val = static_cast<topk_idx_t>(dist(rng));
    }
    
    // CPU reference results (use uint8_t instead of bool for vector compatibility)
    std::vector<int> cpu_num_tokens_per_rank(num_ranks);
    std::vector<int> cpu_num_tokens_per_rdma_rank(num_rdma_ranks);
    std::vector<int> cpu_num_tokens_per_expert(num_experts);
    std::vector<uint8_t> cpu_is_token_in_rank(num_tokens * num_ranks);
    
    compute_layout_cpu(topk_idx_host.data(),
                       cpu_num_tokens_per_rank.data(),
                       cpu_num_tokens_per_rdma_rank.data(),
                       cpu_num_tokens_per_expert.data(),
                       reinterpret_cast<bool*>(cpu_is_token_in_rank.data()),
                       num_tokens, num_topk, num_ranks, num_experts);
    
    // Allocate device memory
    topk_idx_t* topk_idx_dev = sycl::malloc_device<topk_idx_t>(num_tokens * num_topk, q);
    int* num_tokens_per_rank_dev = sycl::malloc_device<int>(num_ranks, q);
    int* num_tokens_per_rdma_rank_dev = sycl::malloc_device<int>(num_rdma_ranks, q);
    int* num_tokens_per_expert_dev = sycl::malloc_device<int>(num_experts, q);
    bool* is_token_in_rank_dev = sycl::malloc_device<bool>(num_tokens * num_ranks, q);
    
    // Copy input to device
    q.memcpy(topk_idx_dev, topk_idx_host.data(), num_tokens * num_topk * sizeof(topk_idx_t));
    q.memset(num_tokens_per_rank_dev, 0, num_ranks * sizeof(int));
    q.memset(num_tokens_per_rdma_rank_dev, 0, num_rdma_ranks * sizeof(int));
    q.memset(num_tokens_per_expert_dev, 0, num_experts * sizeof(int));
    q.memset(is_token_in_rank_dev, 0, num_tokens * num_ranks * sizeof(bool));
    q.wait();
    
    // Run XPU kernel
    try {
        deep_ep::layout::get_dispatch_layout(
            topk_idx_dev,
            num_tokens_per_rank_dev,
            num_tokens_per_rdma_rank_dev,
            num_tokens_per_expert_dev,
            is_token_in_rank_dev,
            num_tokens,
            num_topk,
            num_ranks,
            num_experts,
            q
        );
    } catch (sycl::exception const& e) {
        std::cerr << "SYCL kernel exception: " << e.what() << std::endl;
        // Cleanup
        sycl::free(topk_idx_dev, q);
        sycl::free(num_tokens_per_rank_dev, q);
        sycl::free(num_tokens_per_rdma_rank_dev, q);
        sycl::free(num_tokens_per_expert_dev, q);
        sycl::free(is_token_in_rank_dev, q);
        return;
    }
    
    // Copy results back to host (use uint8_t instead of bool for vector compatibility)
    std::vector<int> xpu_num_tokens_per_rank(num_ranks);
    std::vector<int> xpu_num_tokens_per_rdma_rank(num_rdma_ranks);
    std::vector<int> xpu_num_tokens_per_expert(num_experts);
    std::vector<uint8_t> xpu_is_token_in_rank(num_tokens * num_ranks);
    
    q.memcpy(xpu_num_tokens_per_rank.data(), num_tokens_per_rank_dev, num_ranks * sizeof(int));
    q.memcpy(xpu_num_tokens_per_rdma_rank.data(), num_tokens_per_rdma_rank_dev, num_rdma_ranks * sizeof(int));
    q.memcpy(xpu_num_tokens_per_expert.data(), num_tokens_per_expert_dev, num_experts * sizeof(int));
    q.memcpy(xpu_is_token_in_rank.data(), is_token_in_rank_dev, num_tokens * num_ranks * sizeof(bool));
    q.wait();
    
    // Compare results
    bool all_match = true;
    all_match &= compare_results(xpu_num_tokens_per_rank.data(), cpu_num_tokens_per_rank.data(), 
                                  num_ranks, "num_tokens_per_rank");
    all_match &= compare_results(xpu_num_tokens_per_rdma_rank.data(), cpu_num_tokens_per_rdma_rank.data(),
                                  num_rdma_ranks, "num_tokens_per_rdma_rank");
    all_match &= compare_results(xpu_num_tokens_per_expert.data(), cpu_num_tokens_per_expert.data(),
                                  num_experts, "num_tokens_per_expert");
    all_match &= compare_bool_results(reinterpret_cast<bool*>(xpu_is_token_in_rank.data()), 
                                       reinterpret_cast<bool*>(cpu_is_token_in_rank.data()),
                                       num_tokens * num_ranks, "is_token_in_rank");
    
    // Verify consistency
    int total_expert_tokens = 0;
    for (int i = 0; i < num_experts; ++i) {
        total_expert_tokens += xpu_num_tokens_per_expert[i];
    }
    bool valid_total = (total_expert_tokens == num_tokens * num_topk);
    
    if (all_match && valid_total) {
        std::cout << "✅ Test PASSED" << std::endl;
        std::cout << "   Total expert tokens: " << total_expert_tokens 
                  << " (expected: " << num_tokens * num_topk << ")" << std::endl;
    } else {
        std::cout << "❌ Test FAILED" << std::endl;
        if (!valid_total) {
            std::cout << "   Total expert tokens: " << total_expert_tokens 
                      << " (expected: " << num_tokens * num_topk << ")" << std::endl;
        }
    }
    
    // Cleanup
    sycl::free(topk_idx_dev, q);
    sycl::free(num_tokens_per_rank_dev, q);
    sycl::free(num_tokens_per_rdma_rank_dev, q);
    sycl::free(num_tokens_per_expert_dev, q);
    sycl::free(is_token_in_rank_dev, q);
}

int main() {
    try {
        // Create SYCL queue
        sycl::queue q(sycl::gpu_selector_v);
        std::cout << "Running on device: " 
                  << q.get_device().get_info<sycl::info::device::name>() 
                  << std::endl;
        
        std::cout << "Device max compute units: "
                  << q.get_device().get_info<sycl::info::device::max_compute_units>()
                  << std::endl;
        
        // Run test cases
        test_case(128, 1, 64, 8, q);
        test_case(512, 2, 64, 8, q);
        test_case(1024, 2, 64, 8, q);
        test_case(1024, 4, 128, 8, q);
        test_case(2048, 2, 128, 16, q);
        
        // Edge case: all tokens to same experts
        std::cout << "\n========================================" << std::endl;
        std::cout << "Testing edge case: all tokens to experts 0 and 1" << std::endl;
        
        int num_tokens = 100, num_topk = 2, num_experts = 64, num_ranks = 8;
        std::vector<topk_idx_t> topk_idx_edge(num_tokens * num_topk);
        for (int i = 0; i < num_tokens; ++i) {
            topk_idx_edge[i * num_topk] = 0;
            topk_idx_edge[i * num_topk + 1] = 1;
        }
        
        topk_idx_t* topk_idx_dev = sycl::malloc_device<topk_idx_t>(num_tokens * num_topk, q);
        int* num_tokens_per_expert_dev = sycl::malloc_device<int>(num_experts, q);
        int* num_tokens_per_rank_dev = sycl::malloc_device<int>(num_ranks, q);
        int* num_tokens_per_rdma_rank_dev = sycl::malloc_device<int>(num_ranks / NUM_MAX_NVL_PEERS, q);
        bool* is_token_in_rank_dev = sycl::malloc_device<bool>(num_tokens * num_ranks, q);
        
        q.memcpy(topk_idx_dev, topk_idx_edge.data(), num_tokens * num_topk * sizeof(topk_idx_t));
        q.memset(num_tokens_per_expert_dev, 0, num_experts * sizeof(int));
        q.memset(num_tokens_per_rank_dev, 0, num_ranks * sizeof(int));
        q.memset(num_tokens_per_rdma_rank_dev, 0, (num_ranks / NUM_MAX_NVL_PEERS) * sizeof(int));
        q.memset(is_token_in_rank_dev, 0, num_tokens * num_ranks * sizeof(bool));
        q.wait();
        
        deep_ep::layout::get_dispatch_layout(
            topk_idx_dev, num_tokens_per_rank_dev, num_tokens_per_rdma_rank_dev,
            num_tokens_per_expert_dev, is_token_in_rank_dev,
            num_tokens, num_topk, num_ranks, num_experts, q
        );
        
        std::vector<int> num_tokens_per_expert(num_experts);
        std::vector<int> num_tokens_per_rank(num_ranks);
        q.memcpy(num_tokens_per_expert.data(), num_tokens_per_expert_dev, num_experts * sizeof(int));
        q.memcpy(num_tokens_per_rank.data(), num_tokens_per_rank_dev, num_ranks * sizeof(int));
        q.wait();
        
        bool edge_pass = (num_tokens_per_expert[0] == num_tokens && 
                         num_tokens_per_expert[1] == num_tokens &&
                         num_tokens_per_rank[0] == num_tokens);
        
        if (edge_pass) {
            std::cout << "✅ Edge case PASSED" << std::endl;
            std::cout << "   Expert 0: " << num_tokens_per_expert[0] << " tokens" << std::endl;
            std::cout << "   Expert 1: " << num_tokens_per_expert[1] << " tokens" << std::endl;
            std::cout << "   Rank 0: " << num_tokens_per_rank[0] << " tokens" << std::endl;
        } else {
            std::cout << "❌ Edge case FAILED" << std::endl;
        }
        
        sycl::free(topk_idx_dev, q);
        sycl::free(num_tokens_per_expert_dev, q);
        sycl::free(num_tokens_per_rank_dev, q);
        sycl::free(num_tokens_per_rdma_rank_dev, q);
        sycl::free(is_token_in_rank_dev, q);
        
        std::cout << "\n✅ All tests completed!" << std::endl;
        return 0;
        
    } catch (sycl::exception const& e) {
        std::cerr << "SYCL exception: " << e.what() << std::endl;
        return 1;
    } catch (std::exception const& e) {
        std::cerr << "Exception: " << e.what() << std::endl;
        return 1;
    }
}
