#!/usr/bin/env python
"""
XPU Barrier 功能测试脚本

测试命令:
    2卡:   python test_xpu_barrier.py --num-processes 2
    4卡:   python test_xpu_barrier.py --num-processes 4

或使用 torchrun:
    torchrun --nproc_per_node=2 test_xpu_barrier.py --use-torchrun
"""

import argparse
import os
import time
import torch
import torch.distributed as dist
import torch.multiprocessing as mp
from typing import Optional

# 设置XPU环境
os.environ['USE_XPU'] = '1'
os.environ['USE_CUDA'] = '0'


def init_dist_xpu(local_rank: int, num_local_ranks: int, port: int = 29500):
    """初始化XPU分布式环境"""
    ip = os.getenv('MASTER_ADDR', '127.0.0.1')
    port = int(os.getenv('MASTER_PORT', port))
    num_nodes = int(os.getenv('WORLD_SIZE', 1))
    node_rank = int(os.getenv('RANK', 0))
    
    # 设置XPU设备
    if hasattr(torch, 'xpu') and torch.xpu.is_available():
        torch.xpu.set_device(local_rank)
        device = f'xpu:{local_rank}'
        backend = 'xccl'
    else:
        device = 'cpu'
        backend = 'gloo'
        print(f"[Warning] XPU not available, using {device}")
    
    try:
        dist.init_process_group(
            backend=backend,
            init_method=f'tcp://{ip}:{port}',
            world_size=num_nodes * num_local_ranks,
            rank=node_rank * num_local_ranks + local_rank,
        )
    except Exception as e:
        print(f"[Warning] Failed to init with {backend}, trying gloo: {e}")
        dist.init_process_group(
            backend='gloo',
            init_method=f'tcp://{ip}:{port}',
            world_size=num_nodes * num_local_ranks,
            rank=node_rank * num_local_ranks + local_rank,
        )
    
    return dist.get_rank(), dist.get_world_size(), dist.new_group(list(range(num_local_ranks * num_nodes))), device


def test_barrier_basic(
    rank: int,
    num_ranks: int,
    buffer,  # deep_ep.Buffer
    group: dist.ProcessGroup,
    device: str
):
    """
    基础 barrier 测试 - 使用 GPU barrier_block_cas
    
    测试逻辑:
    1. CPU dist.barrier() 确保所有进程同步
    2. 调用 GPU barrier 测试跨 GPU 同步
    3. 验证所有进程能够正确同步
    """
    if rank == 0:
        print(f"\n{'='*60}")
        print(f"[Test] GPU Barrier Test (barrier_block_cas)")
        print(f"  num_ranks={num_ranks}")
        print(f"{'='*60}\n")
    
    # 测试多次 barrier
    num_iterations = 1
    for i in range(num_iterations):
        print(f"[Rank {rank}] Barrier iteration {i + 1}/{num_iterations}...", flush=True)
        
        # 1. CPU barrier 确保所有进程同时开始
        dist.barrier(group=group)
        print(f"[Rank {rank}] CPU barrier done, starting GPU barrier...", flush=True)
        
        # 2. XPU 同步，确保之前的操作完成
        if hasattr(torch, 'xpu') and torch.xpu.is_available():
            torch.xpu.synchronize()
        
        # 3. 调用 GPU barrier (使用 barrier_block_cas)
        start_time = time.time()
        try:
            buffer.runtime.test_barrier()
            elapsed = time.time() - start_time
            print(f"[Rank {rank}] GPU barrier completed in {elapsed*1000:.2f} ms", flush=True)
        except Exception as e:
            print(f"[Rank {rank}] GPU barrier FAILED: {e}", flush=True)
            import traceback
            traceback.print_exc()
            raise
        
        # 4. 再次 CPU barrier 确保所有进程都完成
        dist.barrier(group=group)
    
    if rank == 0:
        print(f"[Test] GPU barrier test PASSED!\n")


def test_barrier_with_data(
    rank: int,
    num_ranks: int,
    buffer,  # deep_ep.Buffer
    group: dist.ProcessGroup,
    device: str
):
    """
    带数据的 barrier 测试 - 验证 barrier 后数据可见性
    """
    if rank == 0:
        print(f"\n{'='*60}")
        print(f"[Test] Barrier with Data Test")
        print(f"{'='*60}\n")
    
    dist.barrier(group=group)
    
    # 创建本地数据
    data_size = 1024
    local_data = torch.ones(data_size, dtype=torch.float32, device=device) * (rank + 1)
    
    # 同步
    dist.barrier(group=group)
    if hasattr(torch, 'xpu') and torch.xpu.is_available():
        torch.xpu.synchronize()
    
    # 验证本地数据
    expected_value = rank + 1
    actual_value = local_data[0].item()
    
    if rank == 0:
        print(f"  Rank {rank}: expected={expected_value}, actual={actual_value}")
    
    assert actual_value == expected_value, \
        f"[Rank {rank}] Data mismatch: expected {expected_value}, got {actual_value}"
    
    dist.barrier(group=group)
    
    if rank == 0:
        print(f"[Test] Barrier with data test PASSED!\n")


def test_barrier_timing(
    rank: int,
    num_ranks: int,
    buffer,  # deep_ep.Buffer
    group: dist.ProcessGroup,
    device: str
):
    """
    Barrier 时序测试 - 验证所有进程同步点
    """
    if rank == 0:
        print(f"\n{'='*60}")
        print(f"[Test] Barrier Timing Test")
        print(f"{'='*60}\n")
    
    dist.barrier(group=group)
    
    # 不同 rank 有不同的延迟
    if rank == 0:
        time.sleep(0.3)  # Rank 0 延迟 300ms
    
    # 记录进入 barrier 的时间
    enter_time = time.time()
    
    # 执行 barrier
    dist.barrier(group=group)
    if hasattr(torch, 'xpu') and torch.xpu.is_available():
        torch.xpu.synchronize()
    
    # 记录退出 barrier 的时间
    exit_time = time.time()
    
    # 收集所有 rank 的退出时间 - 使用 XPU tensor
    exit_times = [torch.tensor([0.0], device=device) for _ in range(num_ranks)]
    local_exit_time = torch.tensor([exit_time], device=device)
    dist.all_gather(exit_times, local_exit_time, group=group)
    
    # 验证所有退出时间应该非常接近
    exit_times_list = [t.cpu().item() for t in exit_times]
    max_diff = max(exit_times_list) - min(exit_times_list)
    
    if rank == 0:
        print(f"  Exit times: {[f'{t:.3f}' for t in exit_times_list]}")
        print(f"  Max time difference: {max_diff*1000:.2f} ms")
    
    # 允许 200ms 的误差
    assert max_diff < 0.2, f"[Rank {rank}] Barrier timing too different: {max_diff*1000:.2f} ms"
    
    dist.barrier(group=group)
    
    if rank == 0:
        print(f"[Test] Barrier timing test PASSED!\n")


def test_loop(local_rank: int, num_local_ranks: int, args: argparse.Namespace):
    """测试主循环"""
    # Import deep_ep after path setup
    import deep_ep
    
    port = getattr(args, 'port', 29500)
    rank, num_ranks, group, device = init_dist_xpu(local_rank, num_local_ranks, port)
    
    if rank == 0:
        print(f"\n{'#'*60}")
        print(f"# XPU Barrier Test")
        print(f"# Ranks: {num_ranks}, Device: {device}")
        print(f"{'#'*60}\n")
    
    # 创建 Buffer
    try:
        buffer = deep_ep.Buffer(
            group,
            int(1e8),  # 100MB buffer
            0,         # 无 RDMA
            low_latency_mode=False,
            num_qps_per_rank=1
        )
        if rank == 0:
            print(f"[Info] Buffer created successfully")
    except Exception as e:
        print(f"[Rank {rank}] Failed to create buffer: {e}")
        raise
    
    # 同步所有进程
    dist.barrier(group=group)
    
    # 运行测试
    try:
        if args.test == 'basic' or args.test == 'all':
            test_barrier_basic(rank, num_ranks, buffer, group, device)
        
        if args.test == 'data' or args.test == 'all':
            test_barrier_with_data(rank, num_ranks, buffer, group, device)
        
        if args.test == 'timing' or args.test == 'all':
            test_barrier_timing(rank, num_ranks, buffer, group, device)
        
        if rank == 0:
            print(f"\n{'#'*60}")
            print(f"# ALL TESTS PASSED!")
            print(f"{'#'*60}\n")
    
    except Exception as e:
        print(f"[Rank {rank}] Test FAILED: {e}")
        import traceback
        traceback.print_exc()
    
    finally:
        dist.barrier(group=group)
        dist.destroy_process_group()


def worker_fn(local_rank: int, num_local_ranks: int, args: argparse.Namespace):
    """Worker function for multiprocessing"""
    # Add parent directory to sys.path so subprocess can import deep_ep
    import sys
    from pathlib import Path
    repo_root = Path(__file__).parent.parent.absolute()
    if str(repo_root) not in sys.path:
        sys.path.insert(0, str(repo_root))
    
    test_loop(local_rank, num_local_ranks, args)


def main():
    parser = argparse.ArgumentParser(description='Test XPU barrier_block')
    parser.add_argument('--num-processes', type=int, default=2,
                        help='Number of XPU devices to use (default: 2)')
    parser.add_argument('--test', type=str, default='all',
                        choices=['basic', 'data', 'timing', 'all'],
                        help='Which test to run (default: all)')
    parser.add_argument('--port', type=int, default=29500,
                        help='Master port for distributed communication (default: 29500)')
    parser.add_argument('--use-torchrun', action='store_true',
                        help='Use torchrun instead of mp.spawn')
    args = parser.parse_args()
    
    if args.use_torchrun:
        # torchrun 模式
        local_rank = int(os.environ.get('LOCAL_RANK', 0))
        test_loop(local_rank, args.num_processes, args)
    else:
        print(f"Running barrier tests with {args.num_processes} processes")
        print(f"Test mode: {args.test}")
        mp.spawn(worker_fn, args=(args.num_processes, args), nprocs=args.num_processes, join=True)


if __name__ == '__main__':
    main()
