#!/usr/bin/env python
"""
XPU Intranode Dispatch + Combine 性能测试脚本

测试命令:
    mpirun -np 2 python tests/test_xpu_pref.py
    mpirun -np 4 python tests/test_xpu_pref.py
    mpirun -np 8 python tests/test_xpu_pref.py

性能指标:
    - Dispatch/Combine 延迟 (ms)
    - 带宽 (GB/s)
"""

import argparse
import os
import sys
import time

# 将项目根目录添加到 Python 路径
script_dir = os.path.dirname(os.path.abspath(__file__))
project_root = os.path.dirname(script_dir)
if project_root not in sys.path:
    sys.path.insert(0, project_root)

import torch
import torch.distributed as dist

# 设置XPU环境
os.environ['USE_XPU'] = '1'
os.environ['USE_CUDA'] = '0'

from mpi4py import MPI


def init_dist_mpi(port: int = 29500):
    """使用 MPI 初始化分布式环境"""
    comm = MPI.COMM_WORLD
    rank = comm.Get_rank()
    world_size = comm.Get_size()
    
    # 设置 XPU 设备
    local_rank = rank
    torch.xpu.set_device(local_rank)
    device = f'xpu:{local_rank}'
    
    # 设置环境变量
    os.environ['MASTER_ADDR'] = os.getenv('MASTER_ADDR', '127.0.0.1')
    os.environ['MASTER_PORT'] = str(port)
    os.environ['RANK'] = str(rank)
    os.environ['WORLD_SIZE'] = str(world_size)
    
    # 初始化 PyTorch 分布式
    dist.init_process_group(
        backend='xccl',
        init_method=f'tcp://{os.environ["MASTER_ADDR"]}:{port}',
        world_size=world_size,
        rank=rank
    )
    
    group = dist.new_group(list(range(world_size)))
    return rank, world_size, group, device


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


def test_main(args: argparse.Namespace, num_sms: int, local_rank: int, num_ranks: int, 
              rank: int, buffer, group: dist.ProcessGroup, device: str):
    """主测试函数 - 性能测试版本"""
    import deep_ep
    
    # Settings
    num_tokens, hidden = args.num_tokens, args.hidden
    num_topk, num_experts = args.num_topk, args.num_experts
    warmup_iters = args.warmup_iters
    test_iters = args.test_iters

    assert num_experts % num_ranks == 0
    if local_rank == 0:
        print(f'[config] num_tokens={num_tokens}, hidden={hidden}, num_topk={num_topk}, '
              f'num_experts={num_experts}, num_ranks={num_ranks}', flush=True)
        print(f'[config] warmup_iters={warmup_iters}, test_iters={test_iters}', flush=True)

    # Random data - 与 test_intranode.py 保持一致
    # 每个 rank 的所有 token 值都相同（等于 rank 值），方便验证
    x = torch.ones((num_tokens, hidden), dtype=torch.bfloat16, device=device) * rank
    x_pure_rand = torch.randn((num_tokens, hidden), dtype=torch.bfloat16, device=device)
    # print(f"rank:{rank} x[:,0] (first 10 values):", x[:10, 0])
    # 生成随机路由决策
    scores = torch.randn((num_tokens, num_experts), dtype=torch.float32, device=device).abs() + 1
    topk_idx = torch.topk(scores, num_topk, dim=-1, largest=True, sorted=False)[1]
    topk_idx = topk_idx.to(deep_ep.topk_idx_t)
    # topk_weights 也使用常量值（等于 rank），与 test_intranode.py 保持一致
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

    # Config
    nvl_buffer_size = 256
    config = deep_ep.Config(num_sms, 8, nvl_buffer_size)


    def check_dispatch_data(check_x, rank_prefix_matrix):
        """验证 dispatch 后的数据，与 test_intranode.py 保持一致
        
        验证逻辑：
        1. 每行的所有值都相同 (amin == amax)
        2. 来自 rank i 的数据值应该等于 i
        
        rank_prefix_matrix[i][rank] 表示：从 rank 0 到 rank i（包含）发送到当前 rank 的累计 token 数
        """
        # 验证每行数据一致性
        assert torch.allclose(check_x.amin(dim=1), check_x.amax(dim=1)), \
            "Each row should have the same value in all columns"
        
        check_start = 0
        for i in range(num_ranks):
            check_end = rank_prefix_matrix[i][rank].item()
            if check_end <= check_start:
                continue  # 该 rank 没有发送数据到当前 rank
            
            # 验证来自 rank i 的数据值等于 i
            segment = check_x[check_start:check_end, :]
            diff = (segment.int() - i).sum().item()
            assert diff == 0, \
                f"Data from rank {i} should all be {i}, got diff={diff}, " \
                f"actual values: {segment[:3, 0].tolist()}"
            
            check_start = check_end

    # ========== 测试 Dispatch + Combine ==========
    test_cases = [
        ('BF16 without topk', x, False),
        # ('BF16 with topk', x, True),
        # ('Random BF16 without topk', x_pure_rand, False),
        # ('Random BF16 with topk', x_pure_rand, True),
    ]

    # 计算数据量 (用于带宽计算)
    # dispatch: 每个 token 发送到 topk 个 rank，数据量 = num_tokens * hidden * sizeof(bf16) * num_topk
    # combine: 从各 rank 收回数据
    bytes_per_element = 2  # bf16 = 2 bytes
    
    for test_name, current_x, with_topk in test_cases:
        if local_rank == 0:
            print(f'\n{"="*60}', flush=True)
            print(f'[testing] {test_name}...', flush=True)
            print(f'{"="*60}', flush=True)
        
        # ===== Dispatch 性能测试 =====
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
        
        # Warmup
        if local_rank == 0:
            print(f'  [dispatch] Warming up ({warmup_iters} iterations)...', flush=True)
        for _ in range(warmup_iters):
            recv_x, recv_topk_idx, recv_topk_weights, recv_num_tokens_per_expert_list, handle, event = \
                buffer.dispatch(**dispatch_args)
            torch.xpu.synchronize()
        
        # Benchmark dispatch
        if local_rank == 0:
            print(f'  [dispatch] Benchmarking ({test_iters} iterations)...', flush=True)
        
        from mpi4py import MPI
        comm = MPI.COMM_WORLD
        comm.Barrier()
        torch.xpu.synchronize()
        
        dispatch_times = []
        for _ in range(test_iters):
            torch.xpu.synchronize()
            start_time = time.perf_counter()
            
            recv_x, recv_topk_idx, recv_topk_weights, recv_num_tokens_per_expert_list, handle, event = \
                buffer.dispatch(**dispatch_args)
            
            torch.xpu.synchronize()
            end_time = time.perf_counter()
            dispatch_times.append((end_time - start_time) * 1000)  # Convert to ms
        
        # 计算 dispatch 统计
        dispatch_times_tensor = torch.tensor(dispatch_times, device=device)
        dispatch_mean = dispatch_times_tensor.mean().item()
        dispatch_min = dispatch_times_tensor.min().item()
        dispatch_max = dispatch_times_tensor.max().item()
        dispatch_std = dispatch_times_tensor.std().item()
        
        # 计算 dispatch 带宽
        # 发送数据量: num_tokens * hidden * bytes_per_element (每个 token 的数据)
        # 实际发送量需要考虑 topk 路由
        total_send_tokens = num_tokens_per_rank.sum().item()
        dispatch_data_bytes = total_send_tokens * hidden * bytes_per_element
        dispatch_bandwidth = (dispatch_data_bytes / 1e9) / (dispatch_mean / 1000)  # GB/s
        
        # 收集所有 rank 的统计
        all_dispatch_mean = torch.tensor([dispatch_mean], device=device)
        all_dispatch_bandwidth = torch.tensor([dispatch_bandwidth], device=device)
        dist.all_reduce(all_dispatch_mean, op=dist.ReduceOp.SUM)
        dist.all_reduce(all_dispatch_bandwidth, op=dist.ReduceOp.SUM)
        avg_dispatch_mean = all_dispatch_mean.item() / num_ranks
        avg_dispatch_bandwidth = all_dispatch_bandwidth.item() / num_ranks
        
        if local_rank == 0:
            print(f'  [dispatch] Results:', flush=True)
            print(f'    Latency: mean={dispatch_mean:.3f}ms, min={dispatch_min:.3f}ms, '
                  f'max={dispatch_max:.3f}ms, std={dispatch_std:.3f}ms', flush=True)
            print(f'    Data sent per rank: {dispatch_data_bytes/1e6:.2f} MB', flush=True)
            print(f'    Bandwidth (per rank): {dispatch_bandwidth:.2f} GB/s', flush=True)
            print(f'    Avg latency (all ranks): {avg_dispatch_mean:.3f}ms', flush=True)
            print(f'    Avg bandwidth (all ranks): {avg_dispatch_bandwidth:.2f} GB/s', flush=True)
        
        # 验证 dispatch 结果
        rank_prefix_matrix = handle[0]
        expected_recv_tokens = gbl_num_tokens_per_rank[rank].item()
        actual_recv_tokens = recv_x.size(0)
        assert expected_recv_tokens == actual_recv_tokens, \
            f'Expected {expected_recv_tokens} tokens, got {actual_recv_tokens}'
        
        if current_x is x:
            check_dispatch_data(recv_x, rank_prefix_matrix)
        
        if local_rank == 0:
            print(f'  [dispatch] Correctness check passed, recv_x shape: {recv_x.shape}', flush=True)
        
        # ===== Combine 性能测试 =====
        combine_args = {'x': recv_x, 'handle': handle, 'config': config}
        if with_topk:
            combine_args.update({'topk_weights': recv_topk_weights})
        
        # Warmup
        if local_rank == 0:
            print(f'  [combine] Warming up ({warmup_iters} iterations)...', flush=True)
        for _ in range(warmup_iters):
            # 需要重新 dispatch 获取 handle
            recv_x_tmp, _, _, _, handle_tmp, _ = buffer.dispatch(**dispatch_args)
            torch.xpu.synchronize()
            combine_args_tmp = {'x': recv_x_tmp, 'handle': handle_tmp, 'config': config}
            if with_topk:
                combine_args_tmp.update({'topk_weights': recv_topk_weights})
            combined_x, combined_topk_weights, event = buffer.combine(**combine_args_tmp)
            torch.xpu.synchronize()
        
        # Benchmark combine
        if local_rank == 0:
            print(f'  [combine] Benchmarking ({test_iters} iterations)...', flush=True)
        
        comm.Barrier()
        torch.xpu.synchronize()
        
        combine_times = []
        for _ in range(test_iters):
            # 需要重新 dispatch 获取 handle
            recv_x_tmp, _, recv_topk_weights_tmp, _, handle_tmp, _ = buffer.dispatch(**dispatch_args)
            torch.xpu.synchronize()
            
            combine_args_tmp = {'x': recv_x_tmp, 'handle': handle_tmp, 'config': config}
            if with_topk:
                combine_args_tmp.update({'topk_weights': recv_topk_weights_tmp})
            
            torch.xpu.synchronize()
            start_time = time.perf_counter()
            
            combined_x, combined_topk_weights, event = buffer.combine(**combine_args_tmp)
            
            torch.xpu.synchronize()
            end_time = time.perf_counter()
            combine_times.append((end_time - start_time) * 1000)  # Convert to ms
        
        # 计算 combine 统计
        combine_times_tensor = torch.tensor(combine_times, device=device)
        combine_mean = combine_times_tensor.mean().item()
        combine_min = combine_times_tensor.min().item()
        combine_max = combine_times_tensor.max().item()
        combine_std = combine_times_tensor.std().item()
        
        # 计算 combine 带宽
        # combine 接收数据量
        recv_tokens = recv_x.size(0)
        combine_data_bytes = recv_tokens * hidden * bytes_per_element
        combine_bandwidth = (combine_data_bytes / 1e9) / (combine_mean / 1000)  # GB/s
        
        # 收集所有 rank 的统计
        all_combine_mean = torch.tensor([combine_mean], device=device)
        all_combine_bandwidth = torch.tensor([combine_bandwidth], device=device)
        dist.all_reduce(all_combine_mean, op=dist.ReduceOp.SUM)
        dist.all_reduce(all_combine_bandwidth, op=dist.ReduceOp.SUM)
        avg_combine_mean = all_combine_mean.item() / num_ranks
        avg_combine_bandwidth = all_combine_bandwidth.item() / num_ranks
        
        if local_rank == 0:
            print(f'  [combine] Results:', flush=True)
            print(f'    Latency: mean={combine_mean:.3f}ms, min={combine_min:.3f}ms, '
                  f'max={combine_max:.3f}ms, std={combine_std:.3f}ms', flush=True)
            print(f'    Data received per rank: {combine_data_bytes/1e6:.2f} MB', flush=True)
            print(f'    Bandwidth (per rank): {combine_bandwidth:.2f} GB/s', flush=True)
            print(f'    Avg latency (all ranks): {avg_combine_mean:.3f}ms', flush=True)
            print(f'    Avg bandwidth (all ranks): {avg_combine_bandwidth:.2f} GB/s', flush=True)

        # 验证 combine 结果
        assert combined_x.shape[0] == num_tokens, \
            f'combined_x shape mismatch: expected {num_tokens}, got {combined_x.shape[0]}'
        
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
            print(f'  [combine] Correctness check passed, combined_x shape: {combined_x.shape}, diff={diff:.2e}', flush=True)
        
        # ===== 汇总性能结果 =====
        if local_rank == 0:
            print(f'\n  [summary] Performance Summary for "{test_name}":', flush=True)
            print(f'    ┌──────────────┬─────────────┬─────────────┬─────────────┐', flush=True)
            print(f'    │ Phase        │ Latency(ms) │ Data(MB)    │ BW(GB/s)    │', flush=True)
            print(f'    ├──────────────┼─────────────┼─────────────┼─────────────┤', flush=True)
            print(f'    │ Dispatch     │ {avg_dispatch_mean:11.3f} │ {dispatch_data_bytes/1e6:11.2f} │ {avg_dispatch_bandwidth:11.2f} │', flush=True)
            print(f'    │ Combine      │ {avg_combine_mean:11.3f} │ {combine_data_bytes/1e6:11.2f} │ {avg_combine_bandwidth:11.2f} │', flush=True)
            print(f'    │ Total        │ {avg_dispatch_mean + avg_combine_mean:11.3f} │ {(dispatch_data_bytes + combine_data_bytes)/1e6:11.2f} │ {((dispatch_data_bytes + combine_data_bytes)/1e9)/((avg_dispatch_mean + avg_combine_mean)/1000):11.2f} │', flush=True)
            print(f'    └──────────────┴─────────────┴─────────────┴─────────────┘', flush=True)

    print(f'\n==========Rank{rank} All tests passed! ==========\n', flush=True)


def main():
    parser = argparse.ArgumentParser(description='Test XPU intranode dispatch + combine performance')
    parser.add_argument('--num-tokens', type=int, default=4096)
    parser.add_argument('--hidden', type=int, default=4096)
    parser.add_argument('--num-topk', type=int, default=2)
    parser.add_argument('--num-experts', type=int, default=8)
    parser.add_argument('--port', type=int, default=29500)
    parser.add_argument('--warmup-iters', type=int, default=5, help='Number of warmup iterations')
    parser.add_argument('--test-iters', type=int, default=20, help='Number of test iterations for benchmarking')
    args = parser.parse_args()

    import deep_ep
    
    rank, num_ranks, group, device = init_dist_mpi(port=args.port)
    
    if rank == 0:
        print(f'[init] MPI initialized with {num_ranks} ranks', flush=True)
        print(f'[init] Using device: {device}', flush=True)
    
    torch.manual_seed(rank + 42)
    
    # 创建 buffer
    buffer = deep_ep.Buffer(
        group,
        int(1e9),
        0,
        low_latency_mode=False,
        num_qps_per_rank=1
    )
    
    if rank == 0:
        print(f'[init] Buffer created', flush=True)
    
    # 运行测试 - 用 try-except 包裹，确保即使失败也能清理退出
    test_passed = False
    error_msg = None
    try:
        test_main(args, 24, rank, num_ranks, rank, buffer, group, device)
        test_passed = True
    except Exception as e:
        error_msg = str(e)
        print(f'[Rank {rank}] TEST FAILED: {error_msg}', flush=True)
        import traceback
        traceback.print_exc()
    
    # 同步所有 rank，确保大家都完成了测试（无论成功失败）
    torch.xpu.synchronize()
    
    # 使用 MPI barrier 而不是 dist.barrier()，因为 dist 可能在异常后状态不一致
    from mpi4py import MPI
    comm = MPI.COMM_WORLD
    comm.Barrier()
    
    # 汇总结果
    all_passed = comm.allreduce(test_passed, op=MPI.LAND)
    
    if rank == 0:
        if all_passed:
            print(f'\n========== All ranks passed! ==========\n', flush=True)
        else:
            print(f'\n========== Some ranks FAILED! ==========\n', flush=True)
    
    # 清理
    try:
        dist.destroy_process_group()
    except:
        pass
    
    # 确保所有进程以相同方式退出
    comm.Barrier()
    
    if not all_passed:
        sys.exit(1)


if __name__ == '__main__':
    main()

