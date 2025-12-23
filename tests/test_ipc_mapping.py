"""
Test IPC Address Mapping for DeepEP XPU.

This test verifies that IPC memory mapping is working correctly across multiple
XPU devices. It tests whether:
1. Write kernel: Each rank can write to its own barrier_signal_ptrs[rank] + thread_id
   with value = rank * 1000 + thread_id
2. Read kernel: Each rank can read from barrier_signal_ptrs[thread_id] + rank
   and verify the value equals thread_id * 1000 + rank

Usage:
    # Test with 2 ranks
    python tests/test_ipc_mapping.py --num-processes 2 --port 29567
    
    # Test with 4 ranks  
    python tests/test_ipc_mapping.py --num-processes 4 --port 29567
    
    # Test with 8 ranks
    python tests/test_ipc_mapping.py --num-processes 8 --port 29567
"""

import argparse
import os
import sys
import time

# 确保 deep_ep 模块可以被找到
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

import torch
import torch.distributed as dist
import torch.multiprocessing as mp

# 在主进程中先导入 deep_ep 以验证模块存在
import deep_ep


def test_ipc_mapping(local_rank: int, num_ranks: int, args):
    """
    Test IPC address mapping by:
    1. All ranks write their unique values using ipc_test_write
    2. Synchronize via dist.barrier()
    3. All ranks read and verify values using ipc_test_read
    """
    # deep_ep 已在主进程中导入，子进程也能使用
    
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
        print("\n" + "="*60, flush=True)
        print("[Setup] Creating DeepEP Buffer...", flush=True)
        print("="*60, flush=True)
    
    buffer = deep_ep.Buffer(
        group,
        int(2e8),  # 200MB NVL buffer
        num_rdma_bytes=0,
        low_latency_mode=False,
        num_qps_per_rank=1,
        explicitly_destroy=True
    )
    
    print(f"[Rank {local_rank}] Buffer created: rank={buffer.rank}, num_ranks={buffer.group_size}", flush=True)
    
    dist.barrier()
    
    # ========== Phase 1: Write Test ==========
    if local_rank == 0:
        print("\n" + "="*60, flush=True)
        print("[Phase 1] IPC WRITE TEST", flush=True)
        print("  Each rank writes to barrier_signal_ptrs[rank] + thread_id", flush=True)
        print("  Write value = rank * 1000 + thread_id", flush=True)
        print("="*60, flush=True)
    
    dist.barrier()
    
    try:
        print(f"[Rank {local_rank}] Calling test_ipc_write...", flush=True)
        start_time = time.time()
        buffer.runtime.test_ipc_write()
        elapsed = time.time() - start_time
        print(f"[Rank {local_rank}] test_ipc_write completed in {elapsed*1000:.2f} ms", flush=True)
    except Exception as e:
        print(f"[Rank {local_rank}] ERROR in test_ipc_write: {e}", flush=True)
        import traceback
        traceback.print_exc()
        raise
    
    # Synchronize after write
    torch.xpu.synchronize()
    dist.barrier()
    
    if local_rank == 0:
        print("\n[Phase 1] All ranks completed write phase.", flush=True)
    
    # ========== Phase 2: Read Test ==========
    if local_rank == 0:
        print("\n" + "="*60, flush=True)
        print("[Phase 2] IPC READ TEST", flush=True)
        print("  Each rank reads from barrier_signal_ptrs[thread_id] + rank", flush=True)
        print("  Expected value = thread_id * 1000 + rank", flush=True)
        print("="*60, flush=True)
    
    dist.barrier()
    
    try:
        print(f"[Rank {local_rank}] Calling test_ipc_read...", flush=True)
        start_time = time.time()
        buffer.runtime.test_ipc_read()
        elapsed = time.time() - start_time
        print(f"[Rank {local_rank}] test_ipc_read completed in {elapsed*1000:.2f} ms", flush=True)
    except Exception as e:
        print(f"[Rank {local_rank}] ERROR in test_ipc_read: {e}", flush=True)
        import traceback
        traceback.print_exc()
        raise
    
    torch.xpu.synchronize()
    dist.barrier()
    
    # ========== Summary ==========
    if local_rank == 0:
        print("\n" + "="*60, flush=True)
        print("[Summary] IPC MAPPING TEST COMPLETED", flush=True)
        print("  Check the kernel output above for CORRECT/MISMATCH markers.", flush=True)
        print("  If all reads show CORRECT, IPC mapping is working properly.", flush=True)
        print("="*60, flush=True)
    
    # ========== Cleanup ==========
    buffer.destroy()
    dist.barrier()
    dist.destroy_process_group()
    
    if local_rank == 0:
        print("\n[Cleanup] Test completed successfully!", flush=True)


def main_worker(local_rank: int, num_ranks: int, args):
    """Main worker function for each process."""
    try:
        test_ipc_mapping(local_rank, num_ranks, args)
    except Exception as e:
        print(f"[Rank {local_rank}] FATAL ERROR: {e}", flush=True)
        import traceback
        traceback.print_exc()
        raise


def main():
    parser = argparse.ArgumentParser(description='Test IPC Address Mapping for DeepEP XPU')
    parser.add_argument('--num-processes', '-n', type=int, default=2,
                        help='Number of processes/ranks to use (default: 2)')
    parser.add_argument('--port', '-p', type=int, default=29567,
                        help='Port for distributed communication (default: 29567)')
    args = parser.parse_args()
    
    num_ranks = args.num_processes
    
    # Validate num_ranks
    if num_ranks not in [1, 2, 4, 8]:
        print(f"Error: num_processes must be 1, 2, 4, or 8. Got {num_ranks}", file=sys.stderr)
        sys.exit(1)
    
    print(f"Starting IPC mapping test with {num_ranks} processes...", flush=True)
    print(f"Port: {args.port}", flush=True)
    print("="*60, flush=True)
    
    # Use spawn to start multiple processes
    mp.spawn(
        main_worker,
        args=(num_ranks, args),
        nprocs=num_ranks,
        join=True
    )
    
    print("\n" + "="*60, flush=True)
    print("All processes finished.", flush=True)
    print("="*60, flush=True)


if __name__ == '__main__':
    main()
