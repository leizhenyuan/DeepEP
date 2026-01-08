#!/usr/bin/env python
"""
XPU Intranode Dispatch + Combine 完整功能测试脚本

测试命令:
    MPI 启动 (推荐):
        mpirun -np 2 python tests/test_xpu_intranode.py
        mpirun -np 4 python tests/test_xpu_intranode.py
    
    单进程调试:
        python tests/test_xpu_intranode.py --num-processes 1

功能测试:
    1. dispatch: 将 token 发送到各 expert 所在的 rank
    2. combine: 将各 expert 的输出 reduce 回原 token 所在的 rank
"""

import argparse
import os
import sys
import time
import torch
import torch.distributed as dist
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


def init_dist_mpi(port: int = 29500):
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
    else:
        raise RuntimeError("XPU not available!")
    
    # 设置环境变量
    os.environ['MASTER_ADDR'] = os.getenv('MASTER_ADDR', '127.0.0.1')
    os.environ['MASTER_PORT'] = str(port)
    os.environ['RANK'] = str(rank)
    os.environ['WORLD_SIZE'] = str(world_size)
    
    # 初始化 PyTorch 分布式 (使用 gloo，因为 XPU 可能没有 xccl)
    dist.init_process_group(
        backend='gloo',
        init_method=f'tcp://{os.environ["MASTER_ADDR"]}:{port}',
        world_size=world_size,
        rank=rank
    )
    
    group = dist.new_group(list(range(world_size)))
    return rank, world_size, group, device, comm


def calc_diff(x: torch.Tensor, y: torch.Tensor):
    """计算两个 tensor 之间的差异"""
    x, y = x.double() + 1, y.double() + 1
    denominator = (x * x + y * y).sum()
    sim = 2 * (x * y).sum() / denominator
    return (1 - sim).item()


def inplace_unique(x: torch.Tensor, num_classes: int):
    """原地去重，保持第一次出现的值，后续重复值设为 -1"""
    assert x.dim() == 2
    m, n = x.shape
    for i in range(m):
        seen = set()
        for j in range(n):
            val = x[i, j].item()
            if val in seen or val < 0 or val >= num_classes:
                x[i, j] = -1
            else:
                seen.add(val)


def bench(fn, num_warmup: int = 5, num_iters: int = 20):
    """简单的性能测试"""
    # Warmup
    for _ in range(num_warmup):
        fn()
    
    if hasattr(torch, 'xpu'):
        torch.xpu.synchronize()
    
    start = time.perf_counter()
    for _ in range(num_iters):
        fn()
    
    if hasattr(torch, 'xpu'):
        torch.xpu.synchronize()
    
    elapsed = (time.perf_counter() - start) / num_iters
    return elapsed, num_iters


def test_main(args: argparse.Namespace, num_sms: int, local_rank: int, num_ranks: int, 
              rank: int, buffer, group: dist.ProcessGroup, device: str):
    """主测试函数"""
    import deep_ep
    
    # Settings
    num_tokens, hidden = args.num_tokens, args.hidden
    num_topk, num_experts = args.num_topk, args.num_experts

    assert num_experts % num_ranks == 0
    if local_rank == 0:
        print(f'[config] num_tokens={num_tokens}, hidden={hidden}, num_topk={num_topk}, '
              f'num_experts={num_experts}, num_ranks={num_ranks}', flush=True)

    # Random data - 使用 rank 作为值方便验证
    x = torch.ones((num_tokens, hidden), dtype=torch.bfloat16, device=device) * rank
    x_pure_rand = torch.randn((num_tokens, hidden), dtype=torch.bfloat16, device=device)
    
    # 生成随机路由决策
    scores = torch.randn((num_tokens, num_experts), dtype=torch.float32, device=device).abs() + 1
    topk_idx = torch.topk(scores, num_topk, dim=-1, largest=True, sorted=False)[1]
    topk_idx = topk_idx.to(torch.int32)  # XPU 使用 int32
    topk_weights = torch.ones((num_tokens, num_topk), dtype=torch.float32, device=device) * rank
    topk_weights_pure_rand = torch.randn((num_tokens, num_topk), dtype=torch.float32, device=device)
    
    # 计算 rank_idx (每个 token 被路由到哪些 rank)
    rank_idx = topk_idx // (num_experts // num_ranks)
    rank_idx = rank_idx.to(torch.int64)
    rank_idx.masked_fill_(topk_idx == -1, -1)
    inplace_unique(rank_idx, num_ranks)

    # Expert meta - 统计每个 expert 收到多少 token
    num_tokens_per_expert = torch.zeros((num_experts, ), dtype=torch.int, device=device)
    for i in range(num_experts):
        num_tokens_per_expert[i] = (topk_idx == i).sum()
    gbl_num_tokens_per_expert = num_tokens_per_expert.clone()
    dist.all_reduce(gbl_num_tokens_per_expert, group=group)

    # Rank layout meta - 统计每个 rank 收到多少 token
    num_tokens_per_rank = torch.empty((num_ranks, ), dtype=torch.int, device=device)
    token_idx_in_rank = torch.full((num_ranks, num_tokens), -1, dtype=torch.long, device=device)
    for i in range(num_ranks):
        num_tokens_per_rank[i] = (rank_idx == i).sum()
        token_sel = (rank_idx == i).max(dim=-1)[0]
        count = token_sel.sum().item()
        tokens = torch.sort(token_sel.to(torch.int), descending=True)[1]
        tokens[:count] = torch.sort(tokens[:count])[0]
        token_idx_in_rank[i][tokens[:count]] = torch.arange(count, dtype=torch.long, device=device)
    token_idx_in_rank = token_idx_in_rank.T.contiguous().to(torch.int)
    is_token_in_rank = token_idx_in_rank >= 0
    gbl_num_tokens_per_rank = num_tokens_per_rank.clone()
    dist.all_reduce(gbl_num_tokens_per_rank, group=group)

    if local_rank == 0:
        print(f'[layout] num_tokens_per_rank={num_tokens_per_rank.tolist()}', flush=True)
        print(f'[layout] gbl_num_tokens_per_rank={gbl_num_tokens_per_rank.tolist()}', flush=True)

    # Test get_dispatch_layout
    ref_num_tokens_per_rank, _, ref_num_tokens_per_expert, ref_is_token_in_rank, _ = \
        buffer.get_dispatch_layout(topk_idx, num_experts)
    assert torch.allclose(ref_num_tokens_per_rank, num_tokens_per_rank), \
        f"num_tokens_per_rank mismatch: {ref_num_tokens_per_rank} vs {num_tokens_per_rank}"
    assert torch.allclose(ref_num_tokens_per_expert, num_tokens_per_expert), \
        f"num_tokens_per_expert mismatch"
    assert torch.allclose(ref_is_token_in_rank, is_token_in_rank), \
        f"is_token_in_rank mismatch"
    
    if local_rank == 0:
        print('[layout] get_dispatch_layout check passed', flush=True)

    # Config
    nvl_buffer_size = 256
    config = deep_ep.Config(num_sms, 8, nvl_buffer_size)

    # 验证函数：检查 dispatch 后的数据
    def check_dispatch_data(check_x, rank_prefix_matrix):
        """验证 dispatch 后每个 rank 收到的数据值等于发送者的 rank"""
        assert torch.allclose(check_x.amin(dim=1), check_x.amax(dim=1)), \
            "Each token should have uniform values"
        check_start = 0
        for i in range(num_ranks):
            check_end = rank_prefix_matrix[i][rank].item()
            expected_val = i  # 来自 rank i 的数据值应该是 i
            actual_vals = check_x[check_start:check_end, :].float()
            diff = (actual_vals - expected_val).abs().max().item()
            assert diff < 1e-3, f"Data from rank {i} should be {expected_val}, got diff={diff}"
            check_start = check_end

    # ========== 测试 Dispatch + Combine ==========
    test_cases = [
        ('BF16 without topk', x, False),
        ('BF16 with topk', x, True),
        ('Random BF16 without topk', x_pure_rand, False),
        ('Random BF16 with topk', x_pure_rand, True),
    ]

    for test_name, current_x, with_topk in test_cases:
        if local_rank == 0:
            print(f'\n[testing] {test_name}...', flush=True)
        
        # ===== Dispatch =====
        dispatch_args = {
            'x': current_x,
            'num_tokens_per_rank': num_tokens_per_rank,
            'is_token_in_rank': is_token_in_rank,
            'num_tokens_per_expert': num_tokens_per_expert,
            'config': config,
        }
        if with_topk:
            dispatch_args.update({
                'topk_idx': topk_idx,
                'topk_weights': topk_weights_pure_rand if current_x is x_pure_rand else topk_weights
            })
        
        recv_x, recv_topk_idx, recv_topk_weights, recv_num_tokens_per_expert_list, handle, event = \
            buffer.dispatch(**dispatch_args)
        
        # 等待完成
        if hasattr(torch, 'xpu'):
            torch.xpu.synchronize()
        
        # 验证 dispatch 结果
        rank_prefix_matrix = handle[0]
        expected_recv_tokens = gbl_num_tokens_per_rank[rank].item()
        actual_recv_tokens = recv_x.size(0)
        assert expected_recv_tokens == actual_recv_tokens, \
            f'Expected {expected_recv_tokens} tokens, got {actual_recv_tokens}'
        
        if current_x is x:  # 非随机数据，可以验证值
            check_dispatch_data(recv_x, rank_prefix_matrix)
        
        if local_rank == 0:
            print(f'  [dispatch] recv_x shape: {recv_x.shape}, passed', flush=True)
        
        # ===== Combine =====
        combine_args = {'x': recv_x, 'handle': handle, 'config': config}
        if with_topk:
            combine_args.update({'topk_weights': recv_topk_weights})
        
        combined_x, combined_topk_weights, event = buffer.combine(**combine_args)
        
        # 等待完成
        if hasattr(torch, 'xpu'):
            torch.xpu.synchronize()
        
        # 验证 combine 结果
        # combined_x 应该是各 rank 输出的累加，除以副本数后应该恢复原始值
        num_copies = is_token_in_rank.sum(dim=1).unsqueeze(1).float()
        check_x = combined_x.float() / num_copies
        ref_x = x_pure_rand if current_x is x_pure_rand else x
        diff = calc_diff(check_x, ref_x)
        assert diff < 5e-6, f'Combine x diff too large: {diff}'
        
        if with_topk:
            if current_x is x_pure_rand:
                check_topk_weights = combined_topk_weights
                ref_topk_weights = topk_weights_pure_rand
            else:
                check_topk_weights = combined_topk_weights / num_copies
                ref_topk_weights = topk_weights
            diff_weights = calc_diff(check_topk_weights, ref_topk_weights)
            assert diff_weights < 1e-9, f'Combine topk_weights diff too large: {diff_weights}'
        
        if local_rank == 0:
            print(f'  [combine] combined_x shape: {combined_x.shape}, diff={diff:.2e}, passed', flush=True)

    # ========== 测试 Cached Dispatch ==========
    if local_rank == 0:
        print(f'\n[testing] Cached dispatch...', flush=True)
    
    # 使用之前的 handle 进行 cached dispatch
    dispatch_args = {'x': x, 'handle': handle, 'config': config}
    recv_x, _, _, _, _, event = buffer.dispatch(**dispatch_args)
    
    if hasattr(torch, 'xpu'):
        torch.xpu.synchronize()
    
    check_dispatch_data(recv_x, rank_prefix_matrix)
    
    if local_rank == 0:
        print(f'  [cached dispatch] passed', flush=True)

    # ========== 性能测试 ==========
    if args.benchmark:
        if local_rank == 0:
            print(f'\n[benchmark] Running performance tests...', flush=True)
        
        # Dispatch 性能
        dispatch_args = {
            'x': x,
            'num_tokens_per_rank': num_tokens_per_rank,
            'is_token_in_rank': is_token_in_rank,
            'num_tokens_per_expert': num_tokens_per_expert,
            'config': config,
        }
        t_dispatch, _ = bench(lambda: buffer.dispatch(**dispatch_args))
        
        # Combine 性能
        recv_x, _, _, _, handle, _ = buffer.dispatch(**dispatch_args)
        if hasattr(torch, 'xpu'):
            torch.xpu.synchronize()
        
        combine_args = {'x': recv_x, 'handle': handle, 'config': config}
        t_combine, _ = bench(lambda: buffer.combine(**combine_args))
        
        if local_rank == 0:
            dispatch_bytes = recv_x.numel() * 2  # BF16 = 2 bytes
            combine_bytes = dispatch_bytes
            print(f'  [dispatch] {t_dispatch * 1e6:.2f} us, {dispatch_bytes / 1e9 / t_dispatch:.2f} GB/s', flush=True)
            print(f'  [combine]  {t_combine * 1e6:.2f} us, {combine_bytes / 1e9 / t_combine:.2f} GB/s', flush=True)

    if local_rank == 0:
        print(f'\n========== All tests passed! ==========\n', flush=True)


def main_mpi(args: argparse.Namespace):
    """MPI 启动的主函数"""
    import deep_ep
    
    rank, num_ranks, group, device, comm = init_dist_mpi(port=args.port)
    
    if rank == 0:
        print(f'[init] MPI initialized with {num_ranks} ranks', flush=True)
        print(f'[init] Using device: {device}', flush=True)
    
    # 设置随机种子
    torch.manual_seed(rank + 42)
    
    # 创建 buffer
    buffer = deep_ep.Buffer(
        group,
        int(1e9),  # 1GB buffer
        0,  # num_rdma_bytes
        low_latency_mode=False,
        num_qps_per_rank=1
    )
    
    if rank == 0:
        print(f'[init] Buffer created', flush=True)
    
    # 运行测试
    for num_sms in [24]:  # 可以测试不同的 SM 数量
        test_main(args, num_sms, rank, num_ranks, rank, buffer, group, device)
    
    # 清理
    dist.barrier()
    dist.destroy_process_group()
    
    if rank == 0:
        print('[cleanup] Done', flush=True)


def main_spawn(local_rank: int, num_ranks: int, args: argparse.Namespace):
    """多进程 spawn 启动的入口"""
    import deep_ep
    
    # 设置 XPU 设备
    if hasattr(torch, 'xpu') and torch.xpu.is_available():
        torch.xpu.set_device(local_rank)
        device = f'xpu:{local_rank}'
    else:
        raise RuntimeError("XPU not available!")
    
    # 设置环境变量
    os.environ['MASTER_ADDR'] = '127.0.0.1'
    os.environ['MASTER_PORT'] = str(args.port)
    os.environ['RANK'] = str(local_rank)
    os.environ['WORLD_SIZE'] = str(num_ranks)
    
    # 初始化分布式
    dist.init_process_group(
        backend='gloo',
        init_method=f'tcp://127.0.0.1:{args.port}',
        world_size=num_ranks,
        rank=local_rank
    )
    
    group = dist.new_group(list(range(num_ranks)))
    
    if local_rank == 0:
        print(f'[init] Spawn initialized with {num_ranks} ranks', flush=True)
    
    # 设置随机种子
    torch.manual_seed(local_rank + 42)
    
    # 创建 buffer
    buffer = deep_ep.Buffer(
        group,
        int(1e9),
        0,
        low_latency_mode=False,
        num_qps_per_rank=1
    )
    
    # 运行测试
    for num_sms in [24]:
        test_main(args, num_sms, local_rank, num_ranks, local_rank, buffer, group, device)
    
    # 清理
    dist.barrier()
    dist.destroy_process_group()


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Test XPU intranode dispatch + combine')
    parser.add_argument('--num-processes', type=int, default=2, 
                        help='Number of processes for spawn mode (default: 2)')
    parser.add_argument('--num-tokens', type=int, default=256, 
                        help='Number of tokens (default: 256)')
    parser.add_argument('--hidden', type=int, default=128, 
                        help='Hidden dimension size (default: 128)')
    parser.add_argument('--num-topk', type=int, default=4, 
                        help='Number of top-k experts (default: 4)')
    parser.add_argument('--num-experts', type=int, default=16, 
                        help='Number of experts (default: 16)')
    parser.add_argument('--port', type=int, default=29500, 
                        help='Port for distributed communication (default: 29500)')
    parser.add_argument('--benchmark', action='store_true', 
                        help='Run performance benchmarks')
    parser.add_argument('--use-spawn', action='store_true',
                        help='Use mp.spawn instead of MPI')
    args = parser.parse_args()

    # 检测是否在 MPI 环境中运行
    is_mpi_run = HAS_MPI and MPI.COMM_WORLD.Get_size() > 1
    
    if args.use_spawn or not is_mpi_run:
        # 使用 mp.spawn
        if not is_mpi_run:
            print(f'[main] Using mp.spawn with {args.num_processes} processes', flush=True)
        import torch.multiprocessing as mp
        mp.spawn(main_spawn, args=(args.num_processes, args), nprocs=args.num_processes)
    else:
        # 使用 MPI
        main_mpi(args)
