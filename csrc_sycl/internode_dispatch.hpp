// PORTED_FROM: csrc/kernels/internode.cu
// DeepEP Internode Normal (High-Throughput) Dispatch Kernel — SYCL + ishmem port
//
// This file ports the `notify_dispatch` and `dispatch` kernels from CUDA/NVSHMEM/IBGDA
// to SYCL/ishmem for Intel B60/B70 (Battlemage/BMG) GPUs.
//
// === IBGDA → ishmem API Mapping Table ===
// | CUDA IBGDA Function                          | ishmem Replacement                                  | Verified In                     | Notes                          |
// |----------------------------------------------|-----------------------------------------------------|---------------------------------|--------------------------------|
// | nvshmemi_ibgda_put_nbi_warp<true>(dst,src,n,pe,...) | ishmemx_putmem_nbi_work_group(dst,src,n,pe,sg)| src/nbi.cpp:57                  | warp→sub_group cooperative     |
// | nvshmemi_ibgda_quiet(pe, qp)                 | ishmem_quiet()                                      | src/memory_ordering.cpp:53      | global quiet, not per-PE       |
// | nvshmemi_ibgda_amo_nonfetch_add(ptr,v,pe,...) | ishmem_uint64_atomic_add(ptr,v,pe)                  | src/ishmem.h:461                | remote atomic, non-fetch       |
// | nvshmemi_ibgda_rma_p(ptr,v,pe,...)            | ishmem_int_p(ptr,v,pe)                              | src/ishmem.h:159                | single-element put inline      |
// | nvshmem_sync_all()                            | ishmem_sync_all()                                   | src/collectives/sync.cpp:15     |                                |
// | nvshmem_sync(team)                            | ishmem_sync_all()                                   | src/collectives/sync.cpp:15     | no team variant; use sync_all  |
// | ibgda_get_state()                             | N/A                                                 | —                               | IBGDA state not needed         |
//
// === PTX → SYCL Memory Ordering Mapping ===
// | PTX Instruction               | SYCL Equivalent                                                    |
// |-------------------------------|--------------------------------------------------------------------|
// | fence.acq_rel.sys             | sycl::atomic_fence(acq_rel, system)                                |
// | fence.acq_rel.gpu             | sycl::atomic_fence(acq_rel, device)                                |
// | fence.acq_rel.cta             | sycl::atomic_fence(acq_rel, work_group)                            |
// | st.release.sys.global         | atomic_fence(release, system); volatile store                      |
// | ld.acquire.sys.global         | volatile load; atomic_fence(acquire, system)                       |
// | st.relaxed.sys.global         | volatile store (no ordering)                                       |
// | ld.volatile.global            | volatile pointer dereference                                       |
// | ld.global.nc.L1::no_allocate  | plain load (cache hints are perf-only on BMG)                      |
// | st.global.L1::no_allocate     | plain store (cache hints are perf-only on BMG)                     |

#pragma once

#include "configs.hpp"
#include "exception.hpp"
#include "utils.hpp"
#include "buffer.hpp"

#ifndef DISABLE_ISHMEM
#include <ishmem.h>
#include <ishmemx.h>
#endif

// tvisa named barrier support (gateway.hpp from https://github.com/CaoZhongZ/tvisa)
// Provides: named_barrier_init<N>(), nbarrier_signal(id, n_sub_groups), nbarrier_wait(id)
// Required because CUDA barrier.sync N synchronizes a SUBSET of threads in a CTA,
// and sycl::group_barrier() synchronizes ALL threads (would deadlock if any warp returns early).
#if defined(__SYCL_DEVICE_ONLY__) && defined(__SPIR__)
#include "gateway.hpp"
#endif

#include <sycl/sycl.hpp>
#include <cstdint>
#include <limits>
#include <utility>

namespace deep_ep {
namespace internode {

// ============================================================
// SourceMeta — metadata per token for RDMA routing
// ============================================================
// PORTED_FROM: csrc/kernels/internode.cu:18-36

struct SourceMeta {
    int src_rdma_rank, is_token_in_nvl_rank_bits;

    EP_STATIC_ASSERT(NUM_MAX_NVL_PEERS == 8, "Invalid number of maximum NVL peers");

    SourceMeta() = default;

    SourceMeta(int rdma_rank, const bool* is_token_in_nvl_ranks) {
        src_rdma_rank = rdma_rank;
        is_token_in_nvl_rank_bits = is_token_in_nvl_ranks[0];
        #pragma unroll
        for (int i = 1; i < NUM_MAX_NVL_PEERS; ++i)
            is_token_in_nvl_rank_bits |= is_token_in_nvl_ranks[i] << i;
    }

    bool is_token_in_nvl_rank(int nvl_rank) const {
        return (is_token_in_nvl_rank_bits >> nvl_rank) & 1;
    }
};

EP_STATIC_ASSERT(sizeof(SourceMeta) % sizeof(int) == 0, "Invalid size of `SourceMeta`");

inline int get_source_meta_bytes() {
    return sizeof(SourceMeta);
}

// ============================================================
// Token byte layout helper
// ============================================================
// PORTED_FROM: csrc/kernels/internode.cu:42-47

inline int get_num_bytes_per_token(int hidden_int4, int num_scales, int num_topk_idx, int num_topk_weights) {
    return static_cast<int>(align_up<size_t>(
        hidden_int4 * sizeof(int4) + sizeof(SourceMeta) + num_scales * sizeof(float) +
        num_topk_idx * sizeof(int) + num_topk_weights * sizeof(float),
        sizeof(int4)));
}

// ============================================================
// Clean region calculation
// ============================================================
// PORTED_FROM: csrc/kernels/internode.cu:49-87

inline std::pair<int, int> get_rdma_clean_meta(int hidden_int4, int num_scales,
                                                int num_topk_idx, int num_topk_weights,
                                                int num_rdma_ranks, int num_rdma_recv_buffer_tokens,
                                                int num_channels) {
    return {(get_num_bytes_per_token(hidden_int4, num_scales, num_topk_idx, num_topk_weights) *
             num_rdma_recv_buffer_tokens * num_rdma_ranks * 2 * num_channels) / sizeof(int),
            (NUM_MAX_NVL_PEERS * 2 + 4) * num_rdma_ranks * 2 * num_channels};
}

inline std::pair<int, int> get_nvl_clean_meta(int hidden_int4, int num_scales,
                                               int num_topk_idx, int num_topk_weights,
                                               int num_rdma_ranks, int num_nvl_ranks,
                                               int num_nvl_recv_buffer_tokens, int num_channels,
                                               bool /*is_dispatch*/) {
    return {(num_nvl_recv_buffer_tokens *
             get_num_bytes_per_token(hidden_int4, num_scales, num_topk_idx, num_topk_weights) *
             num_nvl_ranks * num_channels) / sizeof(int),
            num_nvl_ranks * (2 * num_rdma_ranks + 2) * num_channels};
}

// ============================================================
// PE translation (low-latency mode remaps ranks)
// ============================================================
// PORTED_FROM: csrc/kernels/internode.cu:89-92

template <bool kLowLatencyMode>
inline int translate_dst_rdma_rank(int dst_rdma_rank, int nvl_rank) {
    return kLowLatencyMode ? (dst_rdma_rank * NUM_MAX_NVL_PEERS + nvl_rank) : dst_rdma_rank;
}

// ============================================================
//  ishmem sync helper
// ============================================================
// PORTED_FROM: csrc/kernels/internode.cu:94-97
// MEMORY_MODEL_FIX: nvshmem_sync(team) → ishmem_sync_all() (no team variant in ishmem)

template <bool kLowLatencyMode>
inline void ishmem_sync_with_same_gpu_idx() {
#ifndef DISABLE_ISHMEM
    ishmem_sync_all();
#endif
}

// ============================================================
// notify_dispatch kernel
// ============================================================
// PORTED_FROM: csrc/kernels/internode.cu:99-353
//
// Grid:  (1 + kNumRDMARanks) work-groups, 512 threads each
// SM 0:  coordination — ishmem quiet, ishmem sync, NVL barrier, token count exchange
// SM 1..N: per-RDMA-rank channel prefix matrix calculation

template <bool kLowLatencyMode, int kNumRDMARanks>
struct NotifyDispatchKernel {
    // Kernel arguments (captured by value)
    const int* num_tokens_per_rank;
    int* moe_recv_counter_mapped;
    int num_ranks;
    const int* num_tokens_per_rdma_rank;
    int* moe_recv_rdma_counter_mapped;
    const int* num_tokens_per_expert;
    int* moe_recv_expert_counter_mapped;
    int num_experts;
    const bool* is_token_in_rank;
    int num_tokens;
    int num_worst_tokens;
    int num_channels;
    int expert_alignment;
    int rdma_clean_offset;
    int rdma_num_int_clean;
    int nvl_clean_offset;
    int nvl_num_int_clean;
    int* rdma_channel_prefix_matrix;
    int* recv_rdma_rank_prefix_sum;
    int* gbl_channel_prefix_matrix;
    int* recv_gbl_rank_prefix_sum;
    void* rdma_buffer_ptr;
    void** buffer_ptrs;
    int** barrier_signal_ptrs;
    int rank;

    void operator()(sycl::nd_item<1> item) const [[sycl::reqd_sub_group_size(32)]] {
        auto sg = item.get_sub_group();
        auto sm_id = static_cast<int>(item.get_group(0));
        auto thread_id = static_cast<int>(item.get_local_id(0));
        auto warp_id = thread_id / 32;
        auto lane_id = static_cast<int>(get_lane_id(sg));
        auto num_threads = static_cast<int>(item.get_local_range(0));
        auto num_warps = num_threads / 32;

        auto rdma_rank = rank / NUM_MAX_NVL_PEERS;
        auto nvl_rank = rank % NUM_MAX_NVL_PEERS;
        auto num_rdma_experts = num_experts / kNumRDMARanks;
        auto num_nvl_experts = num_rdma_experts / NUM_MAX_NVL_PEERS;

        if (sm_id == 0) {
            // ---- SM 0: Coordination ----
            EP_DEVICE_ASSERT(num_warps > 1);
            EP_DEVICE_ASSERT(kNumRDMARanks <= num_threads);

            // MEMORY_MODEL_FIX: IBGDA quiet → ishmem_quiet()
            // Wait for all previous inflight writes to complete
            // PORTED_FROM: csrc/kernels/internode.cu:133-138
#ifndef DISABLE_ISHMEM
            if (thread_id == 0) {
                ishmem_quiet();
            }
#endif
            sycl::group_barrier(item.get_group());

            // MEMORY_MODEL_FIX: nvshmem_sync_all → ishmem_sync_all
            // PORTED_FROM: csrc/kernels/internode.cu:140-141
#ifndef DISABLE_ISHMEM
            if (thread_id == 32)
                ishmem_sync_with_same_gpu_idx<kLowLatencyMode>();
#endif
            barrier_block<NUM_MAX_NVL_PEERS, true>(barrier_signal_ptrs, nvl_rank, item);

            // Send numbers of tokens per rank/expert to RDMA ranks
            // PORTED_FROM: csrc/kernels/internode.cu:144-161
            auto rdma_buffer_ptr_copy = rdma_buffer_ptr;
            auto rdma_buffer_ptr_int = static_cast<int*>(rdma_buffer_ptr);
            auto rdma_recv_num_tokens_mixed = SymBuffer<int>(rdma_buffer_ptr_copy,
                NUM_MAX_NVL_PEERS + num_rdma_experts + 1, kNumRDMARanks);

            // Clean up for later data dispatch
            EP_DEVICE_ASSERT(rdma_recv_num_tokens_mixed.total_bytes <= rdma_clean_offset * static_cast<int64_t>(sizeof(int)));
            for (int i = thread_id; i < rdma_num_int_clean; i += num_threads)
                rdma_buffer_ptr_int[rdma_clean_offset + i] = 0;

            // Copy to send buffer
            for (int i = thread_id; i < num_ranks; i += num_threads)
                rdma_recv_num_tokens_mixed.send_buffer(i / NUM_MAX_NVL_PEERS)[i % NUM_MAX_NVL_PEERS] =
                    num_tokens_per_rank[i];
            for (int i = thread_id; i < num_experts; i += num_threads)
                rdma_recv_num_tokens_mixed.send_buffer(i / num_rdma_experts)[NUM_MAX_NVL_PEERS + i % num_rdma_experts] =
                    num_tokens_per_expert[i];
            if (thread_id < kNumRDMARanks)
                rdma_recv_num_tokens_mixed.send_buffer(thread_id)[NUM_MAX_NVL_PEERS + num_rdma_experts] =
                    num_tokens_per_rdma_rank[thread_id];
            sycl::group_barrier(item.get_group());

            // Issue RDMA puts for token counts
            // PORTED_FROM: csrc/kernels/internode.cu:166-184
            // MEMORY_MODEL_FIX: nvshmemi_ibgda_put_nbi_warp → ishmemx_putmem_nbi_work_group(sub_group)
            for (int i = warp_id; i < kNumRDMARanks; i += num_warps) {
                if (i != rdma_rank) {
#ifndef DISABLE_ISHMEM
                    auto dst = rdma_recv_num_tokens_mixed.recv_buffer(rdma_rank);
                    auto src = rdma_recv_num_tokens_mixed.send_buffer(i);
                    auto nbytes = (NUM_MAX_NVL_PEERS + num_rdma_experts + 1) * static_cast<int>(sizeof(int));
                    auto dst_pe = translate_dst_rdma_rank<kLowLatencyMode>(i, nvl_rank);
                    ishmemx_putmem_nbi_work_group(dst, src, nbytes, dst_pe, sg);
#endif
                } else {
                    // Local copy
                    UNROLLED_WARP_COPY(1, lane_id,
                        NUM_MAX_NVL_PEERS + num_rdma_experts + 1,
                        rdma_recv_num_tokens_mixed.recv_buffer(rdma_rank),
                        rdma_recv_num_tokens_mixed.send_buffer(i),
                        ld_volatile_global, st_na_global);
                }
            }
            sycl::group_barrier(item.get_group());

            // Wait for puts to complete
            // MEMORY_MODEL_FIX: ibgda_quiet per-PE → ishmem_quiet() global
            // PORTED_FROM: csrc/kernels/internode.cu:187-189
#ifndef DISABLE_ISHMEM
            if (thread_id == 0)
                ishmem_quiet();
#endif
            sycl::group_barrier(item.get_group());

            // RDMA barrier
            // PORTED_FROM: csrc/kernels/internode.cu:192-194
#ifndef DISABLE_ISHMEM
            if (thread_id == 0)
                ishmem_sync_with_same_gpu_idx<kLowLatencyMode>();
#endif
            sycl::group_barrier(item.get_group());

            // NVL buffers setup and reduction
            // PORTED_FROM: csrc/kernels/internode.cu:197-212
            auto nvl_send_buffer = thread_id < NUM_MAX_NVL_PEERS ? buffer_ptrs[thread_id] : nullptr;
            auto nvl_recv_buffer = buffer_ptrs[nvl_rank];
            auto nvl_reduced_num_tokens_per_expert =
                Buffer<int>(nvl_recv_buffer, num_rdma_experts).advance_also(nvl_send_buffer);
            auto nvl_send_num_tokens_per_rank =
                AsymBuffer<int>(nvl_send_buffer, kNumRDMARanks, NUM_MAX_NVL_PEERS);
            auto nvl_send_num_tokens_per_expert =
                AsymBuffer<int>(nvl_send_buffer, num_nvl_experts, NUM_MAX_NVL_PEERS);
            auto nvl_recv_num_tokens_per_rank =
                AsymBuffer<int>(nvl_recv_buffer, kNumRDMARanks, NUM_MAX_NVL_PEERS);
            auto nvl_recv_num_tokens_per_expert =
                AsymBuffer<int>(nvl_recv_buffer, num_nvl_experts, NUM_MAX_NVL_PEERS);

            // Clean NVL region
            auto nvl_buffer_ptr_int = static_cast<int*>(buffer_ptrs[nvl_rank]);
            for (int i = thread_id; i < nvl_num_int_clean; i += num_threads)
                nvl_buffer_ptr_int[nvl_clean_offset + i] = 0;

            // Reduce number of tokens per expert
            // PORTED_FROM: csrc/kernels/internode.cu:220-227
            EP_DEVICE_ASSERT(num_rdma_experts <= num_threads);
            if (thread_id < num_rdma_experts) {
                int sum = 0;
                for (int i = 0; i < kNumRDMARanks; ++i)
                    sum += rdma_recv_num_tokens_mixed.recv_buffer(i)[NUM_MAX_NVL_PEERS + thread_id];
                nvl_reduced_num_tokens_per_expert[thread_id] = sum;
            }
            sycl::group_barrier(item.get_group());

            // Reduce RDMA received tokens
            // PORTED_FROM: csrc/kernels/internode.cu:230-240
            if (thread_id == 0) {
                int sum = 0;
                for (int i = 0; i < kNumRDMARanks; ++i) {
                    sum += rdma_recv_num_tokens_mixed.recv_buffer(i)[NUM_MAX_NVL_PEERS + num_rdma_experts];
                    recv_rdma_rank_prefix_sum[i] = sum;
                }
                if (num_worst_tokens == 0) {
                    while (ld_volatile_global(moe_recv_rdma_counter_mapped) != -1)
                        ;
                    *moe_recv_rdma_counter_mapped = sum;
                }
            }

            // Send to NVL ranks
            // PORTED_FROM: csrc/kernels/internode.cu:243-251
            EP_DEVICE_ASSERT(NUM_MAX_NVL_PEERS <= num_threads);
            if (thread_id < NUM_MAX_NVL_PEERS) {
                for (int i = 0; i < kNumRDMARanks; ++i)
                    nvl_send_num_tokens_per_rank.buffer(nvl_rank)[i] =
                        rdma_recv_num_tokens_mixed.recv_buffer(i)[thread_id];
                for (int i = 0; i < num_nvl_experts; ++i)
                    nvl_send_num_tokens_per_expert.buffer(nvl_rank)[i] =
                        nvl_reduced_num_tokens_per_expert[thread_id * num_nvl_experts + i];
            }
            barrier_block<NUM_MAX_NVL_PEERS>(barrier_signal_ptrs, nvl_rank, item);

            // Reduce number of tokens per rank/expert
            // PORTED_FROM: csrc/kernels/internode.cu:254-277
            EP_DEVICE_ASSERT(num_nvl_experts <= num_threads);
            if (thread_id == 0) {
                int sum = 0;
                for (int i = 0; i < num_ranks; ++i) {
                    int src_rdma_rank_l = i / NUM_MAX_NVL_PEERS;
                    int src_nvl_rank = i % NUM_MAX_NVL_PEERS;
                    sum += nvl_recv_num_tokens_per_rank.buffer(src_nvl_rank)[src_rdma_rank_l];
                    recv_gbl_rank_prefix_sum[i] = sum;
                }
                if (num_worst_tokens == 0) {
                    while (ld_volatile_global(moe_recv_counter_mapped) != -1)
                        ;
                    *moe_recv_counter_mapped = sum;
                }
            }
            if (thread_id < num_nvl_experts) {
                int sum = 0;
                for (int i = 0; i < NUM_MAX_NVL_PEERS; ++i)
                    sum += nvl_recv_num_tokens_per_expert.buffer(i)[thread_id];
                sum = (sum + expert_alignment - 1) / expert_alignment * expert_alignment;
                if (num_worst_tokens == 0) {
                    while (ld_volatile_global(moe_recv_expert_counter_mapped + thread_id) != -1)
                        ;
                    moe_recv_expert_counter_mapped[thread_id] = sum;
                }
            }

            // Final barrier
            // PORTED_FROM: csrc/kernels/internode.cu:280-282
#ifndef DISABLE_ISHMEM
            if (thread_id == 32)
                ishmem_sync_with_same_gpu_idx<kLowLatencyMode>();
#endif
            barrier_block<NUM_MAX_NVL_PEERS>(barrier_signal_ptrs, nvl_rank, item);
        } else {
            // ---- SM 1..N: Calculate channel prefix matrices ----
            // PORTED_FROM: csrc/kernels/internode.cu:284-353
            int dst_rdma_rank = sm_id - 1;
            for (int channel_id = warp_id; channel_id < num_channels; channel_id += num_warps) {
                int token_start_idx, token_end_idx;
                get_channel_task_range(num_tokens, num_channels, channel_id, token_start_idx, token_end_idx);

                int total_count = 0;
                int per_nvl_rank_count[NUM_MAX_NVL_PEERS] = {0};
                for (int64_t i = token_start_idx + lane_id; i < token_end_idx; i += 32) {
                    EP_STATIC_ASSERT(NUM_MAX_NVL_PEERS * sizeof(bool) == sizeof(uint64_t),
                                     "Invalid number of NVL peers");
                    auto is_token_in_rank_uint64 = *reinterpret_cast<const uint64_t*>(
                        is_token_in_rank + i * num_ranks + dst_rdma_rank * NUM_MAX_NVL_PEERS);
                    auto is_token_in_rank_values = reinterpret_cast<const bool*>(&is_token_in_rank_uint64);
                    #pragma unroll
                    for (int j = 0; j < NUM_MAX_NVL_PEERS; ++j)
                        per_nvl_rank_count[j] += is_token_in_rank_values[j];
                    total_count += (is_token_in_rank_uint64 != 0);
                }

                // Sub-group reduce
                total_count = warp_reduce_sum(sg, total_count);
                #pragma unroll
                for (int i = 0; i < NUM_MAX_NVL_PEERS; ++i)
                    per_nvl_rank_count[i] = warp_reduce_sum(sg, per_nvl_rank_count[i]);

                // Write into channel matrix (leader only)
                if (elect_one_sync(sg)) {
                    #pragma unroll
                    for (int i = 0; i < NUM_MAX_NVL_PEERS; ++i)
                        gbl_channel_prefix_matrix[(dst_rdma_rank * NUM_MAX_NVL_PEERS + i) * num_channels + channel_id] =
                            per_nvl_rank_count[i];
                    rdma_channel_prefix_matrix[dst_rdma_rank * num_channels + channel_id] = total_count;
                }
            }

            // Calculate prefix sum
            sycl::group_barrier(item.get_group());
            if (thread_id == 0) {
                auto prefix_row = rdma_channel_prefix_matrix + dst_rdma_rank * num_channels;
                for (int i = 1; i < num_channels; ++i)
                    prefix_row[i] += prefix_row[i - 1];
            }

            EP_STATIC_ASSERT(NUM_MAX_NVL_PEERS <= 32, "Invalid number of NVL peers");
            if (thread_id < NUM_MAX_NVL_PEERS) {
                auto prefix_row = gbl_channel_prefix_matrix +
                    (dst_rdma_rank * NUM_MAX_NVL_PEERS + thread_id) * num_channels;
                for (int i = 1; i < num_channels; ++i)
                    prefix_row[i] += prefix_row[i - 1];
            }
        }
    }
};

// ============================================================
// dispatch kernel
// ============================================================
// PORTED_FROM: csrc/kernels/internode.cu:459-1210
//
// Grid: num_channels * 2 work-groups
// Threads: (kNumDispatchRDMASenderWarps + 1 + NUM_MAX_NVL_PEERS) * 32
//
// Warp roles:
//   Even WGs (is_forwarder=true):
//     warps 0..7  → kRDMAAndNVLForwarder (one per NVL peer)
//     warp 8      → kForwarderCoordinator
//   Odd WGs (is_forwarder=false):
//     warps 0..6  → kRDMASender (7 warps)
//     warp 7      → kRDMASenderCoordinator
//     warps 8..15 → kNVLReceivers (one per NVL peer)

constexpr int get_num_topk_rdma_ranks(int num_rdma_ranks) {
    return num_rdma_ranks < 8 ? num_rdma_ranks : 8;
}

template <bool kLowLatencyMode, int kNumRDMARanks, bool kCachedMode,
          int kNumDispatchRDMASenderWarps,
          int kNumTopkRDMARanks = get_num_topk_rdma_ranks(kNumRDMARanks)>
struct DispatchKernel {
    int4* recv_x;
    float* recv_x_scales;
    topk_idx_t* recv_topk_idx;
    float* recv_topk_weights;
    SourceMeta* recv_src_meta;
    const int4* x;
    const float* x_scales;
    const topk_idx_t* topk_idx;
    const float* topk_weights;
    int* send_rdma_head;
    int* send_nvl_head;
    int* recv_rdma_channel_prefix_matrix;
    int* recv_gbl_channel_prefix_matrix;
    const int* rdma_channel_prefix_matrix;
    const int* recv_rdma_rank_prefix_sum;
    const int* gbl_channel_prefix_matrix;
    const int* recv_gbl_rank_prefix_sum;
    const bool* is_token_in_rank;
    int num_tokens;
    int num_worst_tokens;
    int hidden_int4;
    int num_scales;
    int num_topk;
    int num_experts;
    int scale_token_stride;
    int scale_hidden_stride;
    void* rdma_buffer_ptr;
    int num_max_rdma_chunked_send_tokens;
    int num_max_rdma_chunked_recv_tokens;
    void** buffer_ptrs;
    int num_max_nvl_chunked_send_tokens;
    int num_max_nvl_chunked_recv_tokens;
    int rank;
    int num_ranks;

    // Local memory accessors for shared memory emulation
    // We use SYCL local_accessor for rdma_send_channel_lock/tail/window and forward_channel_head/retired
    // These are passed separately from the handler.

    // Shared memory layout within each work-group:
    //   int rdma_send_channel_lock[kNumRDMARanks]      (used by sender WG)
    //   int rdma_send_channel_tail[kNumRDMARanks]       
    //   uint32_t rdma_send_channel_window[kNumRDMARanks]
    //   volatile int forward_channel_head[NUM_MAX_NVL_PEERS][kNumRDMARanks] (used by forwarder WG)
    //   volatile bool forward_channel_retired[NUM_MAX_NVL_PEERS]

    sycl::local_accessor<int, 1> slm;  // unified local memory

    // Offsets into slm
    static constexpr int kLockOffset = 0;
    static constexpr int kTailOffset = kNumRDMARanks;
    static constexpr int kWindowOffset = kNumRDMARanks * 2;
    // forward_channel_head: [NUM_MAX_NVL_PEERS][kNumRDMARanks] as flat int
    static constexpr int kFwdHeadOffset = kNumRDMARanks * 3;
    // forward_channel_retired: [NUM_MAX_NVL_PEERS] as int (bool stored as int)
    static constexpr int kFwdRetiredOffset = kFwdHeadOffset + NUM_MAX_NVL_PEERS * kNumRDMARanks;
    static constexpr int kSlmSize = kFwdRetiredOffset + NUM_MAX_NVL_PEERS;

    void operator()(sycl::nd_item<1> item) const [[sycl::reqd_sub_group_size(32)]] {
        enum class WarpRole { kRDMASender, kRDMASenderCoordinator,
                              kRDMAAndNVLForwarder, kForwarderCoordinator, kNVLReceivers };

        auto sg = item.get_sub_group();
        const auto num_sms = static_cast<int>(item.get_group_range(0));
        const auto sm_id = static_cast<int>(item.get_group(0));
        const auto num_threads = static_cast<int>(item.get_local_range(0));
        const auto num_warps = num_threads / 32;
        const auto thread_id = static_cast<int>(item.get_local_id(0));
        const auto warp_id = thread_id / 32;
        const auto lane_id = static_cast<int>(get_lane_id(sg));
        const auto num_channels = num_sms / 2, channel_id = sm_id / 2;
        const bool is_forwarder = sm_id % 2 == 0;
        const auto rdma_rank = rank / NUM_MAX_NVL_PEERS, nvl_rank = rank % NUM_MAX_NVL_PEERS;

        // Determine warp role
        // PORTED_FROM: csrc/kernels/internode.cu:483-497
        WarpRole warp_role;
        int target_rank;
        if (is_forwarder) {
            if (warp_id < NUM_MAX_NVL_PEERS) {
                warp_role = WarpRole::kRDMAAndNVLForwarder;
                target_rank = (warp_id + channel_id) % NUM_MAX_NVL_PEERS;
            } else {
                warp_role = WarpRole::kForwarderCoordinator;
                target_rank = warp_id - NUM_MAX_NVL_PEERS;
            }
        } else if (warp_id < kNumDispatchRDMASenderWarps) {
            warp_role = WarpRole::kRDMASender;
            target_rank = -1;
        } else if (warp_id == kNumDispatchRDMASenderWarps) {
            warp_role = WarpRole::kRDMASenderCoordinator;
            target_rank = -1;
        } else {
            warp_role = WarpRole::kNVLReceivers;
            target_rank = (warp_id + channel_id - kNumDispatchRDMASenderWarps) % NUM_MAX_NVL_PEERS;
        }
        EP_DEVICE_ASSERT(num_warps == kNumDispatchRDMASenderWarps + 1 + NUM_MAX_NVL_PEERS);
        EP_DEVICE_ASSERT(num_topk <= 32);

        // RDMA symmetric layout
        // PORTED_FROM: csrc/kernels/internode.cu:503-510
        auto hidden_bytes = static_cast<int>(hidden_int4 * sizeof(int4));
        auto scale_bytes = static_cast<int>(num_scales * sizeof(float));
        auto num_bytes_per_token = get_num_bytes_per_token(hidden_int4, num_scales, num_topk, num_topk);

        auto rdma_buffer_ptr_copy = rdma_buffer_ptr;
        auto rdma_channel_data = SymBuffer<uint8_t>(
            rdma_buffer_ptr_copy, num_max_rdma_chunked_recv_tokens * num_bytes_per_token,
            kNumRDMARanks, channel_id, num_channels);
        auto rdma_channel_meta = SymBuffer<int>(
            rdma_buffer_ptr_copy, NUM_MAX_NVL_PEERS * 2 + 2,
            kNumRDMARanks, channel_id, num_channels);
        auto rdma_channel_head = SymBuffer<uint64_t, false>(
            rdma_buffer_ptr_copy, 1, kNumRDMARanks, channel_id, num_channels);
        auto rdma_channel_tail = SymBuffer<uint64_t, false>(
            rdma_buffer_ptr_copy, 1, kNumRDMARanks, channel_id, num_channels);

        // NVL buffer layouts
        // PORTED_FROM: csrc/kernels/internode.cu:515-537
        void *rs_wr_buffer_ptr = nullptr, *ws_rr_buffer_ptr = nullptr;
        int rs_wr_rank = 0, ws_rr_rank = 0;
        if (warp_role == WarpRole::kRDMAAndNVLForwarder) {
            rs_wr_buffer_ptr = buffer_ptrs[nvl_rank];
            ws_rr_buffer_ptr = buffer_ptrs[target_rank];
            rs_wr_rank = nvl_rank;
            ws_rr_rank = target_rank;
        }
        if (warp_role == WarpRole::kNVLReceivers) {
            rs_wr_buffer_ptr = buffer_ptrs[target_rank];
            ws_rr_buffer_ptr = buffer_ptrs[nvl_rank];
            rs_wr_rank = target_rank;
            ws_rr_rank = nvl_rank;
        }

        auto nvl_channel_x = AsymBuffer<uint8_t>(ws_rr_buffer_ptr,
            num_max_nvl_chunked_recv_tokens * num_bytes_per_token,
            NUM_MAX_NVL_PEERS, channel_id, num_channels, rs_wr_rank)
            .advance_also(rs_wr_buffer_ptr);
        auto nvl_channel_prefix_start = AsymBuffer<int>(ws_rr_buffer_ptr,
            kNumRDMARanks, NUM_MAX_NVL_PEERS, channel_id, num_channels, rs_wr_rank)
            .advance_also(rs_wr_buffer_ptr);
        auto nvl_channel_prefix_end = AsymBuffer<int>(ws_rr_buffer_ptr,
            kNumRDMARanks, NUM_MAX_NVL_PEERS, channel_id, num_channels, rs_wr_rank)
            .advance_also(rs_wr_buffer_ptr);
        auto nvl_channel_head = AsymBuffer<int>(rs_wr_buffer_ptr,
            1, NUM_MAX_NVL_PEERS, channel_id, num_channels, ws_rr_rank)
            .advance_also(ws_rr_buffer_ptr);
        auto nvl_channel_tail = AsymBuffer<int>(ws_rr_buffer_ptr,
            1, NUM_MAX_NVL_PEERS, channel_id, num_channels, rs_wr_rank)
            .advance_also(rs_wr_buffer_ptr);

        // SLM pointers (shared memory emulation)
        int* rdma_send_channel_lock_ptr = slm.get_pointer() + kLockOffset;
        int* rdma_send_channel_tail_ptr = slm.get_pointer() + kTailOffset;
        // We store uint32_t window in int slots — reinterpret
        uint32_t* rdma_send_channel_window_ptr =
            reinterpret_cast<uint32_t*>(slm.get_pointer() + kWindowOffset);
        int* forward_channel_head_ptr = slm.get_pointer() + kFwdHeadOffset;
        int* forward_channel_retired_ptr = slm.get_pointer() + kFwdRetiredOffset;

        // Helper to access forward_channel_head[nvl][rdma]
        auto fwd_head = [&](int nvl, int rdma) -> volatile int& {
            return *reinterpret_cast<volatile int*>(forward_channel_head_ptr + nvl * kNumRDMARanks + rdma);
        };
        auto fwd_retired = [&](int nvl) -> volatile int& {
            return *reinterpret_cast<volatile int*>(forward_channel_retired_ptr + nvl);
        };

        // ============================================================
        // Named barrier via tvisa (gateway.hpp)
        // ============================================================
        // PORTED_FROM: csrc/kernels/internode.cu:563,580
        // CUDA: barrier.sync 0, (kNumDispatchRDMASenderWarps + 1) * 32
        //       barrier.sync 1, (NUM_MAX_NVL_PEERS + 1) * 32
        // These synchronize a SUBSET of warps within a CTA.
        // sycl::group_barrier() would DEADLOCK here because some warps return early
        // (e.g., kForwarderCoordinator warps with target_rank > 0).
        //
        // tvisa nbarrier_signal(id, n_sub_groups) + nbarrier_wait(id) provides
        // the exact same subset synchronization as CUDA named barriers.
        // Barrier 0: sender warps (kNumDispatchRDMASenderWarps) + coordinator (1)
        // Barrier 1: forwarder warps (NUM_MAX_NVL_PEERS) + coordinator (1)
#if defined(__SYCL_DEVICE_ONLY__) && defined(__SPIR__)
        // Initialize 2 named barriers at kernel entry (once per work-group, idempotent per sub_group)
        named_barrier_init<2>();
#endif
        auto sync_rdma_sender_smem = [&]() {
#if defined(__SYCL_DEVICE_ONLY__) && defined(__SPIR__)
            nbarrier_signal(0, static_cast<uint8_t>(kNumDispatchRDMASenderWarps + 1));
            nbarrier_wait(0);
#else
            // Host fallback (not used in real execution)
            sycl::group_barrier(item.get_group());
#endif
        };
        auto sync_forwarder_smem = [&]() {
#if defined(__SYCL_DEVICE_ONLY__) && defined(__SPIR__)
            nbarrier_signal(1, static_cast<uint8_t>(NUM_MAX_NVL_PEERS + 1));
            nbarrier_wait(1);
#else
            sycl::group_barrier(item.get_group());
#endif
        };

        // ===========================
        // WarpRole::kRDMASender
        // ===========================
        // PORTED_FROM: csrc/kernels/internode.cu:551-757
        if (warp_role == WarpRole::kRDMASender) {
            int token_start_idx, token_end_idx;
            get_channel_task_range(num_tokens, num_channels, channel_id, token_start_idx, token_end_idx);

            // Send channel metadata (prefix counts encoded as -value-1)
            // PORTED_FROM: csrc/kernels/internode.cu:558-618
            EP_STATIC_ASSERT(NUM_MAX_NVL_PEERS * 2 + 2 <= 32, "Invalid number of NVL peers");
            for (int dst_rdma_rank = warp_id; dst_rdma_rank < kNumRDMARanks;
                 dst_rdma_rank += kNumDispatchRDMASenderWarps) {
                auto dst_ptr = dst_rdma_rank == rdma_rank
                    ? rdma_channel_meta.recv_buffer(dst_rdma_rank)
                    : rdma_channel_meta.send_buffer(dst_rdma_rank);

                if (lane_id < NUM_MAX_NVL_PEERS) {
                    dst_ptr[lane_id] = -(channel_id == 0 ? 0
                        : gbl_channel_prefix_matrix[(dst_rdma_rank * NUM_MAX_NVL_PEERS + lane_id) *
                            num_channels + channel_id - 1]) - 1;
                } else if (lane_id < NUM_MAX_NVL_PEERS * 2) {
                    dst_ptr[lane_id] = -gbl_channel_prefix_matrix[
                        (dst_rdma_rank * NUM_MAX_NVL_PEERS + lane_id - NUM_MAX_NVL_PEERS) *
                        num_channels + channel_id] - 1;
                } else if (lane_id == NUM_MAX_NVL_PEERS * 2) {
                    dst_ptr[lane_id] = -(channel_id == 0 ? 0
                        : rdma_channel_prefix_matrix[dst_rdma_rank * num_channels + channel_id - 1]) - 1;
                } else if (lane_id == NUM_MAX_NVL_PEERS * 2 + 1) {
                    dst_ptr[lane_id] = -rdma_channel_prefix_matrix[
                        dst_rdma_rank * num_channels + channel_id] - 1;
                }
                syncwarp(sg);

                // Issue RDMA for non-local ranks
                // MEMORY_MODEL_FIX: ibgda_put_nbi_warp → ishmemx_putmem_nbi_work_group(sg)
                if (dst_rdma_rank != rdma_rank) {
#ifndef DISABLE_ISHMEM
                    auto dst_meta = rdma_channel_meta.recv_buffer(rdma_rank);
                    auto src_meta = rdma_channel_meta.send_buffer(dst_rdma_rank);
                    auto dst_pe = translate_dst_rdma_rank<kLowLatencyMode>(dst_rdma_rank, nvl_rank);
                    ishmemx_putmem_nbi_work_group(
                        dst_meta, src_meta,
                        sizeof(int) * (NUM_MAX_NVL_PEERS * 2 + 2),
                        dst_pe, sg);
#endif
                }
            }
            sync_rdma_sender_smem();

            // Iterate over tokens and copy into RDMA buffer
            // PORTED_FROM: csrc/kernels/internode.cu:621-757
            int cached_rdma_channel_head = 0, global_rdma_tail_idx = 0;
            auto send_buffer = lane_id == rdma_rank
                ? rdma_channel_data.recv_buffer(lane_id)
                : rdma_channel_data.send_buffer(lane_id);

            for (int64_t token_idx = token_start_idx; token_idx < token_end_idx; ++token_idx) {
                // Read RDMA rank existence
                uint64_t is_token_in_rank_uint64 = 0;
                if (lane_id < kNumRDMARanks) {
                    is_token_in_rank_uint64 = *reinterpret_cast<const uint64_t*>(
                        is_token_in_rank + token_idx * num_ranks + lane_id * NUM_MAX_NVL_PEERS);
                    global_rdma_tail_idx += (is_token_in_rank_uint64 != 0);
                }
                syncwarp(sg);

                // Skip tokens not assigned to this warp
                if ((token_idx - token_start_idx) % kNumDispatchRDMASenderWarps != warp_id)
                    continue;
                auto rdma_tail_idx = is_token_in_rank_uint64 == 0 ? -1 : global_rdma_tail_idx - 1;

                // Wait for remote buffer to be released
                // PORTED_FROM: csrc/kernels/internode.cu:643-657
                uint64_t timeout_ctr = 0;
                while (is_token_in_rank_uint64 != 0 &&
                       rdma_tail_idx - cached_rdma_channel_head >= num_max_rdma_chunked_recv_tokens) {
                    cached_rdma_channel_head = static_cast<int>(
                        ld_volatile_global(rdma_channel_head.buffer(lane_id)));
                    if (++timeout_ctr > NUM_TIMEOUT_CYCLES / 1000) {
                        // clock64() → iteration counter: SYCL has no GPU clock intrinsic.
                        // Iteration count is an approximate timeout; calibrate divisor on target HW.
                        break;
                    }
                }
                syncwarp(sg);

                // Store RDMA head for combine
                if (lane_id < kNumRDMARanks && !kCachedMode)
                    send_rdma_head[token_idx * kNumRDMARanks + lane_id] = rdma_tail_idx;

                // Broadcast tails, determine top-k destination ranks
                // PORTED_FROM: csrc/kernels/internode.cu:664-683
                SourceMeta src_meta;
                int num_topk_ranks = 0;
                void* dst_send_buffers[kNumTopkRDMARanks];
                #pragma unroll
                for (int i = 0; i < kNumRDMARanks; ++i) {
                    int slot_idx = sycl::select_from_group(sg, rdma_tail_idx, i);
                    if (slot_idx >= 0) {
                        slot_idx = slot_idx % num_max_rdma_chunked_recv_tokens;
                        auto recv_is_token_in_rank_uint64 = broadcast(sg, is_token_in_rank_uint64, i);
                        auto recv_is_token_in_rank_values =
                            reinterpret_cast<const bool*>(&recv_is_token_in_rank_uint64);
                        if (lane_id == num_topk_ranks)
                            src_meta = SourceMeta(rdma_rank, recv_is_token_in_rank_values);
                        dst_send_buffers[num_topk_ranks++] =
                            reinterpret_cast<uint8_t*>(broadcast(sg, send_buffer, i)) +
                            slot_idx * num_bytes_per_token;
                    }
                }
                EP_DEVICE_ASSERT(num_topk_ranks <= kNumTopkRDMARanks);

                // Copy x into symmetric send buffer
                // PORTED_FROM: csrc/kernels/internode.cu:686-695
                auto st_broadcast = [&](const int key, const int4& value) {
                    #pragma unroll
                    for (int j = 0; j < num_topk_ranks; ++j)
                        st_na_global(reinterpret_cast<int4*>(dst_send_buffers[j]) + key, value);
                };
                UNROLLED_WARP_COPY(5, lane_id, hidden_int4, 0,
                    x + token_idx * hidden_int4, ld_nc_global, st_broadcast);
                #pragma unroll
                for (int i = 0; i < num_topk_ranks; ++i)
                    dst_send_buffers[i] = reinterpret_cast<int4*>(dst_send_buffers[i]) + hidden_int4;

                // Copy x_scales
                // PORTED_FROM: csrc/kernels/internode.cu:698-706
                for (int i = lane_id; i < num_scales; i += 32) {
                    auto offset = token_idx * scale_token_stride + i * scale_hidden_stride;
                    auto value = ld_nc_global(x_scales + offset);
                    #pragma unroll
                    for (int j = 0; j < num_topk_ranks; ++j)
                        st_na_global(reinterpret_cast<float*>(dst_send_buffers[j]) + i, value);
                }
                #pragma unroll
                for (int i = 0; i < num_topk_ranks; ++i)
                    dst_send_buffers[i] = reinterpret_cast<float*>(dst_send_buffers[i]) + num_scales;

                // Copy source metadata
                // PORTED_FROM: csrc/kernels/internode.cu:709-712
                if (lane_id < num_topk_ranks)
                    st_na_global(reinterpret_cast<SourceMeta*>(dst_send_buffers[lane_id]), src_meta);
                #pragma unroll
                for (int i = 0; i < num_topk_ranks; ++i)
                    dst_send_buffers[i] = reinterpret_cast<SourceMeta*>(dst_send_buffers[i]) + 1;

                // Copy topk_idx and topk_weights
                // PORTED_FROM: csrc/kernels/internode.cu:715-724
                for (int i = lane_id; i < num_topk * num_topk_ranks; i += 32) {
                    auto rank_idx = i / num_topk, copy_idx = i % num_topk;
                    auto idx_value = static_cast<int>(ld_nc_global(topk_idx + token_idx * num_topk + copy_idx));
                    auto weight_value = ld_nc_global(topk_weights + token_idx * num_topk + copy_idx);
                    st_na_global(reinterpret_cast<int*>(dst_send_buffers[rank_idx]) + copy_idx, idx_value);
                    st_na_global(reinterpret_cast<float*>(dst_send_buffers[rank_idx]) + num_topk + copy_idx,
                                 weight_value);
                }
                syncwarp(sg);

                // Release transaction in the window
                // PORTED_FROM: csrc/kernels/internode.cu:727-757
                if (is_token_in_rank_uint64 != 0) {
                    acquire_lock(rdma_send_channel_lock_ptr + lane_id);
                    auto latest_tail = rdma_send_channel_tail_ptr[lane_id];
                    auto offset = rdma_tail_idx - latest_tail;
                    while (offset >= 32) {
                        release_lock(rdma_send_channel_lock_ptr + lane_id);
                        acquire_lock(rdma_send_channel_lock_ptr + lane_id);
                        latest_tail = rdma_send_channel_tail_ptr[lane_id];
                        offset = rdma_tail_idx - latest_tail;
                    }

                    auto window = rdma_send_channel_window_ptr[lane_id] | (1u << offset);
                    if (offset == 0) {
                        auto num_empty_slots = (~window) == 0 ? 32 : ffs_compat(~window) - 1;
                        st_release_cta(rdma_send_channel_tail_ptr + lane_id,
                                       latest_tail + num_empty_slots);
                        window >>= num_empty_slots;
                    }
                    rdma_send_channel_window_ptr[lane_id] = window;
                    release_lock(rdma_send_channel_lock_ptr + lane_id);
                }
                syncwarp(sg);
            }
        }
        // ===========================
        // WarpRole::kRDMASenderCoordinator
        // ===========================
        // PORTED_FROM: csrc/kernels/internode.cu:758-832
        else if (warp_role == WarpRole::kRDMASenderCoordinator) {
            EP_DEVICE_ASSERT(num_max_rdma_chunked_recv_tokens % num_max_rdma_chunked_send_tokens == 0);

            // Clean shared memory
            EP_STATIC_ASSERT(kNumRDMARanks <= 32, "Invalid number of RDMA ranks");
            if (lane_id < kNumRDMARanks) {
                rdma_send_channel_lock_ptr[lane_id] = 0;
                rdma_send_channel_tail_ptr[lane_id] = 0;
                rdma_send_channel_window_ptr[lane_id] = 0;
            }
            sync_rdma_sender_smem();

            // Get number of tokens to send per RDMA rank
            int num_tokens_to_send = 0;
            if (lane_id < kNumRDMARanks) {
                num_tokens_to_send = rdma_channel_prefix_matrix[lane_id * num_channels + channel_id];
                if (channel_id > 0)
                    num_tokens_to_send -= rdma_channel_prefix_matrix[lane_id * num_channels + channel_id - 1];
            }

            // Iterate: wait for senders to pack, then issue RDMA
            // PORTED_FROM: csrc/kernels/internode.cu:790-832
            int last_issued_tail = 0;
            uint64_t timeout_ctr = 0;
            while (any_sync(sg, num_tokens_to_send > 0)) {
                if (++timeout_ctr > NUM_TIMEOUT_CYCLES / 1000) {
                    // clock64() → iteration counter: same approach as kRDMASender timeout.
                    // The coordinator spins waiting for sender warps to pack tokens into
                    // the RDMA send buffer. If senders stall (bug or remote buffer full),
                    // this timeout prevents infinite hang. Calibrate divisor on target HW.
                    break;
                }

                for (int i = 0; i < kNumRDMARanks; ++i) {
                    int dst_rdma_rank = (i + channel_id + rdma_rank) % kNumRDMARanks;
                    int synced_nts = sycl::select_from_group(sg, num_tokens_to_send, dst_rdma_rank);
                    if (synced_nts == 0) continue;

                    auto processed_tail = sycl::select_from_group(sg,
                        ld_acquire_cta(const_cast<const int*>(rdma_send_channel_tail_ptr + dst_rdma_rank)), 0);
                    auto synced_last = sycl::select_from_group(sg, last_issued_tail, dst_rdma_rank);
                    auto num_processed = processed_tail - synced_last;
                    if (num_processed != synced_nts && num_processed < num_max_rdma_chunked_send_tokens)
                        continue;

                    auto num_to_issue = sycl::min(num_processed, num_max_rdma_chunked_send_tokens);
                    EP_DEVICE_ASSERT(num_to_issue >= 0 && num_to_issue <= synced_nts);

                    if (dst_rdma_rank != rdma_rank) {
                        auto dst_slot_idx = synced_last % num_max_rdma_chunked_recv_tokens;
                        EP_DEVICE_ASSERT(dst_slot_idx + num_to_issue <= num_max_rdma_chunked_recv_tokens);
                        auto nbytes = num_bytes_per_token * num_to_issue;
#ifndef DISABLE_ISHMEM
                        auto dst = rdma_channel_data.recv_buffer(rdma_rank) + dst_slot_idx * num_bytes_per_token;
                        auto src = rdma_channel_data.send_buffer(dst_rdma_rank) + dst_slot_idx * num_bytes_per_token;
                        auto dst_pe = translate_dst_rdma_rank<kLowLatencyMode>(dst_rdma_rank, nvl_rank);
                        ishmemx_putmem_nbi_work_group(dst, src, nbytes, dst_pe, sg);
#endif
                    } else {
                        memory_fence();
                    }
                    syncwarp(sg);

                    // Update tails via remote atomic
                    // MEMORY_MODEL_FIX: ibgda_amo_nonfetch_add → ishmem_uint64_atomic_add
                    if (lane_id == dst_rdma_rank) {
                        last_issued_tail += num_to_issue;
                        num_tokens_to_send -= num_to_issue;
#ifndef DISABLE_ISHMEM
                        auto dst_pe = translate_dst_rdma_rank<kLowLatencyMode>(dst_rdma_rank, nvl_rank);
                        ishmem_uint64_atomic_add(
                            rdma_channel_tail.buffer(rdma_rank),
                            static_cast<uint64_t>(num_to_issue), dst_pe);
#endif
                    }
                    syncwarp(sg);
                }
            }
        }
        // ===========================
        // WarpRole::kRDMAAndNVLForwarder
        // ===========================
        // PORTED_FROM: csrc/kernels/internode.cu:833-1020
        else if (warp_role == WarpRole::kRDMAAndNVLForwarder) {
            const auto dst_nvl_rank = target_rank;

            // Wait for metadata counters to arrive via RDMA
            // PORTED_FROM: csrc/kernels/internode.cu:838-878
            int num_tokens_to_recv_from_rdma = 0, src_rdma_channel_prefix = 0;
            EP_DEVICE_ASSERT(kNumRDMARanks <= 32);
            uint64_t timeout_ctr = 0;
            if (lane_id < kNumRDMARanks) {
                while (true) {
                    auto meta_0 = ld_volatile_global(rdma_channel_meta.recv_buffer(lane_id) + dst_nvl_rank);
                    auto meta_1 = ld_volatile_global(rdma_channel_meta.recv_buffer(lane_id) + NUM_MAX_NVL_PEERS + dst_nvl_rank);
                    auto meta_2 = ld_volatile_global(rdma_channel_meta.recv_buffer(lane_id) + NUM_MAX_NVL_PEERS * 2);
                    auto meta_3 = ld_volatile_global(rdma_channel_meta.recv_buffer(lane_id) + NUM_MAX_NVL_PEERS * 2 + 1);
                    if (meta_0 < 0 && meta_1 < 0 && meta_2 < 0 && meta_3 < 0) {
                        int start_sum = -meta_0 - 1, end_sum = -meta_1 - 1;
                        EP_DEVICE_ASSERT(start_sum >= 0 && end_sum >= 0 && end_sum >= start_sum);
                        st_relaxed_sys_global(nvl_channel_prefix_start.buffer() + lane_id, -start_sum - 1);
                        st_relaxed_sys_global(nvl_channel_prefix_end.buffer() + lane_id, -end_sum - 1);

                        src_rdma_channel_prefix = -meta_2 - 1;
                        auto src_rdma_channel_prefix_1 = -meta_3 - 1;
                        num_tokens_to_recv_from_rdma = src_rdma_channel_prefix_1 - src_rdma_channel_prefix;
                        if (!kCachedMode)
                            recv_rdma_channel_prefix_matrix[lane_id * num_channels + channel_id] =
                                src_rdma_channel_prefix_1;
                        src_rdma_channel_prefix += lane_id == 0 ? 0 : recv_rdma_rank_prefix_sum[lane_id - 1];
                        EP_DEVICE_ASSERT(num_tokens_to_recv_from_rdma >= 0);
                        break;
                    }
                    if (++timeout_ctr > NUM_TIMEOUT_CYCLES / 1000)
                        break;
                }
            }
            syncwarp(sg);

            send_nvl_head += src_rdma_channel_prefix * NUM_MAX_NVL_PEERS + dst_nvl_rank;
            sync_forwarder_smem();

            // Forward tokens from RDMA → NVL buffer
            // PORTED_FROM: csrc/kernels/internode.cu:907-1001
            // MEMORY_MODEL_FIX: TMA load/store → explicit sub-group copy
            int src_rdma_rank_iter = sm_id % kNumRDMARanks;
            int cached_rdma_head = 0, cached_rdma_tail = 0;
            int cached_nvl_head = 0, cached_nvl_tail = 0, rdma_nvl_token_idx = 0;

            while (any_sync(sg, num_tokens_to_recv_from_rdma > 0)) {
                // Check NVL buffer space
                timeout_ctr = 0;
                while (true) {
                    int num_used = cached_nvl_tail - cached_nvl_head;
                    if (num_max_nvl_chunked_recv_tokens - num_used >= num_max_nvl_chunked_send_tokens)
                        break;
                    cached_nvl_head = sycl::select_from_group(sg,
                        ld_volatile_global(nvl_channel_head.buffer()), 0);
                    if (++timeout_ctr > NUM_TIMEOUT_CYCLES / 1000) break;
                }

                // Find next source RDMA rank (round-robin)
                timeout_ctr = 0;
                while (true) {
                    src_rdma_rank_iter = (src_rdma_rank_iter + 1) % kNumRDMARanks;
                    if (sycl::select_from_group(sg, num_tokens_to_recv_from_rdma, src_rdma_rank_iter) > 0) {
                        if (lane_id == src_rdma_rank_iter && cached_rdma_head == cached_rdma_tail)
                            cached_rdma_tail = static_cast<int>(
                                ld_acquire_sys_global(rdma_channel_tail.buffer(src_rdma_rank_iter)));
                        if (sycl::select_from_group(sg, cached_rdma_tail > cached_rdma_head, src_rdma_rank_iter))
                            break;
                    }
                    if (++timeout_ctr > NUM_TIMEOUT_CYCLES / 1000) break;
                }
                auto src_head = sycl::select_from_group(sg, cached_rdma_head, src_rdma_rank_iter);
                auto src_tail = sycl::select_from_group(sg, cached_rdma_tail, src_rdma_rank_iter);

                // Copy tokens from RDMA buffer → NVL buffer
                for (int ii = src_head, num_tokens_sent = 0; ii < src_tail; ++ii) {
                    auto rdma_slot_idx = ii % num_max_rdma_chunked_recv_tokens;
                    auto shifted = rdma_channel_data.recv_buffer(src_rdma_rank_iter) +
                        rdma_slot_idx * num_bytes_per_token;
                    auto src_meta_val = ld_nc_global(
                        reinterpret_cast<SourceMeta*>(shifted + hidden_bytes + scale_bytes));
                    if (lane_id == src_rdma_rank_iter)
                        num_tokens_to_recv_from_rdma -= 1;
                    bool is_in_dst = src_meta_val.is_token_in_nvl_rank(dst_nvl_rank);
                    if (lane_id == src_rdma_rank_iter) {
                        auto cached_h = is_in_dst ? rdma_nvl_token_idx : -1;
                        rdma_nvl_token_idx += is_in_dst;
                        if (!kCachedMode)
                            send_nvl_head[ii * NUM_MAX_NVL_PEERS] = cached_h;
                    }
                    if (!is_in_dst)
                        continue;

                    // Get empty NVL slot
                    int dst_slot_idx = (cached_nvl_tail++) % num_max_nvl_chunked_recv_tokens;
                    auto dst_shifted = nvl_channel_x.buffer() + dst_slot_idx * num_bytes_per_token;

                    // MEMORY_MODEL_FIX: TMA load+store → explicit sub_group memcpy
                    // Copy num_bytes_per_token bytes from shifted → dst_shifted
                    auto n_int4 = num_bytes_per_token / static_cast<int>(sizeof(int4));
                    auto src_i4 = reinterpret_cast<const int4*>(shifted);
                    auto dst_i4 = reinterpret_cast<int4*>(dst_shifted);
                    for (int k = lane_id; k < n_int4; k += 32)
                        dst_i4[k] = src_i4[k];
                    syncwarp(sg);

                    if ((++num_tokens_sent) == num_max_nvl_chunked_send_tokens)
                        src_tail = ii + 1;
                }

                // Update RDMA head in shared memory
                if (lane_id == src_rdma_rank_iter)
                    fwd_head(dst_nvl_rank, src_rdma_rank_iter) = (cached_rdma_head = src_tail);

                // Move NVL tail (visible to NVL receiver)
                syncwarp(sg);
                if (elect_one_sync(sg))
                    st_release_sys_global(nvl_channel_tail.buffer(), cached_nvl_tail);
            }

            // Mark this forwarder as retired
            syncwarp(sg);
            if (elect_one_sync(sg))
                fwd_retired(dst_nvl_rank) = 1;
        }
        // ===========================
        // WarpRole::kForwarderCoordinator
        // ===========================
        // PORTED_FROM: csrc/kernels/internode.cu:1001-1046
        else if (warp_role == WarpRole::kForwarderCoordinator) {
            if (target_rank > 0)
                return;

            // Clean shared memory
            for (int i = lane_id; i < kNumRDMARanks * NUM_MAX_NVL_PEERS; i += 32)
                fwd_head(i % NUM_MAX_NVL_PEERS, i / NUM_MAX_NVL_PEERS) = 0;
            if (lane_id < NUM_MAX_NVL_PEERS)
                fwd_retired(lane_id) = 0;
            sync_forwarder_smem();

            int last_head = 0;
            int target_rdma = lane_id < kNumRDMARanks ? lane_id : 0;
            while (true) {
                int min_head = std::numeric_limits<int>::max();
                #pragma unroll
                for (int i = 0; i < NUM_MAX_NVL_PEERS; ++i)
                    if (!fwd_retired(i))
                        min_head = sycl::min(min_head, static_cast<int>(fwd_head(i, target_rdma)));
                if (all_sync(sg, min_head == std::numeric_limits<int>::max()))
                    break;

                // Update remote RDMA head
                // MEMORY_MODEL_FIX: ibgda_amo_nonfetch_add → ishmem_uint64_atomic_add
                if (min_head != std::numeric_limits<int>::max() &&
                    min_head >= last_head + num_max_rdma_chunked_send_tokens &&
                    lane_id < kNumRDMARanks) {
#ifndef DISABLE_ISHMEM
                    auto dst_pe = translate_dst_rdma_rank<kLowLatencyMode>(lane_id, nvl_rank);
                    ishmem_uint64_atomic_add(
                        rdma_channel_head.buffer(rdma_rank),
                        static_cast<uint64_t>(min_head - last_head), dst_pe);
#endif
                    last_head = min_head;
                }
                // No __nanosleep equivalent; spin
            }
        }
        // ===========================
        // WarpRole::kNVLReceivers
        // ===========================
        // PORTED_FROM: csrc/kernels/internode.cu:1047-1198
        else {
            int src_nvl_rank = target_rank, total_offset = 0;
            const int local_expert_begin = rank * (num_experts / num_ranks);
            const int local_expert_end = local_expert_begin + (num_experts / num_ranks);

            if (lane_id < kNumRDMARanks && lane_id * NUM_MAX_NVL_PEERS + src_nvl_rank > 0)
                total_offset = recv_gbl_rank_prefix_sum[lane_id * NUM_MAX_NVL_PEERS + src_nvl_rank - 1];

            // Wait for channel offsets from forwarder
            int start_offset = 0, end_offset = 0;
            uint64_t timeout_ctr = 0;
            while (lane_id < kNumRDMARanks) {
                start_offset = ld_volatile_global(nvl_channel_prefix_start.buffer() + lane_id);
                end_offset = ld_volatile_global(nvl_channel_prefix_end.buffer() + lane_id);
                if (start_offset < 0 && end_offset < 0) {
                    start_offset = -start_offset - 1;
                    end_offset = -end_offset - 1;
                    total_offset += start_offset;
                    break;
                }
                if (++timeout_ctr > NUM_TIMEOUT_CYCLES / 1000) break;
            }
            int num_tokens_to_recv = warp_reduce_sum(sg, end_offset - start_offset);

            if (lane_id < kNumRDMARanks && !kCachedMode)
                recv_gbl_channel_prefix_matrix[
                    (lane_id * NUM_MAX_NVL_PEERS + src_nvl_rank) * num_channels + channel_id] = total_offset;
            syncwarp(sg);

            int cached_head_idx = 0, cached_tail_idx = 0;
            while (num_tokens_to_recv > 0) {
                // Wait for data
                timeout_ctr = 0;
                while (true) {
                    if (cached_head_idx != cached_tail_idx) break;
                    cached_tail_idx = sycl::select_from_group(sg,
                        ld_acquire_sys_global(nvl_channel_tail.buffer()), 0);
                    if (++timeout_ctr > NUM_TIMEOUT_CYCLES / 1000) break;
                }

                // Copy data to output
                int num_recv = cached_tail_idx - cached_head_idx;
                for (int chunk = 0; chunk < num_recv; ++chunk, --num_tokens_to_recv) {
                    int token_buf_idx = (cached_head_idx++) % num_max_nvl_chunked_recv_tokens;
                    auto shifted = nvl_channel_x.buffer() + token_buf_idx * num_bytes_per_token;
                    auto meta = ld_nc_global(
                        reinterpret_cast<SourceMeta*>(shifted + hidden_bytes + scale_bytes));
                    int64_t recv_token_idx = sycl::select_from_group(sg,
                        static_cast<int64_t>(total_offset), meta.src_rdma_rank);
                    if (lane_id == meta.src_rdma_rank)
                        total_offset += 1;

                    // Copy x data
                    // MEMORY_MODEL_FIX: TMA → explicit sub_group copy
                    auto src_x_ptr = reinterpret_cast<const int4*>(shifted);
                    auto dst_x_ptr = recv_x + recv_token_idx * hidden_int4;
                    for (int k = lane_id; k < hidden_int4; k += 32)
                        dst_x_ptr[k] = src_x_ptr[k];
                    shifted += hidden_bytes;

                    // Copy scales
                    auto src_scales = reinterpret_cast<const float*>(shifted);
                    auto dst_scales = recv_x_scales + recv_token_idx * num_scales;
                    for (int k = lane_id; k < num_scales; k += 32)
                        dst_scales[k] = src_scales[k];
                    shifted += scale_bytes;

                    // Copy source meta
                    if (!kCachedMode && elect_one_sync(sg))
                        st_na_global(recv_src_meta + recv_token_idx, meta);
                    shifted += sizeof(SourceMeta);

                    // Copy topk_idx and topk_weights
                    if (lane_id < num_topk) {
                        auto idx_value = static_cast<topk_idx_t>(
                            ld_nc_global(reinterpret_cast<int*>(shifted) + lane_id));
                        auto weight_value = ld_nc_global(
                            reinterpret_cast<float*>(shifted + sizeof(int) * num_topk) + lane_id);
                        auto recv_idx = recv_token_idx * num_topk + lane_id;

                        idx_value = (idx_value >= local_expert_begin && idx_value < local_expert_end)
                            ? idx_value - local_expert_begin : -1;
                        weight_value = idx_value >= 0 ? weight_value : 0.0f;
                        st_na_global(recv_topk_idx + recv_idx, idx_value);
                        st_na_global(recv_topk_weights + recv_idx, weight_value);
                    }
                    syncwarp(sg);
                }

                // Update NVL head (visible to forwarder)
                if (elect_one_sync(sg))
                    st_relaxed_sys_global(nvl_channel_head.buffer(), cached_head_idx);
            }
        }

        // Clean unused recv_topk_idx as -1
        // PORTED_FROM: csrc/kernels/internode.cu:1199-1210
        if (num_worst_tokens > 0) {
            if (is_forwarder)
                return;
            int num_recv_tokens_total = recv_gbl_rank_prefix_sum[num_ranks - 1];
            const auto clean_start = num_recv_tokens_total * num_topk + channel_id * num_threads;
            const auto clean_end = num_worst_tokens * num_topk;
            const auto clean_stride = num_channels * num_threads;
            for (int i = clean_start + thread_id; i < clean_end; i += clean_stride)
                recv_topk_idx[i] = -1;
        }
    }
};

// ============================================================
// Host-side launch functions
// ============================================================

inline void launch_notify_dispatch(
    const int* num_tokens_per_rank,
    int* moe_recv_counter_mapped,
    int num_ranks,
    const int* num_tokens_per_rdma_rank,
    int* moe_recv_rdma_counter_mapped,
    const int* num_tokens_per_expert,
    int* moe_recv_expert_counter_mapped,
    int num_experts,
    const bool* is_token_in_rank,
    int num_tokens,
    int num_worst_tokens,
    int num_channels,
    int hidden_int4,
    int num_scales,
    int num_topk,
    int expert_alignment,
    int* rdma_channel_prefix_matrix,
    int* recv_rdma_rank_prefix_sum,
    int* gbl_channel_prefix_matrix,
    int* recv_gbl_rank_prefix_sum,
    void* rdma_buffer_ptr,
    int num_max_rdma_chunked_recv_tokens,
    void** buffer_ptrs,
    int num_max_nvl_chunked_recv_tokens,
    int** barrier_signal_ptrs,
    int rank,
    sycl::queue& queue,
    int64_t num_rdma_bytes,
    int64_t num_nvl_bytes,
    bool low_latency_mode)
{
    constexpr int kNumThreads = 512;
    const auto num_rdma_ranks = num_ranks / NUM_MAX_NVL_PEERS;

    auto rdma_clean_meta = get_rdma_clean_meta(
        hidden_int4, num_scales, num_topk, num_topk,
        num_rdma_ranks, num_max_rdma_chunked_recv_tokens, num_channels);
    auto nvl_clean_meta = get_nvl_clean_meta(
        hidden_int4, num_scales, num_topk, num_topk,
        num_rdma_ranks, NUM_MAX_NVL_PEERS,
        num_max_nvl_chunked_recv_tokens, num_channels, true);

    EP_HOST_ASSERT((rdma_clean_meta.first + rdma_clean_meta.second) * static_cast<int64_t>(sizeof(int)) <= num_rdma_bytes);
    EP_HOST_ASSERT((nvl_clean_meta.first + nvl_clean_meta.second) * static_cast<int64_t>(sizeof(int)) <= num_nvl_bytes);

    int num_wgs = 1 + num_rdma_ranks;

    // Template dispatch by num_rdma_ranks
    // HIGH_RISK: Only common rank counts are instantiated.
    // If num_rdma_ranks is not in the list, this will assert.
    auto launch = [&](auto rdma_ranks_tag) {
        constexpr int kR = decltype(rdma_ranks_tag)::value;
        using KernelT = NotifyDispatchKernel<false, kR>;
        KernelT kernel{
            num_tokens_per_rank, moe_recv_counter_mapped, num_ranks,
            num_tokens_per_rdma_rank, moe_recv_rdma_counter_mapped,
            num_tokens_per_expert, moe_recv_expert_counter_mapped, num_experts,
            is_token_in_rank, num_tokens, num_worst_tokens, num_channels,
            expert_alignment,
            rdma_clean_meta.first, rdma_clean_meta.second,
            nvl_clean_meta.first, nvl_clean_meta.second,
            rdma_channel_prefix_matrix, recv_rdma_rank_prefix_sum,
            gbl_channel_prefix_matrix, recv_gbl_rank_prefix_sum,
            rdma_buffer_ptr, buffer_ptrs, barrier_signal_ptrs, rank
        };
        queue.submit([&](sycl::handler& h) {
            h.parallel_for(sycl::nd_range<1>(num_wgs * kNumThreads, kNumThreads), kernel);
        });
    };

    switch (num_rdma_ranks) {
        case 2:  launch(std::integral_constant<int, 2>{}); break;
        case 3:  launch(std::integral_constant<int, 3>{}); break;
        case 4:  launch(std::integral_constant<int, 4>{}); break;
        case 6:  launch(std::integral_constant<int, 6>{}); break;
        case 8:  launch(std::integral_constant<int, 8>{}); break;
        case 12: launch(std::integral_constant<int, 12>{}); break;
        case 16: launch(std::integral_constant<int, 16>{}); break;
        case 18: launch(std::integral_constant<int, 18>{}); break;
        case 20: launch(std::integral_constant<int, 20>{}); break;
        default: EP_HOST_ASSERT(false && "Unsupported RDMA ranks");
    }
}

inline void launch_dispatch(
    void* recv_x,
    float* recv_x_scales,
    topk_idx_t* recv_topk_idx,
    float* recv_topk_weights,
    void* recv_src_meta,
    const void* x,
    const float* x_scales,
    const topk_idx_t* topk_idx,
    const float* topk_weights,
    int* send_rdma_head,
    int* send_nvl_head,
    int* recv_rdma_channel_prefix_matrix,
    int* recv_gbl_channel_prefix_matrix,
    const int* rdma_channel_prefix_matrix,
    const int* recv_rdma_rank_prefix_sum,
    const int* gbl_channel_prefix_matrix,
    const int* recv_gbl_rank_prefix_sum,
    const bool* is_token_in_rank,
    int num_tokens,
    int num_worst_tokens,
    int hidden_int4,
    int num_scales,
    int num_topk,
    int num_experts,
    int scale_token_stride,
    int scale_hidden_stride,
    void* rdma_buffer_ptr,
    int num_max_rdma_chunked_send_tokens,
    int num_max_rdma_chunked_recv_tokens,
    void** buffer_ptrs,
    int num_max_nvl_chunked_send_tokens,
    int num_max_nvl_chunked_recv_tokens,
    int rank,
    int num_ranks,
    bool is_cached_dispatch,
    sycl::queue& queue,
    int num_channels,
    bool low_latency_mode)
{
    constexpr int kNumDispatchRDMASenderWarps = 7;
    const int num_threads = (kNumDispatchRDMASenderWarps + 1 + NUM_MAX_NVL_PEERS) * 32;
    const int num_wgs = num_channels * 2;
    const int num_rdma_ranks = num_ranks / NUM_MAX_NVL_PEERS;

    EP_HOST_ASSERT((topk_idx == nullptr) == (topk_weights == nullptr));
    EP_HOST_ASSERT((recv_topk_idx == nullptr) == (recv_topk_weights == nullptr));

    auto launch = [&](auto rdma_ranks_tag) {
        constexpr int kR = decltype(rdma_ranks_tag)::value;
        // Non-cached, non-low-latency mode
        using KernelT = DispatchKernel<false, kR, false, kNumDispatchRDMASenderWarps>;

        queue.submit([&](sycl::handler& h) {
            sycl::local_accessor<int, 1> slm(KernelT::kSlmSize, h);
            KernelT kernel{
                reinterpret_cast<int4*>(recv_x), recv_x_scales,
                recv_topk_idx, recv_topk_weights,
                reinterpret_cast<SourceMeta*>(recv_src_meta),
                reinterpret_cast<const int4*>(x), x_scales,
                topk_idx, topk_weights,
                send_rdma_head, send_nvl_head,
                recv_rdma_channel_prefix_matrix, recv_gbl_channel_prefix_matrix,
                rdma_channel_prefix_matrix, recv_rdma_rank_prefix_sum,
                gbl_channel_prefix_matrix, recv_gbl_rank_prefix_sum,
                is_token_in_rank, num_tokens, num_worst_tokens,
                hidden_int4, num_scales, num_topk, num_experts,
                scale_token_stride, scale_hidden_stride,
                rdma_buffer_ptr,
                num_max_rdma_chunked_send_tokens, num_max_rdma_chunked_recv_tokens,
                buffer_ptrs,
                num_max_nvl_chunked_send_tokens, num_max_nvl_chunked_recv_tokens,
                rank, num_ranks,
                slm
            };
            h.parallel_for(sycl::nd_range<1>(num_wgs * num_threads, num_threads), kernel);
        });
    };

    switch (num_rdma_ranks) {
        case 2:  launch(std::integral_constant<int, 2>{}); break;
        case 3:  launch(std::integral_constant<int, 3>{}); break;
        case 4:  launch(std::integral_constant<int, 4>{}); break;
        case 6:  launch(std::integral_constant<int, 6>{}); break;
        case 8:  launch(std::integral_constant<int, 8>{}); break;
        case 12: launch(std::integral_constant<int, 12>{}); break;
        case 16: launch(std::integral_constant<int, 16>{}); break;
        case 18: launch(std::integral_constant<int, 18>{}); break;
        case 20: launch(std::integral_constant<int, 20>{}); break;
        default: EP_HOST_ASSERT(false && "Unsupported RDMA ranks");
    }
}

}  // namespace internode
}  // namespace deep_ep
