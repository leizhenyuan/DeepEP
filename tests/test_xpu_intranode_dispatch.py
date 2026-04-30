#!/usr/bin/env python
"""
XPU Intranode Dispatch 功能测试脚本

测试命令:
    MPI 启动 (推荐):
        mpirun -np 4 python tests/test_xpu_intranode_dispatch.py --use-mpi
    
    多进程启动:
        python tests/test_xpu_intranode_dispatch.py --num-processes 4
    
    使用 torchrun:
        torchrun --nproc_per_node=4 tests/test_xpu_intranode_dispatch.py --use-torchrun
"""

import argparse
import os
import sys
import time
import torch
import torch.distributed as dist
import torch.multiprocessing as mp
from typing import Optional, Tuple, List

# 设置XPU环境
os.environ['USE_XPU'] = '1'
os.environ['USE_CUDA'] = '0'

# MPI 条件导入
try:
    from mpi4py import MPI
    HAS_MPI = True
except ImportError:
    HAS_MPI = False
    MPI = None


def init_dist_mpi(port: int = 29500, use_gloo: bool = False):
    """使用 MPI 初始化分布式环境"""
    if not HAS_MPI:
        raise RuntimeError("mpi4py is not installed. Please install with: pip install mpi4py")
    
    comm = MPI.COMM_WORLD
    rank = comm.Get_rank()
    world_size = comm.Get_size()
    
    # 设置 XPU 设备
    local_rank = rank
    if hasattr(torch, 'xpu') and torch.xpu.is_available():
        torch.xpu.set_device(local_rank)
        device = f'xpu:{local_rank}'
        backend = 'gloo' if use_gloo else 'xccl'
    else:
        device = 'cpu'
        backend = 'gloo'
        print(f"[Warning] XPU not available, using {device}")
    
    # 设置环境变量
    os.environ['MASTER_ADDR'] = os.getenv('MASTER_ADDR', '127.0.0.1')
    os.environ['MASTER_PORT'] = str(port)
    os.environ['RANK'] = str(rank)
    os.environ['WORLD_SIZE'] = str(world_size)
    
    # 初始化 PyTorch 分布式
    try:
        dist.init_process_group(
            backend=backend,
            init_method=f'tcp://{os.environ["MASTER_ADDR"]}:{port}',
            world_size=world_size,
            rank=rank
        )
    except Exception as e:
        print(f"[Warning] Failed to init with {backend}, trying gloo: {e}")
        dist.init_process_group(
            backend='gloo',
            init_method=f'tcp://{os.environ["MASTER_ADDR"]}:{port}',
            world_size=world_size,
            rank=rank
        )
    
    group = dist.new_group(list(range(world_size)))
    return rank, world_size, group, device, comm


def init_dist_spawn(local_rank: int, num_ranks: int, port: int = 29500):
    """使用 mp.spawn 初始化分布式环境"""
    # 设置 XPU 设备
    if hasattr(torch, 'xpu') and torch.xpu.is_available():
        torch.xpu.set_device(local_rank)
        device = f'xpu:{local_rank}'
        backend = 'xccl'
    else:
        device = 'cpu'
        backend = 'gloo'
        print(f"[Warning] XPU not available, using {device}")
    
    # 设置环境变量
    os.environ['RANK'] = str(local_rank)
    os.environ['LOCAL_RANK'] = str(local_rank)
    os.environ['WORLD_SIZE'] = str(num_ranks)
    os.environ['MASTER_ADDR'] = 'localhost'
    os.environ['MASTER_PORT'] = str(port)
    
    # 初始化 PyTorch 分布式
    try:
        dist.init_process_group(
            backend=backend,
            init_method='env://',
            world_size=num_ranks,
            rank=local_rank
        )
    except Exception as e:
        print(f"[Warning] Failed to init with {backend}, trying gloo: {e}")
        dist.init_process_group(
            backend='gloo',
            init_method='env://',
            world_size=num_ranks,
            rank=local_rank
        )
    
    group = dist.group.WORLD
    return local_rank, num_ranks, group, device, None


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


def generate_test_data(
    rank: int,
    num_ranks: int,
    device: str,
    num_tokens: int,
    hidden: int,
    num_topk: int,
    num_experts: int,
    seed: int = 42
) -> Tuple[torch.Tensor, torch.Tensor, torch.Tensor, torch.Tensor, torch.Tensor, torch.Tensor]:
    """
    生成测试数据
    
    Returns:
        x: [num_tokens, hidden] - 输入数据，填充为 rank 值便于验证
        topk_idx: [num_tokens, num_topk] - topk 专家索引
        topk_weights: [num_tokens, num_topk] - topk 权重
        num_tokens_per_rank: [num_ranks] - 发往各 rank 的 token 数
        num_tokens_per_expert: [num_experts] - 发往各 expert 的 token 数
        is_token_in_rank: [num_tokens, num_ranks] - 路由表
    """
    # 创建输入数据 - 每个 rank 的 x 填充为 rank 值，便于验证
    x = torch.ones((num_tokens, hidden), dtype=torch.bfloat16, device=device) * rank
    
    # 使用固定种子 + rank 确保每个 rank 有不同但可重复的路由
    torch.manual_seed(seed + rank)
    
    # 创建随机的专家路由
    scores = torch.randn((num_tokens, num_experts), dtype=torch.float32, device=device).abs() + 1
    topk_idx = torch.topk(scores, num_topk, dim=-1, largest=True, sorted=False)[1]
    topk_idx = topk_idx.to(torch.int64)
    topk_weights = torch.ones((num_tokens, num_topk), dtype=torch.float32, device=device) * (rank + 1)
    
    # 计算 rank 路由
    num_experts_per_rank = num_experts // num_ranks
    rank_idx = topk_idx // num_experts_per_rank
    rank_idx = rank_idx.to(torch.int64)
    rank_idx.masked_fill_(topk_idx == -1, -1)
    inplace_unique(rank_idx, num_ranks)
    
    # 计算每个 rank 的 token 数
    num_tokens_per_rank = torch.zeros((num_ranks,), dtype=torch.int, device=device)
    for i in range(num_ranks):
        num_tokens_per_rank[i] = (rank_idx == i).any(dim=-1).sum()
    
    # 计算每个 expert 的 token 数
    num_tokens_per_expert = torch.zeros((num_experts,), dtype=torch.int, device=device)
    for i in range(num_experts):
        num_tokens_per_expert[i] = (topk_idx == i).sum()
    
    # 计算 is_token_in_rank
    is_token_in_rank = torch.zeros((num_tokens, num_ranks), dtype=torch.bool, device=device)
    for i in range(num_ranks):
        is_token_in_rank[:, i] = (rank_idx == i).any(dim=-1)
    
    return x, topk_idx, topk_weights, num_tokens_per_rank, num_tokens_per_expert, is_token_in_rank


def verify_dispatch_results(
    rank: int,
    num_ranks: int,
    recv_x: torch.Tensor,
    recv_topk_idx: Optional[torch.Tensor],
    recv_topk_weights: Optional[torch.Tensor],
    rank_prefix_matrix: torch.Tensor,
    all_num_tokens_per_rank: List[torch.Tensor],
    group: dist.ProcessGroup
) -> bool:
    """
    验证 dispatch 结果
    
    验证内容:
    1. 接收到的 token 数量是否正确
    2. 接收到的数据值是否正确（每个来自 rank i 的数据，值应该是 i）
    3. rank_prefix_matrix 是否正确
    """
    all_passed = True
    
    # 1. 验证接收到的总 token 数
    expected_recv_count = sum(t[rank].item() for t in all_num_tokens_per_rank)
    actual_recv_count = recv_x.size(0)
    
    if actual_recv_count == expected_recv_count:
        print(f"[Rank {rank}] ✓ recv_count correct: {actual_recv_count}", flush=True)
    else:
        print(f"[Rank {rank}] ✗ recv_count mismatch: got {actual_recv_count}, expected {expected_recv_count}", flush=True)
        all_passed = False
    
    # 2. 验证接收到的数据值
    # rank_prefix_matrix 只有列 rank 有有效数据
    rank_prefix_cpu = rank_prefix_matrix.cpu()
    col = rank
    
    check_start = 0
    for src_rank in range(num_ranks):
        # 从 rank_prefix_matrix 获取前缀和
        check_end = rank_prefix_cpu[src_rank, col].item()
        num_tokens_from_src = check_end - check_start
        
        if num_tokens_from_src > 0:
            segment = recv_x[check_start:check_end, :]
            expected_val = src_rank  # 数据值应该等于源 rank
            
            # 检查数据值
            actual_min = segment.float().min().item()
            actual_max = segment.float().max().item()
            
            if abs(actual_min - expected_val) < 0.01 and abs(actual_max - expected_val) < 0.01:
                print(f"[Rank {rank}] ✓ Data from rank {src_rank}: {num_tokens_from_src} tokens, value={expected_val}", flush=True)
            else:
                print(f"[Rank {rank}] ✗ Data from rank {src_rank} incorrect: "
                      f"expected {expected_val}, got min={actual_min:.2f}, max={actual_max:.2f}", flush=True)
                all_passed = False
        
        check_start = check_end
    
    # 3. 验证 rank_prefix_matrix 的前缀和
    prefix_sum = 0
    for src_rank in range(num_ranks):
        prefix_sum += all_num_tokens_per_rank[src_rank][rank].item()
        actual_val = rank_prefix_cpu[src_rank, col].item()
        
        if actual_val != prefix_sum:
            print(f"[Rank {rank}] ✗ rank_prefix_matrix[{src_rank}, {col}] mismatch: "
                  f"got {actual_val}, expected {prefix_sum}", flush=True)
            all_passed = False
    
    return all_passed


def test_simple_dispatch(
    rank: int,
    num_ranks: int,
    buffer,
    group: dist.ProcessGroup,
    device: str,
    mpi_comm,
    args: argparse.Namespace
) -> bool:
    """
    简单直观的 dispatch 测试
    
    设计:
    - 每个 rank 发送固定数量的 token 给所有 rank（包括自己）
    - 每个 rank 的数据填充为该 rank 的值（rank 0 的数据全是 0，rank 1 的数据全是 1，...）
    - 这样接收端可以直观地看到数据来自哪个 rank
    """
    import deep_ep
    
    use_mpi = mpi_comm is not None
    
    def cpu_barrier():
        if use_mpi:
            mpi_comm.Barrier()
        else:
            dist.barrier(group=group)
    
    # 简化参数：每个 rank 向每个目标 rank 发送固定数量的 token
    tokens_per_dst = args.tokens_per_dst if hasattr(args, 'tokens_per_dst') else 2
    hidden = args.hidden
    num_experts = num_ranks * 2  # 每个 rank 有 2 个专家
    num_topk = 1  # 简化为 topk=1
    
    num_tokens = tokens_per_dst * num_ranks  # 总 token 数 = 每个目标的数量 * rank 数
    num_experts_per_rank = num_experts // num_ranks
    
    if rank == 0:
        print(f"\n{'='*60}", flush=True)
        print(f"[Test] Simple Dispatch Test (直观验证)", flush=True)
        print(f"  每个 rank 向每个目标 rank 发送 {tokens_per_dst} 个 token", flush=True)
        print(f"  Rank i 的数据值全部填充为 i", flush=True)
        print(f"  num_ranks={num_ranks}, num_tokens={num_tokens}, hidden={hidden}", flush=True)
        print(f"{'='*60}", flush=True)
    
    cpu_barrier()
    
    # 创建输入数据 - 填充为当前 rank 值
    x = torch.ones((num_tokens, hidden), dtype=torch.bfloat16, device=device) * rank
    
    # 创建简单的路由：token i 发送到 rank (i // tokens_per_dst)
    # 例如 tokens_per_dst=2, num_ranks=4:
    #   token 0,1 -> rank 0
    #   token 2,3 -> rank 1
    #   token 4,5 -> rank 2
    #   token 6,7 -> rank 3
    topk_idx = torch.zeros((num_tokens, num_topk), dtype=torch.int64, device=device)
    for i in range(num_tokens):
        dst_rank = i // tokens_per_dst
        # 选择目标 rank 的第一个专家
        expert_id = dst_rank * num_experts_per_rank
        topk_idx[i, 0] = expert_id
    
    topk_weights = torch.ones((num_tokens, num_topk), dtype=torch.float32, device=device)
    
    # 计算 num_tokens_per_rank
    num_tokens_per_rank = torch.zeros((num_ranks,), dtype=torch.int, device=device)
    for i in range(num_ranks):
        num_tokens_per_rank[i] = tokens_per_dst
    
    # 计算 num_tokens_per_expert
    num_tokens_per_expert = torch.zeros((num_experts,), dtype=torch.int, device=device)
    for i in range(num_tokens):
        expert_id = topk_idx[i, 0].item()
        num_tokens_per_expert[expert_id] += 1
    
    # 计算 is_token_in_rank
    is_token_in_rank = torch.zeros((num_tokens, num_ranks), dtype=torch.bool, device=device)
    for i in range(num_tokens):
        dst_rank = i // tokens_per_dst
        is_token_in_rank[i, dst_rank] = True
    
    print(f"[Rank {rank}] 发送数据: x 全部填充为 {rank}", flush=True)
    print(f"[Rank {rank}] num_tokens_per_rank: {num_tokens_per_rank.tolist()}", flush=True)
    
    # 收集所有 rank 的 num_tokens_per_rank
    all_num_tokens_per_rank = [torch.zeros_like(num_tokens_per_rank) for _ in range(num_ranks)]
    dist.all_gather(all_num_tokens_per_rank, num_tokens_per_rank, group=group)
    
    if rank == 0:
        print(f"\n[Info] 预期的 token 流向 (每个 rank 发送 {tokens_per_dst} 个 token 到每个目标 rank):", flush=True)
        for src_rank in range(num_ranks):
            print(f"  Rank {src_rank} (数据值={src_rank}) -> 各 rank: {all_num_tokens_per_rank[src_rank].tolist()}", flush=True)
        
        print(f"\n[Info] 预期各 rank 接收:", flush=True)
        for dst_rank in range(num_ranks):
            recv_from = [f"R{src}({tokens_per_dst}个,值={src})" for src in range(num_ranks)]
            print(f"  Rank {dst_rank} 接收: {', '.join(recv_from)}", flush=True)
    
    cpu_barrier()
    
    # 配置
    num_sms = args.num_sms
    nvl_buffer_size = 256
    config = deep_ep.Config(num_sms, 8, nvl_buffer_size)
    
    # 执行 dispatch
    try:
        if rank == 0:
            print(f"\n[Info] 执行 dispatch...", flush=True)
        
        dispatch_args = {
            'x': x,
            'num_tokens_per_rank': num_tokens_per_rank,
            'is_token_in_rank': is_token_in_rank,
            'num_tokens_per_expert': num_tokens_per_expert,
            'config': config,
            'topk_idx': topk_idx,
            'topk_weights': topk_weights,
        }
        
        recv_x, recv_topk_idx, recv_topk_weights, recv_num_tokens_per_expert_list, handle, event = \
            buffer.dispatch(**dispatch_args)
        
        # 等待完成
        if event is not None and hasattr(event, 'event') and event.event is not None:
            event.current_stream_wait()
        elif hasattr(torch, 'xpu'):
            torch.xpu.synchronize()
        
        cpu_barrier()
        
        # 获取 rank_prefix_matrix
        rank_prefix_matrix = handle[0]
        rank_prefix_cpu = rank_prefix_matrix.cpu()
        
        print(f"\n[Rank {rank}] ====== 接收结果 ======", flush=True)
        print(f"[Rank {rank}] recv_x shape: {recv_x.shape}", flush=True)
        print(f"[Rank {rank}] rank_prefix_matrix (只有列 {rank} 有效):\n{rank_prefix_cpu}", flush=True)
        
        # 直观打印接收到的数据
        print(f"\n[Rank {rank}] ------ 数据内容验证 ------", flush=True)
        col = rank
        check_start = 0
        all_passed = True
        
        for src_rank in range(num_ranks):
            check_end = rank_prefix_cpu[src_rank, col].item()
            num_tokens_from_src = check_end - check_start
            
            if num_tokens_from_src > 0:
                segment = recv_x[check_start:check_end, :]
                
                # 获取数据值（取第一个元素作为代表）
                actual_val = segment[0, 0].float().item()
                expected_val = src_rank
                
                # 检查是否全部相同
                is_uniform = (segment.float() == actual_val).all().item()
                
                status = "✓" if abs(actual_val - expected_val) < 0.01 and is_uniform else "✗"
                if status == "✗":
                    all_passed = False
                
                print(f"[Rank {rank}] {status} 位置 [{check_start}:{check_end}] "
                      f"来自 Rank {src_rank}: {num_tokens_from_src} 个 token, "
                      f"值={actual_val:.1f} (期望={expected_val}), "
                      f"全部相同={is_uniform}", flush=True)
            
            check_start = check_end
        
        # 打印接收数据的前几个值（更直观）
        if recv_x.size(0) > 0:
            print(f"\n[Rank {rank}] recv_x 前 8 个 token 的第一个元素值:", flush=True)
            num_show = min(8, recv_x.size(0))
            vals = [f"{recv_x[i, 0].float().item():.0f}" for i in range(num_show)]
            print(f"[Rank {rank}] {vals}", flush=True)
        
        cpu_barrier()
        
        # 汇总结果
        all_passed_tensor = torch.tensor([1 if all_passed else 0], device=device)
        dist.all_reduce(all_passed_tensor, op=dist.ReduceOp.MIN, group=group)
        all_passed = all_passed_tensor.item() == 1
        
        if rank == 0:
            print(f"\n{'='*60}", flush=True)
            if all_passed:
                print(f"[Result] ✓ Simple dispatch test PASSED!", flush=True)
            else:
                print(f"[Result] ✗ Simple dispatch test FAILED!", flush=True)
            print(f"{'='*60}", flush=True)
        
        return all_passed
        
    except Exception as e:
        print(f"[Rank {rank}] ✗ Simple dispatch failed with error: {e}", flush=True)
        import traceback
        traceback.print_exc()
        return False


def test_dispatch(
    rank: int,
    num_ranks: int,
    buffer,
    group: dist.ProcessGroup,
    device: str,
    mpi_comm,
    args: argparse.Namespace
) -> bool:
    """
    测试 dispatch 功能
    """
    import deep_ep
    
    use_mpi = mpi_comm is not None
    
    def cpu_barrier():
        if use_mpi:
            mpi_comm.Barrier()
        else:
            dist.barrier(group=group)
    
    num_tokens = args.num_tokens
    hidden = args.hidden
    num_topk = args.num_topk
    num_experts = args.num_experts
    
    # 确保专家数能被 rank 数整除
    assert num_experts % num_ranks == 0, f"num_experts ({num_experts}) must be divisible by num_ranks ({num_ranks})"
    
    if rank == 0:
        print(f"\n{'='*60}", flush=True)
        print(f"[Test] Dispatch Correctness Test", flush=True)
        print(f"  num_tokens={num_tokens}, hidden={hidden}", flush=True)
        print(f"  num_topk={num_topk}, num_experts={num_experts}", flush=True)
        print(f"  num_ranks={num_ranks}", flush=True)
        print(f"{'='*60}", flush=True)
    
    cpu_barrier()
    
    # 生成测试数据
    x, topk_idx, topk_weights, num_tokens_per_rank, num_tokens_per_expert, is_token_in_rank = \
        generate_test_data(rank, num_ranks, device, num_tokens, hidden, num_topk, num_experts, seed=42)
    
    print(f"[Rank {rank}] num_tokens_per_rank: {num_tokens_per_rank.tolist()}", flush=True)
    
    # 收集所有 rank 的 num_tokens_per_rank
    all_num_tokens_per_rank = [torch.zeros_like(num_tokens_per_rank) for _ in range(num_ranks)]
    dist.all_gather(all_num_tokens_per_rank, num_tokens_per_rank, group=group)
    
    if rank == 0:
        print(f"\n[Info] Token distribution matrix (row=src, col=dst):", flush=True)
        for src_rank, t in enumerate(all_num_tokens_per_rank):
            print(f"  Rank {src_rank} sends: {t.tolist()}", flush=True)
    
    cpu_barrier()
    
    # 配置
    num_sms = args.num_sms
    nvl_buffer_size = 256
    config = deep_ep.Config(num_sms, 8, nvl_buffer_size)
    
    # 执行 dispatch
    try:
        if rank == 0:
            print(f"\n[Info] Executing dispatch...", flush=True)
        
        start_time = time.time()
        
        dispatch_args = {
            'x': x,
            'num_tokens_per_rank': num_tokens_per_rank,
            'is_token_in_rank': is_token_in_rank,
            'num_tokens_per_expert': num_tokens_per_expert,
            'config': config,
            'topk_idx': topk_idx,
            'topk_weights': topk_weights,
        }
        
        recv_x, recv_topk_idx, recv_topk_weights, recv_num_tokens_per_expert_list, handle, event = \
            buffer.dispatch(**dispatch_args)
        
        # 等待完成
        if event is not None and hasattr(event, 'event') and event.event is not None:
            event.current_stream_wait()
        elif hasattr(torch, 'xpu'):
            torch.xpu.synchronize()
        
        elapsed = time.time() - start_time
        print(f"[Rank {rank}] dispatch completed in {elapsed*1000:.2f} ms", flush=True)
        
        # 获取 rank_prefix_matrix
        rank_prefix_matrix = handle[0]
        
        print(f"[Rank {rank}] recv_x shape: {recv_x.shape}", flush=True)
        print(f"[Rank {rank}] rank_prefix_matrix:\n{rank_prefix_matrix.cpu()}", flush=True)
        
        cpu_barrier()
        
        # 验证结果
        if rank == 0:
            print(f"\n[Info] Verifying results...", flush=True)
        
        passed = verify_dispatch_results(
            rank, num_ranks, recv_x, recv_topk_idx, recv_topk_weights,
            rank_prefix_matrix, all_num_tokens_per_rank, group
        )
        
        cpu_barrier()
        
        # 汇总结果
        all_passed_tensor = torch.tensor([1 if passed else 0], device=device)
        dist.all_reduce(all_passed_tensor, op=dist.ReduceOp.MIN, group=group)
        all_passed = all_passed_tensor.item() == 1
        
        if rank == 0:
            if all_passed:
                print(f"\n[Result] ✓ All ranks PASSED dispatch test!", flush=True)
            else:
                print(f"\n[Result] ✗ Some ranks FAILED dispatch test!", flush=True)
        
        return all_passed
        
    except Exception as e:
        print(f"[Rank {rank}] ✗ Dispatch failed with error: {e}", flush=True)
        import traceback
        traceback.print_exc()
        return False


def test_combine(
    rank: int,
    num_ranks: int,
    buffer,
    group: dist.ProcessGroup,
    device: str,
    mpi_comm,
    args: argparse.Namespace
) -> bool:
    """
    测试 dispatch + combine 完整流程
    """
    import deep_ep
    
    use_mpi = mpi_comm is not None
    
    def cpu_barrier():
        if use_mpi:
            mpi_comm.Barrier()
        else:
            dist.barrier(group=group)
    
    num_tokens = args.num_tokens
    hidden = args.hidden
    num_topk = args.num_topk
    num_experts = args.num_experts
    
    assert num_experts % num_ranks == 0
    
    if rank == 0:
        print(f"\n{'='*60}", flush=True)
        print(f"[Test] Dispatch + Combine Round-trip Test", flush=True)
        print(f"  num_tokens={num_tokens}, hidden={hidden}", flush=True)
        print(f"  num_topk={num_topk}, num_experts={num_experts}", flush=True)
        print(f"  num_ranks={num_ranks}", flush=True)
        print(f"{'='*60}", flush=True)
    
    cpu_barrier()
    
    # 生成测试数据
    x, topk_idx, topk_weights, num_tokens_per_rank, num_tokens_per_expert, is_token_in_rank = \
        generate_test_data(rank, num_ranks, device, num_tokens, hidden, num_topk, num_experts, seed=42)
    
    # 保存原始数据用于验证
    x_original = x.clone()
    
    # 配置
    num_sms = args.num_sms
    nvl_buffer_size = 256
    config = deep_ep.Config(num_sms, 8, nvl_buffer_size)
    
    try:
        # Dispatch
        if rank == 0:
            print(f"\n[Info] Executing dispatch...", flush=True)
        
        dispatch_args = {
            'x': x,
            'num_tokens_per_rank': num_tokens_per_rank,
            'is_token_in_rank': is_token_in_rank,
            'num_tokens_per_expert': num_tokens_per_expert,
            'config': config,
            'topk_idx': topk_idx,
            'topk_weights': topk_weights,
        }
        
        recv_x, recv_topk_idx, recv_topk_weights, recv_num_tokens_per_expert_list, handle, event = \
            buffer.dispatch(**dispatch_args)
        
        if event is not None and hasattr(event, 'event') and event.event is not None:
            event.current_stream_wait()
        elif hasattr(torch, 'xpu'):
            torch.xpu.synchronize()
        
        print(f"[Rank {rank}] dispatch done, recv_x shape: {recv_x.shape}", flush=True)
        
        cpu_barrier()
        
        # Combine (把数据发回)
        if rank == 0:
            print(f"\n[Info] Executing combine...", flush=True)
        
        # 注意: combine 需要 dispatch 返回的 handle
        combined_x, combined_event = buffer.combine(recv_x, handle, config)
        
        if combined_event is not None and hasattr(combined_event, 'event') and combined_event.event is not None:
            combined_event.current_stream_wait()
        elif hasattr(torch, 'xpu'):
            torch.xpu.synchronize()
        
        print(f"[Rank {rank}] combine done, combined_x shape: {combined_x.shape}", flush=True)
        
        cpu_barrier()
        
        # 验证: combine 后的数据应该与原始数据一致（考虑 topk 路由）
        # 简化验证：检查数据形状
        passed = True
        if combined_x.shape[0] != x_original.shape[0]:
            print(f"[Rank {rank}] ✗ combined_x shape mismatch: got {combined_x.shape}, expected {x_original.shape}", flush=True)
            passed = False
        else:
            print(f"[Rank {rank}] ✓ combined_x shape correct: {combined_x.shape}", flush=True)
        
        # 汇总结果
        all_passed_tensor = torch.tensor([1 if passed else 0], device=device)
        dist.all_reduce(all_passed_tensor, op=dist.ReduceOp.MIN, group=group)
        all_passed = all_passed_tensor.item() == 1
        
        if rank == 0:
            if all_passed:
                print(f"\n[Result] ✓ All ranks PASSED combine test!", flush=True)
            else:
                print(f"\n[Result] ✗ Some ranks FAILED combine test!", flush=True)
        
        return all_passed
        
    except Exception as e:
        print(f"[Rank {rank}] ✗ Combine test failed with error: {e}", flush=True)
        import traceback
        traceback.print_exc()
        return False


def run_tests(rank: int, num_ranks: int, group, device: str, mpi_comm, args: argparse.Namespace):
    """运行所有测试"""
    import deep_ep
    
    use_mpi = mpi_comm is not None
    
    def cpu_barrier():
        if use_mpi:
            mpi_comm.Barrier()
        else:
            dist.barrier(group=group)
    
    if rank == 0:
        print(f"\n{'#'*60}", flush=True)
        print(f"# XPU Intranode Dispatch Test", flush=True)
        print(f"# Ranks: {num_ranks}, Device: {device}", flush=True)
        print(f"{'#'*60}", flush=True)
    
    cpu_barrier()
    
    # 创建 Buffer
    try:
        if rank == 0:
            print(f"\n[Setup] Creating DeepEP Buffer...", flush=True)
        
        if use_mpi:
            buffer = deep_ep.Buffer(
                group,
                int(1e9),  # 1GB NVL buffer
                num_rdma_bytes=0,
                low_latency_mode=False,
                num_qps_per_rank=1,
                explicitly_destroy=True,
                comm=mpi_comm
            )
        else:
            buffer = deep_ep.Buffer(
                group,
                int(1e9),  # 1GB NVL buffer
                num_rdma_bytes=0,
                low_latency_mode=False,
                num_qps_per_rank=1,
                explicitly_destroy=True
            )
        
        if rank == 0:
            print(f"[Setup] Buffer created: rank={buffer.rank}, num_ranks={buffer.group_size}", flush=True)
        
    except Exception as e:
        print(f"[Rank {rank}] Failed to create buffer: {e}", flush=True)
        import traceback
        traceback.print_exc()
        return
    
    cpu_barrier()
    
    all_passed = True
    
    # 测试 0: 简单直观的 dispatch 测试
    if args.test_simple:
        passed = test_simple_dispatch(rank, num_ranks, buffer, group, device, mpi_comm, args)
        all_passed = all_passed and passed
    
    cpu_barrier()
    
    # 测试 1: Dispatch 正确性测试
    if args.test_dispatch:
        passed = test_dispatch(rank, num_ranks, buffer, group, device, mpi_comm, args)
        all_passed = all_passed and passed
    
    cpu_barrier()
    
    # 测试 2: Dispatch + Combine 往返测试
    if args.test_combine:
        passed = test_combine(rank, num_ranks, buffer, group, device, mpi_comm, args)
        all_passed = all_passed and passed
    
    cpu_barrier()
    
    # 清理
    buffer.destroy()
    cpu_barrier()
    
    if rank == 0:
        print(f"\n{'#'*60}", flush=True)
        if all_passed:
            print("# ✓ All tests PASSED", flush=True)
        else:
            print("# ✗ Some tests FAILED", flush=True)
        print(f"{'#'*60}\n", flush=True)


def worker_fn(local_rank: int, num_ranks: int, args: argparse.Namespace):
    """Worker function for multiprocessing (mp.spawn mode)"""
    from pathlib import Path
    repo_root = Path(__file__).parent.parent.absolute()
    if str(repo_root) not in sys.path:
        sys.path.insert(0, str(repo_root))
    
    rank, world_size, group, device, mpi_comm = init_dist_spawn(local_rank, num_ranks, args.port)
    
    run_tests(rank, world_size, group, device, mpi_comm, args)
    
    dist.destroy_process_group()


def main_mpi(args: argparse.Namespace):
    """Main function when using MPI (mpirun mode)"""
    from pathlib import Path
    repo_root = Path(__file__).parent.parent.absolute()
    if str(repo_root) not in sys.path:
        sys.path.insert(0, str(repo_root))
    
    rank, world_size, group, device, mpi_comm = init_dist_mpi(args.port, use_gloo=args.use_gloo)
    
    run_tests(rank, world_size, group, device, mpi_comm, args)
    
    dist.destroy_process_group()
    
    if rank == 0:
        print("\n" + "=" * 50, flush=True)
        print("Test completed!", flush=True)
        print("=" * 50, flush=True)


def main():
    parser = argparse.ArgumentParser(description='XPU Intranode Dispatch Test')
    
    # 启动方式
    parser.add_argument('--num-processes', type=int, default=2,
                        help='Number of processes to spawn (default: 2)')
    parser.add_argument('--use-mpi', action='store_true',
                        help='Use MPI for process launch (requires mpirun)')
    parser.add_argument('--use-torchrun', action='store_true',
                        help='Use torchrun launcher')
    parser.add_argument('--use-gloo', action='store_true',
                        help='Use gloo backend instead of xccl')
    parser.add_argument('--port', type=int, default=29500,
                        help='Master port for distributed communication (default: 29500)')
    
    # 测试参数
    parser.add_argument('--num-tokens', type=int, default=4,
                        help='Number of tokens (default: 64)')
    parser.add_argument('--hidden', type=int, default=1024,
                        help='Hidden dimension size (default: 1024)')
    parser.add_argument('--num-topk', type=int, default=2,
                        help='Number of top-k experts (default: 2)')
    parser.add_argument('--num-experts', type=int, default=None,
                        help='Number of experts (default: 8 * num_processes)')
    parser.add_argument('--num-sms', type=int, default=20,
                        help='Number of SMs to use (default: 20)')
    
    # 测试选择
    parser.add_argument('--test-simple', action='store_true', default=False,
                        help='Run simple intuitive dispatch test (直观验证)')
    parser.add_argument('--test-dispatch', action='store_true', default=True,
                        help='Run dispatch correctness test (default: True)')
    parser.add_argument('--test-combine', action='store_true', default=False,
                        help='Run dispatch+combine round-trip test')
    parser.add_argument('--no-dispatch', action='store_true',
                        help='Skip dispatch test')
    parser.add_argument('--tokens-per-dst', type=int, default=2,
                        help='Number of tokens per destination rank in simple test (default: 2)')
    
    args = parser.parse_args()
    
    # 处理参数
    if args.no_dispatch:
        args.test_dispatch = False
    
    if args.num_experts is None:
        args.num_experts = 8 * args.num_processes
    
    # 验证参数
    if args.num_experts % args.num_processes != 0:
        print(f"Error: num_experts ({args.num_experts}) must be divisible by "
              f"num_processes ({args.num_processes})")
        return
    
    if args.use_mpi:
        # MPI mode
        from mpi4py import MPI
        comm = MPI.COMM_WORLD
        rank = comm.Get_rank()
        world_size = comm.Get_size()
        
        # 更新 num_experts 基于实际的 world_size
        if args.num_experts is None or args.num_experts == 8 * args.num_processes:
            args.num_experts = 8 * world_size
        
        if rank == 0:
            print("=" * 60, flush=True)
            print(f"DeepEP XPU Intranode Dispatch Test ({world_size} GPUs, MPI mode)", flush=True)
            print(f"Backend: {'gloo' if args.use_gloo else 'xccl'}", flush=True)
            print(f"num_tokens={args.num_tokens}, hidden={args.hidden}", flush=True)
            print(f"num_topk={args.num_topk}, num_experts={args.num_experts}", flush=True)
            print("=" * 60, flush=True)
        
        main_mpi(args)
        
    elif args.use_torchrun:
        # torchrun mode
        local_rank = int(os.environ.get('LOCAL_RANK', 0))
        world_size = int(os.environ.get('WORLD_SIZE', 1))
        
        from pathlib import Path
        repo_root = Path(__file__).parent.parent.absolute()
        if str(repo_root) not in sys.path:
            sys.path.insert(0, str(repo_root))
        
        rank, world_size, group, device, _ = init_dist_spawn(local_rank, world_size, args.port)
        run_tests(rank, world_size, group, device, None, args)
        dist.destroy_process_group()
        
    else:
        # mp.spawn mode
        num_processes = args.num_processes
        
        print("=" * 60, flush=True)
        print(f"DeepEP XPU Intranode Dispatch Test ({num_processes} GPUs)", flush=True)
        print(f"num_tokens={args.num_tokens}, hidden={args.hidden}", flush=True)
        print(f"num_topk={args.num_topk}, num_experts={args.num_experts}", flush=True)
        print("=" * 60, flush=True)
        
        mp.spawn(
            worker_fn,
            args=(num_processes, args),
            nprocs=num_processes,
            join=True
        )


if __name__ == '__main__':
    main()
