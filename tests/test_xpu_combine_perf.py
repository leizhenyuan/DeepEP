#!/usr/bin/env python
"""
XPU Intranode Combine Performance Test (bfloat16)

使用 bfloat16 数据类型测量 dispatch + combine 全链路性能。
不做精确验证，仅检查 shape 和基本 sanity（combined_x 不全为 0）。

测试命令:
    mpirun -np 4 python tests/test_xpu_combine_perf.py --num-tokens 1024 --num-sms 20 --repeat 10
    mpirun -np 4 python tests/test_xpu_combine_perf.py --num-tokens 4096 --num-sms 20 --repeat 5
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


def main():
    parser = argparse.ArgumentParser(description='Combine performance test (bf16)')
    parser.add_argument('--num-tokens', type=int, default=1024)
    parser.add_argument('--hidden', type=int, default=5120)
    parser.add_argument('--num-topk', type=int, default=2)
    parser.add_argument('--num-experts', type=int, default=128)
    parser.add_argument('--num-sms', type=int, default=4)
    parser.add_argument('--port', type=int, default=29500)
    parser.add_argument('--repeat', type=int, default=5)
    parser.add_argument('--warmup', type=int, default=3)
    parser.add_argument('--test', type=str, default='both',
                        choices=['dispatch', 'combine', 'both'],
                        help='Which phase to measure')
    args = parser.parse_args()

    import deep_ep

    rank, num_ranks, group, device = init_dist_mpi(port=args.port)
    comm = MPI.COMM_WORLD

    assert args.num_experts % num_ranks == 0

    if rank == 0:
        print(f'[init] {num_ranks} ranks, device={device}', flush=True)
        print(f'[config] num_tokens={args.num_tokens}, hidden={args.hidden}, '
              f'num_topk={args.num_topk}, num_experts={args.num_experts}, '
              f'num_sms={args.num_sms}, repeat={args.repeat}, test={args.test}', flush=True)
        print(f'[config] dtype=bfloat16, performance only', flush=True)

    mpi_comm = MPI.COMM_WORLD
    buffer = deep_ep.Buffer(group, int(1e9), 0, low_latency_mode=False, num_qps_per_rank=1, comm=mpi_comm)

    topk_idx, topk_weights, is_token_in_rank, num_tokens_per_rank, num_tokens_per_expert = \
        build_deterministic_routing(args.num_tokens, args.num_topk, args.num_experts, num_ranks, device)

    config = deep_ep.Config(args.num_sms, 256, 512)

    # Warmup
    if rank == 0:
        print(f'\n[warmup] {args.warmup} iterations...', flush=True)
    for _ in range(args.warmup):
        x = torch.randn(args.num_tokens, args.hidden, dtype=torch.bfloat16, device=device)
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

    # Benchmark iterations
    dispatch_times = []
    combine_times = []
    total_times = []

    for iteration in range(args.repeat):
        x = torch.randn(args.num_tokens, args.hidden, dtype=torch.bfloat16, device=device)

        torch.xpu.synchronize()
        comm.Barrier()
        t0 = time.perf_counter()

        recv_x, _, recv_topk_weights, _, handle, _ = buffer.dispatch(
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

        combined_x, combined_topk_weights, _ = buffer.combine(
            x=recv_x, handle=handle,
            topk_weights=recv_topk_weights, config=config)
        torch.xpu.synchronize()
        t2 = time.perf_counter()

        d_ms = (t1 - t0) * 1000
        c_ms = (t2 - t1) * 1000
        dispatch_times.append(d_ms)
        combine_times.append(c_ms)
        total_times.append(d_ms + c_ms)

        # Sanity check
        ok = (combined_x.shape == (args.num_tokens, args.hidden) and
              not combined_x.isnan().any().item() and
              combined_x.abs().sum().item() > 0)
        status = "OK" if ok else "SANITY_FAIL"

        if rank == 0:
            print(f'[rank 0] iter {iteration}: dispatch={d_ms:.3f}ms '
                  f'combine={c_ms:.3f}ms total={d_ms+c_ms:.3f}ms [{status}]', flush=True)

    # Summary
    torch.xpu.synchronize()
    comm.Barrier()

    def stats(times):
        avg = sum(times) / len(times)
        return f'avg={avg:.3f}ms min={min(times):.3f}ms max={max(times):.3f}ms'

    if args.test in ('dispatch', 'both'):
        print(f'[rank {rank}] dispatch: {stats(dispatch_times)}', flush=True)
    if args.test in ('combine', 'both'):
        print(f'[rank {rank}] combine:  {stats(combine_times)}', flush=True)
    if args.test == 'both':
        print(f'[rank {rank}] total:    {stats(total_times)}', flush=True)

    try:
        dist.destroy_process_group()
    except Exception:
        pass

    comm.Barrier()


if __name__ == '__main__':
    main()
