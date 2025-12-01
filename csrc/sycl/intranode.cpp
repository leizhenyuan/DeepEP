#include <sycl/sycl.hpp>
#include <cstdint>
#include "api.hpp"
#include "config.hpp"
#include "configs.h"
#include "utils.hpp"

namespace deep_ep {

namespace intranode {

template <int kNumRanks>
class NotifyDispatchKernel {
public:
    NotifyDispatchKernel(
        const int* num_tokens_per_rank,
        int* moe_recv_counter_mapped,
        const int* num_tokens_per_expert,
        int* moe_recv_expert_counter_mapped,
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
          moe_recv_expert_counter_mapped_(moe_recv_expert_counter_mapped),
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
            // ===== Block 0: 全局元数据计算 =====
            
            // 第一次Barrier同步
            barrier_block<kNumRanks, true>(barrier_signal_ptrs_, rank_, item);

            int *per_rank_buffer, *per_expert_buffer;
            // 每个线程负责一个rank
            if (thread_id < kNumRanks) {
                // 创建rank to rank的list
                per_rank_buffer = static_cast<int*>(buffer_ptrs_[thread_id]);
                // rank i to local expert j的token数
                per_expert_buffer = per_rank_buffer + kNumRanks * kNumRanks;
            }

            // 写入本rank的统计数据
            // After this loop:
            //  - `per_rank_buffer[rank][i, j]` means the number of tokens from rank i to rank j
            //  - `per_expert_buffer[rank][i, j]` means the number of tokens from rank i to local expert j
            int num_experts_per_rank = num_experts_ / kNumRanks;
            if (thread_id < kNumRanks) {
                per_rank_buffer[rank_ * kNumRanks + thread_id] = num_tokens_per_rank_[thread_id];
                #pragma unroll
                for (int i = 0; i < num_experts_per_rank; ++i)
                    per_expert_buffer[rank_ * num_experts_per_rank + i] = 
                        num_tokens_per_expert_[thread_id * num_experts_per_rank + i];
            }

            // 等待所有rank完成统计
            barrier_block<kNumRanks>(barrier_signal_ptrs_, rank_, item);

            // 计算rank间前缀和
            auto local_per_rank_buffer = static_cast<int*>(buffer_ptrs_[rank_]);
            if (thread_id < kNumRanks) {
                #pragma unroll
                for (int i = 1; i < kNumRanks; ++i)
                    local_per_rank_buffer[i * kNumRanks + thread_id] += 
                        local_per_rank_buffer[(i - 1) * kNumRanks + thread_id];
                
                // 写回当前rank的接收总数
                if (thread_id == rank_)
                    *moe_recv_counter_mapped_ = local_per_rank_buffer[(kNumRanks - 1) * kNumRanks + rank_];
            }

            // 计算expert统计
            auto local_per_expert_buffer = local_per_rank_buffer + kNumRanks * kNumRanks;
            if (thread_id < num_experts_per_rank) {
                int sum = 0;
                #pragma unroll
                for (int i = 0; i < kNumRanks; ++i)
                    sum += local_per_expert_buffer[i * num_experts_per_rank + thread_id];
                // 对齐处理
                sum = (sum + expert_alignment_ - 1) / expert_alignment_ * expert_alignment_;
                moe_recv_expert_counter_mapped_[thread_id] = sum;
            }

            // Block内同步
            item.barrier(sycl::access::fence_space::local_space);

            // 复制rank前缀矩阵到输出tensor
            #pragma unroll
            for (int i = thread_id; i < kNumRanks * kNumRanks; i += num_threads)
                rank_prefix_matrix_copy_[i] = local_per_rank_buffer[i];

            // 清零后续通信用的缓冲区
            #pragma unroll
            for (int i = thread_id; i < num_memset_int_; i += num_threads)
                local_per_expert_buffer[i] = 0;

            // 最终Barrier同步
            barrier_block<kNumRanks>(barrier_signal_ptrs_, rank_, item);

        } else {
            // ===== Block 1-kNumRanks: Channel前缀和计算 =====
            
            int dst_rank = sm_id - 1;
            
            // 每个warp处理一个channel
            for (int channel_id = warp_id; channel_id < num_channels_; channel_id += num_warps) {
                // 计算这个channel在token空间的范围
                int token_start_idx, token_end_idx;
                get_channel_task_range(num_tokens_, num_channels_, channel_id, 
                                      token_start_idx, token_end_idx);

                // 统计该channel内有多少token要发送到dst_rank
                // is_token_in_rank [num_tokens, num_ranks]
                int count = 0;
                for (int64_t i = token_start_idx + lane_id; i < token_end_idx; i += 32)
                    count += is_token_in_rank_[i * kNumRanks + dst_rank] ? 1 : 0;
                
                // Warp规约求和
                count = warp_reduce_sum(count, item);

                // 一个warp中的第一个线程写入结果
                if (elect_one_sync(item))
                    // channel发送到rank上面的数量
                    // channel_prefix_matrix shape [num_ranks, num_channels]
                    channel_prefix_matrix_[dst_rank * num_channels_ + channel_id] = count;
            }
            
            // Block内同步
            item.barrier(sycl::access::fence_space::local_space);

            // 计算channel前缀和
            if (thread_id == 0) {
                #pragma unroll
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
    int* moe_recv_expert_counter_mapped_;
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
// notify_dispatch Host端启动函数
// ============================================================================

void notify_dispatch(const int* num_tokens_per_rank,
                     int* moe_recv_counter_mapped,
                     int num_ranks,
                     const int* num_tokens_per_expert,
                     int* moe_recv_expert_counter_mapped,
                     int num_experts,
                     int num_tokens,
                     const bool* is_token_in_rank,
                     int* channel_prefix_matrix,
                     int* rank_prefix_matrix_copy,
                     int num_memset_int,
                     int expert_alignment,
                     void** buffer_ptrs,
                     int** barrier_signal_ptrs,
                     int rank,
                     sycl::queue& stream,
                     int num_channels) {
    
    constexpr int kNumThreads = 128;
    
    // 验证参数
    EP_HOST_ASSERT(num_experts % num_ranks == 0);
    EP_HOST_ASSERT(num_experts / num_ranks <= kNumThreads && num_ranks <= kNumThreads);

    // 计算grid和block大小
    int num_blocks = 1 + num_ranks;
    sycl::range<1> global_range(num_blocks * kNumThreads);
    sycl::range<1> local_range(kNumThreads);

    // 根据num_ranks选择模板实例
    #define NOTIFY_DISPATCH_LAUNCH_CASE(ranks)                                          \
        case ranks:                                                                     \
            stream.parallel_for(                                                        \
                sycl::nd_range<1>(global_range, local_range),                          \
                NotifyDispatchKernel<ranks>(                                           \
                    num_tokens_per_rank,                                               \
                    moe_recv_counter_mapped,                                           \
                    num_tokens_per_expert,                                             \
                    moe_recv_expert_counter_mapped,                                    \
                    num_experts,                                                       \
                    num_tokens,                                                        \
                    num_channels,                                                      \
                    is_token_in_rank,                                                  \
                    channel_prefix_matrix,                                             \
                    rank_prefix_matrix_copy,                                           \
                    num_memset_int,                                                    \
                    expert_alignment,                                                  \
                    buffer_ptrs,                                                       \
                    barrier_signal_ptrs,                                               \
                    rank));                                                            \
            break

    switch (num_ranks) {
        NOTIFY_DISPATCH_LAUNCH_CASE(1);
        NOTIFY_DISPATCH_LAUNCH_CASE(2);
        NOTIFY_DISPATCH_LAUNCH_CASE(4);
        NOTIFY_DISPATCH_LAUNCH_CASE(8);
        default:
            EP_HOST_ASSERT(false && "Unsupported number of ranks");
    }

    #undef NOTIFY_DISPATCH_LAUNCH_CASE
}

// ============================================================================
// cached_notify_dispatch kernel - SYCL版本
// ============================================================================

template <int kNumRanks>
class CachedNotifyDispatchKernel {
public:
    CachedNotifyDispatchKernel(
        const int* rank_prefix_matrix,
        int num_memset_int,
        void** buffer_ptrs,
        int** barrier_signal_ptrs,
        int rank)
        : rank_prefix_matrix_(rank_prefix_matrix),
          num_memset_int_(num_memset_int),
          buffer_ptrs_(buffer_ptrs),
          barrier_signal_ptrs_(barrier_signal_ptrs),
          rank_(rank) {}

    void operator()(sycl::nd_item<1> item) const {
        auto thread_id = static_cast<int>(item.get_local_id(0));
        auto num_threads = static_cast<int>(item.get_local_range(0));

        // Barrier同步
        barrier_block<kNumRanks, true>(barrier_signal_ptrs_, rank_, item);

        // 复制缓存的rank_prefix_matrix
        auto ptr = static_cast<int*>(buffer_ptrs_[rank_]);
        #pragma unroll
        for (int i = thread_id; i < kNumRanks * kNumRanks; i += num_threads)
            ptr[i] = rank_prefix_matrix_[i];
        
        // 清零后续通信用的缓冲区
        #pragma unroll
        for (int i = thread_id; i < num_memset_int_; i += num_threads)
            ptr[kNumRanks * kNumRanks + i] = 0;

        // 最终Barrier同步
        barrier_block<kNumRanks>(barrier_signal_ptrs_, rank_, item);
    }

private:
    const int* rank_prefix_matrix_;
    int num_memset_int_;
    void** buffer_ptrs_;
    int** barrier_signal_ptrs_;
    int rank_;
};

// ============================================================================
// cached_notify_dispatch Host端启动函数
// ============================================================================

void cached_notify_dispatch(const int* rank_prefix_matrix,
                            int num_memset_int,
                            void** buffer_ptrs,
                            int** barrier_signal_ptrs,
                            int rank,
                            int num_ranks,
                            sycl::queue& stream) {
    
    constexpr int kNumThreads = 128;
    
    // 只需要1个block
    sycl::range<1> global_range(kNumThreads);
    sycl::range<1> local_range(kNumThreads);

    #define CACHED_NOTIFY_DISPATCH_LAUNCH_CASE(ranks)                                   \
        case ranks:                                                                     \
            stream.parallel_for(                                                        \
                sycl::nd_range<1>(global_range, local_range),                          \
                CachedNotifyDispatchKernel<ranks>(                                     \
                    rank_prefix_matrix,                                                \
                    num_memset_int,                                                    \
                    buffer_ptrs,                                                       \
                    barrier_signal_ptrs,                                               \
                    rank));                                                            \
            break

    switch (num_ranks) {
        CACHED_NOTIFY_DISPATCH_LAUNCH_CASE(1);
        CACHED_NOTIFY_DISPATCH_LAUNCH_CASE(2);
        CACHED_NOTIFY_DISPATCH_LAUNCH_CASE(4);
        CACHED_NOTIFY_DISPATCH_LAUNCH_CASE(8);
        default:
            EP_HOST_ASSERT(false && "Unsupported number of ranks");
    }

    #undef CACHED_NOTIFY_DISPATCH_LAUNCH_CASE
}

}  // namespace intranode

}  // namespace deep_ep
