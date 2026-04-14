#!/usr/bin/env python
"""
XPU Intranode Dispatch 精确验证测试

使用确定性路由 + 精确值编码，逐 token 验证 dispatch 和 combine 的正确性。

测试命令:
    mpirun -np 2 python tests/test_xpu_intranode_dispatch_v2.py
    mpirun -np 2 python tests/test_xpu_intranode_dispatch_v2.py --test dispatch
    mpirun -np 2 python tests/test_xpu_intranode_dispatch_v2.py --test combine
    mpirun -np 2 python tests/test_xpu_intranode_dispatch_v2.py --test both
"""

import argparse
import os
import sys

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
    """
    确定性路由：token i 的第 k 个 expert 选择 rank (i + k) % num_ranks 的第一个 expert。
    这样每个 rank 收到的 token 数量是均匀可预测的。

    Returns:
        topk_idx:           [num_tokens, num_topk], int64
        topk_weights:       [num_tokens, num_topk], float32
        is_token_in_rank:   [num_tokens, num_ranks], bool
        num_tokens_per_rank:    [num_ranks], int32
        num_tokens_per_expert:  [num_experts], int32
    """
    experts_per_rank = num_experts // num_ranks

    topk_idx = torch.zeros((num_tokens, num_topk), dtype=torch.int64, device=device)
    for i in range(num_tokens):
        for k in range(num_topk):
            target_rank = (i + k) % num_ranks
            topk_idx[i, k] = target_rank * experts_per_rank

    topk_weights = torch.ones((num_tokens, num_topk), dtype=torch.float32, device=device)

    # 构造 is_token_in_rank：每个 token 发送到哪些 rank（去重）
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


def build_encoded_data(num_tokens, hidden, rank, device):
    """
    构造编码数据：每个 token 的所有 hidden 维度值相同，值 = rank * 10000 + token_id。
    dispatch 后可以精确解码出 (src_rank, token_id)。

    要求 num_tokens < 10000 以保证编码不冲突。
    """
    assert num_tokens < 10000, "num_tokens must be < 10000 for encoding to work"
    x = torch.zeros((num_tokens, hidden), dtype=torch.bfloat16, device=device)
    for i in range(num_tokens):
        x[i, :] = rank * 100 + i
    return x


def verify_dispatch(recv_x, rank_prefix_matrix, rank, num_ranks,
                    all_is_token_in_rank, all_num_tokens_per_rank):
    """
    逐 token 精确验证 dispatch 结果：
    1. 收到的 token 数量正确
    2. 每个 token 的值能精确解码出 (src_rank, token_id)
    3. src_rank 与 rank_prefix_matrix 分段一致
    4. 该 token 确实应该发给本 rank
    """
    errors = []

    # 验证总接收数量
    expected_total = sum(t[rank].item() for t in all_num_tokens_per_rank)
    actual_total = recv_x.shape[0]
    if expected_total != actual_total:
        errors.append(f"Total recv count mismatch: expected {expected_total}, got {actual_total}")
        return errors

    recv_values = recv_x[:, 0].float()
    check_start = 0

    for src_rank in range(num_ranks):
        check_end = rank_prefix_matrix[src_rank][rank].item()
        segment_size = check_end - check_start

        # 验证段大小
        expected_segment = all_num_tokens_per_rank[src_rank][rank].item()
        if segment_size != expected_segment:
            errors.append(f"Segment from rank {src_rank}: expected {expected_segment} tokens, "
                          f"got {segment_size}")

        # 逐 token 验证
        seen_tokens = set()
        for idx in range(check_start, check_end):
            val = recv_values[idx].item()
            decoded_rank = int(round(val)) // 100
            decoded_token = int(round(val)) % 100

            if decoded_rank != src_rank:
                errors.append(f"Token at idx {idx}: value {val} decodes to rank {decoded_rank}, "
                              f"expected src_rank {src_rank}")
                continue

            num_tokens_src = all_is_token_in_rank[src_rank].shape[0]
            if decoded_token < 0 or decoded_token >= num_tokens_src:
                errors.append(f"Token at idx {idx}: value {val} decodes to token_id {decoded_token}, "
                              f"out of range [0, {num_tokens_src})")
                continue

            if not all_is_token_in_rank[src_rank][decoded_token, rank].item():
                errors.append(f"Token {decoded_token} from rank {src_rank} should NOT be sent "
                              f"to rank {rank}")

            # 验证行内所有元素一致
            row = recv_x[idx, :].float()
            expected_val = torch.full_like(row, val)
            if not torch.allclose(row, expected_val, atol=1.0):
                errors.append(f"Token at idx {idx}: row values not uniform (data corruption)")

            if decoded_token in seen_tokens:
                errors.append(f"Token {decoded_token} from rank {src_rank} received twice")
            seen_tokens.add(decoded_token)

        check_start = check_end

    return errors


def verify_combine(combined_x, original_x, is_token_in_rank, num_tokens):
    """
    验证 combine 结果：
    combined_x[i] = original_x[i] * num_copies，其中 num_copies 是 token i 被发送到的 rank 数。
    """
    errors = []

    if combined_x.shape[0] != num_tokens:
        errors.append(f"combined_x shape mismatch: expected {num_tokens} rows, got {combined_x.shape[0]}")
        return errors

    num_copies = is_token_in_rank.sum(dim=1).float()

    for i in range(num_tokens):
        copies = num_copies[i].item()
        if copies == 0:
            continue

        actual = combined_x[i, 0].float().item()
        expected = original_x[i, 0].float().item() * copies

        if abs(actual - expected) > abs(expected) * 1e-2 + 1.0:
            errors.append(f"Token {i}: combined={actual}, expected={expected} "
                          f"(original={original_x[i,0].item()}, copies={copies})")

    return errors


def test_dispatch_combine(args, rank, num_ranks, group, device, buffer):
    import deep_ep
    import time

    num_tokens = args.num_tokens
    hidden = args.hidden
    num_topk = args.num_topk
    num_experts = args.num_experts
    test_mode = args.test

    assert num_experts % num_ranks == 0, \
        f"num_experts ({num_experts}) must be divisible by num_ranks ({num_ranks})"

    if rank == 0:
        print(f'[config] num_tokens={num_tokens}, hidden={hidden}, num_topk={num_topk}, '
              f'num_experts={num_experts}, num_ranks={num_ranks}, mode={test_mode}', flush=True)

    # ====== 1. 确定性路由 ======
    topk_idx, topk_weights, is_token_in_rank, num_tokens_per_rank, num_tokens_per_expert = \
        build_deterministic_routing(num_tokens, num_topk, num_experts, num_ranks, device)

    if rank == 0:
        print(f'[routing] num_tokens_per_rank={num_tokens_per_rank.tolist()}', flush=True)
        print(f'[routing] num_tokens_per_expert={num_tokens_per_expert.tolist()}', flush=True)

    # ====== 2. 编码数据 ======
    x = build_encoded_data(num_tokens, hidden, rank, device)
    print(f'[rank {rank}] x[:4, 0] = {x[:4, 0].tolist()}', flush=True)

    # ====== 3. 收集全局元数据（用于验证） ======
    gbl_num_tokens_per_rank = num_tokens_per_rank.clone()
    dist.all_reduce(gbl_num_tokens_per_rank, group=group)

    all_num_tokens_per_rank = [torch.zeros_like(num_tokens_per_rank) for _ in range(num_ranks)]
    dist.all_gather(all_num_tokens_per_rank, num_tokens_per_rank, group=group)

    all_is_token_in_rank = [torch.zeros_like(is_token_in_rank) for _ in range(num_ranks)]
    dist.all_gather(all_is_token_in_rank, is_token_in_rank, group=group)

    if rank == 0:
        print(f'[global] gbl_num_tokens_per_rank={gbl_num_tokens_per_rank.tolist()}', flush=True)
        for r in range(num_ranks):
            print(f'[global] rank {r} sends: {all_num_tokens_per_rank[r].tolist()}', flush=True)

    # ====== 4. Dispatch ======
    config = deep_ep.Config(args.num_sms, 256, 384)

    # ====== Warmup ======
    if rank == 0:
        print(f'\n[warmup] Running warmup iterations...', flush=True)
    for _ in range(3):
        _ = buffer.dispatch(
            x=x,
            num_tokens_per_rank=num_tokens_per_rank,
            is_token_in_rank=is_token_in_rank,
            num_tokens_per_expert=num_tokens_per_expert,
            topk_idx=topk_idx,
            topk_weights=topk_weights,
            config=config,
        )
        torch.xpu.synchronize()

    if rank == 0:
        print(f'\n[dispatch] Starting...', flush=True)

    torch.xpu.synchronize()
    dispatch_start = time.perf_counter()

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
    dispatch_end = time.perf_counter()
    dispatch_ms = (dispatch_end - dispatch_start) * 1000
    print(f'[rank {rank}] DISPATCH TIME: {dispatch_ms:.3f} ms', flush=True)

    # ====== Profiled dispatch run ======
    if args.profile:
        if rank == 0:
            print(f'\n[profile] Running profiled dispatch + combine...', flush=True)

        with torch.profiler.profile(
            activities=[
                torch.profiler.ProfilerActivity.CPU,
                torch.profiler.ProfilerActivity.XPU,
            ],
            record_shapes=True,
            with_stack=False,
        ) as prof:
            torch.xpu.synchronize()

            with torch.profiler.record_function("dispatch_e2e"):
                recv_x2, recv_topk_idx2, recv_topk_weights2, recv_expert_list2, handle2, event2 = \
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

            if test_mode != 'dispatch':
                with torch.profiler.record_function("combine_e2e"):
                    combined_x2, combined_topk_weights2, event3 = buffer.combine(
                        x=recv_x2, handle=handle2, config=config,
                        topk_weights=recv_topk_weights2,
                    )
                    torch.xpu.synchronize()

        # Print profiler results
        print(f'\n[rank {rank}] === PROFILER RESULTS ===', flush=True)
        print(prof.key_averages().table(sort_by="self_xpu_time_total", row_limit=30), flush=True)

        # Export chrome trace
        trace_path = f'/tmp/deepep_trace_rank{rank}.json'
        prof.export_chrome_trace(trace_path)
        print(f'[rank {rank}] Chrome trace exported to {trace_path}', flush=True)

    # ====== 5. 验证 dispatch ======
    rank_prefix_matrix = handle[0]
    print(f'[rank {rank}] recv_x shape: {recv_x.shape}', flush=True)
    print(f'[rank {rank}] recv_x = {recv_x}', flush=True)
    print(f'[rank {rank}] rank_prefix_matrix:\n{rank_prefix_matrix.cpu()}', flush=True)

    dispatch_errors = verify_dispatch(
        recv_x, rank_prefix_matrix, rank, num_ranks,
        all_is_token_in_rank, all_num_tokens_per_rank
    )

    if dispatch_errors:
        for err in dispatch_errors:
            print(f'[rank {rank}] DISPATCH ERROR: {err}', flush=True)
        raise AssertionError(f"Dispatch failed with {len(dispatch_errors)} errors")
    else:
        print(f'[rank {rank}] DISPATCH OK: {recv_x.shape[0]} tokens verified', flush=True)

    if test_mode == 'dispatch':
        return

    # ====== 6. Combine ======
    if rank == 0:
        print(f'\n[combine] Starting...', flush=True)

    torch.xpu.synchronize()
    combine_start = time.perf_counter()

    combined_x, combined_topk_weights, event = buffer.combine(
        x=recv_x, handle=handle, config=config,
        topk_weights=recv_topk_weights,
    )

    torch.xpu.synchronize()
    combine_end = time.perf_counter()
    combine_ms = (combine_end - combine_start) * 1000
    print(f'[rank {rank}] COMBINE TIME: {combine_ms:.3f} ms', flush=True)

    # DEBUG: 打印 recv_topk_weights[8..15] 中的 debug values
    flat_weights = combined_topk_weights.flatten()
    if flat_weights.numel() > 15:
        dbg_vals = flat_weights[0:16].float().cpu().tolist()
        print(f'[rank {rank}] DEBUG values[0..15] (pre-store values): {dbg_vals}', flush=True)

    # ====== 7. 验证 combine ======
    # print(f'[rank {rank}] combined_x shape: {combined_x.shape}', flush=True)
    # print(f'[rank {rank}] combined_x = {combined_x}', flush=True)

    combine_errors = verify_combine(combined_x, x, is_token_in_rank, num_tokens)

    if combine_errors:
        for err in combine_errors:
            print(f'[rank {rank}] COMBINE ERROR: {err}', flush=True)
        raise AssertionError(f"Combine failed with {len(combine_errors)} errors")
    else:
        print(f'[rank {rank}] COMBINE OK: {num_tokens} tokens verified', flush=True)


def main():
    parser = argparse.ArgumentParser(description='Test XPU intranode dispatch (deterministic)')
    parser.add_argument('--num-tokens', type=int, default=1)
    parser.add_argument('--hidden', type=int, default=5120)
    parser.add_argument('--num-topk', type=int, default=2)
    parser.add_argument('--num-experts', type=int, default=128)
    parser.add_argument('--num-sms', type=int, default=16)
    parser.add_argument('--port', type=int, default=29500)
    parser.add_argument('--test', type=str, default='both',
                        choices=['dispatch', 'combine', 'both'],
                        help='Which phase to test: dispatch, combine, or both')
    parser.add_argument('--profile', action='store_true', default=False,
                        help='Enable profiling and print profiler results')
    args = parser.parse_args()

    import deep_ep

    rank, num_ranks, group, device = init_dist_mpi(port=args.port)
    comm = MPI.COMM_WORLD

    if rank == 0:
        print(f'[init] {num_ranks} ranks, device={device}', flush=True)

    buffer = deep_ep.Buffer(group, int(1e9), 0, low_latency_mode=False, num_qps_per_rank=1)

    if rank == 0:
        print(f'[init] Buffer created', flush=True)

    test_passed = False
    try:
        test_dispatch_combine(args, rank, num_ranks, group, device, buffer)
        test_passed = True
    except Exception as e:
        print(f'[rank {rank}] FAILED: {e}', flush=True)
        import traceback
        traceback.print_exc()

    torch.xpu.synchronize()
    comm.Barrier()

    all_passed = comm.allreduce(test_passed, op=MPI.LAND)

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
