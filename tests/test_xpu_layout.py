#!/usr/bin/env python
"""
XPU get_dispatch_layout kernel 正确性测试

测试 SYCL layout kernel 的三个输出:
  - num_tokens_per_rank    [num_ranks]              去重 token 计数
  - num_tokens_per_expert  [num_experts]             不去重 expert 计数
  - is_token_in_rank       [num_tokens, num_ranks]   去重 bool 路由表

测试命令:
    mpirun -np 2 python tests/test_xpu_layout.py
    mpirun -np 2 python tests/test_xpu_layout.py --num-tokens 128 --num-topk 4 --num-experts 16
    mpirun -np 2 python tests/test_xpu_layout.py --sweep
    mpirun -np 1 python tests/test_xpu_layout.py --sweep
"""

import argparse
import os
import sys
import torch
import torch.distributed as dist

from mpi4py import MPI

os.environ['USE_XPU'] = '1'
os.environ['USE_CUDA'] = '0'


def init_dist_mpi(port: int = 29500):
    comm = MPI.COMM_WORLD
    rank = comm.Get_rank()
    world_size = comm.Get_size()

    torch.xpu.set_device(rank)
    device = f'xpu:{rank}'

    os.environ['MASTER_ADDR'] = os.getenv('MASTER_ADDR', '127.0.0.1')
    os.environ['MASTER_PORT'] = str(port)
    os.environ['RANK'] = str(rank)
    os.environ['WORLD_SIZE'] = str(world_size)

    try:
        dist.init_process_group(
            backend='xccl',
            init_method=f'tcp://{os.environ["MASTER_ADDR"]}:{port}',
            world_size=world_size, rank=rank)
    except Exception:
        dist.init_process_group(
            backend='gloo',
            init_method=f'tcp://{os.environ["MASTER_ADDR"]}:{port}',
            world_size=world_size, rank=rank)

    group = dist.new_group(list(range(world_size)))
    return rank, world_size, group, device, comm


# ─── Python 参考实现 ───

def reference_layout(topk_idx_cpu, num_experts, num_ranks):
    """CPU 端独立计算期望结果（source of truth）"""
    num_tokens, num_topk = topk_idx_cpu.shape
    experts_per_rank = num_experts // num_ranks

    num_tokens_per_expert = torch.zeros(num_experts, dtype=torch.int32)
    is_token_in_rank = torch.zeros(num_tokens, num_ranks, dtype=torch.bool)

    for i in range(num_tokens):
        for k in range(num_topk):
            e = topk_idx_cpu[i, k].item()
            if 0 <= e < num_experts:
                num_tokens_per_expert[e] += 1
                r = e // experts_per_rank
                is_token_in_rank[i, r] = True

    num_tokens_per_rank = is_token_in_rank.sum(dim=0).to(torch.int32)
    return num_tokens_per_rank, num_tokens_per_expert, is_token_in_rank


# ─── 测试用例生成 ───

def gen_uniform_random(num_tokens, num_topk, num_experts, seed):
    """均匀随机：每个 topk slot 独立随机选 expert"""
    torch.manual_seed(seed)
    return torch.randint(0, num_experts, (num_tokens, num_topk), dtype=torch.int64)


def gen_deterministic(num_tokens, num_topk, num_experts, seed):
    """确定性：token i 的第 k 个 topk 选 expert (i+k) % num_experts"""
    topk_idx = torch.zeros(num_tokens, num_topk, dtype=torch.int64)
    for i in range(num_tokens):
        for k in range(num_topk):
            topk_idx[i, k] = (i + k) % num_experts
    return topk_idx


def gen_same_rank_dedup(num_tokens, num_topk, num_experts, num_ranks, seed):
    """去重测试：每个 token 的多个 topk 选同一 rank 的不同 expert"""
    experts_per_rank = num_experts // num_ranks
    if num_topk > experts_per_rank:
        return None  # 无法构造
    topk_idx = torch.zeros(num_tokens, num_topk, dtype=torch.int64)
    for i in range(num_tokens):
        target_rank = i % num_ranks
        base = target_rank * experts_per_rank
        for k in range(num_topk):
            topk_idx[i, k] = base + (k % experts_per_rank)
    return topk_idx


def gen_same_expert(num_tokens, num_topk, num_experts, seed):
    """重复 expert：每个 token 的所有 topk 选同一个 expert"""
    topk_idx = torch.zeros(num_tokens, num_topk, dtype=torch.int64)
    for i in range(num_tokens):
        e = i % num_experts
        topk_idx[i, :] = e
    return topk_idx


def gen_with_neg1(num_tokens, num_topk, num_experts, seed):
    """含 -1：奇数位置的 topk slot 设为 -1"""
    torch.manual_seed(seed)
    topk_idx = torch.randint(0, num_experts, (num_tokens, num_topk), dtype=torch.int64)
    for k in range(1, num_topk, 2):
        topk_idx[:, k] = -1
    return topk_idx


def gen_all_neg1(num_tokens, num_topk, num_experts, seed):
    """全 -1：所有 topk 设为 -1"""
    return torch.full((num_tokens, num_topk), -1, dtype=torch.int64)


def gen_all_to_rank0(num_tokens, num_topk, num_experts, num_ranks, seed):
    """集中到 rank 0：所有 expert 选择都在 rank 0 的范围内"""
    experts_per_rank = num_experts // num_ranks
    torch.manual_seed(seed)
    return torch.randint(0, experts_per_rank, (num_tokens, num_topk), dtype=torch.int64)


def build_test_cases(num_tokens, num_topk, num_experts, num_ranks, seed):
    """构造所有测试用例"""
    cases = []

    cases.append(("uniform_random",
                  gen_uniform_random(num_tokens, num_topk, num_experts, seed)))

    cases.append(("deterministic",
                  gen_deterministic(num_tokens, num_topk, num_experts, seed)))

    dedup = gen_same_rank_dedup(num_tokens, num_topk, num_experts, num_ranks, seed)
    if dedup is not None:
        cases.append(("same_rank_dedup", dedup))

    if num_topk >= 2:
        cases.append(("same_expert",
                      gen_same_expert(num_tokens, num_topk, num_experts, seed)))

    if num_topk >= 2:
        cases.append(("with_neg1",
                      gen_with_neg1(num_tokens, num_topk, num_experts, seed)))

    cases.append(("all_neg1",
                  gen_all_neg1(num_tokens, num_topk, num_experts, seed)))

    cases.append(("all_to_rank0",
                  gen_all_to_rank0(num_tokens, num_topk, num_experts, num_ranks, seed)))

    if num_tokens > 0:
        cases.append(("single_token",
                      gen_uniform_random(1, num_topk, num_experts, seed + 99)))

    return cases


# ─── 验证逻辑 ───

def verify_one(name, topk_idx_cpu, num_experts, num_ranks, buffer, device, rank):
    """跑一个测试用例并验证"""
    import deep_ep

    num_tokens, num_topk = topk_idx_cpu.shape

    # kernel 执行
    topk_idx_gpu = topk_idx_cpu.to(device).to(deep_ep.topk_idx_t)
    result = buffer.get_dispatch_layout(topk_idx_gpu, num_experts)
    actual_per_rank, actual_rdma, actual_per_expert, actual_is_in_rank, _ = result
    torch.xpu.synchronize()

    # to CPU
    actual_per_rank = actual_per_rank.cpu()
    actual_per_expert = actual_per_expert.cpu()
    actual_is_in_rank = actual_is_in_rank.cpu()

    # 参考实现
    exp_per_rank, exp_per_expert, exp_is_in_rank = reference_layout(
        topk_idx_cpu, num_experts, num_ranks)

    # 比较
    errors = []

    if not torch.equal(actual_per_expert, exp_per_expert):
        diff_mask = actual_per_expert != exp_per_expert
        diff_indices = diff_mask.nonzero(as_tuple=True)[0].tolist()
        errors.append(
            f"num_tokens_per_expert mismatch at indices {diff_indices[:10]}: "
            f"got {actual_per_expert[diff_mask].tolist()[:10]}, "
            f"expected {exp_per_expert[diff_mask].tolist()[:10]}")

    if not torch.equal(actual_is_in_rank, exp_is_in_rank):
        diff_mask = actual_is_in_rank != exp_is_in_rank
        num_diff = diff_mask.sum().item()
        errors.append(
            f"is_token_in_rank mismatch: {num_diff}/{num_tokens * num_ranks} elements differ")

    if not torch.equal(actual_per_rank, exp_per_rank):
        errors.append(
            f"num_tokens_per_rank mismatch: got {actual_per_rank.tolist()}, "
            f"expected {exp_per_rank.tolist()}")

    # 一致性检查
    cross_check = actual_is_in_rank.sum(dim=0).to(torch.int32)
    if not torch.equal(actual_per_rank, cross_check):
        errors.append(
            f"cross-check failed: per_rank={actual_per_rank.tolist()} vs "
            f"is_in_rank.sum(0)={cross_check.tolist()}")

    return errors


# ─── 主测试 ───

def run_tests(args):
    repo_root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    if repo_root not in sys.path:
        sys.path.insert(0, repo_root)
    import deep_ep

    rank, num_ranks, group, device, mpi_comm = init_dist_mpi(args.port)

    buffer = deep_ep.Buffer(
        group, int(1e8), 0,
        low_latency_mode=False, num_qps_per_rank=1,
        comm=mpi_comm)

    mpi_comm.Barrier()

    if args.sweep:
        param_grid = []
        for nt in [1, 8, 64, 256]:
            for nk in [1, 2, 4]:
                for ne in [4, 8, 16]:
                    if ne % num_ranks == 0 and ne // num_ranks >= nk:
                        param_grid.append((nt, nk, ne))
    else:
        nt, nk, ne = args.num_tokens, args.num_topk, args.num_experts
        assert ne % num_ranks == 0, \
            f"num_experts ({ne}) must be divisible by num_ranks ({num_ranks})"
        param_grid = [(nt, nk, ne)]

    total_pass = 0
    total_fail = 0

    if rank == 0:
        print(f"\n{'='*60}")
        print(f"  get_dispatch_layout 正确性测试")
        print(f"  num_ranks={num_ranks}, device={device}")
        print(f"  参数组合: {len(param_grid)} 组")
        print(f"{'='*60}\n")

    for nt, nk, ne in param_grid:
        cases = build_test_cases(nt, nk, ne, num_ranks, args.seed)
        # 加一个 num_tokens=0 边界情况
        if nt > 0:
            cases.append(("empty_tokens",
                          torch.zeros(0, nk, dtype=torch.int64)))

        if rank == 0:
            print(f"--- tokens={nt}, topk={nk}, experts={ne} "
                  f"({len(cases)} cases) ---")

        for name, topk_idx_cpu in cases:
            errors = verify_one(
                name, topk_idx_cpu, ne, num_ranks, buffer, device, rank)

            if errors:
                total_fail += 1
                if rank == 0:
                    print(f"  \u2717 {name} (tokens={topk_idx_cpu.shape[0]})")
                    for e in errors:
                        print(f"      {e}")
            else:
                total_pass += 1
                if rank == 0:
                    print(f"  \u2713 {name} (tokens={topk_idx_cpu.shape[0]})")

    mpi_comm.Barrier()

    if rank == 0:
        print(f"\n{'='*60}")
        print(f"  结果: {total_pass} passed, {total_fail} failed")
        print(f"{'='*60}\n")

    if total_fail > 0:
        sys.exit(1)


def main():
    parser = argparse.ArgumentParser(
        description='Test XPU get_dispatch_layout kernel')
    parser.add_argument('--num-tokens', type=int, default=64)
    parser.add_argument('--num-topk', type=int, default=2)
    parser.add_argument('--num-experts', type=int, default=8)
    parser.add_argument('--seed', type=int, default=42)
    parser.add_argument('--sweep', action='store_true',
                        help='自动扫描参数矩阵')
    parser.add_argument('--port', type=int, default=29500)
    args = parser.parse_args()
    run_tests(args)


if __name__ == '__main__':
    main()
