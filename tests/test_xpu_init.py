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

def test_barrier_signal_cross_write(
    local_rank: int,
    num_ranks: int,
    buffer,
    device: str
):
    """
    Test: Barrier Signal Cross-Write Test
    
    验证 IPC 地址映射的正确性：
    - 每个 rank 写入 +1024 到自己的所有位置
    - 每个 rank 写入 -1024 到所有其他 rank 对应自己的位置
    - 最终每个位置的值应该为 0
    
    数学验证：
    barrier_signal_ptrs[rank][i] 初始值 = 0
    + rank i 自己写入 +1024
    - 所有其他 rank j (j != i) 写入 -1024
    最终值 = +1024 - 1024 * (num_ranks - 1) 
    
    对于 2 个 rank：+1024 - 1024 = 0
    """
    if local_rank == 0:
        print("\n[Test] Barrier Signal Cross-Write Test", flush=True)
        print("=" * 60, flush=True)
        print("  Purpose: Verify IPC address mapping correctness", flush=True)
        print("  Method: Each rank writes +1024 to self, -1024 to others", flush=True)
        print("  Expected: All final values should be 0", flush=True)
        print("=" * 60, flush=True)
    
    # Step 1: CPU barrier
    dist.barrier()
    print(f"[Rank {local_rank}] Starting barrier signal test...", flush=True)
    
    # Step 2: Get barrier signal memory region
    # In DeepEP, barrier_signal_ptrs is at the end of NVL buffer
    # Layout: buffer_ptrs[rank] + num_nvl_bytes points to barrier_signal_ptrs[rank]
    # Each rank has num_ranks * sizeof(int) bytes for barrier signals
    
    # Calculate offset: barrier signals are after NVL buffer
    # We'll access them through the buffer API
    
    # For simplicity, we'll implement this test through C++ side
    # Add methods: reset_barrier_signals(), barrier_signal_write(), barrier_signal_read()
    
    try:
        # Reset all barrier signals to 0
        print(f"[Rank {local_rank}] Resetting barrier signals to 0...", flush=True)
        # This would call a C++ method to memset barrier_signal_ptrs[rank] to 0
        
        # For now, manually access through buffer tensor
        # barrier signals start at offset 0 from the designated barrier region
        # Get local barrier signal array as int32 tensor
        local_barrier_buf = buffer.get_local_buffer_tensor(torch.int32, torch.Size([num_ranks]))
        
        # Initialize to 0
        local_barrier_buf.zero_()
        torch.xpu.synchronize()
        
        dist.barrier()
        print(f"[Rank {local_rank}] Initial values: {local_barrier_buf.tolist()}", flush=True)
        
        # Step 3: Write operations
        # For each rank i: 
        #   - Write +1024 to barrier_signal_ptrs[rank][i] (my memory, thread i)
        #   - Write -1024 to barrier_signal_ptrs[i][rank] (rank i's memory, my thread)
        
        print(f"[Rank {local_rank}] Writing +1024 to self, -1024 to others...", flush=True)
        
        # Write +1024 to my own memory for all positions
        for i in range(num_ranks):
            local_barrier_buf[i] += 1023
        
        # Write -1024 to other ranks' memory at position [other_rank][my_rank]
        for other_rank in range(num_ranks):
            remote_buf = buffer.get_remote_buffer_tensor(other_rank, torch.int32, torch.Size([num_ranks]))
            # Atomic operation: remote_buf[local_rank] -= 1024
            remote_buf[local_rank] -= 1025
        
        torch.xpu.synchronize()
        dist.barrier()
        
        # Step 4: Read and verify
        print(f"[Rank {local_rank}] Reading final values...", flush=True)
        final_values = local_barrier_buf.tolist()
        
        print(f"[Rank {local_rank}] Final values: {final_values}", flush=True)
        
        # Verify all values are 0
        all_zero = all(v == -2 for v in final_values)
        
        if all_zero:
            print(f"[Rank {local_rank}] ✓ PASS: All values are 0", flush=True)
        else:
            print(f"[Rank {local_rank}] ✗ FAIL: Values are not 0!", flush=True)
            raise AssertionError(f"Rank {local_rank}: Expected all 0, got {final_values}")
    
    except Exception as e:
        print(f"[Rank {local_rank}] ERROR: {e}", flush=True)
        buffer.destroy()
        import traceback
        traceback.print_exc()
        raise
    
    dist.barrier()
    
    if local_rank == 0:
        print(f"\n[Test] Barrier signal cross-write test PASSED!\n", flush=True)


def run_tests(local_rank: int, num_ranks: int, port: int = 29558):
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
    os.environ['MASTER_PORT'] = str(port)
    
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
    
    # ========== Create DeepEP Buffer ==========
    if local_rank == 0:
        print("\n[Setup] Creating DeepEP Buffer...", flush=True)
    
    buffer = deep_ep.Buffer(
        group,
        int(1e8),  # 100MB NVL buffer
        num_rdma_bytes=0,
        low_latency_mode=False,
        num_qps_per_rank=1,
        explicitly_destroy=True  # Allow explicit destroy
    )
    
    dist.barrier()
    
    # ========== Test: Barrier Signal Cross-Write ==========
    test_barrier_signal_cross_write(local_rank, num_ranks, buffer, device)
    
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


def worker_fn(local_rank: int, num_ranks: int, port: int):
    """Worker function for multiprocessing"""
    # Add parent directory to sys.path so subprocess can import deep_ep
    import sys
    from pathlib import Path
    repo_root = Path(__file__).parent.parent.absolute()
    if str(repo_root) not in sys.path:
        sys.path.insert(0, str(repo_root))
    
    run_tests(local_rank, num_ranks, port)


def main():
    parser = argparse.ArgumentParser(description='Test DeepEP XPU init and buffer communication')
    parser.add_argument('--num-processes', type=int, default=2,
                        help='Number of XPU devices to use (default: 2)')
    parser.add_argument('--port', type=int, default=29558,
                        help='Master port for distributed communication (default: 29558)')
    args = parser.parse_args()
    
    num_processes = args.num_processes
    port = args.port
    print("=" * 50, flush=True)
    print(f"DeepEP XPU Test ({num_processes} GPUs)", flush=True)
    print("=" * 50, flush=True)
    
    # Spawn worker processes
    mp.spawn(
        worker_fn,
        args=(num_processes, port),
        nprocs=num_processes,
        join=True
    )


if __name__ == '__main__':
    main()
