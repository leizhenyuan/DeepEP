#include <sycl/sycl.hpp>
#include <cstdint>
#include <limits>
#include <iostream>
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
        int rank,
        const sycl::stream* debug_stream)
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
          rank_(rank),
          debug_stream_(debug_stream) {}

    void operator()(sycl::nd_item<1> item) const {
        auto sm_id = static_cast<int>(item.get_group(0));
        auto thread_id = static_cast<int>(item.get_local_id(0));
        auto num_threads = static_cast<int>(item.get_local_range(0));
        auto lane_id = thread_id % 32;
        auto warp_id = thread_id / 32;
        auto num_warps = num_threads / 32;

        if (sm_id == 0 && thread_id == 0) {
            if (debug_stream_ != nullptr) {
                *debug_stream_ << "[Rank " << rank_ << "] NotifyDispatchKernel: ENTERED, sm_id=" << sm_id 
                              << ", num_threads=" << num_threads << sycl::endl;
            }
        }

        if (sm_id == 0) {

            barrier_block_cas<kNumRanks, true>(barrier_signal_ptrs_, rank_, item, debug_stream_);

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
            barrier_block<kNumRanks>(barrier_signal_ptrs_, rank_, item, debug_stream_);

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

            // 最终Barrier同步
            barrier_block<kNumRanks>(barrier_signal_ptrs_, rank_, item, debug_stream_);
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
    const sycl::stream* debug_stream_;
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
    
    DEBUG_LOG(rank, "notify_dispatch: START - num_ranks=" << num_ranks << ", num_tokens=" << num_tokens << ", num_experts=" << num_experts);

    constexpr int kNumThreads = 128;
    
    // 验证参数
    EP_HOST_ASSERT(num_experts % num_ranks == 0);
    EP_HOST_ASSERT(num_experts / num_ranks <= kNumThreads && num_ranks <= kNumThreads);
    

    // 计算grid和block大小
    int num_blocks = 1 + num_ranks;
    sycl::range<1> global_range(num_blocks * kNumThreads);
    sycl::range<1> local_range(kNumThreads);

    DEBUG_LOG(rank, "notify_dispatch: Launch parameters - "
    << "num_blocks=" << num_blocks 
    << ", kNumThreads=" << kNumThreads
    << ", global_range=" << (num_blocks * kNumThreads)
    << ", local_range=" << kNumThreads
    << ", num_channels=" << num_channels);

    // 根据num_ranks选择模板实例
    #define NOTIFY_DISPATCH_LAUNCH_CASE(ranks)                                          \
        case ranks: {                                                                   \
                stream.submit([&](sycl::handler& cgh) {                                \
                    sycl::stream debug_stream(1024, 10240, cgh);                        \
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
                                rank,                                                  \
                                &debug_stream);                                          \
                            kernel(item);                                              \
                        });                                                            \
                });                                                                    \
                DEBUG_LOG(rank, "notify_dispatch: Kernel submitted for ranks=" << ranks); \
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
    
    // 给 kernel 一点时间启动
    std::this_thread::sleep_for(std::chrono::milliseconds(100));
    
    
    try {
        DEBUG_LOG(rank, "notify_dispatch: Calling stream.wait()...");
        stream.wait();
    } catch (sycl::exception const& e) {
        DEBUG_LOG(rank, "notify_dispatch: SYCL exception caught: " << e.what());
        throw;
    } catch (std::exception const& e) {
        DEBUG_LOG(rank, "notify_dispatch: Standard exception caught: " << e.what());
        throw;
    }
    
    DEBUG_LOG(rank, "notify_dispatch: COMPLETED");
    
}


template <int kNumRanks>
class CachedNotifyDispatchKernel {
public:
    CachedNotifyDispatchKernel(
        const int* rank_prefix_matrix,
        int num_memset_int,
        void** buffer_ptrs,
        int** barrier_signal_ptrs,
        int rank,
        const sycl::stream* debug_stream)
        : rank_prefix_matrix_(rank_prefix_matrix),
          num_memset_int_(num_memset_int),
          buffer_ptrs_(buffer_ptrs),
          barrier_signal_ptrs_(barrier_signal_ptrs),
          rank_(rank),
          debug_stream_(debug_stream) {}

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
    const sycl::stream* debug_stream_;
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
            stream.submit([&](sycl::handler& cgh) {                                    \
                sycl::stream debug_stream(10240, 256, cgh);                            \
                cgh.parallel_for(                                                      \
                    sycl::nd_range<1>(global_range, local_range),                     \
                    [=](sycl::nd_item<1> item) {                                      \
                        CachedNotifyDispatchKernel<ranks> kernel(                     \
                            rank_prefix_matrix,                                        \
                            num_memset_int,                                            \
                            buffer_ptrs,                                               \
                            barrier_signal_ptrs,                                       \
                            rank,                                                      \
                            &debug_stream);                                            \
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
        int* shared_channel_tail_idx_ptr)
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
          shared_channel_tail_idx_(shared_channel_tail_idx_ptr) {}

    void operator()(sycl::nd_item<1> item) const {
        const auto num_sms = static_cast<int>(item.get_group_range(0));
        const auto sm_id = static_cast<int>(item.get_group(0));
        const auto thread_id = static_cast<int>(item.get_local_id(0));
        const auto lane_id = get_lane_id(item);
        
        // 偶数sm负责发送，奇数sm负责接收，每两个sm负责一个channel
        const bool is_sender = sm_id % 2 == 0;

        // Several warps are responsible for a single rank
        const auto num_threads_per_rank = kNumThreads / kNumRanks;
        const auto num_channels = num_sms / 2;
        const auto responsible_rank = thread_id / num_threads_per_rank;
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
        // Senders are responsible for tails, and receivers are responsible for heads
        // `start_offset`: kNumChannels * kNumRanks * sizeof(int)
        // `end_offset`: kNumChannels * kNumRanks * sizeof(int)
        // `head_idx`: kNumChannels * kNumRanks * sizeof(int)
        // `tail_idx`: kNumChannels * kNumRanks * sizeof(int)
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
            dispatch_sender(item, num_threads_per_rank, num_channels, responsible_rank, responsible_channel,
                           num_experts_per_rank, channel_start_offset, channel_end_offset, channel_head_idx,
                           channel_tail_idx, channel_x_buffers, channel_src_idx_buffers, channel_topk_idx_buffers,
                           channel_topk_weights_buffers, channel_x_scales_buffers);
        } else {
            dispatch_receiver(item, num_threads_per_rank, num_channels, responsible_rank, responsible_channel,
                             channel_start_offset, channel_end_offset, channel_head_idx, channel_tail_idx,
                             channel_x_buffers, channel_src_idx_buffers, channel_topk_idx_buffers,
                             channel_topk_weights_buffers, channel_x_scales_buffers);
        }

        // Clean unused `recv_topk_idx` as -1
        if (num_worst_tokens_ > 0 && recv_topk_idx_ != nullptr) {
            auto rank_prefix_matrix = static_cast<int*>(buffer_ptrs_[rank_]);
            const auto num_recv_tokens = rank_prefix_matrix[(kNumRanks - 1) * kNumRanks + rank_];
            const auto clean_start = num_recv_tokens * num_topk_ + sm_id * kNumThreads;
            const auto clean_end = num_worst_tokens_ * num_topk_;
            const auto clean_stride = num_sms * kNumThreads;
            for (int i = clean_start + thread_id; i < clean_end; i += clean_stride)
                recv_topk_idx_[i] = -1;
        }
    }

private:
    void dispatch_sender(
        sycl::nd_item<1> item,
        int num_threads_per_rank,
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
        
        const auto thread_id = static_cast<int>(item.get_local_id(0));
        const auto lane_id = get_lane_id(item);
        
        constexpr int num_send_warps = kNumThreads / 32;
        constexpr int num_send_warps_per_rank = num_send_warps / kNumRanks;
        const auto send_thread_id = thread_id;
        const auto send_warp_id_in_rank = send_thread_id % num_threads_per_rank / 32;

        // Send offset by `-value - 1`, e.g. 0 -> -1, 1 -> -2
        // NOTES: this is for distinguishing zero tokens
        if (send_warp_id_in_rank == 0 && elect_one_sync(item)) {
            int value = responsible_channel > 0 ? 
                channel_prefix_matrix_[responsible_rank * num_channels + responsible_channel - 1] : 0;
            st_relaxed_sys_global(channel_start_offset.buffer(), -value - 1);
            value = channel_prefix_matrix_[responsible_rank * num_channels + responsible_channel];
            st_relaxed_sys_global(channel_end_offset.buffer(), -value - 1);
        }
        // Warp sync
        sycl::group_barrier(item.get_sub_group());

        // Get tasks
        int token_start_idx, token_end_idx;
        get_channel_task_range(num_tokens_, num_channels, responsible_channel, token_start_idx, token_end_idx);

        // Iterate over all tokens and send by chunks
        int cached_channel_tail_idx = 0;
        for (int64_t token_idx = token_start_idx; token_idx < token_end_idx;) {
            // Check destination queue emptiness
            // Note: XPU doesn't have clock64(), so we use a simple loop counter for timeout
            if (elect_one_sync(item)) {
                int loop_count = 0;
                while (true) {
                    int num_used_slots = cached_channel_tail_idx - ld_volatile_global(channel_head_idx.buffer());
                    if (num_recv_buffer_tokens_ - num_used_slots >= num_max_send_tokens_)
                        break;

                    // Timeout check (simplified without clock)
                    loop_count++;
                    if (loop_count > 100000000) {
                        // Timeout - just break to avoid infinite loop
                        break;
                    }
                }
            }
            sycl::group_barrier(item.get_sub_group());

            int chunk_token_idx = 0;
            while (chunk_token_idx < num_max_send_tokens_ && token_idx < token_end_idx) {
                // Record send_head
                if (token_idx % num_send_warps_per_rank == send_warp_id_in_rank && elect_one_sync(item))
                    send_head_[token_idx * kNumRanks + responsible_rank] =
                        is_token_in_rank_[token_idx * kNumRanks + responsible_rank] ? cached_channel_tail_idx : -1;

                // Skip if not selected
                if (!is_token_in_rank_[token_idx * kNumRanks + responsible_rank]) {
                    token_idx++;
                    continue;
                }

                // Get an empty slot
                int dst_slot_idx = (cached_channel_tail_idx++) % num_recv_buffer_tokens_;
                if (cached_channel_tail_idx % num_send_warps_per_rank == send_warp_id_in_rank) {
                    // Copy data - warp-level copy
                    auto shifted_channel_x_buffers = channel_x_buffers.buffer() + dst_slot_idx * hidden_int4_;
                    auto shifted_x = x_ + token_idx * hidden_int4_;
                    UNROLLED_WARP_COPY(5, lane_id, hidden_int4_, shifted_channel_x_buffers, shifted_x, ld_nc_global, st_na_global);

                    // Copy source index
                    if (elect_one_sync(item))
                        channel_src_idx_buffers[dst_slot_idx] = static_cast<int>(token_idx);

                    // Copy `topk_idx` and `topk_weights`
                    if (topk_idx_ != nullptr && lane_id < num_topk_) {
                        int recv_expert_begin = responsible_rank * num_experts_per_rank;
                        int recv_expert_end = (responsible_rank + 1) * num_experts_per_rank;
                        auto idx_value = topk_idx_[token_idx * num_topk_ + lane_id];
                        idx_value = (idx_value >= recv_expert_begin && idx_value < recv_expert_end) ? 
                                   idx_value - recv_expert_begin : -1;
                        channel_topk_idx_buffers[dst_slot_idx * num_topk_ + lane_id] = idx_value;

                        auto weight_value = topk_weights_[token_idx * num_topk_ + lane_id];
                        weight_value = (idx_value >= 0) ? weight_value : 0.0f;
                        channel_topk_weights_buffers[dst_slot_idx * num_topk_ + lane_id] = weight_value;
                    }

                    // Copy `x_scales`
                    if (x_scales_ != nullptr) {
                        for (int i = lane_id; i < num_scales_; i += 32) {
                            auto offset = token_idx * scale_token_stride_ + i * scale_hidden_stride_;
                            channel_x_scales_buffers[dst_slot_idx * num_scales_ + i] = x_scales_[offset];
                        }
                    }
                }

                // Move token index
                chunk_token_idx++;
                token_idx++;
            }

            // Move tail index - barrier sync for responsible_rank
            item.barrier(sycl::access::fence_space::local_space);
            
            if (send_warp_id_in_rank == 0 && elect_one_sync(item))
                st_release_sys_global(channel_tail_idx.buffer(), cached_channel_tail_idx);
        }
    }

    void dispatch_receiver(
        sycl::nd_item<1> item,
        int num_threads_per_rank,
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
        
        const auto thread_id = static_cast<int>(item.get_local_id(0));
        const auto lane_id = get_lane_id(item);
        
        constexpr int num_recv_warps = kNumThreads / 32;
        constexpr int num_recv_warps_per_rank = num_recv_warps / kNumRanks;
        const auto recv_thread_id = thread_id;
        const auto recv_thread_id_in_rank = recv_thread_id % num_threads_per_rank;
        const auto recv_warp_id_in_rank = recv_thread_id_in_rank / 32;

        // Calculate offset first
        auto rank_prefix_matrix = static_cast<int*>(buffer_ptrs_[rank_]);
        int rank_offset = responsible_rank > 0 ? rank_prefix_matrix[(responsible_rank - 1) * kNumRanks + rank_] : 0;

        // Receive channel offset
        int total_offset = 0, num_tokens_to_recv = 0;
        if (elect_one_sync(item)) {
            int loop_count = 0;
            while ((total_offset = ld_volatile_global(channel_start_offset.buffer())) == 0) {
                loop_count++;
                if (loop_count > 100000000) break;
            }
            loop_count = 0;
            while ((num_tokens_to_recv = ld_volatile_global(channel_end_offset.buffer())) == 0) {
                loop_count++;
                if (loop_count > 100000000) break;
            }
            total_offset = -total_offset - 1;
            num_tokens_to_recv = -num_tokens_to_recv - 1;
            
            if (recv_warp_id_in_rank == 0)
                recv_channel_offset_[responsible_rank * num_channels + responsible_channel] = total_offset;
            num_tokens_to_recv -= total_offset;
        }
        total_offset = warp_broadcast(total_offset, 0, item);
        total_offset += rank_offset;
        num_tokens_to_recv = warp_broadcast(num_tokens_to_recv, 0, item);

        // Use shared memory for tail index synchronization
        // shared_channel_tail_idx_ points to workgroup local memory passed in

        int cached_channel_head_idx = 0, cached_channel_tail_idx = 0;
        
        while (num_tokens_to_recv > 0) {
            // Wait for new data - only first thread in rank polls
            if (recv_thread_id_in_rank == 0) {
                int loop_count = 0;
                while (true) {
                    cached_channel_tail_idx = ld_acquire_sys_global(channel_tail_idx.buffer());
                    if (cached_channel_head_idx != cached_channel_tail_idx) {
                        // Store to shared memory for other threads
                        shared_channel_tail_idx_[responsible_rank] = cached_channel_tail_idx;
                        break;
                    }
                    loop_count++;
                    if (loop_count > 100000000) break;
                }
            }

            // Synchronize queue tail across all threads in the rank
            item.barrier(sycl::access::fence_space::local_space);
            cached_channel_tail_idx = shared_channel_tail_idx_[responsible_rank];

            // Copy data
            int num_recv_tokens = cached_channel_tail_idx - cached_channel_head_idx;
            for (int chunk_idx = recv_warp_id_in_rank; chunk_idx < num_recv_tokens; chunk_idx += num_recv_warps_per_rank) {
                int token_idx_in_buffer = (cached_channel_head_idx + chunk_idx) % num_recv_buffer_tokens_;
                auto shifted_buffer_x_int4 = channel_x_buffers.buffer() + token_idx_in_buffer * hidden_int4_;
                auto shifted_recv_x_int4 = recv_x_ + static_cast<int64_t>(total_offset + chunk_idx) * hidden_int4_;
                
                // Warp-level copy (no TMA on XPU)
                UNROLLED_WARP_COPY(5, lane_id, hidden_int4_, shifted_recv_x_int4, shifted_buffer_x_int4, ld_nc_global, st_na_global);
            }

            // Copy `src_idx`
            #pragma unroll 4
            for (int chunk_idx = cached_channel_head_idx + recv_thread_id_in_rank; 
                 chunk_idx < cached_channel_tail_idx;
                 chunk_idx += 32 * num_recv_warps_per_rank) {
                recv_src_idx_[total_offset + chunk_idx - cached_channel_head_idx] =
                    ld_nc_global(channel_src_idx_buffers.buffer() + chunk_idx % num_recv_buffer_tokens_);
            }

            // Copy `topk_idx` and `topk_weights`
            if (recv_topk_idx_ != nullptr) {
                #pragma unroll 4
                for (int idx = recv_thread_id_in_rank; idx < num_recv_tokens * num_topk_; idx += 32 * num_recv_warps_per_rank) {
                    int chunk_idx = idx / num_topk_, token_topk_idx = idx % num_topk_;
                    int token_idx_in_buffer = (cached_channel_head_idx + chunk_idx) % num_recv_buffer_tokens_;
                    auto recv_idx = static_cast<int64_t>(total_offset + chunk_idx) * num_topk_ + token_topk_idx;
                    auto buffer_idx = token_idx_in_buffer * num_topk_ + token_topk_idx;
                    recv_topk_idx_[recv_idx] = ld_nc_global(channel_topk_idx_buffers.buffer() + buffer_idx);
                    recv_topk_weights_[recv_idx] = ld_nc_global(channel_topk_weights_buffers.buffer() + buffer_idx);
                }
            }

            // Copy `x_scales`
            if (recv_x_scales_ != nullptr) {
                #pragma unroll 4
                for (int i = recv_thread_id_in_rank; i < num_recv_tokens * num_scales_; i += 32 * num_recv_warps_per_rank) {
                    int chunk_idx = i / num_scales_, scales_idx = i % num_scales_;
                    int token_idx_in_buffer = (cached_channel_head_idx + chunk_idx) % num_recv_buffer_tokens_;
                    recv_x_scales_[static_cast<int64_t>(total_offset + chunk_idx) * num_scales_ + scales_idx] =
                        ld_nc_global(channel_x_scales_buffers.buffer() + token_idx_in_buffer * num_scales_ + scales_idx);
                }
            }

            // Move queue
            cached_channel_head_idx += num_recv_tokens;
            total_offset += num_recv_tokens;
            item.barrier(sycl::access::fence_space::local_space);
            
            if (recv_warp_id_in_rank == num_recv_warps_per_rank - 1 && elect_one_sync(item))
                st_relaxed_sys_global(channel_head_idx.buffer(), cached_channel_head_idx);

            // Exit
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
    
    // DEBUG_LOG(rank, "dispatch: START - num_ranks=" << num_ranks << ", num_tokens=" << num_tokens << ", num_sms=" << num_sms);
    
    constexpr int kNumThreads = 768;

    // Make sure never OOB
    EP_HOST_ASSERT(static_cast<int64_t>(num_scales) * scale_hidden_stride < std::numeric_limits<int>::max());
    EP_HOST_ASSERT(num_sms % 2 == 0);
    
    // DEBUG_LOG(rank, "dispatch: Assertions passed, launching kernel...");

    sycl::range<1> global_range(num_sms * kNumThreads);
    sycl::range<1> local_range(kNumThreads);

#define DISPATCH_LAUNCH_CASE(ranks)                                                                     \
    case ranks:                                                                                         \
        stream.submit([&](sycl::handler& cgh) {                                                        \
            /* Local memory for shared_channel_tail_idx */                                             \
            sycl::local_accessor<int, 1> shared_tail_idx(sycl::range<1>(ranks), cgh);                  \
            cgh.parallel_for(                                                                          \
                sycl::nd_range<1>(global_range, local_range),                                          \
                [=](sycl::nd_item<1> item) {                                                           \
                    DispatchKernel<ranks, kNumThreads> kernel(                                         \
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
                        shared_tail_idx.get_pointer());                                                \
                    kernel(item);                                                                      \
                });                                                                                    \
        });                                                                                            \
        break

    switch (num_ranks) {
        DISPATCH_LAUNCH_CASE(1);
        DISPATCH_LAUNCH_CASE(2);
        DISPATCH_LAUNCH_CASE(4);
        DISPATCH_LAUNCH_CASE(8);
        default:
            EP_HOST_ASSERT(false && "Unsupported number of ranks");
    }

#undef DISPATCH_LAUNCH_CASE
    
    // DEBUG_LOG(rank, "dispatch: Kernel launched, waiting for completion...");
    stream.wait();
    // DEBUG_LOG(rank, "dispatch: COMPLETED");
}


void cached_notify_combine(void** buffer_ptrs,
                           int* send_head,
                           int num_channels,
                           int num_recv_tokens,
                           int num_memset_int,
                           int** barrier_signal_ptrs,
                           int rank,
                           int num_ranks,
                           sycl::queue& stream) {
    // TODO: Implement cached_notify_combine for SYCL
    EP_HOST_ASSERT(false && "cached_notify_combine not yet implemented for SYCL");
}

// ============================================================================
// combine kernel - SYCL版本 (Stub)
// ============================================================================

void combine(std::nullptr_t type,
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
    // TODO: Implement combine for SYCL
    EP_HOST_ASSERT(false && "combine not yet implemented for SYCL");
}

// ============================================================================
// barrier kernel - SYCL版本 (使用 barrier_block_cas)
// ============================================================================

template <int kNumRanks>
class BarrierKernel {
public:
    BarrierKernel(int** barrier_signal_ptrs, int rank, const sycl::stream* debug_stream)
        : barrier_signal_ptrs_(barrier_signal_ptrs),
          rank_(rank),
          debug_stream_(debug_stream) {}

    void operator()(sycl::nd_item<1> item) const {
        // 使用 CAS-based barrier
        barrier_block_cas<kNumRanks, true>(barrier_signal_ptrs_, rank_, item, debug_stream_);
    }

private:
    int** barrier_signal_ptrs_;
    int rank_;
    const sycl::stream* debug_stream_;
};

void barrier(int** barrier_signal_ptrs, int rank, int num_ranks, sycl::queue& stream) {
    constexpr int kNumThreads = 128;
    
    sycl::range<1> global_range(kNumThreads);
    sycl::range<1> local_range(kNumThreads);

    DEBUG_LOG(rank, "barrier: START - num_ranks=" << num_ranks);

    #define BARRIER_LAUNCH_CASE(ranks)                                              \
        case ranks: {                                                               \
            try {                                                                   \
                stream.submit([&](sycl::handler& cgh) {                            \
                    sycl::stream debug_stream(65536, 1024, cgh);                   \
                    cgh.parallel_for(                                              \
                        sycl::nd_range<1>(global_range, local_range),             \
                        [=](sycl::nd_item<1> item) {                              \
                            BarrierKernel<ranks> kernel(                          \
                                barrier_signal_ptrs,                               \
                                rank,                                              \
                                &debug_stream);                                    \
                            kernel(item);                                          \
                        });                                                        \
                });                                                                \
                DEBUG_LOG(rank, "barrier: Kernel submitted for ranks=" << ranks); \
            } catch (sycl::exception const& e) {                                   \
                DEBUG_LOG(rank, "barrier: SYCL exception: " << e.what());         \
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
    DEBUG_LOG(rank, "barrier: COMPLETED");
}

// ============================================================================
// IPC Test Write Kernel - 仅写入测试值
// ============================================================================

template <int kNumRanks>
class IPCTestWriteKernel {
public:
    IPCTestWriteKernel(int** barrier_signal_ptrs, int rank, const sycl::stream* debug_stream)
        : barrier_signal_ptrs_(barrier_signal_ptrs),
          rank_(rank),
          debug_stream_(debug_stream) {}

    void operator()(sycl::nd_item<1> item) const {
        // 使用新的简洁 barrier_block_write
        barrier_block_write<kNumRanks>(barrier_signal_ptrs_, rank_, item, debug_stream_);
    }

private:
    int** barrier_signal_ptrs_;
    int rank_;
    const sycl::stream* debug_stream_;
};

void ipc_test_write(int** barrier_signal_ptrs, int rank, int num_ranks, sycl::queue& stream) {
    constexpr int kNumThreads = 128;
    
    sycl::range<1> global_range(kNumThreads);
    sycl::range<1> local_range(kNumThreads);

    DEBUG_LOG(rank, "ipc_test_write: START - num_ranks=" << num_ranks);

    #define IPC_WRITE_LAUNCH_CASE(ranks)                                            \
        case ranks: {                                                               \
            try {                                                                   \
                stream.submit([&](sycl::handler& cgh) {                            \
                    sycl::stream debug_stream(65536, 1024, cgh);                   \
                    cgh.parallel_for(                                              \
                        sycl::nd_range<1>(global_range, local_range),             \
                        [=](sycl::nd_item<1> item) {                              \
                            IPCTestWriteKernel<ranks> kernel(                      \
                                barrier_signal_ptrs,                               \
                                rank,                                              \
                                &debug_stream);                                    \
                            kernel(item);                                          \
                        });                                                        \
                });                                                                \
                stream.wait();                                                     \
                DEBUG_LOG(rank, "ipc_test_write: Kernel completed for ranks=" << ranks); \
            } catch (sycl::exception const& e) {                                   \
                DEBUG_LOG(rank, "ipc_test_write: SYCL exception: " << e.what());  \
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
    
    DEBUG_LOG(rank, "ipc_test_write: COMPLETED");
}

// ============================================================================
// IPC Test Read Kernel - 仅读取测试值
// ============================================================================

template <int kNumRanks>
class IPCTestReadKernel {
public:
    IPCTestReadKernel(int** barrier_signal_ptrs, int rank, const sycl::stream* debug_stream)
        : barrier_signal_ptrs_(barrier_signal_ptrs),
          rank_(rank),
          debug_stream_(debug_stream) {}

    void operator()(sycl::nd_item<1> item) const {
        // 使用新的简洁 barrier_block_read
        barrier_block_read<kNumRanks>(barrier_signal_ptrs_, rank_, item, debug_stream_);
    }

private:
    int** barrier_signal_ptrs_;
    int rank_;
    const sycl::stream* debug_stream_;
};

void ipc_test_read(int** barrier_signal_ptrs, int rank, int num_ranks, sycl::queue& stream) {
    constexpr int kNumThreads = 128;
    
    sycl::range<1> global_range(kNumThreads);
    sycl::range<1> local_range(kNumThreads);

    DEBUG_LOG(rank, "ipc_test_read: START - num_ranks=" << num_ranks);

    #define IPC_READ_LAUNCH_CASE(ranks)                                             \
        case ranks: {                                                               \
            try {                                                                   \
                stream.submit([&](sycl::handler& cgh) {                            \
                    sycl::stream debug_stream(65536, 1024, cgh);                   \
                    cgh.parallel_for(                                              \
                        sycl::nd_range<1>(global_range, local_range),             \
                        [=](sycl::nd_item<1> item) {                              \
                            IPCTestReadKernel<ranks> kernel(                       \
                                barrier_signal_ptrs,                               \
                                rank,                                              \
                                &debug_stream);                                    \
                            kernel(item);                                          \
                        });                                                        \
                });                                                                \
                stream.wait();                                                     \
                DEBUG_LOG(rank, "ipc_test_read: Kernel completed for ranks=" << ranks); \
            } catch (sycl::exception const& e) {                                   \
                DEBUG_LOG(rank, "ipc_test_read: SYCL exception: " << e.what());   \
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
    
    DEBUG_LOG(rank, "ipc_test_read: COMPLETED");
}

}  // namespace intranode

}  // namespace deep_ep
