"""
Test DeepEP XPU initialization and basic buffer communication.

Usage:
    python tests/test_xpu_init.py --num-processes 2
"""

import argparse
import os
import sys

import torch
import torch.distributed as dist
import torch.multiprocessing as mp
# import faulthandler
# import sys

# # 在程序最开始启用
# faulthandler.enable()
# faulthandler.dump_traceback_later(timeout=30, repeat=True, file=sys.stderr)

def run_tests(local_rank: int, num_ranks: int):
    """Run basic DeepEP init and buffer communication tests"""
    import deep_ep
    
    # Set XPU device
    torch.xpu.set_device(local_rank)
    device = f'xpu:{local_rank}'
    
    # Set environment variables
    os.environ['RANK'] = str(local_rank)
    os.environ['LOCAL_RANK'] = str(local_rank)
    os.environ['WORLD_SIZE'] = str(num_ranks)
    os.environ['MASTER_ADDR'] = 'localhost'
    os.environ['MASTER_PORT'] = '29555'
    
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
    
    # ========== Test 1: DeepEP Buffer Creation ==========
    if local_rank == 0:
        print("\n[Test 1] Creating DeepEP Buffer...", flush=True)
    
    buffer = deep_ep.Buffer(
        group,
        int(1e8),  # 100MB NVL buffer
        num_rdma_bytes=0,
        low_latency_mode=False,
        num_qps_per_rank=1,
        explicitly_destroy=True  # Allow explicit destroy
    )
    
    if local_rank == 0:
        print(f"[Test 1] Buffer created: rank={buffer.rank}, num_ranks={buffer.group_size}", flush=True)
    
    dist.barrier()
    
    # Note: IPC handle exchange and sync are already done in Buffer() constructor
    # No need to call sync() again!
    
    # ========== Test 2: Basic dispatch layout ==========
    if local_rank == 0:
        print("\n[Test 2] Testing get_dispatch_layout...", flush=True)
    
    num_tokens = 128
    num_experts = 8 * num_ranks
    num_topk = 2
    
    topk_idx = torch.randint(0, num_experts, (num_tokens, num_topk),
                              dtype=deep_ep.topk_idx_t, device=device)
    
    result = buffer.get_dispatch_layout(topk_idx, num_experts)
    num_tokens_per_rank, _, num_tokens_per_expert, is_token_in_rank, _ = result
    
    if local_rank == 0:
        print(f"[Test 2] Layout OK: num_tokens_per_rank={num_tokens_per_rank.tolist()}", flush=True)
    
    dist.barrier()
    
    # ========== Test 3: IPC Memory Communication ==========
    if local_rank == 0:
        print("\n[Test 3] Testing IPC memory read/write across ranks...", flush=True)
    
    # Get local buffer tensor (shared via IPC)
    local_buf = buffer.get_local_buffer_tensor(torch.float32, torch.Size([1024]))
    
    # Each rank writes its unique value: Rank 0 -> 100, Rank 1 -> 200, etc.
    my_value = float(local_rank + 1) * 100
    local_buf.fill_(my_value)
    torch.xpu.synchronize()
    dist.barrier()
    
    # Now read from ALL ranks (including self) and verify
    # Each rank should be able to read every other rank's buffer via IPC
    all_values = []
    for target_rank in range(num_ranks):
        # Get buffer pointer for target rank
        remote_buf = buffer.get_remote_buffer_tensor(target_rank, torch.float32, torch.Size([1024]))
        val = remote_buf[0].item()
        all_values.append(val)
        expected = float(target_rank + 1) * 100
        assert val == expected, f"Rank {local_rank} read rank {target_rank}: got {val}, expected {expected}"
    
    torch.xpu.synchronize()
    dist.barrier()
    
    # All ranks should see the same values: [100, 200, ...]
    expected_values = [float(r + 1) * 100 for r in range(num_ranks)]
    print(f"[Test 3] Rank {local_rank}: Read values from all ranks = {all_values}", flush=True)
    assert all_values == expected_values, f"Rank {local_rank}: values mismatch!"
    
    dist.barrier()
    if local_rank == 0:
        print(f"[Test 3] IPC cross-rank read OK! All ranks see: {expected_values}", flush=True)
    
    dist.barrier()
    
    # ========== Cleanup ==========
    if local_rank == 0:
        print("\n[Cleanup] Destroying buffer...", flush=True)
    
    buffer.destroy()
    dist.barrier()
    dist.destroy_process_group()
    
    if local_rank == 0:
        print("\n" + "=" * 50, flush=True)
        print("All tests passed!", flush=True)
        print("=" * 50, flush=True)


def worker_fn(local_rank: int, num_ranks: int):
    """Worker function for multiprocessing"""
    run_tests(local_rank, num_ranks)


def main():
    parser = argparse.ArgumentParser(description='Test DeepEP XPU init and buffer communication')
    parser.add_argument('--num-processes', type=int, default=2,
                        help='Number of XPU devices to use (default: 2)')
    args = parser.parse_args()
    
    num_processes = args.num_processes
    
    print("=" * 50, flush=True)
    print(f"DeepEP XPU Test ({num_processes} GPUs)", flush=True)
    print("=" * 50, flush=True)
    
    # Spawn worker processes
    mp.spawn(
        worker_fn,
        args=(num_processes,),
        nprocs=num_processes,
        join=True
    )


if __name__ == '__main__':
    main()
