# PORTED_FROM: deep_ep/buffers/legacy.py
# Python frontend for the DeepEP V1 (legacy) SYCL port.
#
# This mirrors the original legacy.py but:
#   - Uses _C_sycl instead of _C (SYCL extension module)
#   - Replaces NVSHMEM unique_id exchange with ishmem MPI bootstrap
#   - Removes CUDA-specific env vars (NVSHMEM_*)
#   - Uses torch.xpu instead of torch.cuda for device/stream ops

import os
import torch
import torch.distributed as dist
from typing import Callable, List, Tuple, Optional, Union

# noinspection PyUnresolvedReferences
import deep_ep._C_sycl as _C_sycl
# noinspection PyUnresolvedReferences
from deep_ep._C_sycl import Config, EventHandle


class EventOverlap:
    """Wrapper for SYCL EventHandle, compatible with the V1 Python API."""

    def __init__(self, event=None):
        self.event = event

    def current_stream_wait(self):
        if self.event is not None:
            self.event.current_stream_wait()


class Buffer:
    """
    SYCL-ported expert-parallel (EP) communication buffer for MoE models.

    This is the Intel GPU equivalent of the CUDA legacy Buffer class.
    Supports internode all-to-all dispatch (and combine once ported).

    Attributes:
        num_sms: the work-groups used in high-throughput kernels.
        rank: the local rank number.
        group_size: the number of ranks in the group.
        num_nvl_bytes: the buffer size for intranode IPC communication.
        num_rdma_bytes: the buffer size for internode RDMA (ishmem) communication.
        runtime: the C++ SYCL runtime.
    """

    num_sms: int = 20

    def __init__(self,
                 group: Optional[dist.ProcessGroup] = None,
                 num_nvl_bytes: int = 0,
                 num_rdma_bytes: int = 0,
                 low_latency_mode: bool = False,
                 explicitly_destroy: bool = False,
                 comm: Optional["mpi4py.MPI.Comm"] = None) -> None:  # noqa: F821
        """
        Initialize the SYCL communication buffer.

        Arguments:
            group: the communication group.
            num_nvl_bytes: buffer size for intranode IPC communication.
            num_rdma_bytes: buffer size for internode ishmem RDMA communication.
            low_latency_mode: whether to enable low-latency mode.
            explicitly_destroy: if True, you must call destroy() explicitly.
            comm: the mpi4py.MPI.Comm communicator (alternative to group).
        """
        # Initialize the CPP runtime
        if group is not None:
            self.rank = group.rank()
            self.group = group
            self.group_size = group.size()

            def all_gather_object(obj):
                object_list = [None] * self.group_size
                dist.all_gather_object(object_list, obj, group)
                return object_list
        elif comm is not None:
            self.rank = comm.Get_rank()
            self.group = comm
            self.group_size = comm.Get_size()

            def all_gather_object(obj):
                return comm.allgather(obj)
        else:
            raise ValueError("Either 'group' or 'comm' must be provided.")

        self.num_nvl_bytes = num_nvl_bytes
        self.num_rdma_bytes = num_rdma_bytes
        self.low_latency_mode = low_latency_mode
        self.explicitly_destroy = explicitly_destroy

        # Create C++ SYCL buffer
        # Note: fewer constructor args than CUDA version (no enable_shrink, allow_mnnvl)
        self.runtime = _C_sycl.Buffer(
            self.rank, self.group_size,
            num_nvl_bytes, num_rdma_bytes,
            low_latency_mode, explicitly_destroy)

        # Synchronize device IDs
        local_device_id = self.runtime.get_local_device_id()
        device_ids = all_gather_object(local_device_id)

        # Synchronize IPC handles
        local_ipc_handle = self.runtime.get_local_ipc_handle()
        ipc_handles = all_gather_object(local_ipc_handle)

        # ishmem initialization:
        # Unlike NVSHMEM (which uses unique_id exchange), ishmem uses MPI bootstrap.
        # ishmem_init() is called inside buffer.sync() and uses MPI_COMM_WORLD.
        # No unique_id exchange needed.

        # Make CPP runtime available
        self.runtime.sync(device_ids, ipc_handles)
        assert self.runtime.is_available()

    def destroy(self):
        """Destroy the cpp runtime and release resources."""
        assert self.explicitly_destroy, '`explicitly_destroy` flag must be set'
        self.runtime.destroy()
        self.runtime = None

    @staticmethod
    def set_num_sms(new_num_sms: int) -> None:
        """Set the number of SMs (work-groups) for high-throughput kernels."""
        assert new_num_sms % 2 == 0, 'The SM count must be even'
        Buffer.num_sms = new_num_sms

    @staticmethod
    def capture() -> EventOverlap:
        """Capture an event on the current stream."""
        return EventOverlap(EventHandle())

    @staticmethod
    def get_dispatch_config(num_ranks: int) -> Config:
        """Get a recommended dispatch config."""
        config_map = {
            2: Config(Buffer.num_sms, 24, 256, 6, 128),
            4: Config(Buffer.num_sms, 6, 256, 6, 128),
            8: Config(Buffer.num_sms, 6, 256, 6, 128),
            16: Config(Buffer.num_sms, 36, 288, 20, 128),
            24: Config(Buffer.num_sms, 32, 288, 8, 128),
            32: Config(Buffer.num_sms, 32, 288, 8, 128),
            48: Config(Buffer.num_sms, 32, 288, 8, 128),
            64: Config(Buffer.num_sms, 32, 288, 8, 128),
            96: Config(Buffer.num_sms, 20, 480, 12, 128),
            128: Config(Buffer.num_sms, 20, 560, 12, 128),
            144: Config(Buffer.num_sms, 32, 720, 12, 128),
            160: Config(Buffer.num_sms, 28, 720, 12, 128),
        }
        assert num_ranks in config_map, f'Unsupported number of EP ranks: {num_ranks}'
        return config_map[num_ranks]

    def get_dispatch_layout(self, topk_idx: torch.Tensor, num_experts: int,
                            previous_event: Optional[EventOverlap] = None,
                            async_finish: bool = False,
                            allocate_on_comm_stream: bool = False) -> \
            Tuple[torch.Tensor, Optional[torch.Tensor], torch.Tensor, torch.Tensor, EventOverlap]:
        """
        Calculate the layout required for later communication.

        Arguments:
            topk_idx: [num_tokens, num_topk] with topk_idx_t
            num_experts: the number of experts.
            previous_event: event to wait before executing.
            async_finish: if True, do not wait for completion.
            allocate_on_comm_stream: allocate tensors on comm stream.

        Returns:
            num_tokens_per_rank, num_tokens_per_rdma_rank,
            num_tokens_per_expert, is_token_in_rank, event
        """
        num_tokens_per_rank, num_tokens_per_rdma_rank, num_tokens_per_expert, is_token_in_rank, event = \
            self.runtime.get_dispatch_layout(
                topk_idx, num_experts,
                getattr(previous_event, 'event', None),
                async_finish, allocate_on_comm_stream)
        return (num_tokens_per_rank, num_tokens_per_rdma_rank,
                num_tokens_per_expert, is_token_in_rank, EventOverlap(event))

    def dispatch(self, x: Union[torch.Tensor, Tuple[torch.Tensor, torch.Tensor]],
                 handle: Optional[Tuple] = None,
                 num_tokens_per_rank: Optional[torch.Tensor] = None,
                 num_tokens_per_rdma_rank: Optional[torch.Tensor] = None,
                 is_token_in_rank: Optional[torch.Tensor] = None,
                 num_tokens_per_expert: Optional[torch.Tensor] = None,
                 topk_idx: Optional[torch.Tensor] = None,
                 topk_weights: Optional[torch.Tensor] = None,
                 expert_alignment: int = 1,
                 num_worst_tokens: int = 0,
                 config: Optional[Config] = None,
                 previous_event: Optional[EventOverlap] = None,
                 async_finish: bool = False,
                 allocate_on_comm_stream: bool = False) -> \
            Tuple[Union[Tuple[torch.Tensor, torch.Tensor], torch.Tensor],
                  Optional[torch.Tensor],
                  Optional[torch.Tensor], List[int], Tuple, EventOverlap]:
        """
        Dispatch tokens to different ranks (internode).

        Arguments:
            x: [num_tokens, hidden] with bfloat16, or tuple of (fp8_tensor, scales).
            handle: optional cached communication handle.
            num_tokens_per_rank: [num_ranks] with int.
            num_tokens_per_rdma_rank: [num_rdma_ranks] with int.
            is_token_in_rank: [num_tokens, num_ranks] with bool.
            num_tokens_per_expert: [num_experts] with int.
            topk_idx: [num_tokens, num_topk] with topk_idx_t.
            topk_weights: [num_tokens, num_topk] with float.
            expert_alignment: expert token count alignment.
            num_worst_tokens: worst-case token count (0 = sync with CPU).
            config: performance tuning config.
            previous_event: event to wait before executing.
            async_finish: if True, do not wait for completion.
            allocate_on_comm_stream: allocate tensors on comm stream.

        Returns:
            recv_x, recv_topk_idx, recv_topk_weights,
            num_recv_tokens_per_expert_list, handle, event
        """
        # Default config
        config = self.get_dispatch_config(self.group_size) if config is None else config

        # Only internode dispatch is supported in SYCL port
        assert self.runtime.get_num_rdma_ranks() > 1, \
            'SYCL port only supports internode dispatch (num_rdma_ranks must be > 1)'
        assert num_worst_tokens == 0, 'Internode dispatch does not support num_worst_tokens > 0'

        return self._internode_dispatch(
            x, handle, num_tokens_per_rank, num_tokens_per_rdma_rank,
            is_token_in_rank, num_tokens_per_expert,
            topk_idx, topk_weights, expert_alignment,
            config, previous_event, async_finish, allocate_on_comm_stream)

    def _internode_dispatch(self, x, handle, num_tokens_per_rank, num_tokens_per_rdma_rank,
                            is_token_in_rank, num_tokens_per_expert,
                            topk_idx, topk_weights, expert_alignment,
                            config, previous_event, async_finish,
                            allocate_on_comm_stream):
        """Internal internode dispatch implementation."""
        assert config is not None

        x, x_scales = x if isinstance(x, tuple) else (x, None)
        if handle is not None:
            assert topk_idx is None and topk_weights is None
            (is_token_in_rank,
             rdma_channel_prefix_matrix, gbl_channel_prefix_matrix,
             recv_rdma_channel_prefix_matrix, recv_rdma_rank_prefix_sum,
             recv_gbl_channel_prefix_matrix, recv_gbl_rank_prefix_sum,
             recv_src_meta, send_rdma_head, send_nvl_head) = handle
            num_recv_tokens = recv_src_meta.size(0)
            num_rdma_recv_tokens = send_nvl_head.size(0)
            (recv_x, recv_x_scales, _, _, _, _, _, _, _, _, _, _, _, _, event
             ) = self.runtime.internode_dispatch(
                x, x_scales, topk_idx, topk_weights,
                None, None, is_token_in_rank, None,
                num_recv_tokens, num_rdma_recv_tokens,
                rdma_channel_prefix_matrix, recv_rdma_rank_prefix_sum,
                gbl_channel_prefix_matrix, recv_gbl_rank_prefix_sum,
                expert_alignment, config,
                getattr(previous_event, 'event', None),
                async_finish, allocate_on_comm_stream)
            return ((recv_x, recv_x_scales) if x_scales is not None else recv_x,
                    None, None, None, None, EventOverlap(event))
        else:
            assert num_tokens_per_rank is not None
            assert is_token_in_rank is not None
            assert num_tokens_per_expert is not None
            (recv_x, recv_x_scales, recv_topk_idx, recv_topk_weights,
             num_recv_tokens_per_expert_list,
             rdma_channel_prefix_matrix, gbl_channel_prefix_matrix,
             recv_rdma_channel_prefix_matrix, recv_rdma_rank_prefix_sum,
             recv_gbl_channel_prefix_matrix, recv_gbl_rank_prefix_sum,
             recv_src_meta, send_rdma_head, send_nvl_head, event
             ) = self.runtime.internode_dispatch(
                x, x_scales, topk_idx, topk_weights,
                num_tokens_per_rank, num_tokens_per_rdma_rank,
                is_token_in_rank, num_tokens_per_expert,
                0, 0, None, None, None, None,
                expert_alignment, config,
                getattr(previous_event, 'event', None),
                async_finish, allocate_on_comm_stream)
            handle = (is_token_in_rank,
                      rdma_channel_prefix_matrix, gbl_channel_prefix_matrix,
                      recv_rdma_channel_prefix_matrix, recv_rdma_rank_prefix_sum,
                      recv_gbl_channel_prefix_matrix, recv_gbl_rank_prefix_sum,
                      recv_src_meta, send_rdma_head, send_nvl_head)
            return ((recv_x, recv_x_scales) if x_scales is not None else recv_x,
                    recv_topk_idx, recv_topk_weights,
                    num_recv_tokens_per_expert_list, handle, EventOverlap(event))
