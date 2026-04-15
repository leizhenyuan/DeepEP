#!/usr/bin/env python
"""
XPU Intranode Combine Stress Test (int32)

通过 dispatch → combine 全链路验证 combine 正确性。
使用 int32 数据类型，combine 的 reduce 是加法，验证逻辑：
  - dispatch 前：x[i,:] = rank * 1000000 + token_id
  - dispatch 后：recv_x 存其他 rank 发来的 int32 值（不做 expert 变换）
  - combine 后：combined_x[i,:] = sum of copies = value * num_copies
  - 验证：combined_x[i,:] == (rank * 1000000 + i) * num_copies[i]

注意：num_copies = is_token_in_rank[i].sum()，即 token i 被发送到的 rank 数。
对于 topk=2, num_ranks=4 的确定性路由，大部分 token 发到 2 个 rank，
所以 combined_x = 原值 * 2。

测试命令:
    mpirun -np 2 python tests/test_xpu_combine_stress.py
    mpirun -np 4 python tests/test_xpu_combine_stress.py --num-tokens 64
    mpirun -np 4 python tests/test_xpu_combine_stress.py --num-tokens 1024 --repeat 5
"""

import argparse
import os
import sys
import time

script_dir = os.path.dirname(os.path.abspath(__file__))
project_root = os.path.dirname(script_dir)
if project_root not in sys.path:
    sys.path.insert(0, project_root)

import torch
import torch.distributed as dist

os.environ['USE_XPU'] = '1'
os.environ['USE_CUDA'] = '0'

from mpi4py import MPI


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

    dist.init_process_group(
        backend='xccl',
        init_method=f'tcp://{os.environ["MASTER_ADDR"]}:{port}',
        world_size=world_size,
        rank=rank
    )

    group = dist.new_group(list(range(world_size)))
    return rank, world_size, group, device


def build_deterministic_routing(num_tokens, num_topk, num_experts, num_ranks, device):
    experts_per_rank = num_experts // num_ranks

    topk_idx = torch.zeros((num_tokens, num_topk), dtype=torch.int64, device=device)
    for i in range(num_tokens):
        for k in range(num_topk):
            target_rank = (i + k) % num_ranks
            topk_idx[i, k] = target_rank * experts_per_rank

    topk_weights = torch.ones((num_tokens, num_topk), dtype=torch.float32, device=device)

    is_token_in_rank = torch.zeros(num_tokens, num_ranks, dtype=torch.bool, device=device)
    for i in range(num_tokens):
        seen = set()
        for k in range(num_topk):
            r = (i + k) % num_ranks
            if r not in seen:
                is_token_in_rank[i, r] = True
                seen.add(r)

    num_tokens_per_rank = is_token_in_rank.sum(dim=0).to(torch.int32)

    num_tokens_per_expert = torch.zeros(num_experts, dtype=torch.int32, device=device)
    for i in range(num_tokens):
        for k in range(num_topk):
            idx = topk_idx[i, k].item()
            num_tokens_per_expert[idx] += 1

    return topk_idx, topk_weights, is_token_in_rank, num_tokens_per_rank, num_tokens_per_expert


def build_encoded_data_int32(num_tokens, hidden, rank, device):
    assert num_tokens < 1000000, f"num_tokens must be < 1000000, got {num_tokens}"
    values = rank * 1000000 + torch.arange(num_tokens, dtype=torch.int32, device=device)
    x = values.unsqueeze(1).expand(num_tokens, hidden).contiguous()
    return x


def verify_combine_int32(combined_x, is_token_in_rank, rank, num_tokens, hidden, verbose=False):
    """
    验证 combine 结果：
    combined_x[i,:] 应 == (rank * 1000000 + i) * num_copies[i]

    因为 dispatch 时 x[i,:] 全填 rank*1000000+i，
    combine 将各 rank 发回的副本相加（identity expert），
    即 value * num_copies。
    """
    errors = []

    if combined_x.shape[0] != num_tokens:
        errors.append(f"Shape mismatch: expected {num_tokens} tokens, got {combined_x.shape[0]}")
        return errors

    num_copies = is_token_in_rank.sum(dim=1)  # [num_tokens]

    for i in range(num_tokens):
        original_val = rank * 1000000 + i
        nc = num_copies[i].item()
        expected_val = original_val * nc

        actual_val = combined_x[i, 0].item()
        if actual_val != expected_val:
            errors.append(
                f"Token {i}: expected {expected_val} (={original_val}*{nc}), got {actual_val}")
            if len(errors) > 20:
                errors.append("... too many errors, stopping")
                return errors
            continue

        row = combined_x[i, :]
        if not (row == expected_val).all():
            mismatches = (row != expected_val).sum().item()
            errors.append(
                f"Token {i}: {mismatches}/{hidden} elements differ (expected {expected_val})")
            if len(errors) > 20:
                errors.append("... too many errors, stopping")
                return errors

        if verbose and i < 3:
            print(f"  [rank {rank}] token {i}: val={actual_val} "
                  f"(original={original_val} * {nc} copies) OK", flush=True)

    return errors


def run_combine_test(args, rank, num_ranks, device, buffer, iteration,
                     topk_idx, topk_weights, is_token_in_rank,
                     num_tokens_per_rank, num_tokens_per_expert):
    import deep_ep

    num_tokens = args.num_tokens
    hidden = args.hidden
    config = deep_ep.Config(args.num_sms, 256, 512)

    # 1. Build encoded data
    x = build_encoded_data_int32(num_tokens, hidden, rank, device)

    torch.xpu.synchronize()
    t0 = time.perf_counter()

    # 2. Dispatch
    recv_x, recv_topk_idx, recv_topk_weights, recv_expert_list, handle, event = \
        buffer.dispatch(
            x=x,
            num_tokens_per_rank=num_tokens_per_rank,
            is_token_in_rank=is_token_in_rank,
            num_tokens_per_expert=num_tokens_per_expert,
            topk_idx=topk_idx,
            topk_weights=topk_weights,
            config=config,
        )
    torch.xpu.synchronize()
    t1 = time.perf_counter()

    # 3. Combine (no expert transformation — identity)
    combined_x, combined_topk_weights, combine_event = buffer.combine(
        x=recv_x,
        handle=handle,
        topk_weights=recv_topk_weights,
        config=config,
    )
    torch.xpu.synchronize()
    t2 = time.perf_counter()

    dispatch_ms = (t1 - t0) * 1000
    combine_ms = (t2 - t1) * 1000

    # 4. Verify
    verbose = (iteration == 0 and rank == 0)
    combine_errors = verify_combine_int32(
        combined_x, is_token_in_rank, rank, num_tokens, hidden, verbose=verbose)

    return combine_errors, dispatch_ms, combine_ms


def main():
    parser = argparse.ArgumentParser(description='Combine stress test (int32)')
    parser.add_argument('--num-tokens', type=int, default=16)
    parser.add_argument('--hidden', type=int, default=5120)
    parser.add_argument('--num-topk', type=int, default=2)
    parser.add_argument('--num-experts', type=int, default=128)
    parser.add_argument('--num-sms', type=int, default=4)
    parser.add_argument('--port', type=int, default=29500)
    parser.add_argument('--repeat', type=int, default=1)
    parser.add_argument('--warmup', type=int, default=3)
    parser.add_argument('--max-errors', type=int, default=20)
    args = parser.parse_args()

    import deep_ep

    rank, num_ranks, group, device = init_dist_mpi(port=args.port)
    comm = MPI.COMM_WORLD

    assert args.num_experts % num_ranks == 0

    if rank == 0:
        print(f'[init] {num_ranks} ranks, device={device}', flush=True)
        print(f'[config] num_tokens={args.num_tokens}, hidden={args.hidden}, '
              f'num_topk={args.num_topk}, num_experts={args.num_experts}, '
              f'num_sms={args.num_sms}, repeat={args.repeat}', flush=True)
        print(f'[config] dtype=int32, test=dispatch+combine correctness', flush=True)

    mpi_comm = MPI.COMM_WORLD
    buffer = deep_ep.Buffer(group, int(1e9), 0, low_latency_mode=False, num_qps_per_rank=1, comm=mpi_comm)

    topk_idx, topk_weights, is_token_in_rank, num_tokens_per_rank, num_tokens_per_expert = \
        build_deterministic_routing(args.num_tokens, args.num_topk, args.num_experts, num_ranks, device)

    # Warmup
    if args.warmup > 0:
        if rank == 0:
            print(f'\n[warmup] {args.warmup} iterations...', flush=True)
        for _ in range(args.warmup):
            x = build_encoded_data_int32(args.num_tokens, args.hidden, rank, device)
            config = deep_ep.Config(args.num_sms, 256, 384)
            recv_x, _, recv_topk_weights, _, handle, _ = buffer.dispatch(
                x=x,
                num_tokens_per_rank=num_tokens_per_rank,
                is_token_in_rank=is_token_in_rank,
                num_tokens_per_expert=num_tokens_per_expert,
                topk_idx=topk_idx,
                topk_weights=topk_weights,
                config=config,
            )
            _ = buffer.combine(x=recv_x, handle=handle,
                               topk_weights=recv_topk_weights, config=config)
            torch.xpu.synchronize()
        if rank == 0:
            print(f'[warmup] done', flush=True)

    # Test iterations
    total_errors = 0
    dispatch_times = []
    combine_times = []
    all_passed_local = True

    for iteration in range(args.repeat):
        errs, d_ms, c_ms = run_combine_test(
            args, rank, num_ranks, device, buffer, iteration,
            topk_idx, topk_weights, is_token_in_rank,
            num_tokens_per_rank, num_tokens_per_expert)
        dispatch_times.append(d_ms)
        combine_times.append(c_ms)

        if errs:
            all_passed_local = False
            total_errors += len(errs)
            for e in errs[:args.max_errors]:
                print(f'[rank {rank}] iter {iteration} ERROR: {e}', flush=True)
        else:
            print(f'[rank {rank}] iter {iteration} OK '
                  f'(dispatch={d_ms:.3f}ms combine={c_ms:.3f}ms)', flush=True)

    # Summary
    torch.xpu.synchronize()
    comm.Barrier()

    if combine_times:
        avg_c = sum(combine_times) / len(combine_times)
        min_c = min(combine_times)
        max_c = max(combine_times)
        print(f'[rank {rank}] combine: avg={avg_c:.3f}ms min={min_c:.3f}ms '
              f'max={max_c:.3f}ms errors={total_errors}', flush=True)

    all_passed = comm.allreduce(all_passed_local, op=MPI.LAND)

    if rank == 0:
        if all_passed:
            print(f'\n========== ALL PASSED ==========\n', flush=True)
        else:
            print(f'\n========== FAILED ==========\n', flush=True)

    try:
        dist.destroy_process_group()
    except Exception:
        pass

    comm.Barrier()
    if not all_passed:
        sys.exit(1)


if __name__ == '__main__':
    main()
