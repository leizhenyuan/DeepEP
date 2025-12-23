"""
Test basic distributed setup and all-reduce on 4 XPU cards.

Usage:
    mpirun -n 4 python tests/test_dist.py
    # or
    torchrun --nproc_per_node=4 --master_port=29501 tests/test_dist.py
    # or with custom port
    MASTER_PORT=29501 mpirun -n 4 python tests/test_dist.py
"""

import os
import torch
import torch.distributed as dist


def main():
    # Get rank from environment
    local_rank = int(os.environ.get('LOCAL_RANK', os.environ.get('PALS_LOCAL_RANKID', os.environ.get('MPI_LOCALRANKID', 0))))
    world_size = int(os.environ.get('WORLD_SIZE', os.environ.get('PALS_LOCAL_SIZE', os.environ.get('MPI_LOCALNRANKS', 4))))
    rank = int(os.environ.get('RANK', os.environ.get('PALS_RANKID', os.environ.get('MPI_RANKID', local_rank))))
    
    # Set master address and port (use non-default port to avoid conflicts)
    master_addr = os.environ.get('MASTER_ADDR', 'localhost')
    master_port = os.environ.get('MASTER_PORT', '29501')  # Changed default to 29501
    os.environ['MASTER_ADDR'] = master_addr
    os.environ['MASTER_PORT'] = master_port
    
    print(f"[Rank {rank}] Initializing: local_rank={local_rank}, world_size={world_size}, port={master_port}", flush=True)
    
    # Set XPU device
    torch.xpu.set_device(local_rank)
    device = f'xpu:{local_rank}'
    
    # Initialize process group
    dist.init_process_group(
        backend='xccl',
        init_method='env://',
        world_size=world_size,
        rank=rank
    )
    
    print(f"[Rank {rank}] Process group initialized successfully", flush=True)
    
    # Test 1: Simple tensor creation
    print(f"[Rank {rank}] Test 1: Creating tensor on {device}...", flush=True)
    x = torch.ones(4, dtype=torch.float32, device=device) * rank
    print(f"[Rank {rank}] Created tensor: {x.tolist()}", flush=True)
    
    # Test 2: All-reduce sum
    print(f"[Rank {rank}] Test 2: All-reduce sum...", flush=True)
    y = torch.ones(4, dtype=torch.float32, device=device) * rank
    dist.all_reduce(y, op=dist.ReduceOp.SUM)
    expected_sum = sum(range(world_size))  # 0 + 1 + 2 + 3 = 6 for 4 ranks
    print(f"[Rank {rank}] All-reduce result: {y.tolist()}, expected: {expected_sum}", flush=True)
    assert y[0].item() == expected_sum, f"All-reduce failed: got {y[0].item()}, expected {expected_sum}"
    
    # Test 3: All-reduce with larger tensor
    print(f"[Rank {rank}] Test 3: All-reduce with larger tensor...", flush=True)
    z = torch.full((1024, 128), float(rank), dtype=torch.float32, device=device)
    dist.all_reduce(z, op=dist.ReduceOp.SUM)
    assert z[0, 0].item() == expected_sum, f"Large tensor all-reduce failed"
    print(f"[Rank {rank}] Large tensor all-reduce passed", flush=True)
    
    # Test 4: Barrier
    print(f"[Rank {rank}] Test 4: Barrier...", flush=True)
    dist.barrier()
    print(f"[Rank {rank}] Barrier passed", flush=True)
    
    # Cleanup
    dist.destroy_process_group()
    
    if rank == 0:
        print("\n" + "=" * 50, flush=True)
        print("All tests passed!", flush=True)
        print("=" * 50, flush=True)


if __name__ == '__main__':
    main()
