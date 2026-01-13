#!/usr/bin/env python
"""
CUDA Intranode Dispatch + Combine 功能测试脚本

测试命令:
    mpirun -np 2 python tests/test_cuda_intranode.py
    mpirun -np 4 python tests/test_cuda_intranode.py
"""

import argparse
import os
import sys

# 将项目根目录添加到 Python 路径
script_dir = os.path.dirname(os.path.abspath(__file__))
project_root = os.path.dirname(script_dir)
if project_root not in sys.path:
    sys.path.insert(0, project_root)

import torch
import torch.distributed as dist

# 设置CUDA环境
os.environ['USE_XPU'] = '0'
os.environ['USE_CUDA'] = '1'

from mpi4py import MPI


def init_dist_torchrun():
    """使用 torchrun 初始化分布式环境"""
    # torchrun 会自动设置这些环境变量
    rank = int(os.environ['RANK'])
    world_size = int(os.environ['WORLD_SIZE'])
    local_rank = int(os.environ['LOCAL_RANK'])
    
    # 设置 CUDA 设备
    torch.cuda.set_device(local_rank)
    device = f'cuda:{local_rank}'
    
    # 初始化 PyTorch 分布式 (torchrun 已经设置了 MASTER_ADDR 和 MASTER_PORT)
    dist.init_process_group(backend='nccl')
    
    group = dist.new_group(list(range(world_size)))
    return rank, world_size, group, device


def init_dist_mpi(port: int = 29500):
    """使用 MPI 初始化分布式环境"""
    comm = MPI.COMM_WORLD
    rank = comm.Get_rank()
    world_size = comm.Get_size()
    
    # 设置 CUDA 设备
    local_rank = rank % torch.cuda.device_count()
    torch.cuda.set_device(local_rank)
    device = f'cuda:{local_rank}'
    
    # 设置环境变量
    os.environ['MASTER_ADDR'] = os.getenv('MASTER_ADDR', '127.0.0.1')
    os.environ['MASTER_PORT'] = str(port)
    os.environ['RANK'] = str(rank)
    os.environ['WORLD_SIZE'] = str(world_size)
    os.environ['LOCAL_RANK'] = str(local_rank)
    
    # 初始化 PyTorch 分布式
    dist.init_process_group(
        backend='nccl',
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
    topk_idx = topk_idx.to(deep_ep.topk_idx_t)
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
        print("rank_prefix_matrix:", rank_prefix_matrix)
        print("check_x:", check_x)
        """验证 dispatch 后每个 rank 收到的数据值等于发送者的 rank"""
        assert torch.allclose(check_x.amin(dim=1), check_x.amax(dim=1)), \
            "Each token should have uniform values"
        check_start = 0
        for i in range(num_ranks):
            check_end = rank_prefix_matrix[i][rank].item()
            expected_val = i
            
            actual_vals = check_x[check_start:check_end, :].float()
            
            # print("dispatch rank:", rank, "actual vals:", actual_vals)
            # print("dispatch rank:", rank, "expected vals:", expected_val)
            diff = (actual_vals - expected_val).abs().max().item()
            assert diff < 1e-3, f"Data from rank {i} should be {expected_val}, got diff={diff}"
            check_start = check_end

    # ========== 测试 Dispatch + Combine ==========
    test_cases = [
        ('BF16 without topk', x, False),
        # ('BF16 with topk', x, True),
        # ('Random BF16 without topk', x_pure_rand, False),
        # ('Random BF16 with topk', x_pure_rand, True),
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
        
        torch.cuda.synchronize()
        
        # 验证 dispatch 结果
        rank_prefix_matrix = handle[0]
        expected_recv_tokens = gbl_num_tokens_per_rank[rank].item()
        actual_recv_tokens = recv_x.size(0)
        assert expected_recv_tokens == actual_recv_tokens, \
            f'Expected {expected_recv_tokens} tokens, got {actual_recv_tokens}'
        
        if current_x is x:
            check_dispatch_data(recv_x, rank_prefix_matrix)
        
        if local_rank == 0:
            print(f'  [dispatch] recv_x shape: {recv_x.shape}, passed', flush=True)
        
        # ===== Combine =====
        combine_args = {'x': recv_x, 'handle': handle, 'config': config}
        if with_topk:
            combine_args.update({'topk_weights': recv_topk_weights})
        print("rank:", rank, "handle for combine:", handle)
        combined_x, combined_topk_weights, event = buffer.combine(**combine_args)
        
        torch.cuda.synchronize()
        
        # 调试输出
        if local_rank == 1:
            print(f'  [debug] combined_x shape: {combined_x.shape}', flush=True)
            print(f'  [debug] x shape: {x.shape}', flush=True)
            print(f'  [debug] is_token_in_rank shape: {is_token_in_rank.shape}', flush=True)
            print(f'  [debug] num_tokens: {num_tokens}', flush=True)
        
        # 验证 combine 结果
        # combined_x 应该是 [num_tokens, hidden] 形状，与原始 x 相同
        assert combined_x.shape[0] == num_tokens, \
            f'combined_x shape mismatch: expected {num_tokens}, got {combined_x.shape[0]}'
        
        num_copies = is_token_in_rank.sum(dim=1).unsqueeze(1).float()
        check_x = combined_x.float() / num_copies
        ref_x = x_pure_rand if current_x is x_pure_rand else x
        print("rank:", rank, "combine check_x:", check_x)
        print("rank:", rank, "combine ref_x:", ref_x)
        for x in ref_x:
            print(f"rank:{rank} ref_x row:{x}", x)
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

    if local_rank == 0:
        print(f'\n========== All tests passed! ==========\n', flush=True)


def main():
    parser = argparse.ArgumentParser(description='Test CUDA intranode dispatch + combine')
    parser.add_argument('--num-tokens', type=int, default=8)
    parser.add_argument('--hidden', type=int, default=128)
    parser.add_argument('--num-topk', type=int, default=2)
    parser.add_argument('--num-experts', type=int, default=4)
    parser.add_argument('--port', type=int, default=None,
                        help='Master port (default: auto-select or use torchrun default)')
    parser.add_argument('--launcher', type=str, default='mpi', choices=['mpi', 'torchrun'],
                        help='Launcher type: mpi or torchrun')
    args = parser.parse_args()
    
    # 如果没有指定端口，使用默认值
    if args.port is None:
        args.port = 29500

    import deep_ep
    
    # 根据 launcher 类型选择初始化方式
    if args.launcher == 'torchrun':
        rank, num_ranks, group, device = init_dist_torchrun()
    else:
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
    torch.cuda.synchronize()
    
    # 使用相应的 barrier
    if args.launcher == 'mpi':
        from mpi4py import MPI
        comm = MPI.COMM_WORLD
        comm.Barrier()
        # 汇总结果
        all_passed = comm.allreduce(test_passed, op=MPI.LAND)
    else:
        # torchrun 使用 dist.barrier
        dist.barrier()
        # 汇总结果
        all_passed_tensor = torch.tensor([int(test_passed)], device=device)
        dist.all_reduce(all_passed_tensor, op=dist.ReduceOp.MIN)
        all_passed = bool(all_passed_tensor.item())
    
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
    if args.launcher == 'mpi':
        from mpi4py import MPI
        comm = MPI.COMM_WORLD
        comm.Barrier()
    else:
        try:
            dist.barrier()
        except:
            pass
    
    if not all_passed:
        sys.exit(1)


if __name__ == '__main__':
    main()
