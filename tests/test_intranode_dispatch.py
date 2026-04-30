#!/usr/bin/env python
"""
XPU Intranode Dispatch 功能测试脚本

测试命令:
    单卡:  python test_xpu_intranode_dispatch.py --num-processes 1
    4卡:   python test_xpu_intranode_dispatch.py --num-processes 4
    8卡:   python test_xpu_intranode_dispatch.py --num-processes 8

或使用 torchrun:
    torchrun --nproc_per_node=4 test_xpu_intranode_dispatch.py --use-torchrun
"""

import argparse
import os
import time
import torch
import torch.distributed as dist
from typing import Optional

# 设置XPU环境
os.environ['USE_XPU'] = '1'
os.environ['USE_CUDA'] = '0'

import deep_ep


def init_dist_xpu(local_rank: int, num_local_ranks: int):
    """初始化XPU分布式环境"""
    ip = os.getenv('MASTER_ADDR', '127.0.0.1')
    port = int(os.getenv('MASTER_PORT', '29500'))
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


def inplace_unique(tensor: torch.Tensor, num_ranks: int):
    """对每行进行去重，只保留第一次出现的值"""
    for row_idx in range(tensor.size(0)):
        seen = set()
        for col_idx in range(tensor.size(1)):
            val = tensor[row_idx, col_idx].item()
            if val in seen or val < 0:
                tensor[row_idx, col_idx] = -1
            else:
                seen.add(val)


def test_dispatch_basic(
    rank: int,
    num_ranks: int,
    buffer: deep_ep.Buffer,
    group: dist.ProcessGroup,
    device: str,
    num_tokens: int = 256,
    hidden: int = 1024,
    num_topk: int = 2,
    num_experts: int = 8
):
    """
    基础dispatch功能测试
    
    测试逻辑:
    1. 创建输入数据 x，每个rank的数据填充为rank值
    2. 创建随机的topk路由
    3. 执行dispatch
    4. 验证接收到的数据是否正确
    """
    if rank == 0:
        print(f"\n{'='*60}")
        print(f"[Test] Basic Dispatch Test")
        print(f"  num_tokens={num_tokens}, hidden={hidden}")
        print(f"  num_topk={num_topk}, num_experts={num_experts}")
        print(f"  num_ranks={num_ranks}")
        print(f"{'='*60}")
    
    # 确保专家数能被rank数整除
    assert num_experts % num_ranks == 0, f"num_experts ({num_experts}) must be divisible by num_ranks ({num_ranks})"
    
    # 创建输入数据 - 每个rank的x填充为rank值，便于验证
    x = torch.ones((num_tokens, hidden), dtype=torch.bfloat16, device=device) * rank
    
    # 创建随机的专家路由
    torch.manual_seed(42 + rank)  # 固定种子确保可重复
    scores = torch.randn((num_tokens, num_experts), dtype=torch.float32, device=device).abs() + 1
    topk_idx = torch.topk(scores, num_topk, dim=-1, largest=True, sorted=False)[1]
    topk_idx = topk_idx.to(torch.int64)
    topk_weights = torch.ones((num_tokens, num_topk), dtype=torch.float32, device=device) * (rank + 1)
    
    # 计算rank路由
    num_experts_per_rank = num_experts // num_ranks
    rank_idx = topk_idx // num_experts_per_rank
    rank_idx = rank_idx.to(torch.int64)
    rank_idx.masked_fill_(topk_idx == -1, -1)
    inplace_unique(rank_idx, num_ranks)
    
    # 计算每个rank/expert的token数
    num_tokens_per_rank = torch.zeros((num_ranks,), dtype=torch.int, device=device)
    for i in range(num_ranks):
        num_tokens_per_rank[i] = (rank_idx == i).any(dim=-1).sum()
    
    num_tokens_per_expert = torch.zeros((num_experts,), dtype=torch.int, device=device)
    for i in range(num_experts):
        num_tokens_per_expert[i] = (topk_idx == i).sum()
    
    # 计算is_token_in_rank
    is_token_in_rank = torch.zeros((num_tokens, num_ranks), dtype=torch.bool, device=device)
    for i in range(num_ranks):
        is_token_in_rank[:, i] = (rank_idx == i).any(dim=-1)
    
    if rank == 0:
        print(f"[Info] num_tokens_per_rank: {num_tokens_per_rank.tolist()}")
        print(f"[Info] Total tokens to send: {num_tokens_per_rank.sum().item()}")
    
    # 配置
    num_sms = 20
    nvl_buffer_size = 256
    config = deep_ep.Config(num_sms, 8, nvl_buffer_size)
    
    # 执行dispatch
    try:
        if rank == 0:
            print(f"[Info] Executing dispatch...")
        
        dispatch_args = {
            'x': x,
            'num_tokens_per_rank': num_tokens_per_rank,
            'is_token_in_rank': is_token_in_rank,
            'num_tokens_per_expert': num_tokens_per_expert,
            'config': config,
            'topk_idx': topk_idx,
            'topk_weights': topk_weights,
        }
        # print(f"[Info] Dispatch args:", dispatch_args)
        recv_x, recv_topk_idx, recv_topk_weights, recv_num_tokens_per_expert_list, handle, event = \
            buffer.dispatch(**dispatch_args)
        
        # 等待完成 - XPU可能不返回有效的event
        if event is not None and hasattr(event, 'event') and event.event is not None:
            event.current_stream_wait()
        elif hasattr(torch, 'xpu'):
            torch.xpu.synchronize()
        
        # 获取前缀矩阵
        rank_prefix_matrix = handle[0]
        num_recv_tokens = recv_x.size(0)
        
        if rank == 0:
            print(f"[Result] Received {num_recv_tokens} tokens")
            print(f"[Result] recv_x shape: {recv_x.shape}")
            if recv_topk_idx is not None:
                print(f"[Result] recv_topk_idx shape: {recv_topk_idx.shape}")
        
        # 验证数据
        # 检查接收到的数据：每个来自rank i的token，其x值应该都是i
        check_passed = True
        check_start = 0
        for i in range(num_ranks):
            check_end = rank_prefix_matrix[i][rank].item() if i < rank_prefix_matrix.size(0) else check_start
            if check_end > check_start:
                segment = recv_x[check_start:check_end, :]
                expected_val = i
                actual_min = segment.float().min().item()
                actual_max = segment.float().max().item()
                
                if abs(actual_min - expected_val) > 0.01 or abs(actual_max - expected_val) > 0.01:
                    print(f"[Error] Rank {rank}: Data from rank {i} incorrect. "
                          f"Expected {expected_val}, got min={actual_min}, max={actual_max}")
                    check_passed = False
            check_start = check_end
        
        if check_passed:
            print(f"[Rank {rank}] ✓ Data verification PASSED")
        else:
            print(f"[Rank {rank}] ✗ Data verification FAILED")
        
        return check_passed
        
    except Exception as e:
        print(f"[Rank {rank}] ✗ Dispatch failed with error: {e}")
        import traceback
        traceback.print_exc()
        return False


def test_dispatch_performance(
    rank: int,
    num_ranks: int,
    buffer: deep_ep.Buffer,
    group: dist.ProcessGroup,
    device: str,
    num_tokens: int = 4096,
    hidden: int = 4096,
    num_topk: int = 4,
    num_experts: int = 64,
    num_iterations: int = 10
):
    """性能测试（简化版）"""
    if rank == 0:
        print(f"\n{'='*60}")
        print(f"[Test] Performance Test")
        print(f"  num_tokens={num_tokens}, hidden={hidden}")
        print(f"  num_topk={num_topk}, num_experts={num_experts}")
        print(f"  iterations={num_iterations}")
        print(f"{'='*60}")
    
    assert num_experts % num_ranks == 0
    
    # 准备数据
    x = torch.randn((num_tokens, hidden), dtype=torch.bfloat16, device=device)
    
    torch.manual_seed(42)
    scores = torch.randn((num_tokens, num_experts), dtype=torch.float32, device=device).abs() + 1
    topk_idx = torch.topk(scores, num_topk, dim=-1, largest=True, sorted=False)[1].to(torch.int64)
    topk_weights = torch.randn((num_tokens, num_topk), dtype=torch.float32, device=device)
    
    num_experts_per_rank = num_experts // num_ranks
    rank_idx = topk_idx // num_experts_per_rank
    rank_idx.masked_fill_(topk_idx == -1, -1)
    inplace_unique(rank_idx, num_ranks)
    
    num_tokens_per_rank = torch.zeros((num_ranks,), dtype=torch.int, device=device)
    for i in range(num_ranks):
        num_tokens_per_rank[i] = (rank_idx == i).any(dim=-1).sum()
    
    num_tokens_per_expert = torch.zeros((num_experts,), dtype=torch.int, device=device)
    for i in range(num_experts):
        num_tokens_per_expert[i] = (topk_idx == i).sum()
    
    is_token_in_rank = torch.zeros((num_tokens, num_ranks), dtype=torch.bool, device=device)
    for i in range(num_ranks):
        is_token_in_rank[:, i] = (rank_idx == i).any(dim=-1)
    
    num_sms = 20
    config = deep_ep.Config(num_sms, 8, 256)
    
    dispatch_args = {
        'x': x,
        'num_tokens_per_rank': num_tokens_per_rank,
        'is_token_in_rank': is_token_in_rank,
        'num_tokens_per_expert': num_tokens_per_expert,
        'config': config,
        'topk_idx': topk_idx,
        'topk_weights': topk_weights,
    }
    
    # Warmup
    for _ in range(3):
        try:
            _, _, _, _, _, event = buffer.dispatch(**dispatch_args)
            if event is not None and hasattr(event, 'event') and event.event is not None:
                event.current_stream_wait()
            elif hasattr(torch, 'xpu'):
                torch.xpu.synchronize()
        except Exception as e:
            print(f"[Rank {rank}] Warmup failed: {e}")
            return
    
    # 同步
    dist.barrier(group)
    
    # 计时
    if hasattr(torch, 'xpu'):
        torch.xpu.synchronize()
    
    start_time = time.time()
    for _ in range(num_iterations):
        _, _, _, _, _, event = buffer.dispatch(**dispatch_args)
        if event is not None and hasattr(event, 'event') and event.event is not None:
            event.current_stream_wait()
        elif hasattr(torch, 'xpu'):
            torch.xpu.synchronize()
    
    if hasattr(torch, 'xpu'):
        torch.xpu.synchronize()
    
    elapsed = time.time() - start_time
    avg_time = elapsed / num_iterations
    
    # 计算带宽
    bytes_per_token = hidden * 2  # BF16
    total_bytes = num_tokens * bytes_per_token * num_ranks  # 估算
    bandwidth_gb = total_bytes / avg_time / 1e9
    
    if rank == 0:
        print(f"[Perf] Average time: {avg_time * 1000:.3f} ms")
        print(f"[Perf] Estimated bandwidth: {bandwidth_gb:.2f} GB/s")


def test_loop(local_rank: int, num_local_ranks: int, args: argparse.Namespace):
    """主测试循环"""
    # 初始化分布式环境
    rank, num_ranks, group, device = init_dist_xpu(local_rank, num_local_ranks)
    
    if rank == 0:
        print(f"\n{'#'*60}")
        print(f"# XPU Intranode Dispatch Test")
        print(f"# Ranks: {num_ranks}, Device: {device}")
        print(f"{'#'*60}")
    
    # 创建Buffer
    try:
        buffer = deep_ep.Buffer(
            group,
            num_nvl_bytes=int(1e9),  # 1GB NVL buffer
            num_rdma_bytes=0,
            low_latency_mode=False,
            explicitly_destroy=True
        )
    except Exception as e:
        print(f"[Rank {rank}] Failed to create buffer: {e}")
        import traceback
        traceback.print_exc()
        dist.destroy_process_group()
        return
    
    torch.manual_seed(rank)
    
    # 运行测试
    all_passed = True
    
    # 测试1: 基础功能测试（小规模）
    if args.test_basic:
        passed = test_dispatch_basic(
            rank, num_ranks, buffer, group, device,
            num_tokens=args.num_tokens,
            hidden=args.hidden,
            num_topk=args.num_topk,
            num_experts=max(args.num_experts, num_ranks)
        )
        all_passed = all_passed and passed
    
    # 测试2: 性能测试
    if args.test_perf:
        test_dispatch_performance(
            rank, num_ranks, buffer, group, device,
            num_tokens=args.num_tokens * 4,
            hidden=args.hidden,
            num_topk=args.num_topk,
            num_experts=max(args.num_experts, num_ranks)
        )
    
    # 清理
    dist.barrier(group)
    buffer.destroy()
    dist.barrier()
    dist.destroy_process_group()
    
    if rank == 0:
        print(f"\n{'#'*60}")
        if all_passed:
            print("# All tests PASSED ✓")
        else:
            print("# Some tests FAILED ✗")
        print(f"{'#'*60}\n")


def main():
    parser = argparse.ArgumentParser(description='XPU Intranode Dispatch Test')
    parser.add_argument('--num-processes', type=int, default=2, 
                        help='Number of processes to spawn (default: 1)')
    parser.add_argument('--num-tokens', type=int, default=32, 
                        help='Number of tokens (default: 256)')
    parser.add_argument('--hidden', type=int, default=1024, 
                        help='Hidden dimension size (default: 1024)')
    parser.add_argument('--num-topk', type=int, default=2, 
                        help='Number of top-k experts (default: 2)')
    parser.add_argument('--num-experts', type=int, default=8, 
                        help='Number of experts (default: 8)')
    parser.add_argument('--test-basic', action='store_true', default=True,
                        help='Run basic functionality test')
    parser.add_argument('--test-perf', action='store_true', default=False,
                        help='Run performance test')
    parser.add_argument('--use-torchrun', action='store_true',
                        help='Use torchrun launcher (single process mode)')
    args = parser.parse_args()
    
    if args.use_torchrun:
        # 使用torchrun时，直接运行当前进程
        local_rank = int(os.environ.get('LOCAL_RANK', 0))
        world_size = int(os.environ.get('WORLD_SIZE', 1))
        test_loop(local_rank, world_size, args)
    else:
        # 使用multiprocessing spawn
        num_processes = args.num_processes
        print(f"Starting {num_processes} processes...")
        torch.multiprocessing.spawn(
            test_loop, 
            args=(num_processes, args), 
            nprocs=num_processes,
            join=True
        )


if __name__ == '__main__':
    main()
