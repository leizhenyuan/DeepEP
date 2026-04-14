/**
 * Standalone reproducer for IGC JIT compiler crash:
 *   malloc(): invalid size (unsorted)
 *
 * Root cause: The NotifyDispatchKernel uses inline asm (lsc_load.ugm.uc.uc)
 * and cross-device atomic operations (system scope) that trigger an internal
 * compiler error (ICE) in the Intel Graphics Compiler (IGC) on BMG targets,
 * both in AOT and JIT modes.
 *
 * Build (JIT mode — reproduces at runtime):
 *   source /data/model/zhenyuan/oneapi/setvars.sh
 *   icpx -fsycl -O3 -o test_igc_malloc_crash tests/test_igc_malloc_crash.cpp
 *
 * Build (AOT mode — reproduces at link time):
 *   icpx -fsycl -fsycl-targets=spir64_gen -Xs "-device bmg" -O3 \
 *        -o test_igc_malloc_crash tests/test_igc_malloc_crash.cpp
 *
 * Run:
 *   ./test_igc_malloc_crash
 *
 * Expected: "malloc(): invalid size (unsorted)" crash from IGC
 */

#include <sycl/sycl.hpp>
#include <cstdint>
#include <iostream>
#include <cstring>

// ============================================================================
// Minimal reproducer extracted from DeepEP csrc/sycl/utils.hpp + intranode.cpp
// ============================================================================

#define FINISHED_SUM_TAG 1024

// --- inline asm: uncached load (lsc_load.ugm.uc.uc) ---
#ifdef __SYCL_DEVICE_ONLY__
inline int ld_volatile_global(const int* addr) {
    int result;
    asm volatile (
        "lsc_load.ugm.uc.uc (M1, 32) %0:d32 flat[%1]:a64"
        : "=rw"(result) : "rw"(addr)
    );
    return result;
}
#else
inline int ld_volatile_global(const int* addr) { return *addr; }
#endif

// --- system-scope atomics ---
inline int atomic_add_system(int* ptr, int value) {
    auto ref = sycl::atomic_ref<int,
        sycl::memory_order::seq_cst,
        sycl::memory_scope::system,
        sycl::access::address_space::global_space>(*ptr);
    return ref.fetch_add(value);
}

inline int atomic_sub_system(int* ptr, int value) {
    auto ref = sycl::atomic_ref<int,
        sycl::memory_order::seq_cst,
        sycl::memory_scope::system,
        sycl::access::address_space::global_space>(*ptr);
    return ref.fetch_sub(value);
}

// --- system-scope memory fence ---
inline void memory_fence_system() {
    sycl::atomic_fence(sycl::memory_order::acq_rel, sycl::memory_scope::system);
}

// --- barrier (from DeepEP barrier_block_bypass) ---
template <int kNumRanks>
void barrier_block_bypass(int** barrier_signal_ptrs, int rank,
                           sycl::nd_item<1>& item) {
    auto thread_id = static_cast<int>(item.get_local_id(0));

    memory_fence_system();
    item.barrier(sycl::access::fence_space::local_space);

    if (thread_id < kNumRanks) {
        atomic_add_system(barrier_signal_ptrs[rank] + thread_id, FINISHED_SUM_TAG);
        atomic_sub_system(barrier_signal_ptrs[thread_id] + rank, FINISHED_SUM_TAG);
    }

    if (thread_id < kNumRanks) {
        while (ld_volatile_global(barrier_signal_ptrs[rank] + thread_id) > 0) {
            // spin
        }
    }

    item.barrier(sycl::access::fence_space::local_space);
}

// --- warp reduce ---
inline int warp_reduce_sum(int value, sycl::nd_item<1>& item) {
    auto sg = item.get_sub_group();
    return sycl::reduce_over_group(sg, value, sycl::plus<int>());
}

inline bool elect_one_sync(sycl::nd_item<1>& item) {
    auto sg = item.get_sub_group();
    return sg.get_local_linear_id() == 0;
}

inline void get_channel_task_range(int num_tokens, int num_sms, int sm_id,
                                   int& start, int& end) {
    int per_sm = (num_tokens + num_sms - 1) / num_sms;
    start = sycl::min(per_sm * sm_id, num_tokens);
    end = sycl::min(start + per_sm, num_tokens);
}

// ============================================================================
// Simplified NotifyDispatchKernel — enough to trigger the IGC crash
// ============================================================================
template <int kNumRanks>
class NotifyDispatchKernel {
public:
    NotifyDispatchKernel(
        const int* num_tokens_per_rank,
        int* moe_recv_counter_mapped,
        const int* num_tokens_per_expert,
        int num_experts,
        int num_tokens,
        int num_channels,
        const bool* is_token_in_rank,
        int* channel_prefix_matrix,
        int* rank_prefix_matrix_copy,
        int num_memset_int,
        int expert_alignment,
        void** buffer_ptrs,
        int** barrier_signal_ptrs,
        int rank)
        : num_tokens_per_rank_(num_tokens_per_rank),
          moe_recv_counter_mapped_(moe_recv_counter_mapped),
          num_tokens_per_expert_(num_tokens_per_expert),
          num_experts_(num_experts),
          num_tokens_(num_tokens),
          num_channels_(num_channels),
          is_token_in_rank_(is_token_in_rank),
          channel_prefix_matrix_(channel_prefix_matrix),
          rank_prefix_matrix_copy_(rank_prefix_matrix_copy),
          num_memset_int_(num_memset_int),
          expert_alignment_(expert_alignment),
          buffer_ptrs_(buffer_ptrs),
          barrier_signal_ptrs_(barrier_signal_ptrs),
          rank_(rank) {}

    void operator()(sycl::nd_item<1> item) const {
        auto sm_id = static_cast<int>(item.get_group(0));
        auto thread_id = static_cast<int>(item.get_local_id(0));
        auto num_threads = static_cast<int>(item.get_local_range(0));
        auto lane_id = thread_id % 32;
        auto warp_id = thread_id / 32;
        auto num_warps = num_threads / 32;

        if (sm_id == 0) {
            // Block 0: barrier + rank prefix matrix computation
            barrier_block_bypass<kNumRanks>(barrier_signal_ptrs_, rank_, item);

            int *per_rank_buffer, *per_expert_buffer;
            if (thread_id < kNumRanks) {
                per_rank_buffer = static_cast<int*>(buffer_ptrs_[thread_id]);
                per_expert_buffer = per_rank_buffer + kNumRanks * kNumRanks;
            }

            int num_experts_per_rank = num_experts_ / kNumRanks;
            if (thread_id < kNumRanks) {
                per_rank_buffer[rank_ * kNumRanks + thread_id] = num_tokens_per_rank_[thread_id];
                for (int i = 0; i < num_experts_per_rank; ++i)
                    per_expert_buffer[rank_ * num_experts_per_rank + i] =
                        num_tokens_per_expert_[thread_id * num_experts_per_rank + i];
            }

            barrier_block_bypass<kNumRanks>(barrier_signal_ptrs_, rank_, item);

            auto local_buf = static_cast<int*>(buffer_ptrs_[rank_]);
            if (thread_id < kNumRanks) {
                for (int i = 1; i < kNumRanks; ++i)
                    local_buf[i * kNumRanks + thread_id] +=
                        local_buf[(i - 1) * kNumRanks + thread_id];

                if (thread_id == rank_)
                    *moe_recv_counter_mapped_ = local_buf[(kNumRanks - 1) * kNumRanks + rank_];
            }

            item.barrier(sycl::access::fence_space::local_space);

            for (int i = thread_id; i < kNumRanks * kNumRanks; i += num_threads)
                rank_prefix_matrix_copy_[i] = local_buf[i];

            auto local_expert_buf = local_buf + kNumRanks * kNumRanks;
            for (int i = thread_id; i < num_memset_int_; i += num_threads)
                local_expert_buf[i] = 0;

            item.barrier(sycl::access::fence_space::local_space);
            barrier_block_bypass<kNumRanks>(barrier_signal_ptrs_, rank_, item);

        } else {
            // Block 1+: channel prefix sum
            int dst_rank = sm_id - 1;
            for (int ch = warp_id; ch < num_channels_; ch += num_warps) {
                int start, end;
                get_channel_task_range(num_tokens_, num_channels_, ch, start, end);

                int count = 0;
                for (int64_t i = start + lane_id; i < end; i += 32)
                    count += is_token_in_rank_[i * kNumRanks + dst_rank] ? 1 : 0;

                count = warp_reduce_sum(count, item);

                if (elect_one_sync(item))
                    channel_prefix_matrix_[dst_rank * num_channels_ + ch] = count;
            }

            item.barrier(sycl::access::fence_space::local_space);

            if (thread_id == 0) {
                for (int i = 1; i < num_channels_; ++i)
                    channel_prefix_matrix_[dst_rank * num_channels_ + i] +=
                        channel_prefix_matrix_[dst_rank * num_channels_ + i - 1];
            }
        }
    }

private:
    const int* num_tokens_per_rank_;
    int* moe_recv_counter_mapped_;
    const int* num_tokens_per_expert_;
    int num_experts_;
    int num_tokens_;
    int num_channels_;
    const bool* is_token_in_rank_;
    int* channel_prefix_matrix_;
    int* rank_prefix_matrix_copy_;
    int num_memset_int_;
    int expert_alignment_;
    void** buffer_ptrs_;
    int** barrier_signal_ptrs_;
    int rank_;
};

// ============================================================================
// Main: single-device reproducer (no MPI needed)
// ============================================================================
int main() {
    constexpr int kNumRanks = 2;
    constexpr int kNumThreads = 128;
    constexpr int num_tokens = 5;
    constexpr int num_experts = 4;
    constexpr int num_channels = 4;
    constexpr int num_experts_per_rank = num_experts / kNumRanks;
    constexpr int barrier_signal_ints = 8;  // NUM_MAX_NVL_PEERS
    constexpr int num_memset_int = num_channels * kNumRanks * 4;
    constexpr int expert_alignment = 1;
    constexpr int rank = 0;

    // Use a single GPU
    sycl::queue q{sycl::gpu_selector_v, sycl::property::queue::in_order{}};
    auto dev = q.get_device();
    std::cout << "Device: " << dev.get_info<sycl::info::device::name>() << std::endl;

    // --- Allocate device memory ---
    // Simulate buffer_ptrs: each rank has a buffer of ints
    int buffer_size = kNumRanks * kNumRanks + kNumRanks * num_experts_per_rank + num_memset_int + 1024;
    int* dev_buffer_0 = sycl::malloc_device<int>(buffer_size, q);
    int* dev_buffer_1 = sycl::malloc_device<int>(buffer_size, q);
    q.memset(dev_buffer_0, 0, buffer_size * sizeof(int));
    q.memset(dev_buffer_1, 0, buffer_size * sizeof(int));

    // buffer_ptrs array (device)
    void* host_buffer_ptrs[2] = {dev_buffer_0, dev_buffer_1};
    void** dev_buffer_ptrs = sycl::malloc_device<void*>(2, q);
    q.memcpy(dev_buffer_ptrs, host_buffer_ptrs, sizeof(void*) * 2);

    // barrier_signal_ptrs: each rank has barrier_signal_ints ints
    int* dev_barrier_0 = sycl::malloc_device<int>(barrier_signal_ints, q);
    int* dev_barrier_1 = sycl::malloc_device<int>(barrier_signal_ints, q);
    q.memset(dev_barrier_0, 0, barrier_signal_ints * sizeof(int));
    q.memset(dev_barrier_1, 0, barrier_signal_ints * sizeof(int));

    int* host_barrier_ptrs[2] = {dev_barrier_0, dev_barrier_1};
    int** dev_barrier_ptrs = sycl::malloc_device<int*>(2, q);
    q.memcpy(dev_barrier_ptrs, host_barrier_ptrs, sizeof(int*) * 2);

    // Input data
    int host_num_tokens_per_rank[kNumRanks] = {5, 5};
    int host_num_tokens_per_expert[num_experts] = {5, 0, 5, 0};

    int* dev_num_tokens_per_rank = sycl::malloc_device<int>(kNumRanks, q);
    int* dev_num_tokens_per_expert = sycl::malloc_device<int>(num_experts, q);
    q.memcpy(dev_num_tokens_per_rank, host_num_tokens_per_rank, sizeof(int) * kNumRanks);
    q.memcpy(dev_num_tokens_per_expert, host_num_tokens_per_expert, sizeof(int) * num_experts);

    // is_token_in_rank: [num_tokens, kNumRanks]
    bool host_is_token_in_rank[num_tokens * kNumRanks];
    for (int i = 0; i < num_tokens; ++i)
        for (int r = 0; r < kNumRanks; ++r)
            host_is_token_in_rank[i * kNumRanks + r] = true;  // all tokens go to all ranks

    bool* dev_is_token_in_rank = sycl::malloc_device<bool>(num_tokens * kNumRanks, q);
    q.memcpy(dev_is_token_in_rank, host_is_token_in_rank, sizeof(bool) * num_tokens * kNumRanks);

    // Output
    int* dev_channel_prefix = sycl::malloc_device<int>(kNumRanks * num_channels, q);
    int* dev_rank_prefix = sycl::malloc_device<int>(kNumRanks * kNumRanks, q);
    int* dev_moe_recv_counter = sycl::malloc_device<int>(1, q);
    q.memset(dev_channel_prefix, 0, sizeof(int) * kNumRanks * num_channels);
    q.memset(dev_rank_prefix, 0, sizeof(int) * kNumRanks * kNumRanks);
    q.memset(dev_moe_recv_counter, 0xff, sizeof(int));  // -1

    q.wait();

    // --- Launch kernel ---
    int num_blocks = 1 + kNumRanks;
    sycl::range<1> global_range(num_blocks * kNumThreads);
    sycl::range<1> local_range(kNumThreads);

    std::cout << "Launching NotifyDispatchKernel<" << kNumRanks << "> with "
              << num_blocks << " blocks x " << kNumThreads << " threads..." << std::endl;
    std::cout << "(If IGC crashes, you'll see 'malloc(): invalid size (unsorted)' below)" << std::endl;

    try {
        q.submit([&](sycl::handler& cgh) {
            cgh.parallel_for(
                sycl::nd_range<1>(global_range, local_range),
                [=](sycl::nd_item<1> item) {
                    NotifyDispatchKernel<kNumRanks> kernel(
                        dev_num_tokens_per_rank,
                        dev_moe_recv_counter,
                        dev_num_tokens_per_expert,
                        num_experts,
                        num_tokens,
                        num_channels,
                        dev_is_token_in_rank,
                        dev_channel_prefix,
                        dev_rank_prefix,
                        num_memset_int,
                        expert_alignment,
                        dev_buffer_ptrs,
                        dev_barrier_ptrs,
                        rank);
                    kernel(item);
                });
        });
        q.wait();
        std::cout << "Kernel completed successfully (no IGC crash)." << std::endl;
    } catch (sycl::exception const& e) {
        std::cerr << "SYCL exception: " << e.what() << std::endl;
        return 1;
    } catch (std::exception const& e) {
        std::cerr << "Exception: " << e.what() << std::endl;
        return 1;
    }

    // Read back results
    int host_rank_prefix[kNumRanks * kNumRanks];
    int host_channel_prefix[kNumRanks * num_channels];
    int host_moe_recv;
    q.memcpy(host_rank_prefix, dev_rank_prefix, sizeof(int) * kNumRanks * kNumRanks);
    q.memcpy(host_channel_prefix, dev_channel_prefix, sizeof(int) * kNumRanks * num_channels);
    q.memcpy(&host_moe_recv, dev_moe_recv_counter, sizeof(int));
    q.wait();

    std::cout << "\nResults:" << std::endl;
    std::cout << "moe_recv_counter = " << host_moe_recv << std::endl;
    std::cout << "rank_prefix_matrix:" << std::endl;
    for (int i = 0; i < kNumRanks; ++i) {
        std::cout << "  [";
        for (int j = 0; j < kNumRanks; ++j)
            std::cout << host_rank_prefix[i * kNumRanks + j] << (j < kNumRanks - 1 ? ", " : "");
        std::cout << "]" << std::endl;
    }

    // Cleanup
    sycl::free(dev_buffer_0, q);
    sycl::free(dev_buffer_1, q);
    sycl::free(dev_buffer_ptrs, q);
    sycl::free(dev_barrier_0, q);
    sycl::free(dev_barrier_1, q);
    sycl::free(dev_barrier_ptrs, q);
    sycl::free(dev_num_tokens_per_rank, q);
    sycl::free(dev_num_tokens_per_expert, q);
    sycl::free(dev_is_token_in_rank, q);
    sycl::free(dev_channel_prefix, q);
    sycl::free(dev_rank_prefix, q);
    sycl::free(dev_moe_recv_counter, q);

    return 0;
}
