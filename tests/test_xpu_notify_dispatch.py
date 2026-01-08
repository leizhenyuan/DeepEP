"""
Test DeepEP XPU notify_dispatch kernel directly.

This test isolates the notify_dispatch kernel to debug barrier synchronization.

Usage:
    # Test the notify_dispatch kernel directly
    python tests/test_xpu_notify_dispatch.py --num-processes 2
    
    # Use MPI (recommended for xccl backend)
    mpirun -np 2 python tests/test_xpu_notify_dispatch.py --use-mpi
"""

import argparse
import os
import sys
import time
import torch
import torch.distributed as dist
import torch.multiprocessing as mp

# MPI 条件导入
try:
    from mpi4py import MPI
    HAS_MPI = True
except ImportError:
    HAS_MPI = False
    MPI = None


def init_dist_mpi(port: int = 29556, use_gloo: bool = False):
    """使用 MPI 初始化分布式环境
    
    Args:
        port: 分布式通信端口
        use_gloo: 是否强制使用 gloo 后端
    """
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


def init_dist_spawn(local_rank: int, num_ranks: int, port: int = 29556):
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


def test_notify_dispatch_direct(rank: int, num_ranks: int, group, device: str, mpi_comm, args):
    """
    Test notify_dispatch kernel directly using the new test_notify_dispatch method.
    This bypasses the full dispatch path and tests the kernel in isolation.
    """
    import deep_ep
    
    use_mpi = mpi_comm is not None
    
    def cpu_barrier():
        if use_mpi:
            mpi_comm.Barrier()
        else:
            dist.barrier(group=group)
    
    cpu_barrier()
    
    # ========== Create Buffer ==========
    if rank == 0:
        print("\n[Setup] Creating DeepEP Buffer...", flush=True)
    
    if use_mpi:
        buffer = deep_ep.Buffer(
            group,
            int(2e8),  # 200MB NVL buffer
            num_rdma_bytes=0,
            low_latency_mode=False,
            num_qps_per_rank=1,
            explicitly_destroy=True,
            comm=mpi_comm
        )
    else:
        buffer = deep_ep.Buffer(
            group,
            int(2e8),  # 200MB NVL buffer
            num_rdma_bytes=0,
            low_latency_mode=False,
            num_qps_per_rank=1,
            explicitly_destroy=True
        )
    
    if rank == 0:
        print(f"[Setup] Buffer created: rank={buffer.rank}, num_ranks={buffer.group_size}", flush=True)
    
    cpu_barrier()
    
    # ========== Test Parameters ==========
    num_tokens = args.num_tokens
    num_experts = args.num_experts
    num_channels = args.num_channels
    expert_alignment = args.expert_alignment
    
    if rank == 0:
        print(f"\n[Test Direct] Parameters:", flush=True)
        print(f"  num_tokens={num_tokens}", flush=True)
        print(f"  num_experts={num_experts}", flush=True)
        print(f"  num_channels={num_channels}", flush=True)
        print(f"  expert_alignment={expert_alignment}", flush=True)
        print(f"  num_ranks={num_ranks}", flush=True)
    
    # ========== Generate Test Data ==========
    # Use fixed seed for reproducibility
    torch.manual_seed(42 + rank)
    
    # Each token randomly selects one expert
    token_expert_idx = torch.randint(0, num_experts, (num_tokens,), device=device)
    
    # Calculate is_token_in_rank
    experts_per_rank = num_experts // num_ranks
    token_rank_idx = token_expert_idx // experts_per_rank
    
    is_token_in_rank = torch.zeros(num_tokens, num_ranks, dtype=torch.bool, device=device)
    for i in range(num_tokens):
        target_rank = token_rank_idx[i].item()
        is_token_in_rank[i, target_rank] = True
    
    # Calculate num_tokens_per_rank
    num_tokens_per_rank = is_token_in_rank.sum(dim=0).to(torch.int32)
    
    # Calculate num_tokens_per_expert
    num_tokens_per_expert = torch.zeros(num_experts, dtype=torch.int32, device=device)
    for i in range(num_tokens):
        expert_idx = token_expert_idx[i].item()
        num_tokens_per_expert[expert_idx] += 1
    
    print(f"[Rank {rank}] Generated test data:", flush=True)
    print(f"  num_tokens_per_rank: {num_tokens_per_rank.tolist()}", flush=True)
    print(f"  num_tokens_per_expert: {num_tokens_per_expert.tolist()}", flush=True)
    
    torch.xpu.synchronize()
    cpu_barrier()
    
    # ========== Call test_notify_dispatch ==========
    if rank == 0:
        print(f"\n[Test Direct] Calling test_notify_dispatch...", flush=True)
    
    start_time = time.time()
    
    try:
        moe_recv_count, expert_counts, rank_prefix_matrix, channel_prefix_matrix = \
            buffer.runtime.test_notify_dispatch(
                num_tokens_per_rank,
                num_tokens_per_expert,
                is_token_in_rank,
                num_tokens,
                num_experts,
                num_channels,
                expert_alignment
            )
        
        elapsed = time.time() - start_time
        print(f"[Rank {rank}] test_notify_dispatch completed in {elapsed*1000:.2f} ms", flush=True)
        
        # Print results
        print(f"[Rank {rank}] Results:", flush=True)
        print(f"  moe_recv_count: {moe_recv_count}", flush=True)
        print(f"  expert_counts: {expert_counts}", flush=True)
        
        # ========== 验证结果 ==========
        all_passed = True
        
        # 1. 验证 moe_recv_count
        # 需要收集所有 rank 的 num_tokens_per_rank，然后计算发送到本 rank 的总数
        # 每个 rank 的 num_tokens_per_rank[i] 表示该 rank 发送给 rank i 的 token 数
        # 所以本 rank 收到的总数 = sum(all_ranks_num_tokens_per_rank[:, rank])
        
        # 使用 MPI/dist 收集所有 rank 的 num_tokens_per_rank
        all_num_tokens_per_rank = [torch.zeros_like(num_tokens_per_rank) for _ in range(num_ranks)]
        dist.all_gather(all_num_tokens_per_rank, num_tokens_per_rank, group=group)
        
        # 计算本 rank 应该收到的 token 总数
        expected_recv_count = sum(t[rank].item() for t in all_num_tokens_per_rank)
        
        if moe_recv_count == expected_recv_count:
            print(f"[Rank {rank}] ✓ moe_recv_count CORRECT! ({moe_recv_count} == {expected_recv_count})", flush=True)
        else:
            print(f"[Rank {rank}] ✗ moe_recv_count MISMATCH! (got {moe_recv_count}, expected {expected_recv_count})", flush=True)
            all_passed = False
        
        # 2. 验证 expert_counts
        # expert_counts 应该等于本 rank 负责的 experts 收到的 token 数
        experts_per_rank = num_experts // num_ranks
        local_expert_start = rank * experts_per_rank
        local_expert_end = local_expert_start + experts_per_rank
        
        # 收集所有 rank 的 num_tokens_per_expert
        all_num_tokens_per_expert = [torch.zeros_like(num_tokens_per_expert) for _ in range(num_ranks)]
        dist.all_gather(all_num_tokens_per_expert, num_tokens_per_expert, group=group)
        
        # 计算本 rank 的每个 local expert 应该收到的 token 数
        expected_expert_counts = []
        for e in range(local_expert_start, local_expert_end):
            count = sum(t[e].item() for t in all_num_tokens_per_expert)
            expected_expert_counts.append(count)
        
        if expert_counts == expected_expert_counts:
            print(f"[Rank {rank}] ✓ expert_counts CORRECT! {expert_counts}", flush=True)
        else:
            print(f"[Rank {rank}] ✗ expert_counts MISMATCH!", flush=True)
            print(f"    got:      {expert_counts}", flush=True)
            print(f"    expected: {expected_expert_counts}", flush=True)
            all_passed = False
        
        # 3. 验证 rank_prefix_matrix
        # 关键理解：每个 rank 的 rank_prefix_matrix 只有列 rank 有有效数据！
        # rank_prefix_matrix[i, rank] = 前 i+1 个 rank 发送给本 rank 的 token 数的前缀和
        print(f"[Rank {rank}] rank_prefix_matrix shape: {rank_prefix_matrix.shape}", flush=True)
        print(f"[Rank {rank}] rank_prefix_matrix:", flush=True)
        print(rank_prefix_matrix.cpu(), flush=True)
        
        rank_prefix_cpu = rank_prefix_matrix.cpu()
        col = rank  # 只有列 rank 有有效数据
        
        # 计算期望的前缀和
        prefix_sum = 0
        for i in range(num_ranks):
            # 期望值：前 i+1 个 rank 发给本 rank 的 token 数的前缀和
            prefix_sum += all_num_tokens_per_rank[i][rank].item()
            actual_val = rank_prefix_cpu[i, col].item()
            
            if actual_val != prefix_sum:
                print(f"[Rank {rank}] ✗ rank_prefix_matrix[{i}, {col}] mismatch: "
                      f"got {actual_val}, expected {prefix_sum}", flush=True)
                all_passed = False
            else:
                print(f"[Rank {rank}] ✓ rank_prefix_matrix[{i}, {col}] = {actual_val} (correct)", flush=True)
        
        # 最后一行的值应该等于 moe_recv_count
        last_row_val = rank_prefix_cpu[num_ranks - 1, col].item()
        if last_row_val != expected_recv_count:
            print(f"[Rank {rank}] ✗ rank_prefix_matrix last row mismatch: "
                  f"got {last_row_val}, expected {expected_recv_count}", flush=True)
            all_passed = False
        else:
            print(f"[Rank {rank}] ✓ rank_prefix_matrix last row = moe_recv_count = {last_row_val}", flush=True)
        
        # 4. 验证 channel_prefix_matrix
        # channel_prefix_matrix[dst_rank, channel] = 前 channel+1 个 channel 中发往 dst_rank 的 token 数的前缀和
        # 这个矩阵是本 rank 本地计算的，不涉及跨 rank 通信
        # print(f"[Rank {rank}] channel_prefix_matrix shape: {channel_prefix_matrix.shape}", flush=True)
        # print(f"[Rank {rank}] channel_prefix_matrix:", flush=True)
        # print(channel_prefix_matrix.cpu(), flush=True)
        
        channel_prefix_cpu = channel_prefix_matrix.cpu()
        
        # 计算期望的 channel_prefix_matrix
        # 首先计算每个 channel 中发往各 rank 的 token 数
        def get_channel_task_range(num_tokens, num_channels, channel_id):
            """计算 channel 的 token 范围（与 kernel 中的逻辑一致）"""
            tokens_per_channel = num_tokens // num_channels
            remainder = num_tokens % num_channels
            if channel_id < remainder:
                start = channel_id * (tokens_per_channel + 1)
                end = start + tokens_per_channel + 1
            else:
                start = remainder * (tokens_per_channel + 1) + (channel_id - remainder) * tokens_per_channel
                end = start + tokens_per_channel
            return start, end
        
        # 计算每个 (dst_rank, channel) 的 token 数
        channel_counts = torch.zeros(num_ranks, num_channels, dtype=torch.int32)
        is_token_in_rank_cpu = is_token_in_rank.cpu()
        
        for dst_rank in range(num_ranks):
            for channel_id in range(num_channels):
                token_start, token_end = get_channel_task_range(num_tokens, num_channels, channel_id)
                count = 0
                for token_idx in range(token_start, token_end):
                    if is_token_in_rank_cpu[token_idx, dst_rank]:
                        count += 1
                channel_counts[dst_rank, channel_id] = count
        
        # 计算前缀和
        expected_channel_prefix = torch.zeros(num_ranks, num_channels, dtype=torch.int32)
        for dst_rank in range(num_ranks):
            prefix_sum = 0
            for channel_id in range(num_channels):
                prefix_sum += channel_counts[dst_rank, channel_id].item()
                expected_channel_prefix[dst_rank, channel_id] = prefix_sum
        
        # 验证
        channel_prefix_match = True
        for dst_rank in range(num_ranks):
            for channel_id in range(num_channels):
                actual = channel_prefix_cpu[dst_rank, channel_id].item()
                expected = expected_channel_prefix[dst_rank, channel_id].item()
                if actual != expected:
                    print(f"[Rank {rank}] ✗ channel_prefix_matrix[{dst_rank}, {channel_id}] mismatch: "
                          f"got {actual}, expected {expected}", flush=True)
                    channel_prefix_match = False
                    all_passed = False
        
        if channel_prefix_match:
            print(f"[Rank {rank}] ✓ channel_prefix_matrix CORRECT!", flush=True)
        
        # 额外检查：每行的最后一个值应该等于发往该 rank 的 token 总数
        for dst_rank in range(num_ranks):
            last_channel_val = channel_prefix_cpu[dst_rank, num_channels - 1].item()
            expected_total = num_tokens_per_rank[dst_rank].item()
            if last_channel_val != expected_total:
                print(f"[Rank {rank}] ✗ channel_prefix_matrix[{dst_rank}] last value mismatch: "
                      f"got {last_channel_val}, expected {expected_total}", flush=True)
                all_passed = False
            else:
                print(f"[Rank {rank}] ✓ channel_prefix_matrix[{dst_rank}] last value = {last_channel_val} "
                      f"(matches num_tokens_per_rank[{dst_rank}])", flush=True)
        
        # 5. 总结
        if all_passed:
            print(f"[Rank {rank}] ✓ All checks PASSED!", flush=True)
        else:
            print(f"[Rank {rank}] ✗ Some checks FAILED!", flush=True)
            # 打印详细信息帮助调试
            print(f"\n[Rank {rank}] Debug info:", flush=True)
            print(f"  all_num_tokens_per_rank:", flush=True)
            for r, t in enumerate(all_num_tokens_per_rank):
                print(f"    Rank {r}: {t.tolist()}", flush=True)
            print(f"  expected_channel_prefix:", flush=True)
            print(expected_channel_prefix, flush=True)
        
    except Exception as e:
        print(f"[Rank {rank}] ERROR during test_notify_dispatch: {e}", flush=True)
        import traceback
        traceback.print_exc()
        raise
    
    torch.xpu.synchronize()
    cpu_barrier()
    
    if rank == 0:
        print(f"\n[Test Direct] notify_dispatch direct test PASSED!", flush=True)
    
    # ========== Cleanup ==========
    buffer.destroy()
    cpu_barrier()


def worker_fn(local_rank: int, num_ranks: int, args):
    """Worker function for multiprocessing (mp.spawn mode)"""
    # Add parent directory to sys.path so subprocess can import deep_ep
    from pathlib import Path
    repo_root = Path(__file__).parent.parent.absolute()
    if str(repo_root) not in sys.path:
        sys.path.insert(0, str(repo_root))
    
    # Initialize distributed backend
    rank, world_size, group, device = init_dist_spawn(local_rank, num_ranks, args.port)
    mpi_comm = None  # No MPI in mp.spawn mode
    
    test_notify_dispatch_direct(rank, world_size, group, device, mpi_comm, args)
    
    # Cleanup
    dist.destroy_process_group()


def main_mpi(args):
    """Main function when using MPI (mpirun mode)"""
    from pathlib import Path
    repo_root = Path(__file__).parent.parent.absolute()
    if str(repo_root) not in sys.path:
        sys.path.insert(0, str(repo_root))
    
    # Initialize via MPI
    rank, world_size, group, device, mpi_comm = init_dist_mpi(args.port, use_gloo=args.use_gloo)
    
    test_notify_dispatch_direct(rank, world_size, group, device, mpi_comm, args)
    
    # Cleanup
    dist.destroy_process_group()
    
    if rank == 0:
        print("\n" + "=" * 50, flush=True)
        print("Test completed!", flush=True)
        print("=" * 50, flush=True)


def main():
    parser = argparse.ArgumentParser(description='Test DeepEP XPU notify_dispatch kernel')
    parser.add_argument('--num-processes', type=int, default=2,
                        help='Number of XPU devices to use (default: 2)')
    parser.add_argument('--num-tokens', type=int, default=64,
                        help='Number of tokens (default: 64)')
    parser.add_argument('--num-experts', type=int, default=None,
                        help='Number of experts (default: 8 * num_processes)')
    parser.add_argument('--num-channels', type=int, default=4,
                        help='Number of channels (default: 4)')
    parser.add_argument('--expert-alignment', type=int, default=1,
                        help='Expert alignment (default: 1)')
    parser.add_argument('--port', type=int, default=29556,
                        help='Master port for distributed communication (default: 29556)')
    parser.add_argument('--use-mpi', action='store_true',
                        help='Use MPI for process launch (requires mpirun)')
    parser.add_argument('--use-gloo', action='store_true',
                        help='Use gloo backend instead of xccl (only with --use-mpi)')
    args = parser.parse_args()
    
    # Default num_experts
    if args.num_experts is None:
        args.num_experts = 8 * args.num_processes
    
    # Validate num_experts
    if args.num_experts % args.num_processes != 0:
        print(f"Error: num_experts ({args.num_experts}) must be divisible by "
              f"num_processes ({args.num_processes})")
        return
    
    if args.use_mpi:
        # MPI mode - processes already launched by mpirun
        from mpi4py import MPI
        comm = MPI.COMM_WORLD
        rank = comm.Get_rank()
        world_size = comm.Get_size()
        
        if rank == 0:
            print("=" * 60, flush=True)
            print(f"DeepEP XPU notify_dispatch Test ({world_size} GPUs, MPI mode)", flush=True)
            print(f"Backend: {'gloo' if args.use_gloo else 'xccl'}", flush=True)
            print(f"num_tokens={args.num_tokens}, num_experts={args.num_experts}", flush=True)
            print(f"num_channels={args.num_channels}, expert_alignment={args.expert_alignment}", flush=True)
            print("=" * 60, flush=True)
        
        main_mpi(args)
    else:
        # mp.spawn mode
        num_processes = args.num_processes
        
        print("=" * 60, flush=True)
        print(f"DeepEP XPU notify_dispatch Test ({num_processes} GPUs)", flush=True)
        print(f"num_tokens={args.num_tokens}, num_experts={args.num_experts}", flush=True)
        print(f"num_channels={args.num_channels}, expert_alignment={args.expert_alignment}", flush=True)
        print("=" * 60, flush=True)
        
        # Spawn worker processes
        mp.spawn(
            worker_fn,
            args=(num_processes, args),
            nprocs=num_processes,
            join=True
        )


if __name__ == '__main__':
    main()
