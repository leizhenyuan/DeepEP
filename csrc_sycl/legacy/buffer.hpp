// PORTED_FROM: csrc/legacy/buffer.hpp
// SYCL V1 (legacy) Buffer class — the C++ glue layer between Python frontend
// and SYCL internode dispatch/combine kernels.
//
// This class manages:
//   - IPC buffer allocation and exchange (Level Zero IPC)
//   - RDMA symmetric heap (ishmem)
//   - Host-pinned MoE counters (USM shared memory)
//   - Kernel launch orchestration (notify_dispatch + dispatch)
//   - Stream (sycl::queue) management
//
// HIGH_RISK: Several components require hardware validation:
//   1. Level Zero IPC over PCIe (no NVLink coherence)
//   2. ishmem initialization with MPI bootstrap
//   3. USM shared memory for host-device counter polling
#pragma once

#include <sycl/sycl.hpp>
#include <torch/python.h>
#include <pybind11/pybind11.h>
#include <pybind11/stl.h>

#include <chrono>
#include <cstring>
#include <memory>
#include <optional>
#include <vector>
#include <algorithm>

#include "../configs.hpp"
#include "../exception.hpp"
#include "../event.hpp"
#include "../ipc.hpp"
#include "../runtime.hpp"
#include "../internode_dispatch.hpp"
#include "config.hpp"

namespace deep_ep::legacy {

namespace py = pybind11;

struct Buffer {
    EP_STATIC_ASSERT(NUM_MAX_NVL_PEERS <= 8 && NUM_MAX_NVL_PEERS >= 1, "NUM_MAX_NVL_PEERS must be 1..8");

private:
    // NVL (intranode IPC) buffers
    int64_t num_nvl_bytes;
    void* buffer_ptrs[NUM_MAX_NVL_PEERS] = {nullptr};
    void** buffer_ptrs_gpu = nullptr;

    // RDMA (ishmem symmetric) buffer
    int64_t num_rdma_bytes;
    void* rdma_buffer_ptr = nullptr;

    // Device info and communication
    int rank, rdma_rank, nvl_rank;
    int num_ranks, num_rdma_ranks, num_nvl_ranks;
    int num_device_eus;  // execution units (Intel GPU equivalent of SMs)

    // SYCL queue for communication (equivalent of comm_stream)
    sycl::queue comm_queue;

    // IPC handles
    shared_memory::MemHandle ipc_handles[NUM_MAX_NVL_PEERS];
    shared_memory::SharedMemoryAllocator shared_memory_allocator;

    // Track total NVL allocation size for IPC handle creation
    int64_t nvl_alloc_size = 0;

    // Barrier signals (intranode)
    int* barrier_signal_ptrs[NUM_MAX_NVL_PEERS] = {nullptr};
    int** barrier_signal_ptrs_gpu = nullptr;

    // Host-visible MoE counters (USM shared memory)
    // These are polled by the CPU while the GPU writes to them.
    // HIGH_RISK: On Intel, sycl::malloc_shared provides USM that is
    // coherent between host and device. This replaces cudaMallocHost +
    // cudaHostGetDevicePointer (mapped host memory).
    volatile int* moe_recv_counter = nullptr;
    int* moe_recv_counter_mapped = nullptr;  // device-accessible alias

    volatile int* moe_recv_expert_counter = nullptr;
    int* moe_recv_expert_counter_mapped = nullptr;

    volatile int* moe_recv_rdma_counter = nullptr;
    int* moe_recv_rdma_counter_mapped = nullptr;

    // Workspace
    void* workspace = nullptr;

    // Availability
    bool available = false;
    bool explicitly_destroy;
    bool destroyed = false;

    // Low-latency mode
    bool low_latency_mode = false;

public:
    Buffer(int rank,
           int num_ranks,
           int64_t num_nvl_bytes,
           int64_t num_rdma_bytes,
           bool low_latency_mode,
           bool explicitly_destroy)
        : rank(rank),
          num_ranks(num_ranks),
          num_nvl_bytes(num_nvl_bytes),
          num_rdma_bytes(num_rdma_bytes),
          low_latency_mode(low_latency_mode),
          explicitly_destroy(explicitly_destroy),
          comm_queue(sycl::queue{sycl::gpu_selector_v,
                                sycl::property_list{sycl::property::queue::in_order{}}}) {

        // Metadata memory
        int64_t barrier_signal_bytes = NUM_MAX_NVL_PEERS * sizeof(int);
        int64_t buffer_ptr_bytes = NUM_MAX_NVL_PEERS * sizeof(void*);
        int64_t barrier_signal_ptr_bytes = NUM_MAX_NVL_PEERS * sizeof(int*);

        // Common checks
        EP_STATIC_ASSERT(NUM_BUFFER_ALIGNMENT_BYTES % sizeof(int4) == 0, "Invalid alignment");
        EP_HOST_ASSERT(num_nvl_bytes % NUM_BUFFER_ALIGNMENT_BYTES == 0 and
                       (num_nvl_bytes <= std::numeric_limits<int>::max() or num_rdma_bytes == 0));
        EP_HOST_ASSERT(num_rdma_bytes % NUM_BUFFER_ALIGNMENT_BYTES == 0 and
                       (low_latency_mode or num_rdma_bytes <= std::numeric_limits<int>::max()));
        EP_HOST_ASSERT(num_nvl_bytes / static_cast<int64_t>(sizeof(int4)) < std::numeric_limits<int>::max());
        EP_HOST_ASSERT(num_rdma_bytes / static_cast<int64_t>(sizeof(int4)) < std::numeric_limits<int>::max());
        EP_HOST_ASSERT(0 <= rank and rank < num_ranks and
                       (num_ranks <= NUM_MAX_NVL_PEERS * NUM_MAX_RDMA_PEERS or low_latency_mode));
        EP_HOST_ASSERT(num_ranks < NUM_MAX_NVL_PEERS or num_ranks % NUM_MAX_NVL_PEERS == 0);
        if (num_rdma_bytes > 0)
            EP_HOST_ASSERT(num_ranks > NUM_MAX_NVL_PEERS or low_latency_mode);

        // Get ranks
        rdma_rank = rank / NUM_MAX_NVL_PEERS;
        nvl_rank = rank % NUM_MAX_NVL_PEERS;
        num_rdma_ranks = std::max(1, num_ranks / NUM_MAX_NVL_PEERS);
        num_nvl_ranks = std::min(num_ranks, NUM_MAX_NVL_PEERS);

        // Get device info
        auto device = comm_queue.get_device();
        // Intel GPUs report max_compute_units as the number of EUs.
        // We use this as an approximate SM count for kernel launch config.
        num_device_eus = static_cast<int>(device.get_info<sycl::info::device::max_compute_units>());

        if (num_nvl_bytes > 0) {
            // Allocate local IPC buffer via Level Zero
            nvl_alloc_size = num_nvl_bytes + barrier_signal_bytes + buffer_ptr_bytes + barrier_signal_ptr_bytes;
            shared_memory_allocator.malloc(&buffer_ptrs[nvl_rank], nvl_alloc_size, comm_queue);
            shared_memory_allocator.get_mem_handle(&ipc_handles[nvl_rank], buffer_ptrs[nvl_rank], nvl_alloc_size, comm_queue);
            buffer_ptrs_gpu = reinterpret_cast<void**>(
                static_cast<uint8_t*>(buffer_ptrs[nvl_rank]) + num_nvl_bytes + barrier_signal_bytes);

            // Set barrier signals
            barrier_signal_ptrs[nvl_rank] = reinterpret_cast<int*>(
                static_cast<uint8_t*>(buffer_ptrs[nvl_rank]) + num_nvl_bytes);
            barrier_signal_ptrs_gpu = reinterpret_cast<int**>(
                static_cast<uint8_t*>(buffer_ptrs[nvl_rank]) + num_nvl_bytes + barrier_signal_bytes + buffer_ptr_bytes);

            comm_queue.memset(barrier_signal_ptrs[nvl_rank], 0, barrier_signal_bytes);
        }

        // Workspace (32 MiB)
        workspace = sycl::malloc_device(NUM_WORKSPACE_BYTES, comm_queue);
        comm_queue.memset(workspace, 0, NUM_WORKSPACE_BYTES);

        // MoE counters — use USM shared memory so both host and device can access
        // HIGH_RISK: USM shared memory coherence on Intel GPUs.
        // sycl::malloc_shared should provide automatic coherence between host
        // and device, replacing CUDA's cudaMallocHost + cudaHostGetDevicePointer.
        // The device writes a counter, CPU polls it — this pattern requires
        // visibility guarantees that USM shared should provide.
        moe_recv_counter = static_cast<volatile int*>(
            sycl::malloc_shared(sizeof(int64_t), comm_queue));
        moe_recv_counter_mapped = const_cast<int*>(moe_recv_counter);
        *moe_recv_counter = -1;

        moe_recv_expert_counter = static_cast<volatile int*>(
            sycl::malloc_shared(sizeof(int) * NUM_MAX_LOCAL_EXPERTS, comm_queue));
        moe_recv_expert_counter_mapped = const_cast<int*>(moe_recv_expert_counter);
        for (int i = 0; i < NUM_MAX_LOCAL_EXPERTS; ++i)
            moe_recv_expert_counter[i] = -1;

        if (num_rdma_ranks > 0) {
            moe_recv_rdma_counter = static_cast<volatile int*>(
                sycl::malloc_shared(sizeof(int), comm_queue));
            moe_recv_rdma_counter_mapped = const_cast<int*>(moe_recv_rdma_counter);
            *moe_recv_rdma_counter = -1;
        }

        // Wait for all initialization to complete
        comm_queue.wait();
    }

    ~Buffer() noexcept(false) {
        if (not explicitly_destroy) {
            destroy();
        } else if (not destroyed) {
            printf("WARNING: destroy() was not called before DeepEP buffer destruction, which can leak resources.\n");
            fflush(stdout);
        }
    }

    bool is_available() const { return available; }

    bool is_internode_available() const {
        return is_available() and num_ranks > NUM_MAX_NVL_PEERS;
    }

    int get_num_rdma_ranks() const { return num_rdma_ranks; }
    int get_rdma_rank() const { return rdma_rank; }
    int get_root_rdma_rank(bool global) const { return global ? nvl_rank : 0; }
    int get_local_device_id() const {
        // Return an integer device ID. On Intel, use ordinal from queue's device.
        // For IPC handle exchange, what matters is the peer device index.
        auto dev = comm_queue.get_device();
        auto platform = dev.get_platform();
        auto devices = platform.get_devices(sycl::info::device_type::gpu);
        for (size_t i = 0; i < devices.size(); ++i)
            if (devices[i] == dev) return static_cast<int>(i);
        return 0;
    }

    py::bytearray get_local_ipc_handle() const {
        EP_HOST_ASSERT(num_nvl_bytes > 0);
        return py::bytearray(reinterpret_cast<const char*>(&ipc_handles[nvl_rank]),
                             sizeof(shared_memory::MemHandle));
    }

    sycl::queue& get_comm_queue() { return comm_queue; }

    // ================================================================
    // sync — Exchange IPC handles and initialize ishmem
    // ================================================================
    // PORTED_FROM: csrc/legacy/buffer.hpp:227-290
    //
    // Key differences from CUDA:
    //   - IPC: Level Zero zeMemOpenIpcHandle instead of cudaIpcOpenMemHandle
    //   - RDMA: ishmem_init() + ishmem_malloc() instead of nvshmem init + alloc
    //   - No unique_id exchange — ishmem uses MPI bootstrap
    void sync(const std::vector<int>& device_ids,
              const std::vector<std::optional<py::bytearray>>& all_gathered_handles) {
        EP_HOST_ASSERT(not is_available());

        // Sync IPC handles
        if (num_nvl_bytes > 0) {
            EP_HOST_ASSERT(static_cast<int>(device_ids.size()) == num_ranks);
            EP_HOST_ASSERT(static_cast<int>(all_gathered_handles.size()) == num_ranks);
            for (int i = 0, offset = rdma_rank * num_nvl_ranks; i < num_nvl_ranks; ++i) {
                EP_HOST_ASSERT(all_gathered_handles[offset + i].has_value());
                auto handle_str = std::string(all_gathered_handles[offset + i].value());
                EP_HOST_ASSERT(handle_str.size() == sizeof(shared_memory::MemHandle));
                if (offset + i != rank) {
                    std::memcpy(&ipc_handles[i], handle_str.c_str(), sizeof(shared_memory::MemHandle));
                    shared_memory_allocator.open_mem_handle(&buffer_ptrs[i], &ipc_handles[i], comm_queue);
                    barrier_signal_ptrs[i] = reinterpret_cast<int*>(
                        static_cast<uint8_t*>(buffer_ptrs[i]) + num_nvl_bytes);
                } else {
                    EP_HOST_ASSERT(std::memcmp(&ipc_handles[i], handle_str.c_str(),
                                              sizeof(shared_memory::MemHandle)) == 0);
                }
            }

            // Copy buffer and barrier signal pointers to device
            comm_queue.memcpy(buffer_ptrs_gpu, buffer_ptrs,
                              sizeof(void*) * NUM_MAX_NVL_PEERS);
            comm_queue.memcpy(barrier_signal_ptrs_gpu, barrier_signal_ptrs,
                              sizeof(int*) * NUM_MAX_NVL_PEERS);
            comm_queue.wait();
        }

        // Initialize ishmem and allocate RDMA buffer
        if (num_rdma_bytes > 0) {
            // ishmem uses MPI bootstrap — must be called after MPI_Init
            ishmem_runtime::init();

            // Allocate symmetric heap
            rdma_buffer_ptr = ishmem_runtime::alloc(num_rdma_bytes, NUM_BUFFER_ALIGNMENT_BYTES);

            // Clean buffer
            comm_queue.memset(rdma_buffer_ptr, 0, num_rdma_bytes).wait();

            // Barrier across all PEs
            ishmem_runtime::barrier(true);
        }

        available = true;
    }

    void destroy() {
        EP_HOST_ASSERT(not destroyed);

        comm_queue.wait();

        if (num_nvl_bytes > 0) {
            if (is_available()) {
                for (int i = 0; i < num_nvl_ranks; ++i)
                    if (i != nvl_rank)
                        shared_memory_allocator.close_mem_handle(buffer_ptrs[i], comm_queue);
            }
            shared_memory_allocator.free(buffer_ptrs[nvl_rank], comm_queue);
        }

        if (workspace)
            sycl::free(workspace, comm_queue);
        if (moe_recv_counter)
            sycl::free(const_cast<int*>(moe_recv_counter), comm_queue);
        if (moe_recv_expert_counter)
            sycl::free(const_cast<int*>(moe_recv_expert_counter), comm_queue);
        if (moe_recv_rdma_counter)
            sycl::free(const_cast<int*>(moe_recv_rdma_counter), comm_queue);

        if (num_rdma_bytes > 0 and rdma_buffer_ptr != nullptr) {
            ishmem_runtime::free(rdma_buffer_ptr);
            ishmem_runtime::finalize();
        }

        destroyed = true;
    }

    // ================================================================
    // get_dispatch_layout — compute token routing layout
    // ================================================================
    // PORTED_FROM: csrc/legacy/buffer.hpp:337-406
    //
    // This kernel is a simple parallel histogram and does not use
    // RDMA/ishmem. Porting it is straightforward.
    // TODO: Port layout.cu to SYCL and call it here.
    // For now, we implement a host-side fallback.
    std::tuple<torch::Tensor,
               std::optional<torch::Tensor>,
               torch::Tensor,
               torch::Tensor,
               std::optional<EventHandle>>
    get_dispatch_layout(const torch::Tensor& topk_idx,
                        int num_experts,
                        const std::optional<EventHandle>& previous_event,
                        bool async_flag,
                        bool allocate_on_comm_stream) {
        EP_HOST_ASSERT(topk_idx.dim() == 2);
        EP_HOST_ASSERT(topk_idx.is_contiguous());
        EP_HOST_ASSERT(num_experts > 0);

        // Wait previous tasks
        if (previous_event.has_value())
            queue_wait(comm_queue, previous_event.value());

        auto num_tokens = static_cast<int>(topk_idx.size(0));
        auto num_topk = static_cast<int>(topk_idx.size(1));

        // Allocate output tensors on XPU
        auto opts_int = torch::TensorOptions().dtype(torch::kInt32).device(torch::kXPU);
        auto opts_bool = torch::TensorOptions().dtype(torch::kBool).device(torch::kXPU);

        auto num_tokens_per_rank = torch::zeros({num_ranks}, opts_int);
        auto num_tokens_per_expert = torch::zeros({num_experts}, opts_int);
        auto is_token_in_rank = torch::zeros({num_tokens, num_ranks}, opts_bool);
        auto num_tokens_per_rdma_rank = std::optional<torch::Tensor>();
        if (is_internode_available())
            num_tokens_per_rdma_rank = torch::zeros({num_rdma_ranks}, opts_int);

        // TODO: Replace with SYCL kernel port of layout.cu
        // For now, run on host (slow but correct)
        {
            auto topk_idx_cpu = topk_idx.to(torch::kCPU).contiguous();
            auto ntp_rank_cpu = torch::zeros({num_ranks}, torch::kInt32);
            auto ntp_rdma_cpu = torch::zeros({num_rdma_ranks}, torch::kInt32);
            auto ntp_expert_cpu = torch::zeros({num_experts}, torch::kInt32);
            auto is_in_rank_cpu = torch::zeros({num_tokens, num_ranks}, torch::kBool);

            auto topk_ptr = topk_idx_cpu.data_ptr<topk_idx_t>();
            auto rank_ptr = ntp_rank_cpu.data_ptr<int>();
            auto rdma_ptr = ntp_rdma_cpu.data_ptr<int>();
            auto expert_ptr = ntp_expert_cpu.data_ptr<int>();
            auto is_in_ptr = is_in_rank_cpu.data_ptr<bool>();

            int num_expert_per_rank = num_experts / num_ranks;
            for (int t = 0; t < num_tokens; ++t) {
                bool counted_rank[NUM_MAX_NVL_PEERS * NUM_MAX_RDMA_PEERS] = {};
                bool counted_rdma[NUM_MAX_RDMA_PEERS] = {};
                for (int k = 0; k < num_topk; ++k) {
                    auto eidx = static_cast<int>(topk_ptr[t * num_topk + k]);
                    if (eidx < 0 || eidx >= num_experts) continue;
                    expert_ptr[eidx]++;
                    int r = eidx / num_expert_per_rank;
                    if (!counted_rank[r]) {
                        counted_rank[r] = true;
                        rank_ptr[r]++;
                        is_in_ptr[t * num_ranks + r] = true;
                    }
                    int rr = r / NUM_MAX_NVL_PEERS;
                    if (!counted_rdma[rr]) {
                        counted_rdma[rr] = true;
                        rdma_ptr[rr]++;
                    }
                }
            }

            // Copy results to device
            num_tokens_per_rank.copy_(ntp_rank_cpu);
            num_tokens_per_expert.copy_(ntp_expert_cpu);
            is_token_in_rank.copy_(is_in_rank_cpu);
            if (num_tokens_per_rdma_rank.has_value())
                num_tokens_per_rdma_rank->copy_(ntp_rdma_cpu);
        }

        std::optional<EventHandle> event;
        if (async_flag) {
            event = EventHandle(comm_queue);
        }

        return {num_tokens_per_rank, num_tokens_per_rdma_rank,
                num_tokens_per_expert, is_token_in_rank, event};
    }

    // ================================================================
    // internode_dispatch — the main dispatch entry point
    // ================================================================
    // PORTED_FROM: csrc/legacy/buffer.hpp:875-1210
    //
    // This calls:
    //   1. internode::launch_notify_dispatch() — sends token counts, computes prefix matrices
    //   2. CPU busy-wait on host-mapped counters
    //   3. internode::launch_dispatch() — actual data movement
    std::tuple<torch::Tensor,                    // recv_x
               std::optional<torch::Tensor>,     // recv_x_scales
               std::optional<torch::Tensor>,     // recv_topk_idx
               std::optional<torch::Tensor>,     // recv_topk_weights
               std::vector<int>,                 // num_recv_tokens_per_expert_list
               torch::Tensor,                    // rdma_channel_prefix_matrix
               torch::Tensor,                    // gbl_channel_prefix_matrix
               std::optional<torch::Tensor>,     // recv_rdma_channel_prefix_matrix
               std::optional<torch::Tensor>,     // recv_rdma_rank_prefix_sum
               std::optional<torch::Tensor>,     // recv_gbl_channel_prefix_matrix
               std::optional<torch::Tensor>,     // recv_gbl_rank_prefix_sum
               std::optional<torch::Tensor>,     // recv_src_meta
               std::optional<torch::Tensor>,     // send_rdma_head
               std::optional<torch::Tensor>,     // send_nvl_head
               std::optional<EventHandle>>       // event
    internode_dispatch(const torch::Tensor& x,
                       const std::optional<torch::Tensor>& x_scales,
                       const std::optional<torch::Tensor>& topk_idx,
                       const std::optional<torch::Tensor>& topk_weights,
                       const std::optional<torch::Tensor>& num_tokens_per_rank,
                       const std::optional<torch::Tensor>& num_tokens_per_rdma_rank,
                       const torch::Tensor& is_token_in_rank,
                       const std::optional<torch::Tensor>& num_tokens_per_expert,
                       int cached_num_recv_tokens,
                       int cached_num_rdma_recv_tokens,
                       const std::optional<torch::Tensor>& cached_rdma_channel_prefix_matrix,
                       const std::optional<torch::Tensor>& cached_recv_rdma_rank_prefix_sum,
                       const std::optional<torch::Tensor>& cached_gbl_channel_prefix_matrix,
                       const std::optional<torch::Tensor>& cached_recv_gbl_rank_prefix_sum,
                       int expert_alignment,
                       const Config& config,
                       std::optional<EventHandle>& previous_event,
                       bool async_flag,
                       bool allocate_on_comm_stream) {
        // Release GIL during long GPU operations
        py::gil_scoped_release release;

        // num_worst_tokens is always 0 for internode dispatch
        // (Python asserts this in dispatch() before calling internode_dispatch)
        const int num_worst_tokens = 0;

        const int num_channels = config.num_sms / 2;
        EP_HOST_ASSERT(config.num_sms % 2 == 0);
        EP_HOST_ASSERT(0 < get_num_rdma_ranks() and get_num_rdma_ranks() <= NUM_MAX_RDMA_PEERS);

        bool cached_mode = cached_rdma_channel_prefix_matrix.has_value();
        if (cached_mode) {
            EP_HOST_ASSERT(cached_recv_rdma_rank_prefix_sum.has_value());
            EP_HOST_ASSERT(cached_gbl_channel_prefix_matrix.has_value());
            EP_HOST_ASSERT(cached_recv_gbl_rank_prefix_sum.has_value());
        } else {
            EP_HOST_ASSERT(num_tokens_per_rank.has_value());
            EP_HOST_ASSERT(num_tokens_per_rdma_rank.has_value());
            EP_HOST_ASSERT(num_tokens_per_expert.has_value());
        }

        // Type checks
        if (cached_mode) {
            EP_HOST_ASSERT(cached_rdma_channel_prefix_matrix->scalar_type() == torch::kInt32);
            EP_HOST_ASSERT(cached_recv_rdma_rank_prefix_sum->scalar_type() == torch::kInt32);
            EP_HOST_ASSERT(cached_gbl_channel_prefix_matrix->scalar_type() == torch::kInt32);
            EP_HOST_ASSERT(cached_recv_gbl_rank_prefix_sum->scalar_type() == torch::kInt32);
        } else {
            EP_HOST_ASSERT(num_tokens_per_rank->scalar_type() == torch::kInt32);
            EP_HOST_ASSERT(num_tokens_per_rdma_rank->scalar_type() == torch::kInt32);
            EP_HOST_ASSERT(num_tokens_per_expert->scalar_type() == torch::kInt32);
        }

        // Shape and contiguous checks
        EP_HOST_ASSERT(x.dim() == 2 and x.is_contiguous());
        EP_HOST_ASSERT((x.size(1) * x.element_size()) % sizeof(int4) == 0);
        if (cached_mode) {
            EP_HOST_ASSERT(cached_rdma_channel_prefix_matrix->dim() == 2 and
                           cached_rdma_channel_prefix_matrix->is_contiguous());
            EP_HOST_ASSERT(cached_rdma_channel_prefix_matrix->size(0) == num_rdma_ranks and
                           cached_rdma_channel_prefix_matrix->size(1) == num_channels);
            EP_HOST_ASSERT(cached_recv_rdma_rank_prefix_sum->dim() == 1 and
                           cached_recv_rdma_rank_prefix_sum->is_contiguous());
            EP_HOST_ASSERT(cached_recv_rdma_rank_prefix_sum->size(0) == num_rdma_ranks);
            EP_HOST_ASSERT(cached_gbl_channel_prefix_matrix->dim() == 2 and
                           cached_gbl_channel_prefix_matrix->is_contiguous());
            EP_HOST_ASSERT(cached_gbl_channel_prefix_matrix->size(0) == num_ranks and
                           cached_gbl_channel_prefix_matrix->size(1) == num_channels);
            EP_HOST_ASSERT(cached_recv_gbl_rank_prefix_sum->dim() == 1 and
                           cached_recv_gbl_rank_prefix_sum->is_contiguous());
            EP_HOST_ASSERT(cached_recv_gbl_rank_prefix_sum->size(0) == num_ranks);
        } else {
            EP_HOST_ASSERT(num_tokens_per_rank->dim() == 1 and num_tokens_per_rank->is_contiguous());
            EP_HOST_ASSERT(num_tokens_per_rdma_rank->dim() == 1 and num_tokens_per_rdma_rank->is_contiguous());
            EP_HOST_ASSERT(num_tokens_per_expert->dim() == 1 and num_tokens_per_expert->is_contiguous());
            EP_HOST_ASSERT(num_tokens_per_rank->size(0) == num_ranks);
            EP_HOST_ASSERT(num_tokens_per_rdma_rank->size(0) == num_rdma_ranks);
            EP_HOST_ASSERT(num_tokens_per_expert->size(0) % num_ranks == 0);
            EP_HOST_ASSERT(num_tokens_per_expert->size(0) / num_ranks <= NUM_MAX_LOCAL_EXPERTS);
        }

        auto num_tokens = static_cast<int>(x.size(0));
        auto hidden = static_cast<int>(x.size(1));
        auto hidden_int4 = static_cast<int>(x.size(1) * x.element_size() / sizeof(int4));
        auto num_experts = cached_mode ? 0 : static_cast<int>(num_tokens_per_expert->size(0));
        auto num_local_experts = num_experts / num_ranks;

        // Top-k checks
        int num_topk = 0;
        topk_idx_t* topk_idx_ptr = nullptr;
        float* topk_weights_ptr = nullptr;
        EP_HOST_ASSERT(topk_idx.has_value() == topk_weights.has_value());
        if (topk_idx.has_value()) {
            num_topk = static_cast<int>(topk_idx->size(1));
            EP_HOST_ASSERT(num_experts > 0);
            EP_HOST_ASSERT(topk_idx->dim() == 2 and topk_idx->is_contiguous());
            EP_HOST_ASSERT(topk_weights->dim() == 2 and topk_weights->is_contiguous());
            EP_HOST_ASSERT(num_tokens == topk_idx->size(0) and num_tokens == topk_weights->size(0));
            EP_HOST_ASSERT(num_topk == topk_weights->size(1));
            EP_HOST_ASSERT(topk_weights->scalar_type() == torch::kFloat32);
            topk_idx_ptr = topk_idx->data_ptr<topk_idx_t>();
            topk_weights_ptr = topk_weights->data_ptr<float>();
        }

        // FP8 scales checks
        float* x_scales_ptr = nullptr;
        int num_scales = 0, scale_token_stride = 0, scale_hidden_stride = 0;
        if (x_scales.has_value()) {
            EP_HOST_ASSERT(x.element_size() == 1);
            EP_HOST_ASSERT(x_scales->scalar_type() == torch::kFloat32 or x_scales->scalar_type() == torch::kInt);
            EP_HOST_ASSERT(x_scales->dim() == 2);
            EP_HOST_ASSERT(x_scales->size(0) == num_tokens);
            num_scales = x_scales->dim() == 1 ? 1 : static_cast<int>(x_scales->size(1));
            x_scales_ptr = static_cast<float*>(x_scales->data_ptr());
            scale_token_stride = static_cast<int>(x_scales->stride(0));
            scale_hidden_stride = static_cast<int>(x_scales->stride(1));
        }

        // Wait previous tasks to be finished
        if (previous_event.has_value()) {
            queue_wait(comm_queue, previous_event.value());
        }

        // Create handles (only return for non-cached mode)
        int num_recv_tokens = -1, num_rdma_recv_tokens = -1;
        auto rdma_channel_prefix_matrix = torch::Tensor();
        auto recv_rdma_rank_prefix_sum = torch::Tensor();
        auto gbl_channel_prefix_matrix = torch::Tensor();
        auto recv_gbl_rank_prefix_sum = torch::Tensor();
        std::vector<int> num_recv_tokens_per_expert_list;

        auto opts_int = torch::TensorOptions().dtype(torch::kInt32).device(torch::kXPU);

        if (cached_mode) {
            num_recv_tokens = cached_num_recv_tokens;
            num_rdma_recv_tokens = cached_num_rdma_recv_tokens;
            rdma_channel_prefix_matrix = cached_rdma_channel_prefix_matrix.value();
            recv_rdma_rank_prefix_sum = cached_recv_rdma_rank_prefix_sum.value();
            gbl_channel_prefix_matrix = cached_gbl_channel_prefix_matrix.value();
            recv_gbl_rank_prefix_sum = cached_recv_gbl_rank_prefix_sum.value();

            // TODO: cached_notify not yet ported — assert for now
            EP_HOST_ASSERT(false && "Cached internode dispatch not yet supported in SYCL port");
        } else {
            rdma_channel_prefix_matrix = torch::empty({num_rdma_ranks, num_channels}, opts_int);
            recv_rdma_rank_prefix_sum = torch::empty({num_rdma_ranks}, opts_int);
            gbl_channel_prefix_matrix = torch::empty({num_ranks, num_channels}, opts_int);
            recv_gbl_rank_prefix_sum = torch::empty({num_ranks}, opts_int);

            // Reset counters
            *moe_recv_counter = -1;
            *moe_recv_rdma_counter = -1;
            for (int i = 0; i < num_local_experts; ++i)
                moe_recv_expert_counter[i] = -1;

            // Launch notify_dispatch kernel
            internode::launch_notify_dispatch(
                num_tokens_per_rank->data_ptr<int>(),
                moe_recv_counter_mapped,
                num_ranks,
                num_tokens_per_rdma_rank->data_ptr<int>(),
                moe_recv_rdma_counter_mapped,
                num_tokens_per_expert->data_ptr<int>(),
                moe_recv_expert_counter_mapped,
                num_experts,
                is_token_in_rank.data_ptr<bool>(),
                num_tokens,
                num_worst_tokens,
                num_channels,
                hidden_int4,
                num_scales,
                num_topk,
                expert_alignment,
                rdma_channel_prefix_matrix.data_ptr<int>(),
                recv_rdma_rank_prefix_sum.data_ptr<int>(),
                gbl_channel_prefix_matrix.data_ptr<int>(),
                recv_gbl_rank_prefix_sum.data_ptr<int>(),
                rdma_buffer_ptr,
                config.num_max_rdma_chunked_recv_tokens,
                buffer_ptrs_gpu,
                config.num_max_nvl_chunked_recv_tokens,
                barrier_signal_ptrs_gpu,
                rank,
                comm_queue,
                config.get_rdma_buffer_size_hint(hidden_int4 * sizeof(int4), num_ranks),
                num_nvl_bytes,
                low_latency_mode);

            // CPU busy-wait for received token counts
            // The GPU writes to USM shared counters; CPU polls them.
            auto start_time = std::chrono::high_resolution_clock::now();
            while (true) {
                num_recv_tokens = static_cast<int>(*moe_recv_counter);
                num_rdma_recv_tokens = static_cast<int>(*moe_recv_rdma_counter);

                bool ready = (num_recv_tokens >= 0) and (num_rdma_recv_tokens >= 0);
                for (int i = 0; i < num_local_experts and ready; ++i)
                    ready &= moe_recv_expert_counter[i] >= 0;

                if (ready)
                    break;

                if (std::chrono::duration_cast<std::chrono::seconds>(
                        std::chrono::high_resolution_clock::now() - start_time).count() > NUM_CPU_TIMEOUT_SECS) {
                    printf("Global rank: %d, num_recv_tokens: %d, num_rdma_recv_tokens: %d\n",
                           rank, num_recv_tokens, num_rdma_recv_tokens);
                    for (int i = 0; i < num_local_experts; ++i)
                        printf("moe_recv_expert_counter[%d]: %d\n", i, moe_recv_expert_counter[i]);
                    throw std::runtime_error("DeepEP error: timeout (dispatch CPU)");
                }
            }
            num_recv_tokens_per_expert_list = std::vector<int>(
                moe_recv_expert_counter, moe_recv_expert_counter + num_local_experts);
        }

        // Allocate output tensors
        auto recv_x = torch::empty({num_recv_tokens, hidden}, x.options());
        auto recv_topk_idx = std::optional<torch::Tensor>();
        auto recv_topk_weights = std::optional<torch::Tensor>();
        auto recv_x_scales = std::optional<torch::Tensor>();
        auto recv_src_meta = std::optional<torch::Tensor>();
        auto recv_rdma_channel_prefix_matrix = std::optional<torch::Tensor>();
        auto recv_gbl_channel_prefix_matrix = std::optional<torch::Tensor>();
        auto send_rdma_head = std::optional<torch::Tensor>();
        auto send_nvl_head = std::optional<torch::Tensor>();

        auto opts_byte = torch::TensorOptions().dtype(torch::kByte).device(torch::kXPU);

        if (not cached_mode) {
            recv_src_meta = torch::empty(
                {num_recv_tokens, internode::get_source_meta_bytes()}, opts_byte);
            recv_rdma_channel_prefix_matrix = torch::empty(
                {num_rdma_ranks, num_channels}, opts_int);
            recv_gbl_channel_prefix_matrix = torch::empty(
                {num_ranks, num_channels}, opts_int);
            send_rdma_head = torch::empty(
                {num_tokens, num_rdma_ranks}, opts_int);
            send_nvl_head = torch::empty(
                {num_rdma_recv_tokens, NUM_MAX_NVL_PEERS}, opts_int);
        }

        topk_idx_t* recv_topk_idx_ptr = nullptr;
        float* recv_topk_weights_ptr = nullptr;
        float* recv_x_scales_ptr = nullptr;
        if (topk_idx.has_value()) {
            recv_topk_idx = torch::empty({num_recv_tokens, num_topk}, topk_idx->options());
            recv_topk_weights = torch::empty({num_recv_tokens, num_topk}, topk_weights->options());
            recv_topk_idx_ptr = recv_topk_idx->data_ptr<topk_idx_t>();
            recv_topk_weights_ptr = recv_topk_weights->data_ptr<float>();
        }
        if (x_scales.has_value()) {
            recv_x_scales = x_scales->dim() == 1
                ? torch::empty({num_recv_tokens}, x_scales->options())
                : torch::empty({num_recv_tokens, num_scales}, x_scales->options());
            recv_x_scales_ptr = static_cast<float*>(recv_x_scales->data_ptr());
        }

        // Launch data dispatch kernel
        internode::launch_dispatch(
            recv_x.data_ptr(),
            recv_x_scales_ptr,
            recv_topk_idx_ptr,
            recv_topk_weights_ptr,
            cached_mode ? nullptr : recv_src_meta->data_ptr(),
            x.data_ptr(),
            x_scales_ptr,
            topk_idx_ptr,
            topk_weights_ptr,
            cached_mode ? nullptr : send_rdma_head->data_ptr<int>(),
            cached_mode ? nullptr : send_nvl_head->data_ptr<int>(),
            cached_mode ? nullptr : recv_rdma_channel_prefix_matrix->data_ptr<int>(),
            cached_mode ? nullptr : recv_gbl_channel_prefix_matrix->data_ptr<int>(),
            rdma_channel_prefix_matrix.data_ptr<int>(),
            recv_rdma_rank_prefix_sum.data_ptr<int>(),
            gbl_channel_prefix_matrix.data_ptr<int>(),
            recv_gbl_rank_prefix_sum.data_ptr<int>(),
            is_token_in_rank.data_ptr<bool>(),
            num_tokens,
            num_worst_tokens,
            hidden_int4,
            num_scales,
            num_topk,
            num_experts,
            scale_token_stride,
            scale_hidden_stride,
            rdma_buffer_ptr,
            config.num_max_rdma_chunked_send_tokens,
            config.num_max_rdma_chunked_recv_tokens,
            buffer_ptrs_gpu,
            config.num_max_nvl_chunked_send_tokens,
            config.num_max_nvl_chunked_recv_tokens,
            rank,
            num_ranks,
            cached_mode,
            comm_queue,
            num_channels,
            low_latency_mode);

        // Wait or create event
        std::optional<EventHandle> event;
        if (async_flag) {
            event = EventHandle(comm_queue);
        } else {
            comm_queue.wait();
        }

        return {recv_x,
                recv_x_scales,
                recv_topk_idx,
                recv_topk_weights,
                num_recv_tokens_per_expert_list,
                rdma_channel_prefix_matrix,
                gbl_channel_prefix_matrix,
                recv_rdma_channel_prefix_matrix,
                recv_rdma_rank_prefix_sum,
                recv_gbl_channel_prefix_matrix,
                recv_gbl_rank_prefix_sum,
                recv_src_meta,
                send_rdma_head,
                send_nvl_head,
                event};
    }
};

// ================================================================
// pybind11 registration
// ================================================================
static void register_apis(py::module_& m) {
    py::class_<Config>(m, "Config")
        .def(py::init<int, int, int, int, int>(),
             py::arg("num_sms") = 20,
             py::arg("num_max_nvl_chunked_send_tokens") = 6,
             py::arg("num_max_nvl_chunked_recv_tokens") = 256,
             py::arg("num_max_rdma_chunked_send_tokens") = 6,
             py::arg("num_max_rdma_chunked_recv_tokens") = 256)
        .def("get_nvl_buffer_size_hint", &Config::get_nvl_buffer_size_hint)
        .def("get_rdma_buffer_size_hint", &Config::get_rdma_buffer_size_hint);

    py::class_<EventHandle>(m, "EventHandle")
        .def(py::init<>())
        .def("current_stream_wait", &EventHandle::current_stream_wait);

    py::class_<Buffer>(m, "Buffer")
        .def(py::init<int, int, int64_t, int64_t, bool, bool>(),
             py::arg("rank"),
             py::arg("num_ranks"),
             py::arg("num_nvl_bytes"),
             py::arg("num_rdma_bytes"),
             py::arg("low_latency_mode"),
             py::arg("explicitly_destroy"))
        .def("is_available", &Buffer::is_available)
        .def("get_num_rdma_ranks", &Buffer::get_num_rdma_ranks)
        .def("get_rdma_rank", &Buffer::get_rdma_rank)
        .def("get_root_rdma_rank", &Buffer::get_root_rdma_rank)
        .def("get_local_device_id", &Buffer::get_local_device_id)
        .def("get_local_ipc_handle", &Buffer::get_local_ipc_handle)
        .def("sync", &Buffer::sync)
        .def("destroy", &Buffer::destroy)
        .def("get_dispatch_layout", &Buffer::get_dispatch_layout)
        .def("internode_dispatch", &Buffer::internode_dispatch);
}

}  // namespace deep_ep::legacy
