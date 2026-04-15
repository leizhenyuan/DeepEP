#include <sycl/sycl.hpp>
#include <cstdint>
#include <limits>
#include <iostream>
#include <sstream>
#include <vector>
#include <chrono>
#include <thread>
#include "api.hpp"
#include "buffer.hpp"
#include "config.hpp"
#include "configs.h"
#include "utils.hpp"

#define DEBUG_LOG(rank, msg) \
    do { \
        auto now = std::chrono::system_clock::now(); \
        auto ms = std::chrono::duration_cast<std::chrono::milliseconds>(now.time_since_epoch()).count(); \
        std::cout << "[Rank " << rank << " @ " << ms << "ms] " << msg << std::endl << std::flush; \
    } while(0)

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

        if (sm_id == 0 && thread_id == 0) {
        }

        if (sm_id == 0) {

            barrier_block_bypass<kNumRanks, true>(barrier_signal_ptrs_, rank_, item);

            int *per_rank_buffer, *per_expert_buffer;
            // 每个线程负责一个rank
            if (thread_id < kNumRanks) {
                // 创建rank to rank的list
                per_rank_buffer = static_cast<int*>(buffer_ptrs_[thread_id]);
                // rank i to local expert j的token数
                per_expert_buffer = per_rank_buffer + kNumRanks * kNumRanks;
            }

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
            barrier_block_bypass<kNumRanks>(barrier_signal_ptrs_, rank_, item);

            // 打印所有 rank 的 per_rank_buffer 和 per_expert_buffer（barrier后所有数据可见）

            auto local_per_rank_buffer = static_cast<int*>(buffer_ptrs_[rank_]);
            if (thread_id < kNumRanks) {
                #pragma unroll
                for (int i = 1; i < kNumRanks; ++i)
                    local_per_rank_buffer[i * kNumRanks + thread_id] += 
                        local_per_rank_buffer[(i - 1) * kNumRanks + thread_id];
                
                if (thread_id == rank_)
                    *moe_recv_counter_mapped_ = local_per_rank_buffer[(kNumRanks - 1) * kNumRanks + rank_];
            }

            auto local_per_expert_buffer = local_per_rank_buffer + kNumRanks * kNumRanks;
            if (thread_id < num_experts_per_rank) {
                int sum = 0;
                #pragma unroll
                for (int i = 0; i < kNumRanks; ++i)
                    sum += local_per_expert_buffer[i * num_experts_per_rank + thread_id];
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

            // 打印 rank_prefix_matrix_copy_ 结果
            item.barrier(sycl::access::fence_space::local_space);

            // 最终Barrier同步
            barrier_block_bypass<kNumRanks>(barrier_signal_ptrs_, rank_, item);
            
            
        } 
        else {
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
        case ranks: {                                                                   \
                stream.submit([&](sycl::handler& cgh) {                                \
                                                                                                            cgh.parallel_for(                                                  \
                        sycl::nd_range<1>(global_range, local_range),                 \
                        [=](sycl::nd_item<1> item) {                                  \
                            NotifyDispatchKernel<ranks> kernel(                       \
                                num_tokens_per_rank,                                   \
                                moe_recv_counter_mapped,                               \
                                num_tokens_per_expert,                                 \
                                moe_recv_expert_counter_mapped,                        \
                                num_experts,                                           \
                                num_tokens,                                            \
                                num_channels,                                          \
                                is_token_in_rank,                                      \
                                channel_prefix_matrix,                                 \
                                rank_prefix_matrix_copy,                               \
                                num_memset_int,                                        \
                                expert_alignment,                                      \
                                buffer_ptrs,                                           \
                                barrier_signal_ptrs,                                   \
                                rank);                                                   \
                            kernel(item);                                              \
                        });                                                            \
                });                                                                    \
                break;                                                                 \
        }

    switch (num_ranks) {
        NOTIFY_DISPATCH_LAUNCH_CASE(1);
        NOTIFY_DISPATCH_LAUNCH_CASE(2);
        NOTIFY_DISPATCH_LAUNCH_CASE(4);
        NOTIFY_DISPATCH_LAUNCH_CASE(8);
        default:
            EP_HOST_ASSERT(false && "Unsupported number of ranks");
    }

    #undef NOTIFY_DISPATCH_LAUNCH_CASE
    
    try {
        stream.wait();
    } catch (sycl::exception const& e) {
        throw;
    } catch (std::exception const& e) {
        throw;
    }
    
    
}


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
        // barrier_block<kNumRanks, true>(barrier_signal_ptrs_, rank_, item, debug_stream_);

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
        // barrier_block<kNumRanks>(barrier_signal_ptrs_, rank_, item, debug_stream_);
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
            stream.submit([&](sycl::handler& cgh) {                                \
                                                                                                        cgh.parallel_for(                                                      \
                    sycl::nd_range<1>(global_range, local_range),                     \
                    [=](sycl::nd_item<1> item) {                                      \
                        CachedNotifyDispatchKernel<ranks> kernel(                     \
                            rank_prefix_matrix,                                        \
                            num_memset_int,                                            \
                            buffer_ptrs,                                               \
                            barrier_signal_ptrs,                                       \
                            rank);                                                     \
                        kernel(item);                                                  \
                    });                                                                \
            });                                                                        \
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

template <int kNumRanks, int kNumThreads>
class DispatchKernel {
public:
    DispatchKernel(
        int4* recv_x,
        float* recv_x_scales,
        int* recv_src_idx,
        topk_idx_t* recv_topk_idx,
        float* recv_topk_weights,
        int* recv_channel_offset,
        int* send_head,
        const int4* x,
        const float* x_scales,
        const topk_idx_t* topk_idx,
        const float* topk_weights,
        const bool* is_token_in_rank,
        const int* channel_prefix_matrix,
        int num_tokens,
        int num_worst_tokens,
        int hidden_int4,
        int num_topk,
        int num_experts,
        int num_scales,
        int scale_token_stride,
        int scale_hidden_stride,
        void** buffer_ptrs,
        int rank,
        int num_max_send_tokens,
        int num_recv_buffer_tokens,
        int* shared_channel_tail_idx_ptr,
        int* barrier_counters_ptr)
        : recv_x_(recv_x),
          recv_x_scales_(recv_x_scales),
          recv_src_idx_(recv_src_idx),
          recv_topk_idx_(recv_topk_idx),
          recv_topk_weights_(recv_topk_weights),
          recv_channel_offset_(recv_channel_offset),
          send_head_(send_head),
          x_(x),
          x_scales_(x_scales),
          topk_idx_(topk_idx),
          topk_weights_(topk_weights),
          is_token_in_rank_(is_token_in_rank),
          channel_prefix_matrix_(channel_prefix_matrix),
          num_tokens_(num_tokens),
          num_worst_tokens_(num_worst_tokens),
          hidden_int4_(hidden_int4),
          num_topk_(num_topk),
          num_experts_(num_experts),
          num_scales_(num_scales),
          scale_token_stride_(scale_token_stride),
          scale_hidden_stride_(scale_hidden_stride),
          buffer_ptrs_(buffer_ptrs),
          rank_(rank),
          num_max_send_tokens_(num_max_send_tokens),
          num_recv_buffer_tokens_(num_recv_buffer_tokens),
          shared_channel_tail_idx_(shared_channel_tail_idx_ptr),
          barrier_counters_(barrier_counters_ptr) {}

    void operator()(sycl::nd_item<1> item) const {
        const auto num_sms = static_cast<int>(item.get_group_range(0));
        const auto sm_id = static_cast<int>(item.get_group(0));
        const auto thread_id = static_cast<int>(item.get_local_id(0));
        const auto lane_id = get_lane_id(item);
        
        // 偶数sm负责发送，奇数sm负责接收，每两个sm负责一个channel
        const bool is_sender = sm_id % 2 == 0;

        // Exactly one warp per rank (kNumThreads == kNumRanks * 32)
        const auto num_channels = num_sms / 2;
        const auto responsible_rank = thread_id / 32;
        const auto responsible_channel = sm_id / 2;

        int num_experts_per_rank = num_experts_ / kNumRanks;

        // Calculate pointers by the specific layout
        // `rank_prefix_matrix`: kNumRanks * kNumRanks * sizeof(int)
        auto ptr = reinterpret_cast<void*>(static_cast<int8_t*>(buffer_ptrs_[is_sender ? responsible_rank : rank_]) +
                                           kNumRanks * kNumRanks * sizeof(int));
        int target_rank = is_sender ? rank_ : responsible_rank;
        auto num_channels_total = num_channels * kNumRanks;
        auto channel_rank_offset = responsible_channel * kNumRanks + target_rank;

        // Channel buffer metadata
        auto channel_start_offset = Buffer<int>(ptr, num_channels_total, channel_rank_offset);
        auto channel_end_offset = Buffer<int>(ptr, num_channels_total, channel_rank_offset);
        auto channel_head_idx = Buffer<int>(ptr, num_channels_total, channel_rank_offset);
        auto channel_tail_idx = Buffer<int>(ptr, num_channels_total, channel_rank_offset);

        // Channel data buffers
        auto channel_x_buffers = Buffer<int4>(
            ptr, static_cast<int64_t>(num_channels_total) * num_recv_buffer_tokens_ * hidden_int4_, 
            static_cast<int64_t>(channel_rank_offset) * num_recv_buffer_tokens_ * hidden_int4_);
        auto channel_src_idx_buffers =
            Buffer<int>(ptr, static_cast<int64_t>(num_channels_total) * num_recv_buffer_tokens_, 
                       static_cast<int64_t>(channel_rank_offset) * num_recv_buffer_tokens_);
        auto channel_topk_idx_buffers = Buffer<topk_idx_t>(
            ptr, static_cast<int64_t>(num_channels_total) * num_recv_buffer_tokens_ * num_topk_, 
            static_cast<int64_t>(channel_rank_offset) * num_recv_buffer_tokens_ * num_topk_);
        auto channel_topk_weights_buffers = Buffer<float>(
            ptr, static_cast<int64_t>(num_channels_total) * num_recv_buffer_tokens_ * num_topk_, 
            static_cast<int64_t>(channel_rank_offset) * num_recv_buffer_tokens_ * num_topk_);
        auto channel_x_scales_buffers = Buffer<float>(
            ptr, static_cast<int64_t>(num_channels_total) * num_recv_buffer_tokens_ * num_scales_, 
            static_cast<int64_t>(channel_rank_offset) * num_recv_buffer_tokens_ * num_scales_);

        if (is_sender) {
            dispatch_sender(item, sm_id, num_channels, responsible_rank, responsible_channel,
                           num_experts_per_rank, channel_start_offset, channel_end_offset, channel_head_idx,
                           channel_tail_idx, channel_x_buffers, channel_src_idx_buffers, channel_topk_idx_buffers,
                           channel_topk_weights_buffers, channel_x_scales_buffers);
        } else {
            dispatch_receiver(item, sm_id, num_channels, responsible_rank, responsible_channel,
                             channel_start_offset, channel_end_offset, channel_head_idx, channel_tail_idx,
                             channel_x_buffers, channel_src_idx_buffers, channel_topk_idx_buffers,
                             channel_topk_weights_buffers, channel_x_scales_buffers);
        }
    }

private:
    void dispatch_sender(
        sycl::nd_item<1> item,
        int sm_id,
        int num_channels,
        int responsible_rank,
        int responsible_channel,
        int num_experts_per_rank,
        Buffer<int>& channel_start_offset,
        Buffer<int>& channel_end_offset,
        Buffer<int>& channel_head_idx,
        Buffer<int>& channel_tail_idx,
        Buffer<int4>& channel_x_buffers,
        Buffer<int>& channel_src_idx_buffers,
        Buffer<topk_idx_t>& channel_topk_idx_buffers,
        Buffer<float>& channel_topk_weights_buffers,
        Buffer<float>& channel_x_scales_buffers) const {
        
        const auto lane_id = get_lane_id(item);

        // Send offset by `-value - 1`, e.g. 0 -> -1, 1 -> -2
        // NOTES: this is for distinguishing zero tokens
        if (elect_one_sync(item)) {
            int value = responsible_channel > 0 ? 
                channel_prefix_matrix_[responsible_rank * num_channels + responsible_channel - 1] : 0;
            st_volatile_global(channel_start_offset.buffer(), -value - 1);
            
            value = channel_prefix_matrix_[responsible_rank * num_channels + responsible_channel];
            st_volatile_global(channel_end_offset.buffer(), -value - 1);
        }
        sycl::group_barrier(item.get_sub_group());

        int token_start_idx, token_end_idx;
        get_channel_task_range(num_tokens_, num_channels, responsible_channel, token_start_idx, token_end_idx);

        int cached_channel_tail_idx = 0;
        for (int64_t token_idx = token_start_idx; token_idx < token_end_idx;) {
            // Check destination queue emptiness
            if (elect_one_sync(item)) {
                int loop_count = 0;
                while (true) {
                    int head_idx_value = ld_volatile_global(channel_head_idx.buffer());
                    int num_used_slots = cached_channel_tail_idx - head_idx_value;
                    if (num_recv_buffer_tokens_ - num_used_slots >= num_max_send_tokens_) {
                        break;
                    }
                    loop_count++;
                    if (loop_count > 1000000) {
                        break;
                    }
                }
            }
            sycl::group_barrier(item.get_sub_group());

            int chunk_token_idx = 0;
            while (chunk_token_idx < num_max_send_tokens_ && token_idx < token_end_idx) {
                // Record send_head
                if (elect_one_sync(item))
                    send_head_[token_idx * kNumRanks + responsible_rank] =
                        is_token_in_rank_[token_idx * kNumRanks + responsible_rank] ? cached_channel_tail_idx : -1;

                // Skip if not selected
                if (!is_token_in_rank_[token_idx * kNumRanks + responsible_rank]) {
                    token_idx++;
                    continue;
                }

                // Get an empty slot
                int dst_slot_idx = (cached_channel_tail_idx++) % num_recv_buffer_tokens_;

                // Copy data
                auto shifted_channel_x_buffers = channel_x_buffers.buffer() + dst_slot_idx * hidden_int4_;
                auto shifted_x = x_ + token_idx * hidden_int4_;
                UNROLLED_WARP_COPY(5, lane_id, hidden_int4_, shifted_channel_x_buffers, shifted_x, ld_nc_global, st_na_global);

                if (elect_one_sync(item))
                    st_na_global(channel_src_idx_buffers.buffer() + dst_slot_idx, static_cast<int>(token_idx));

                // Copy topk_idx and topk_weights
                if (topk_idx_ != nullptr && lane_id < num_topk_) {
                    int recv_expert_begin = responsible_rank * num_experts_per_rank;
                    int recv_expert_end = (responsible_rank + 1) * num_experts_per_rank;
                    auto idx_value = topk_idx_[token_idx * num_topk_ + lane_id];
                    idx_value = (idx_value >= recv_expert_begin && idx_value < recv_expert_end) ? 
                               idx_value - recv_expert_begin : -1;
                    st_na_global(channel_topk_idx_buffers.buffer() + dst_slot_idx * num_topk_ + lane_id, idx_value);

                    auto weight_value = topk_weights_[token_idx * num_topk_ + lane_id];
                    weight_value = (idx_value >= 0) ? weight_value : 0.0f;
                    st_na_global(channel_topk_weights_buffers.buffer() + dst_slot_idx * num_topk_ + lane_id, weight_value);
                }

                // Copy x_scales
                if (x_scales_ != nullptr) {
                    for (int i = lane_id; i < num_scales_; i += 32) {
                        auto offset = token_idx * scale_token_stride_ + i * scale_hidden_stride_;
                        st_na_global(channel_x_scales_buffers.buffer() + dst_slot_idx * num_scales_ + i, x_scales_[offset]);
                    }
                }

                chunk_token_idx++;
                token_idx++;
            }

            // Single warp per rank: sub-group barrier is sufficient before publishing tail
            sycl::group_barrier(item.get_sub_group());
            
            if (elect_one_sync(item)) {
                // Fence ensures all prior UC data stores are visible before tail publish
                memory_fence_system();
                st_volatile_global(channel_tail_idx.buffer(), cached_channel_tail_idx);
            }
        }

    }

    void dispatch_receiver(
        sycl::nd_item<1> item,
        int sm_id,
        int num_channels,
        int responsible_rank,
        int responsible_channel,
        Buffer<int>& channel_start_offset,
        Buffer<int>& channel_end_offset,
        Buffer<int>& channel_head_idx,
        Buffer<int>& channel_tail_idx,
        Buffer<int4>& channel_x_buffers,
        Buffer<int>& channel_src_idx_buffers,
        Buffer<topk_idx_t>& channel_topk_idx_buffers,
        Buffer<float>& channel_topk_weights_buffers,
        Buffer<float>& channel_x_scales_buffers) const {
        
        const auto lane_id = get_lane_id(item);

        auto rank_prefix_matrix = static_cast<int*>(buffer_ptrs_[rank_]);
        int rank_offset = responsible_rank > 0 ? rank_prefix_matrix[(responsible_rank - 1) * kNumRanks + rank_] : 0;

        int total_offset = 0, num_tokens_to_recv = 0;
        if (elect_one_sync(item)) {
            int loop_count = 0;
            while ((total_offset = ld_volatile_global(channel_start_offset.buffer())) == 0) {
                loop_count++;
                if (loop_count > 1000000) {
                    break;
                }
            }

            loop_count = 0;
            while ((num_tokens_to_recv = ld_volatile_global(channel_end_offset.buffer())) == 0) {
                loop_count++;
                if (loop_count > 1000000) {
                    break;
                }
            }
            total_offset = -total_offset - 1;
            num_tokens_to_recv = -num_tokens_to_recv - 1;

            recv_channel_offset_[responsible_rank * num_channels + responsible_channel] = total_offset;
            num_tokens_to_recv -= total_offset;
        }
        total_offset = warp_broadcast(total_offset, 0, item);
        total_offset += rank_offset;
        num_tokens_to_recv = warp_broadcast(num_tokens_to_recv, 0, item);

        // ==================== Data receive loop ====================
        int cached_channel_head_idx = 0, cached_channel_tail_idx = 0;
        
        while (num_tokens_to_recv > 0) {
            // Wait for new data - single warp polls directly
            if (elect_one_sync(item)) {
                int loop_count = 0;
                while (true) {
                    cached_channel_tail_idx = ld_volatile_global(channel_tail_idx.buffer());
                    if (cached_channel_head_idx != cached_channel_tail_idx) {
                        break;
                    }
                    loop_count++;
                    if (loop_count > 1000000) {
                        break;
                    }
                }
            }
            // Broadcast tail_idx to all lanes
            cached_channel_tail_idx = warp_broadcast(cached_channel_tail_idx, 0, item);

            int num_recv_tokens = cached_channel_tail_idx - cached_channel_head_idx;
            
            // If no tokens (timeout case), exit loop
            if (num_recv_tokens <= 0) {
                break;
            }
            
            // Copy data - single warp handles all tokens sequentially
            for (int chunk_idx = 0; chunk_idx < num_recv_tokens; chunk_idx++) {
                int token_idx_in_buffer = (cached_channel_head_idx + chunk_idx) % num_recv_buffer_tokens_;
                auto shifted_buffer_x_int4 = channel_x_buffers.buffer() + token_idx_in_buffer * hidden_int4_;
                auto shifted_recv_x_int4 = recv_x_ + static_cast<int64_t>(total_offset + chunk_idx) * hidden_int4_;
                UNROLLED_WARP_COPY(5, lane_id, hidden_int4_, shifted_recv_x_int4, shifted_buffer_x_int4, ld_nc_global, st_na_global);
            }

            // Copy src_idx
            for (int chunk_idx = cached_channel_head_idx + lane_id; 
                 chunk_idx < cached_channel_tail_idx;
                 chunk_idx += 32) {
                recv_src_idx_[total_offset + chunk_idx - cached_channel_head_idx] =
                    ld_nc_global(channel_src_idx_buffers.buffer() + chunk_idx % num_recv_buffer_tokens_);
            }

            // Copy topk_idx and topk_weights
            if (recv_topk_idx_ != nullptr) {
                for (int idx = lane_id; idx < num_recv_tokens * num_topk_; idx += 32) {
                    int chunk_idx = idx / num_topk_, token_topk_idx = idx % num_topk_;
                    int token_idx_in_buffer = (cached_channel_head_idx + chunk_idx) % num_recv_buffer_tokens_;
                    auto recv_idx = static_cast<int64_t>(total_offset + chunk_idx) * num_topk_ + token_topk_idx;
                    auto buffer_idx = token_idx_in_buffer * num_topk_ + token_topk_idx;
                    recv_topk_idx_[recv_idx] = ld_nc_global(channel_topk_idx_buffers.buffer() + buffer_idx);
                    recv_topk_weights_[recv_idx] = ld_nc_global(channel_topk_weights_buffers.buffer() + buffer_idx);
                }
            }

            // Copy x_scales
            if (recv_x_scales_ != nullptr) {
                for (int i = lane_id; i < num_recv_tokens * num_scales_; i += 32) {
                    int chunk_idx = i / num_scales_, scales_idx = i % num_scales_;
                    int token_idx_in_buffer = (cached_channel_head_idx + chunk_idx) % num_recv_buffer_tokens_;
                    recv_x_scales_[static_cast<int64_t>(total_offset + chunk_idx) * num_scales_ + scales_idx] =
                        ld_nc_global(channel_x_scales_buffers.buffer() + token_idx_in_buffer * num_scales_ + scales_idx);
                }
            }

            // Move queue
            cached_channel_head_idx += num_recv_tokens;
            total_offset += num_recv_tokens;
            
            // Single warp: sub-group barrier then update head
            sycl::group_barrier(item.get_sub_group());
            
            if (elect_one_sync(item)) {
                st_volatile_global(channel_head_idx.buffer(), cached_channel_head_idx);
            }

            num_tokens_to_recv -= num_recv_tokens;
        }

    }

    // Member variables
    int4* recv_x_;
    float* recv_x_scales_;
    int* recv_src_idx_;
    topk_idx_t* recv_topk_idx_;
    float* recv_topk_weights_;
    int* recv_channel_offset_;
    int* send_head_;
    const int4* x_;
    const float* x_scales_;
    const topk_idx_t* topk_idx_;
    const float* topk_weights_;
    const bool* is_token_in_rank_;
    const int* channel_prefix_matrix_;
    int num_tokens_;
    int num_worst_tokens_;
    int hidden_int4_;
    int num_topk_;
    int num_experts_;
    int num_scales_;
    int scale_token_stride_;
    int scale_hidden_stride_;
    void** buffer_ptrs_;
    int rank_;
    int num_max_send_tokens_;
    int num_recv_buffer_tokens_;
    int* shared_channel_tail_idx_;
    int* barrier_counters_;
};

void dispatch(void* recv_x,
              float* recv_x_scales,
              int* recv_src_idx,
              topk_idx_t* recv_topk_idx,
              float* recv_topk_weights,
              int* recv_channel_offset,
              int* send_head,
              const void* x,
              const float* x_scales,
              const topk_idx_t* topk_idx,
              const float* topk_weights,
              const bool* is_token_in_rank,
              const int* channel_prefix_matrix,
              int num_tokens,
              int num_worst_tokens,
              int hidden_int4,
              int num_topk,
              int num_experts,
              int num_scales,
              int scale_token_stride,
              int scale_hidden_stride,
              void** buffer_ptrs,
              int rank,
              int num_ranks,
              sycl::queue& stream,
              int num_sms,
              int num_max_send_tokens,
              int num_recv_buffer_tokens) {
    
    
    // kNumThreads = kNumRanks * 32: exactly one warp per rank.
    // No partial_barrier needed — each rank's work is handled by a single warp.

    // Make sure never OOB
    EP_HOST_ASSERT(static_cast<int64_t>(num_scales) * scale_hidden_stride < std::numeric_limits<int>::max());
    EP_HOST_ASSERT(num_sms % 2 == 0);

#define DISPATCH_LAUNCH_CASE(ranks)                                                                     \
    case ranks: {                                                                                       \
        constexpr int kLaunchThreads = ranks * 32;                                                     \
        sycl::range<1> global_range(num_sms * kLaunchThreads);                                         \
        sycl::range<1> local_range(kLaunchThreads);                                                    \
        stream.submit([&](sycl::handler& cgh) {                                                        \
            cgh.parallel_for(                                                                          \
                sycl::nd_range<1>(global_range, local_range),                                          \
                [=](sycl::nd_item<1> item) {                                                           \
                    DispatchKernel<ranks, kLaunchThreads> kernel(                                      \
                        reinterpret_cast<int4*>(recv_x),                                               \
                        recv_x_scales,                                                                 \
                        recv_src_idx,                                                                  \
                        recv_topk_idx,                                                                 \
                        recv_topk_weights,                                                             \
                        recv_channel_offset,                                                           \
                        send_head,                                                                     \
                        reinterpret_cast<const int4*>(x),                                              \
                        x_scales,                                                                      \
                        topk_idx,                                                                      \
                        topk_weights,                                                                  \
                        is_token_in_rank,                                                              \
                        channel_prefix_matrix,                                                         \
                        num_tokens,                                                                    \
                        num_worst_tokens,                                                              \
                        hidden_int4,                                                                   \
                        num_topk,                                                                      \
                        num_experts,                                                                   \
                        num_scales,                                                                    \
                        scale_token_stride,                                                            \
                        scale_hidden_stride,                                                           \
                        buffer_ptrs,                                                                   \
                        rank,                                                                          \
                        num_max_send_tokens,                                                           \
                        num_recv_buffer_tokens,                                                        \
                        nullptr,                                                                       \
                        nullptr);                                                                      \
                    kernel(item);                                                                      \
                });                                                                                    \
        });                                                                                            \
        break;                                                                                         \
    }

    switch (num_ranks) {
        DISPATCH_LAUNCH_CASE(1);
        DISPATCH_LAUNCH_CASE(2);
        DISPATCH_LAUNCH_CASE(4);
        DISPATCH_LAUNCH_CASE(8);
        default:
            EP_HOST_ASSERT(false && "Unsupported number of ranks");
    }

#undef DISPATCH_LAUNCH_CASE
    
    stream.wait();
}

template <int kNumRanks>
class CachedNotifyCombineKernel {
public:
    CachedNotifyCombineKernel(
        void** buffer_ptrs,
        int* send_head,
        int num_channels,
        int num_recv_tokens,
        int num_memset_int,
        int** barrier_signal_ptrs,
        int rank)
        : buffer_ptrs_(buffer_ptrs),
          send_head_(send_head),
          num_channels_(num_channels),
          num_recv_tokens_(num_recv_tokens),
          num_memset_int_(num_memset_int),
          barrier_signal_ptrs_(barrier_signal_ptrs),
          rank_(rank) {}

    void operator()(sycl::nd_item<1> item) const {
        auto sm_id = static_cast<int>(item.get_group(0));
        auto thread_id = static_cast<int>(item.get_local_id(0));
        auto num_threads = static_cast<int>(item.get_local_range(0));

        if (sm_id == 0) {
            // Block 0: 清理IPC Buffer

            // Barrier before cleaning
            barrier_block_bypass<kNumRanks, true>(barrier_signal_ptrs_, rank_, item);

            // Clean buffer
            auto ptr = static_cast<int*>(buffer_ptrs_[rank_]);
            #pragma unroll
            for (int i = thread_id; i < num_memset_int_; i += num_threads)
                ptr[i] = 0;

            // Barrier after cleaning
            barrier_block_bypass<kNumRanks>(barrier_signal_ptrs_, rank_, item);
        } else {
            // Block 1 ~ num_channels: 补全send_head数组
            const auto channel_id = sm_id - 1;
            const auto rank_id = thread_id / 32;
            const auto lane_id = thread_id % 32;
            
            // 如果rank_id超出范围，直接返回
            if (rank_id >= kNumRanks)
                return;

            // 获取该channel负责的token范围
            int token_start_idx, token_end_idx;
            get_channel_task_range(num_recv_tokens_, num_channels_, channel_id, token_start_idx, token_end_idx);

            // NOTES: `1 << 25` is a heuristic large number
            int last_head = 1 << 25;
            
            // 从后向前遍历，为负值的send_head填充合理的值
            #pragma unroll
            for (int token_idx_tail = token_end_idx - 1; token_idx_tail >= token_start_idx; token_idx_tail -= 32) {
                int token_idx = token_idx_tail - lane_id;
                int expected_head = 0;
                
                // 读取当前head值，如果token_idx越界则设为-1
                auto current_head = (token_idx >= token_start_idx) ? 
                    ld_nc_global(send_head_ + token_idx * kNumRanks + rank_id) : -1;
                
                // Warp内依次处理每个token
                auto sg = item.get_sub_group();
                int num_iters = sycl::min(32, token_idx_tail - token_start_idx + 1);
                for (int i = 0; i < num_iters; ++i) {
                    // 从lane i广播head值
                    const int head = sycl::select_from_group(sg, current_head, i);
                    if (head < 0) {
                        // 如果head是负值，当前lane需要计算expected_head
                        if (lane_id == i)
                            expected_head = -last_head - 1;
                    } else {
                        // 更新last_head
                        last_head = head;
                    }
                }
                
                // 如果current_head是负值且token_idx有效，写回expected_head
                if (current_head < 0 && token_idx >= token_start_idx)
                    send_head_[token_idx * kNumRanks + rank_id] = expected_head;
            }
        }
    }

private:
    void** buffer_ptrs_;
    int* send_head_;
    int num_channels_;
    int num_recv_tokens_;
    int num_memset_int_;
    int** barrier_signal_ptrs_;
    int rank_;
};

void cached_notify_combine(void** buffer_ptrs,
                           int* send_head,
                           int num_channels,
                           int num_recv_tokens,
                           int num_memset_int,
                           int** barrier_signal_ptrs,
                           int rank,
                           int num_ranks,
                           sycl::queue& stream) {
    
    // 计算线程数：至少128，每个rank需要32个线程（一个warp）
    const int num_threads = std::max(128, 32 * num_ranks);
    EP_HOST_ASSERT(num_ranks <= num_threads);
    EP_HOST_ASSERT(num_threads <= 1024);
    EP_HOST_ASSERT(1 + num_channels <= num_channels * 2);

    // grid size: 1 + num_channels
    // - Block 0: 清理IPC Buffer
    // - Block 1 ~ num_channels: 补全send_head数组
    int num_blocks = 1 + num_channels;
    sycl::range<1> global_range(num_blocks * num_threads);
    sycl::range<1> local_range(num_threads);

    #define CACHED_NOTIFY_COMBINE_LAUNCH_CASE(ranks)                                    \
        case ranks:                                                                     \
            stream.submit([&](sycl::handler& cgh) {                                \
                                                                                                        cgh.parallel_for(                                                      \
                    sycl::nd_range<1>(global_range, local_range),                     \
                    [=](sycl::nd_item<1> item) {                                      \
                        CachedNotifyCombineKernel<ranks> kernel(                       \
                            buffer_ptrs,                                               \
                            send_head,                                                 \
                            num_channels,                                              \
                            num_recv_tokens,                                           \
                            num_memset_int,                                            \
                            barrier_signal_ptrs,                                       \
                            rank);                                                     \
                        kernel(item);                                                  \
                    });                                                                \
            });                                                                        \
            break

    switch (num_ranks) {
        CACHED_NOTIFY_COMBINE_LAUNCH_CASE(1);
        CACHED_NOTIFY_COMBINE_LAUNCH_CASE(2);
        CACHED_NOTIFY_COMBINE_LAUNCH_CASE(4);
        CACHED_NOTIFY_COMBINE_LAUNCH_CASE(8);
        default:
            EP_HOST_ASSERT(false && "Unsupported number of ranks");
    }

    #undef CACHED_NOTIFY_COMBINE_LAUNCH_CASE
    
    stream.wait();
}
template <typename dtype_t, int kNumRanks, int kNumThreads>
class CombineKernel {
public:
    CombineKernel(
        dtype_t* recv_x,
        float* recv_topk_weights,
        const dtype_t* x,
        const float* topk_weights,
        const dtype_t* bias_0,
        const dtype_t* bias_1,
        const int* src_idx,
        const int* rank_prefix_matrix,
        const int* channel_prefix_matrix,
        int* send_head,
        int num_tokens,
        int num_recv_tokens,
        int hidden,
        int num_topk,
        void** buffer_ptrs,
        int rank,
        int num_sms,
        int num_max_send_tokens,
        int num_recv_buffer_tokens)
        : recv_x_(recv_x),
          recv_topk_weights_(recv_topk_weights),
          x_(x),
          topk_weights_(topk_weights),
          bias_0_(bias_0),
          bias_1_(bias_1),
          src_idx_(src_idx),
          rank_prefix_matrix_(rank_prefix_matrix),
          channel_prefix_matrix_(channel_prefix_matrix),
          send_head_(send_head),
          num_tokens_(num_tokens),
          num_recv_tokens_(num_recv_tokens),
          hidden_(hidden),
          num_topk_(num_topk),
          buffer_ptrs_(buffer_ptrs),
          rank_(rank),
          num_sms_(num_sms),
          num_max_send_tokens_(num_max_send_tokens),
          num_recv_buffer_tokens_(num_recv_buffer_tokens) {}

    void operator()(sycl::nd_item<1> item,
                    volatile int* warp_channel_head_idx,  // [num_recv_warps][kNumRanks]
                    volatile int* channel_tail_idx_shared,       // [kNumRanks]
                    volatile int* warp_retired            // [num_recv_warps], cast to int for atomic
                    ) const {
        constexpr int num_recv_warps = kNumThreads / 32;
        
        auto sm_id = static_cast<int>(item.get_group(0));
        auto thread_id = static_cast<int>(item.get_local_id(0));
        auto lane_id = thread_id % 32;
        auto warp_id = thread_id / 32;
        
        const int num_channels = num_sms_ / 2;
        const bool is_sender = (sm_id % 2 == 0);
        const int responsible_channel = sm_id / 2;
        
        constexpr int kDtypePerInt4 = sizeof(int4) / sizeof(dtype_t);
        int hidden_int4 = hidden_ * sizeof(dtype_t) / sizeof(int4);
        auto x_int4 = reinterpret_cast<const int4*>(x_);
        auto bias_0_int4 = reinterpret_cast<const int4*>(bias_0_);
        auto bias_1_int4 = reinterpret_cast<const int4*>(bias_1_);
        auto recv_int4 = reinterpret_cast<int4*>(recv_x_);
        
        if (is_sender) {
            combine_sender(item, num_channels, responsible_channel, hidden_int4, x_int4);
        } else {
            combine_receiver(item, num_channels, responsible_channel, hidden_int4, kDtypePerInt4,
                           x_int4, bias_0_int4, bias_1_int4, recv_int4,
                           warp_channel_head_idx, channel_tail_idx_shared, warp_retired);
        }
    }

private:
    // Sender: 将本地expert输出发送到各rank的combine buffer
    void combine_sender(
        sycl::nd_item<1> item,
        int num_channels,
        int responsible_channel,
        int hidden_int4,
        const int4* x_int4) const {
        
        constexpr int num_send_warps_per_rank = (kNumThreads / 32) / kNumRanks;
        constexpr int num_send_warps = num_send_warps_per_rank * kNumRanks;
        const int num_threads_per_rank = num_send_warps_per_rank * 32;
        
        auto thread_id = static_cast<int>(item.get_local_id(0));
        auto lane_id = thread_id % 32;
        const int send_warp_id = thread_id / 32;
        // 发送到的目标rank
        const int send_rank_id = (responsible_channel + send_warp_id) % kNumRanks;
        const int send_warp_id_in_rank = send_warp_id / kNumRanks;
        
        // 计算buffer指针布局
        // 在combine阶段，sender写入目标rank的buffer
        auto ptr = reinterpret_cast<void*>(static_cast<int8_t*>(buffer_ptrs_[send_rank_id]));
        auto num_channels_total = num_channels * kNumRanks;
        auto channel_rank_offset = responsible_channel * kNumRanks + rank_;  // 写入时用自己的rank标识来源
        
        // Buffer布局:
        // head_idx: [num_channels * num_ranks]
        // tail_idx: [num_channels * num_ranks]
        // x_buffers: [num_channels * num_ranks * num_recv_buffer_tokens * hidden_int4]
        // src_idx_buffers: [num_channels * num_ranks * num_recv_buffer_tokens]
        // topk_weights_buffers: [num_channels * num_ranks * num_recv_buffer_tokens * num_topk]
        auto channel_head_idx = Buffer<int>(ptr, num_channels_total, channel_rank_offset);
        auto channel_tail_idx = Buffer<int>(ptr, num_channels_total, channel_rank_offset);
        auto channel_x_buffers = Buffer<int4>(
            ptr, static_cast<int64_t>(num_channels_total) * num_recv_buffer_tokens_ * hidden_int4,
            static_cast<int64_t>(channel_rank_offset) * num_recv_buffer_tokens_ * hidden_int4);
        auto channel_src_idx_buffers = Buffer<int>(
            ptr, static_cast<int64_t>(num_channels_total) * num_recv_buffer_tokens_,
            static_cast<int64_t>(channel_rank_offset) * num_recv_buffer_tokens_);
        auto channel_topk_weights_buffers = Buffer<float>(
            ptr, static_cast<int64_t>(num_channels_total) * num_recv_buffer_tokens_ * num_topk_,
            static_cast<int64_t>(channel_rank_offset) * num_recv_buffer_tokens_ * num_topk_);
        
        // 获取任务范围
        // rank_prefix_matrix[send_rank_id * kNumRanks + rank_] 是从各rank发送到send_rank_id的累计token数
        int rank_offset = send_rank_id > 0 ? rank_prefix_matrix_[(send_rank_id - 1) * kNumRanks + rank_] : 0;
        int num_rank_tokens = rank_prefix_matrix_[send_rank_id * kNumRanks + rank_] - rank_offset;
        int channel_offset = channel_prefix_matrix_[send_rank_id * num_channels + responsible_channel];
        int num_channel_tokens = 
            (responsible_channel == num_channels - 1 ? num_rank_tokens
                                                     : channel_prefix_matrix_[send_rank_id * num_channels + responsible_channel + 1]) 
            - channel_offset;
        int token_start_idx = rank_offset + channel_offset;
        int token_end_idx = rank_offset + channel_offset + num_channel_tokens;
        
        // 迭代发送所有token
        int current_channel_tail_idx = 0;
        for (int64_t token_idx = token_start_idx; token_idx < token_end_idx; ) {
            // 检查目标队列是否有足够空间
            int num_round_tokens = sycl::min(num_max_send_tokens_, token_end_idx - static_cast<int>(token_idx));
            
            if (elect_one_sync(item)) {
                while (true) {
                    int num_used_slots = current_channel_tail_idx - ld_volatile_global(channel_head_idx.buffer());
                    if (num_recv_buffer_tokens_ - num_used_slots >= num_round_tokens)
                        break;
                    // 忙等待直到有足够空间
                }
            }
            item.get_sub_group().barrier();
            
            // 分块发送
            for (int i = send_warp_id_in_rank; i < num_round_tokens; i += num_send_warps_per_rank) {
                int dst_slot_idx = (current_channel_tail_idx + i) % num_recv_buffer_tokens_;
                
                // 复制数据x
                auto shifted_x_buffers = channel_x_buffers.buffer() + dst_slot_idx * hidden_int4;
                auto shifted_x = x_int4 + (token_idx + i) * hidden_int4;
                for (int j = lane_id; j < hidden_int4; j += 32) {
                    st_na_global(shifted_x_buffers + j, ld_nc_global(shifted_x + j));
                }
                
                // 调试日志：打印发送信息
                
                // 发送src_idx
                if (elect_one_sync(item)) {
                    channel_src_idx_buffers[dst_slot_idx] = src_idx_[token_idx + i];
                }
                
                // 发送topk_weights
                if (num_topk_ > 0 && lane_id < num_topk_) {
                    channel_topk_weights_buffers[dst_slot_idx * num_topk_ + lane_id] = 
                        topk_weights_[(token_idx + i) * num_topk_ + lane_id];
                }
            }
            
            token_idx += num_round_tokens;
            current_channel_tail_idx += num_round_tokens;
            
            // warning:这里可能是一个risk，应该是所有相同send rank id的warp进行同步
            // 可能会出现其他warp没写完，但是warp0 issue了tail，还要再想想，不行的话就减少warp，每个kernel send = rank数
            item.get_sub_group().barrier();
            
            // Fence: 确保所有 st_na_global 数据写对其他 rank 可见，再写 tail
            memory_fence_system();
            
            // 更新tail索引 (只有第一个warp的leader执行)
            if (send_warp_id_in_rank == 0 && elect_one_sync(item)) {
                st_volatile_global(channel_tail_idx.buffer(), current_channel_tail_idx);
            }
        }
    }
    
    // Receiver: 从buffer中读取数据并进行reduce
    SYCL_EXTERNAL void combine_receiver(
        sycl::nd_item<1> item,
        int num_channels,
        int responsible_channel,
        int hidden_int4,
        int kDtypePerInt4,
        const int4* x_int4,
        const int4* bias_0_int4,
        const int4* bias_1_int4,
        int4* recv_int4,
        volatile int* warp_channel_head_idx,  // [num_recv_warps][kNumRanks]
        volatile int* channel_tail_idx_shared,       // [kNumRanks]
        volatile int* warp_retired            // [num_recv_warps]
        ) const {
        
        constexpr int num_recv_warps = kNumThreads / 32;
        
        auto thread_id = static_cast<int>(item.get_local_id(0));
        auto lane_id = thread_id % 32;
        auto recv_warp_id = thread_id / 32;
        
        // 初始化shared memory
        if (thread_id < num_recv_warps) {
            warp_retired[thread_id] = 0;  // false
        }
        if (lane_id < kNumRanks) {
            warp_channel_head_idx[recv_warp_id * kNumRanks + lane_id] = 0;
        }
        if (thread_id < kNumRanks) {
            channel_tail_idx_shared[thread_id] = 0;
        }
        item.barrier(sycl::access::fence_space::local_space);
        
        // Warp 0 作为队列head更新器
        if (thread_id < 32) {
            // head_idx指针在本rank的buffer中
            int* channel_head_idx_ptr = static_cast<int*>(buffer_ptrs_[rank_]) + responsible_channel * kNumRanks + lane_id;
            // tail_idx紧跟head_idx之后
            int* channel_tail_idx_ptr = channel_head_idx_ptr + num_channels * kNumRanks;
            
            int last_head = 0;
            while (lane_id < kNumRanks) {
                // 检查所有reducer warp是否都已完成
                bool retired = true;
                for (int i = 1; i < num_recv_warps; ++i) {
                    if (warp_retired[i] == 0) {
                        retired = false;
                        break;
                    }
                }
                if (retired) break;
                
                // 更新队列tail (从全局内存读取sender写入的值)
                channel_tail_idx_shared[lane_id] = ld_volatile_global(channel_tail_idx_ptr);
                
                // 计算所有未完成warp的最小head
                int min_head = std::numeric_limits<int>::max();
                for (int i = 1; i < num_recv_warps; ++i) {
                    if (warp_retired[i] == 0) {
                        int warp_head = warp_channel_head_idx[i * kNumRanks + lane_id];
                        if (warp_head < min_head) {
                            min_head = warp_head;
                        }
                    }
                }
                
                // 更新全局head
                if (min_head != std::numeric_limits<int>::max() && min_head > last_head) {
                    st_volatile_global(channel_head_idx_ptr, min_head);
                    last_head = min_head;
                }
            }
        } else {
            // Reducer warps (warp 1 to num_recv_warps-1)
            // 设置各rank的buffer指针
            Buffer<int4> channel_x_buffers[kNumRanks];
            Buffer<float> channel_topk_weights_buffers[kNumRanks];
            
            for (int i = 0; i < kNumRanks; ++i) {
                auto channel_rank_offset = responsible_channel * kNumRanks + i;
                auto num_channels_total = num_channels * kNumRanks;
                // 跳过head_idx和tail_idx
                auto ptr = reinterpret_cast<void*>(static_cast<int8_t*>(buffer_ptrs_[rank_]) + 
                           2 * num_channels * kNumRanks * sizeof(int));
                
                channel_x_buffers[i] = Buffer<int4>(
                    ptr,
                    static_cast<int64_t>(num_channels_total) * num_recv_buffer_tokens_ * hidden_int4,
                    static_cast<int64_t>(channel_rank_offset) * num_recv_buffer_tokens_ * hidden_int4);
                
                // 跳过x_buffers和src_idx_buffers
                ptr = reinterpret_cast<void*>(static_cast<int8_t*>(ptr) + 
                      static_cast<int64_t>(num_channels_total) * num_recv_buffer_tokens_ * sizeof(int));
                
                channel_topk_weights_buffers[i] = Buffer<float>(
                    ptr,
                    static_cast<int64_t>(num_channels_total) * num_recv_buffer_tokens_ * num_topk_,
                    static_cast<int64_t>(channel_rank_offset) * num_recv_buffer_tokens_ * num_topk_);
            }
            
            // 获取channel的token范围
            int token_start_idx, token_end_idx;
            get_channel_task_range(num_recv_tokens_, num_channels, responsible_channel, 
                                   token_start_idx, token_end_idx);
            
            // 迭代处理所有token (stride by num_recv_warps - 1, 因为warp 0是head updater)
            for (int64_t token_idx = token_start_idx + recv_warp_id - 1; 
                 token_idx < token_end_idx; 
                 token_idx += num_recv_warps - 1) {
                
                // 读取send_head中记录的期望位置
                int expected_head = -1;
                if (lane_id < kNumRanks) {
                    expected_head = ld_nc_global(send_head_ + token_idx * kNumRanks + lane_id);
                }
                
                // 等待所有需要的数据到达
                // 当expected_head >= 0时，需要等待对应rank的tail超过expected_head
                bool any_waiting = true;
                while (any_waiting) {
                    any_waiting = false;
                    // 检查是否还有lane在等待
                    if (lane_id < kNumRanks && expected_head >= 0) {
                        if (channel_tail_idx_shared[lane_id] <= expected_head) {
                            any_waiting = true;
                        }
                    }
                    // sub_group级别的any_sync
                    any_waiting = sycl::any_of_group(item.get_sub_group(), any_waiting);
                    if (any_waiting) {
                        // 继续等待
                    }
                }
                item.get_sub_group().barrier();
                
                // 收集有效的rank和slot索引
                int num_topk_ranks = 0;
                int topk_ranks[kNumRanks];
                int slot_indices[kNumRanks];
                
                for (int i = 0; i < kNumRanks; ++i) {
                    int expected_head_i = warp_broadcast(expected_head, i, item);
                    if (expected_head_i >= 0) {
                        slot_indices[num_topk_ranks] = expected_head_i % num_recv_buffer_tokens_;
                        topk_ranks[num_topk_ranks++] = i;
                    }
                }
                
                // Reduce数据
                for (int i = lane_id; i < hidden_int4; i += 32) {
                    // 读取bias
                    int4 bias_0_value_int4 = (bias_0_int4 != nullptr) 
                        ? bias_0_int4[token_idx * hidden_int4 + i] 
                        : make_int4(0, 0, 0, 0);
                    int4 bias_1_value_int4 = (bias_1_int4 != nullptr)
                        ? bias_1_int4[token_idx * hidden_int4 + i]
                        : make_int4(0, 0, 0, 0);
                    
                    int4 recv_value_int4[kNumRanks];
                    for (int j = 0; j < num_topk_ranks; ++j) {
                        recv_value_int4[j] = ld_nc_global(
                            channel_x_buffers[topk_ranks[j]].buffer() + slot_indices[j] * hidden_int4 + i);
                    }
                    
                    // Reduce bias
                    float values[sizeof(int4) / sizeof(dtype_t)];
                    auto bias_0_values = reinterpret_cast<const dtype_t*>(&bias_0_value_int4);
                    auto bias_1_values = reinterpret_cast<const dtype_t*>(&bias_1_value_int4);
                    constexpr int kDtypePerInt4_local = sizeof(int4) / sizeof(dtype_t);
                    for (int j = 0; j < kDtypePerInt4_local; ++j) {
                        values[j] = static_cast<float>(bias_0_values[j]) + static_cast<float>(bias_1_values[j]);
                    }
                    
                    // Reduce all-to-all结果
                    for (int j = 0; j < num_topk_ranks; ++j) {
                        auto recv_value_dtypes = reinterpret_cast<const dtype_t*>(&recv_value_int4[j]);
                        for (int k = 0; k < kDtypePerInt4_local; ++k) {
                            values[k] += static_cast<float>(recv_value_dtypes[k]);
                        }
                    }
                
                    // 转换回dtype_t, 用memcpy避免strict aliasing violation
                    dtype_t out_bf16[kDtypePerInt4_local];
                    for (int j = 0; j < kDtypePerInt4_local; ++j) {
                        out_bf16[j] = static_cast<dtype_t>(values[j]);
                    }
                    int4 out_int4;
                    __builtin_memcpy(&out_int4, out_bf16, sizeof(int4));
                    

                    recv_int4[token_idx * hidden_int4 + i] = out_int4;
                }

                // Reduce topk_weights
                if (lane_id < num_topk_) {
                    float value = 0;
                    for (int i = 0; i < num_topk_ranks; ++i) {
                        value += ld_nc_global(
                            channel_topk_weights_buffers[topk_ranks[i]].buffer() + 
                            slot_indices[i] * num_topk_ + lane_id);
                    }
                    recv_topk_weights_[token_idx * num_topk_ + lane_id] = value;
                }


                if (lane_id < kNumRanks) {
                    warp_channel_head_idx[recv_warp_id * kNumRanks + lane_id] = 
                        (expected_head < 0) ? -expected_head - 1 : expected_head + 1;
                }
            }
            
            // 标记本warp已完成
            item.get_sub_group().barrier();
            if (elect_one_sync(item)) {
                warp_retired[recv_warp_id] = 1;  // true
            }
        }
    }
    
    // 成员变量
    dtype_t* recv_x_;
    float* recv_topk_weights_;
    const dtype_t* x_;
    const float* topk_weights_;
    const dtype_t* bias_0_;
    const dtype_t* bias_1_;
    const int* src_idx_;
    const int* rank_prefix_matrix_;
    const int* channel_prefix_matrix_;
    int* send_head_;
    int num_tokens_;
    int num_recv_tokens_;
    int hidden_;
    int num_topk_;
    void** buffer_ptrs_;
    int rank_;
    int num_sms_;
    int num_max_send_tokens_;
    int num_recv_buffer_tokens_;
};

void combine(DataType type,
             void* recv_x,
             float* recv_topk_weights,
             const void* x,
             const float* topk_weights,
             const void* bias_0,
             const void* bias_1,
             const int* src_idx,
             const int* rank_prefix_matrix,
             const int* channel_prefix_matrix,
             int* send_head,
             int num_tokens,
             int num_recv_tokens,
             int hidden,
             int num_topk,
             void** buffer_ptrs,
             int rank,
             int num_ranks,
             sycl::queue& stream,
             int num_sms,
             int num_max_send_tokens,
             int num_recv_buffer_tokens) {
    
    // 验证参数
    EP_HOST_ASSERT(num_sms % 2 == 0);

    // kNumThreads = ranks * 32: sender needs at least one warp per rank
    // (num_send_warps_per_rank = kNumThreads/32/kNumRanks must be >= 1)
    #define COMBINE_LAUNCH_CASE(dtype_t, ranks)                                             \
        {                                                                                   \
            constexpr int kLaunchThreads = ranks * 32;                                      \
            constexpr int kLaunchRecvWarps = kLaunchThreads / 32;                           \
            sycl::range<1> global_range(num_sms * kLaunchThreads);                          \
            sycl::range<1> local_range(kLaunchThreads);                                     \
            stream.submit([&](sycl::handler& cgh) {                                         \
                sycl::local_accessor<int, 1> warp_channel_head_idx_acc(                     \
                    sycl::range<1>(kLaunchRecvWarps * ranks), cgh);                          \
                sycl::local_accessor<int, 1> channel_tail_idx_acc(                          \
                    sycl::range<1>(ranks), cgh);                                             \
                sycl::local_accessor<int, 1> warp_retired_acc(                              \
                    sycl::range<1>(kLaunchRecvWarps), cgh);                                  \
                                                                                             \
                cgh.parallel_for(                                                            \
                    sycl::nd_range<1>(global_range, local_range),                           \
                    [=](sycl::nd_item<1> item) {                                            \
                        CombineKernel<dtype_t, ranks, kLaunchThreads> kernel(                \
                            reinterpret_cast<dtype_t*>(recv_x),                             \
                            recv_topk_weights,                                               \
                            reinterpret_cast<const dtype_t*>(x),                            \
                            topk_weights,                                                    \
                            reinterpret_cast<const dtype_t*>(bias_0),                       \
                            reinterpret_cast<const dtype_t*>(bias_1),                       \
                            src_idx,                                                         \
                            rank_prefix_matrix,                                              \
                            channel_prefix_matrix,                                           \
                            send_head,                                                       \
                            num_tokens,                                                      \
                            num_recv_tokens,                                                 \
                            hidden,                                                          \
                            num_topk,                                                        \
                            buffer_ptrs,                                                     \
                            rank,                                                            \
                            num_sms,                                                         \
                            num_max_send_tokens,                                             \
                            num_recv_buffer_tokens);                                         \
                        kernel(item,                                                         \
                               warp_channel_head_idx_acc.get_pointer(),                     \
                               channel_tail_idx_acc.get_pointer(),                          \
                               warp_retired_acc.get_pointer());                             \
                    });                                                                      \
            });                                                                              \
            break;                                                                           \
        }

    #define COMBINE_RANKS_CASE(dtype_t)           \
        switch (num_ranks) {                      \
            case 1: COMBINE_LAUNCH_CASE(dtype_t, 1); \
            case 2: COMBINE_LAUNCH_CASE(dtype_t, 2); \
            case 4: COMBINE_LAUNCH_CASE(dtype_t, 4); \
            default:                              \
                EP_HOST_ASSERT(false && "Unsupported number of ranks"); \
        }

    switch (type) {
        case DataType::kBFloat16:
            COMBINE_RANKS_CASE(sycl::ext::oneapi::bfloat16);
            break;
        case DataType::kInt32:
            COMBINE_RANKS_CASE(int);
            break;
        default:
            EP_HOST_ASSERT(false && "Unsupported data type for combine");
    }

    #undef COMBINE_RANKS_CASE
    #undef COMBINE_LAUNCH_CASE
    
    try {
        stream.wait();
    } catch (sycl::exception const& e) {
        throw;
    } catch (std::exception const& e) {
        throw;
    }
    
}

// ============================================================================
// barrier kernel - SYCL版本 (使用 barrier_block_bypass)
// ============================================================================

template <int kNumRanks>
class BarrierKernel {
public:
    BarrierKernel(int** barrier_signal_ptrs, int rank)
        : barrier_signal_ptrs_(barrier_signal_ptrs),
          rank_(rank) {}

    void operator()(sycl::nd_item<1> item) const {
        // 使用 CAS-based barrier
        barrier_block_bypass<kNumRanks, true>(barrier_signal_ptrs_, rank_, item);
    }

private:
    int** barrier_signal_ptrs_;
    int rank_;
};

void barrier(int** barrier_signal_ptrs, int rank, int num_ranks, sycl::queue& stream) {
    constexpr int kNumThreads = 128;
    
    sycl::range<1> global_range(kNumThreads);
    sycl::range<1> local_range(kNumThreads);


    #define BARRIER_LAUNCH_CASE(ranks)                                              \
        case ranks: {                                                               \
            try {                                                                   \
                stream.submit([&](sycl::handler& cgh) {                                \
                                                                                                        cgh.parallel_for(                                              \
                        sycl::nd_range<1>(global_range, local_range),             \
                        [=](sycl::nd_item<1> item) {                              \
                            BarrierKernel<ranks> kernel(                          \
                                barrier_signal_ptrs,                               \
                                rank);                                             \
                            kernel(item);                                          \
                        });                                                        \
                });                                                                \
            } catch (sycl::exception const& e) {                                   \
                throw;                                                             \
            }                                                                      \
            break;                                                                 \
        }

    switch (num_ranks) {
        BARRIER_LAUNCH_CASE(1);
        BARRIER_LAUNCH_CASE(2);
        BARRIER_LAUNCH_CASE(4);
        BARRIER_LAUNCH_CASE(8);
        default:
            EP_HOST_ASSERT(false && "Unsupported number of ranks");
    }

    #undef BARRIER_LAUNCH_CASE
    
    stream.wait();
}

// ============================================================================
// IPC Test Write Kernel - 仅写入测试值
// ============================================================================

template <int kNumRanks>
class IPCTestWriteKernel {
public:
    IPCTestWriteKernel(int** barrier_signal_ptrs, int rank)
        : barrier_signal_ptrs_(barrier_signal_ptrs),
          rank_(rank) {}

    void operator()(sycl::nd_item<1> item) const {
        // 使用新的简洁 barrier_block_write
        barrier_block_write<kNumRanks>(barrier_signal_ptrs_, rank_, item);
    }

private:
    int** barrier_signal_ptrs_;
    int rank_;
};

void ipc_test_write(int** barrier_signal_ptrs, int rank, int num_ranks, sycl::queue& stream) {
    constexpr int kNumThreads = 128;
    
    sycl::range<1> global_range(kNumThreads);
    sycl::range<1> local_range(kNumThreads);

    #define IPC_WRITE_LAUNCH_CASE(ranks)                                            \
        case ranks: {                                                               \
            try {                                                                   \
                stream.submit([&](sycl::handler& cgh) {                                \
                                                                                                        cgh.parallel_for(                                              \
                        sycl::nd_range<1>(global_range, local_range),             \
                        [=](sycl::nd_item<1> item) {                              \
                            IPCTestWriteKernel<ranks> kernel(                      \
                                barrier_signal_ptrs,                               \
                                rank);                                             \
                            kernel(item);                                          \
                        });                                                        \
                });                                                                \
                stream.wait();                                                     \
            } catch (sycl::exception const& e) {                                   \
                throw;                                                             \
            }                                                                      \
            break;                                                                 \
        }

    switch (num_ranks) {
        IPC_WRITE_LAUNCH_CASE(1);
        IPC_WRITE_LAUNCH_CASE(2);
        IPC_WRITE_LAUNCH_CASE(4);
        IPC_WRITE_LAUNCH_CASE(8);
        default:
            EP_HOST_ASSERT(false && "Unsupported number of ranks");
    }

    #undef IPC_WRITE_LAUNCH_CASE
    
}

// ============================================================================
// IPC Test Read Kernel - 仅读取测试值
// ============================================================================

template <int kNumRanks>
class IPCTestReadKernel {
public:
    IPCTestReadKernel(int** barrier_signal_ptrs, int rank)
        : barrier_signal_ptrs_(barrier_signal_ptrs),
          rank_(rank) {}

    void operator()(sycl::nd_item<1> item) const {
        // 使用新的简洁 barrier_block_read
        barrier_block_read<kNumRanks>(barrier_signal_ptrs_, rank_, item);
    }

private:
    int** barrier_signal_ptrs_;
    int rank_;
};

void ipc_test_read(int** barrier_signal_ptrs, int rank, int num_ranks, sycl::queue& stream) {
    constexpr int kNumThreads = 128;
    
    sycl::range<1> global_range(kNumThreads);
    sycl::range<1> local_range(kNumThreads);

    #define IPC_READ_LAUNCH_CASE(ranks)                                             \
        case ranks: {                                                               \
            try {                                                                   \
                stream.submit([&](sycl::handler& cgh) {                                \
                                                                                                        cgh.parallel_for(                                              \
                        sycl::nd_range<1>(global_range, local_range),             \
                        [=](sycl::nd_item<1> item) {                              \
                            IPCTestReadKernel<ranks> kernel(                       \
                                barrier_signal_ptrs,                               \
                                rank);                                             \
                            kernel(item);                                          \
                        });                                                        \
                });                                                                \
                stream.wait();                                                     \
            } catch (sycl::exception const& e) {                                   \
                throw;                                                             \
            }                                                                      \
            break;                                                                 \
        }

    switch (num_ranks) {
        IPC_READ_LAUNCH_CASE(1);
        IPC_READ_LAUNCH_CASE(2);
        IPC_READ_LAUNCH_CASE(4);
        IPC_READ_LAUNCH_CASE(8);
        default:
            EP_HOST_ASSERT(false && "Unsupported number of ranks");
    }

    #undef IPC_READ_LAUNCH_CASE
}

// ============================================================================
// Barrier Stress Test Kernel — correctness mode
// write → barrier → read+verify → barrier, repeated inner_repeat times
// ============================================================================

template <int kNumRanks>
class BarrierStressTestKernel {
public:
    BarrierStressTestKernel(
        void** buffer_ptrs,
        int** barrier_signal_ptrs,
        int* error_count,
        int rank,
        int inner_repeat,
        int iter_offset,
        int data_size,
        int data_offset_ints)
        : buffer_ptrs_(buffer_ptrs),
          barrier_signal_ptrs_(barrier_signal_ptrs),
          error_count_(error_count),
          rank_(rank),
          inner_repeat_(inner_repeat),
          iter_offset_(iter_offset),
          data_size_(data_size),
          data_offset_ints_(data_offset_ints) {}

    void operator()(sycl::nd_item<1> item) const {
        auto thread_id = static_cast<int>(item.get_local_id(0));
        auto num_threads = static_cast<int>(item.get_local_range(0));

        for (int i = 0; i < inner_repeat_; ++i) {
            int iter = iter_offset_ + i;

            // Step 1: WRITE — each rank writes to its own IPC data buffer
            int* my_data = reinterpret_cast<int*>(
                static_cast<uint8_t*>(buffer_ptrs_[rank_])) + data_offset_ints_;
            for (int j = thread_id; j < data_size_; j += num_threads) {
                int encoded = iter * 10000 + rank_ * 100 + (j % 100);
                st_volatile_global(my_data + j, encoded);
            }

            // Step 2: Fence data writes, then BARRIER
            memory_fence_system();
            item.barrier(sycl::access::fence_space::local_space);
            barrier_block_bypass<kNumRanks, true>(barrier_signal_ptrs_, rank_, item);

            // Step 3: READ + VERIFY — read all peers' data
            int local_errors = 0;
            for (int p = 0; p < kNumRanks; ++p) {
                if (p == rank_) continue;
                int* peer_data = reinterpret_cast<int*>(
                    static_cast<uint8_t*>(buffer_ptrs_[p])) + data_offset_ints_;
                for (int j = thread_id; j < data_size_; j += num_threads) {
                    int expected = iter * 10000 + p * 100 + (j % 100);
                    int actual = ld_volatile_global(peer_data + j);
                    if (actual != expected) {
                        local_errors++;
                    }
                }
            }
            if (local_errors > 0) {
                atomic_add_system(error_count_, local_errors);
            }

            // Step 4: BARRIER — ensure all reads done before next write
            barrier_block_bypass<kNumRanks, true>(barrier_signal_ptrs_, rank_, item);
        }
    }

private:
    void** buffer_ptrs_;
    int** barrier_signal_ptrs_;
    int* error_count_;
    int rank_;
    int inner_repeat_;
    int iter_offset_;
    int data_size_;
    int data_offset_ints_;
};

void barrier_stress_test(void** buffer_ptrs,
                         int** barrier_signal_ptrs,
                         int* error_count,
                         int rank, int num_ranks,
                         int inner_repeat, int iter_offset,
                         int data_size, int data_offset_ints,
                         sycl::queue& stream) {
    constexpr int kNumThreads = 128;

    sycl::range<1> global_range(kNumThreads);
    sycl::range<1> local_range(kNumThreads);

    #define STRESS_LAUNCH_CASE(ranks)                                               \
        case ranks: {                                                               \
            stream.submit([&](sycl::handler& cgh) {                                \
                cgh.parallel_for(                                                  \
                    sycl::nd_range<1>(global_range, local_range),                  \
                    [=](sycl::nd_item<1> item) {                                   \
                        BarrierStressTestKernel<ranks> kernel(                     \
                            buffer_ptrs, barrier_signal_ptrs,                      \
                            error_count, rank,                                     \
                            inner_repeat, iter_offset,                             \
                            data_size, data_offset_ints);                          \
                        kernel(item);                                              \
                    });                                                            \
            });                                                                    \
            break;                                                                 \
        }

    switch (num_ranks) {
        STRESS_LAUNCH_CASE(2);
        STRESS_LAUNCH_CASE(4);
        STRESS_LAUNCH_CASE(8);
        default:
            EP_HOST_ASSERT(false && "Unsupported number of ranks for stress test");
    }

    #undef STRESS_LAUNCH_CASE

    stream.wait();
}

// ============================================================================
// Barrier Stress Test — perf mode (pure barrier, no data)
// Directly calls the proven barrier() function in a loop.
// Each call does submit + stream.wait(), matching test_xpu_barrier.py behavior.
// ============================================================================

void barrier_perf_test(int** barrier_signal_ptrs,
                       int rank, int num_ranks,
                       int inner_repeat,
                       sycl::queue& stream) {
    for (int i = 0; i < inner_repeat; ++i) {
        barrier(barrier_signal_ptrs, rank, num_ranks, stream);
    }
}

}  // namespace intranode

}  // namespace deep_ep
