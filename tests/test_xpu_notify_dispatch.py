"""
Test DeepEP XPU notify_dispatch kernel directly.

This test isolates the notify_dispatch kernel to debug barrier synchronization.

Usage:
    # Test the notify_dispatch kernel directly (simpler, faster)
    python tests/test_xpu_notify_dispatch.py --num-processes 2 --test direct
    
    # Test through full dispatch path
    python tests/test_xpu_notify_dispatch.py --num-processes 2 --test full
    
    # Test both
    python tests/test_xpu_notify_dispatch.py --num-processes 2 --test all
"""

import argparse
import os
import sys
import time
import torch
import torch.distributed as dist
import torch.multiprocessing as mp


def test_notify_dispatch_direct(local_rank: int, num_ranks: int, args):
    """
    Test notify_dispatch kernel directly using the new test_notify_dispatch method.
    This bypasses the full dispatch path and tests the kernel in isolation.
    """
    import deep_ep
    
    # Set XPU device
    torch.xpu.set_device(local_rank)
    device = f'xpu:{local_rank}'
    
    # Set environment variables
    os.environ['RANK'] = str(local_rank)
    os.environ['LOCAL_RANK'] = str(local_rank)
    os.environ['WORLD_SIZE'] = str(num_ranks)
    os.environ['MASTER_ADDR'] = 'localhost'
    os.environ['MASTER_PORT'] = str(args.port)
    
    # Initialize process group
    print(f"[Rank {local_rank}] Initializing process group...", flush=True)
    dist.init_process_group(
        backend='xccl',
        init_method='env://',
        world_size=num_ranks,
        rank=local_rank
    )
    print(f"[Rank {local_rank}] Process group initialized", flush=True)
    
    group = dist.group.WORLD
    dist.barrier()
    
    # ========== Create Buffer ==========
    if local_rank == 0:
        print("\n[Setup] Creating DeepEP Buffer...", flush=True)
    
    buffer = deep_ep.Buffer(
        group,
        int(2e8),  # 200MB NVL buffer
        num_rdma_bytes=0,
        low_latency_mode=False,
        num_qps_per_rank=1,
        explicitly_destroy=True
    )
    
    if local_rank == 0:
        print(f"[Setup] Buffer created: rank={buffer.rank}, num_ranks={buffer.group_size}", flush=True)
    
    dist.barrier()
    
    # ========== Test Parameters ==========
    num_tokens = args.num_tokens
    num_experts = args.num_experts
    num_channels = args.num_channels
    expert_alignment = args.expert_alignment
    
    if local_rank == 0:
        print(f"\n[Test Direct] Parameters:", flush=True)
        print(f"  num_tokens={num_tokens}", flush=True)
        print(f"  num_experts={num_experts}", flush=True)
        print(f"  num_channels={num_channels}", flush=True)
        print(f"  expert_alignment={expert_alignment}", flush=True)
        print(f"  num_ranks={num_ranks}", flush=True)
    
    # ========== Generate Test Data ==========
    # Use fixed seed for reproducibility
    torch.manual_seed(42 + local_rank)
    
    # Each token randomly selects one expert
    token_expert_idx = torch.randint(0, num_experts, (num_tokens,), device=device)
    
    # Calculate is_token_in_rank
    experts_per_rank = num_experts // num_ranks
    token_rank_idx = token_expert_idx // experts_per_rank
    
    is_token_in_rank = torch.zeros(num_tokens, num_ranks, dtype=torch.bool, device=device)
    for i in range(num_tokens):
        target_rank = token_rank_idx[i].item()
        is_token_in_rank[i, target_rank] = True
    
    # Calculate num_tokens_per_rank
    num_tokens_per_rank = is_token_in_rank.sum(dim=0).to(torch.int32)
    
    # Calculate num_tokens_per_expert
    num_tokens_per_expert = torch.zeros(num_experts, dtype=torch.int32, device=device)
    for i in range(num_tokens):
        expert_idx = token_expert_idx[i].item()
        num_tokens_per_expert[expert_idx] += 1
    
    print(f"[Rank {local_rank}] Generated test data:", flush=True)
    print(f"  num_tokens_per_rank: {num_tokens_per_rank.tolist()}", flush=True)
    print(f"  num_tokens_per_expert: {num_tokens_per_expert.tolist()}", flush=True)
    
    torch.xpu.synchronize()
    dist.barrier()
    
    # ========== Call test_notify_dispatch ==========
    if local_rank == 0:
        print(f"\n[Test Direct] Calling test_notify_dispatch...", flush=True)
    
    start_time = time.time()
    
    try:
        moe_recv_count, expert_counts, rank_prefix_matrix, channel_prefix_matrix = \
            buffer.runtime.test_notify_dispatch(
                num_tokens_per_rank,
                num_tokens_per_expert,
                is_token_in_rank,
                num_tokens,
                num_experts,
                num_channels,
                expert_alignment
            )
        
        elapsed = time.time() - start_time
        print(f"[Rank {local_rank}] test_notify_dispatch completed in {elapsed*1000:.2f} ms", flush=True)
        
        # Print results
        print(f"[Rank {local_rank}] Results:", flush=True)
        print(f"  moe_recv_count: {moe_recv_count}", flush=True)
        print(f"  expert_counts: {expert_counts}", flush=True)
        
        # Verify moe_recv_count
        # This should equal the sum of tokens sent to this rank from all ranks
        # In the single-machine case with local data, it should equal num_tokens_per_rank[local_rank]
        expected_recv_count = num_tokens_per_rank[local_rank].item()
        if moe_recv_count == expected_recv_count:
            print(f"[Rank {local_rank}] moe_recv_count CORRECT! ({moe_recv_count} == {expected_recv_count})", flush=True)
        else:
            print(f"[Rank {local_rank}] moe_recv_count MISMATCH! (got {moe_recv_count}, expected {expected_recv_count})", flush=True)
        
        # Print matrices
        print(f"[Rank {local_rank}] rank_prefix_matrix:", flush=True)
        print(rank_prefix_matrix.cpu(), flush=True)
        print(f"[Rank {local_rank}] channel_prefix_matrix:", flush=True)
        print(channel_prefix_matrix.cpu(), flush=True)
        
    except Exception as e:
        print(f"[Rank {local_rank}] ERROR during test_notify_dispatch: {e}", flush=True)
        import traceback
        traceback.print_exc()
        raise
    
    torch.xpu.synchronize()
    dist.barrier()
    
    if local_rank == 0:
        print(f"\n[Test Direct] notify_dispatch direct test PASSED!", flush=True)
    
    # ========== Cleanup ==========
    buffer.destroy()
    dist.barrier()
    dist.destroy_process_group()


def test_notify_dispatch_full(local_rank: int, num_ranks: int, args):
    """Test notify_dispatch kernel through full dispatch path"""
    import deep_ep
    
    # Set XPU device
    torch.xpu.set_device(local_rank)
    device = f'xpu:{local_rank}'
    
    # Set environment variables
    os.environ['RANK'] = str(local_rank)
    os.environ['LOCAL_RANK'] = str(local_rank)
    os.environ['WORLD_SIZE'] = str(num_ranks)
    os.environ['MASTER_ADDR'] = 'localhost'
    os.environ['MASTER_PORT'] = str(args.port + 1)  # Use different port
    
    # Initialize process group
    print(f"[Rank {local_rank}] Initializing process group...", flush=True)
    dist.init_process_group(
        backend='xccl',
        init_method='env://',
        world_size=num_ranks,
        rank=local_rank
    )
    print(f"[Rank {local_rank}] Process group initialized", flush=True)
    
    group = dist.group.WORLD
    dist.barrier()
    
    # ========== Create Buffer ==========
    if local_rank == 0:
        print("\n[Setup] Creating DeepEP Buffer...", flush=True)
    
    buffer = deep_ep.Buffer(
        group,
        int(2e8),  # 200MB NVL buffer
        num_rdma_bytes=0,
        low_latency_mode=False,
        num_qps_per_rank=1,
        explicitly_destroy=True
    )
    
    if local_rank == 0:
        print(f"[Setup] Buffer created: rank={buffer.rank}, num_ranks={buffer.group_size}", flush=True)
    
    dist.barrier()
    
    # ========== Test Parameters ==========
    num_tokens = args.num_tokens
    hidden = 512
    num_experts = args.num_experts
    num_topk = 4
    
    if local_rank == 0:
        print(f"\n[Test Full] Parameters:", flush=True)
        print(f"  num_tokens={num_tokens}", flush=True)
        print(f"  hidden={hidden}", flush=True)
        print(f"  num_experts={num_experts}", flush=True)
        print(f"  num_topk={num_topk}", flush=True)
        print(f"  num_ranks={num_ranks}", flush=True)
    
    # ========== Prepare Input Data ==========
    # Create input tensor
    x = torch.ones((num_tokens, hidden), dtype=torch.bfloat16, device=device) * local_rank
    
    # Create topk_idx
    scores = torch.randn((num_tokens, num_experts), dtype=torch.float32, device=device).abs() + 1
    topk_idx = torch.topk(scores, num_topk, dim=-1, largest=True, sorted=False)[1]
    topk_idx = topk_idx.to(deep_ep.topk_idx_t)
    
    # Create topk_weights
    topk_weights = torch.ones((num_tokens, num_topk), dtype=torch.float32, device=device) * local_rank
    
    torch.xpu.synchronize()
    dist.barrier()
    
    if local_rank == 0:
        print(f"\n[Test] Input data prepared", flush=True)
        print(f"  x.shape={x.shape}, x.dtype={x.dtype}", flush=True)
        print(f"  topk_idx.shape={topk_idx.shape}, topk_idx.dtype={topk_idx.dtype}", flush=True)
    
    # ========== Get Dispatch Layout ==========
    if local_rank == 0:
        print(f"\n[Test] Getting dispatch layout...", flush=True)
    
    num_tokens_per_rank, _, num_tokens_per_expert, is_token_in_rank, _ = \
        buffer.get_dispatch_layout(topk_idx, num_experts)
    
    torch.xpu.synchronize()
    dist.barrier()
    
    if local_rank == 0:
        print(f"[Test] Layout obtained:", flush=True)
        print(f"  num_tokens_per_rank={num_tokens_per_rank.tolist()}", flush=True)
        print(f"  num_tokens_per_expert.shape={num_tokens_per_expert.shape}", flush=True)
        print(f"  is_token_in_rank.shape={is_token_in_rank.shape}", flush=True)
    
    # ========== Test Dispatch (THIS IS WHERE IT HANGS) ==========
    if local_rank == 0:
        print(f"\n[Test] About to call buffer.dispatch()...", flush=True)
        print(f"[Test] This will trigger notify_dispatch kernel", flush=True)
    
    dist.barrier()
    
    # Set number of SMs
    num_sms = 24
    deep_ep.Buffer.set_num_sms(num_sms)
    config = deep_ep.Buffer.get_dispatch_config(num_ranks)
    
    if local_rank == 0:
        print(f"[Test Full] Config: num_sms={num_sms}, config={config}", flush=True)
    
    try:
        print(f"[Rank {local_rank}] Calling dispatch... (should see C++ debug logs)", flush=True)
        start_time = time.time()
        
        recv_x, recv_topk_idx, recv_topk_weights, num_recv_tokens_per_expert_list, handle, event = \
            buffer.dispatch(
                x=x,
                num_tokens_per_rank=num_tokens_per_rank,
                is_token_in_rank=is_token_in_rank,
                num_tokens_per_expert=num_tokens_per_expert,
                topk_idx=topk_idx,
                topk_weights=topk_weights,
                config=config,
                async_finish=False
            )
        
        elapsed = time.time() - start_time
        print(f"[Rank {local_rank}] Dispatch completed in {elapsed*1000:.2f} ms!", flush=True)
        
        # Verify results
        print(f"[Rank {local_rank}] Results:", flush=True)
        print(f"  recv_x.shape={recv_x.shape}", flush=True)
        print(f"  recv_topk_idx.shape={recv_topk_idx.shape if recv_topk_idx is not None else None}", flush=True)
        
    except Exception as e:
        print(f"[Rank {local_rank}] ERROR during dispatch: {e}", flush=True)
        import traceback
        traceback.print_exc()
        raise
    
    torch.xpu.synchronize()
    dist.barrier()
    
    if local_rank == 0:
        print(f"\n[Test Full] Dispatch test PASSED!", flush=True)
    
    # ========== Cleanup ==========
    if local_rank == 0:
        print("\n[Cleanup] Destroying buffer...", flush=True)
    
    buffer.destroy()
    dist.barrier()
    dist.destroy_process_group()
    
    if local_rank == 0:
        print("\n" + "=" * 50, flush=True)
        print("notify_dispatch full test completed successfully!", flush=True)
        print("=" * 50, flush=True)


def worker_fn(local_rank: int, num_ranks: int, args):
    """Worker function for multiprocessing"""
    # Add parent directory to sys.path so subprocess can import deep_ep
    from pathlib import Path
    repo_root = Path(__file__).parent.parent.absolute()
    if str(repo_root) not in sys.path:
        sys.path.insert(0, str(repo_root))
    
    test_type = args.test
    
    if test_type == 'direct' or test_type == 'all':
        test_notify_dispatch_direct(local_rank, num_ranks, args)
        
        # If running 'all', need to reinit dist after first test
        if test_type == 'all' and local_rank == 0:
            print("\n" + "=" * 60, flush=True)
            print("Direct test completed, starting full test...", flush=True)
            print("=" * 60 + "\n", flush=True)
    
    if test_type == 'full':
        test_notify_dispatch_full(local_rank, num_ranks, args)


def main():
    parser = argparse.ArgumentParser(description='Test DeepEP XPU notify_dispatch kernel')
    parser.add_argument('--num-processes', type=int, default=2,
                        help='Number of XPU devices to use (default: 2)')
    parser.add_argument('--num-tokens', type=int, default=64,
                        help='Number of tokens (default: 64)')
    parser.add_argument('--num-experts', type=int, default=None,
                        help='Number of experts (default: 8 * num_processes)')
    parser.add_argument('--num-channels', type=int, default=4,
                        help='Number of channels (default: 4)')
    parser.add_argument('--expert-alignment', type=int, default=1,
                        help='Expert alignment (default: 1)')
    parser.add_argument('--test', type=str, default='direct',
                        choices=['direct', 'full', 'all'],
                        help='Which test to run: direct (new API), full (dispatch path), all')
    parser.add_argument('--port', type=int, default=29556,
                        help='Master port for distributed communication (default: 29556)')
    args = parser.parse_args()
    
    num_processes = args.num_processes
    
    # Default num_experts
    if args.num_experts is None:
        args.num_experts = 8 * num_processes
    
    # Validate num_experts
    if args.num_experts % num_processes != 0:
        print(f"Error: num_experts ({args.num_experts}) must be divisible by "
              f"num_processes ({num_processes})")
        return
    
    print("=" * 60, flush=True)
    print(f"DeepEP XPU notify_dispatch Test ({num_processes} GPUs)", flush=True)
    print(f"Test mode: {args.test}", flush=True)
    print(f"num_tokens={args.num_tokens}, num_experts={args.num_experts}", flush=True)
    print(f"num_channels={args.num_channels}, expert_alignment={args.expert_alignment}", flush=True)
    print("=" * 60, flush=True)
    
    # Spawn worker processes
    mp.spawn(
        worker_fn,
        args=(num_processes, args),
        nprocs=num_processes,
        join=True
    )


if __name__ == '__main__':
    main()
