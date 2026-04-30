#!/usr/bin/env python
"""
XPU Multicast Bandwidth 测试脚本

测试命令:
    mpirun -np 8 python tests/test_xpu_multicast_bw.py
"""

import argparse
import os
import sys
import time

os.environ['USE_XPU'] = '1'
os.environ['USE_CUDA'] = '0'

import torch
import torch.distributed as dist
from mpi4py import MPI


def main():
    parser = argparse.ArgumentParser(description='Test XPU multicast bandwidth')
    parser.add_argument('--num-tokens', type=int, default=4096 * 32)
    parser.add_argument('--hidden', type=int, default=7168)
    parser.add_argument('--port', type=int, default=29500)
    args = parser.parse_args()

    # MPI 初始化
    comm = MPI.COMM_WORLD
    rank = comm.Get_rank()
    world_size = comm.Get_size()
    
    torch.xpu.set_device(rank)
    device = f'xpu:{rank}'
    
    # PyTorch 分布式初始化
    os.environ['MASTER_ADDR'] = os.getenv('MASTER_ADDR', '127.0.0.1')
    os.environ['MASTER_PORT'] = str(args.port)
    os.environ['RANK'] = str(rank)
    os.environ['WORLD_SIZE'] = str(world_size)
    
    dist.init_process_group(
        backend='xccl',
        init_method=f'tcp://{os.environ["MASTER_ADDR"]}:{args.port}',
        world_size=world_size,
        rank=rank
    )
    
    if rank == 0:
        print(f'[config] num_tokens={args.num_tokens}, hidden={args.hidden}, world_size={world_size}', flush=True)
    
    # 创建测试数据: bf16, [num_tokens, hidden]
    num_tokens = args.num_tokens
    hidden = args.hidden
    x = torch.randn((num_tokens, hidden), dtype=torch.bfloat16, device=device)
    
    # 数据量计算
    bytes_per_element = 2  # bf16
    data_bytes = num_tokens * hidden * bytes_per_element
    
    if rank == 0:
        print(f'[data] Tensor shape: {x.shape}, Size: {data_bytes/1e6:.2f} MB', flush=True)
        print(f'{"="*60}', flush=True)
    
    # ========== Test 1: All-Gather ==========
    # 每个 rank 发送全部数据，收集到 world_size 倍大小
    x_full = x.clone()  # 每个 rank 发送完整的 [num_tokens, hidden]
    x_gathered = torch.zeros((num_tokens * world_size, hidden), dtype=torch.bfloat16, device=device)

    comm.Barrier()
    torch.xpu.synchronize()

    start_time = time.perf_counter()
    dist.all_gather_into_tensor(x_gathered, x_full)
    torch.xpu.synchronize()
    end_time = time.perf_counter()

    allgather_time = (end_time - start_time) * 1000  # ms
    # all_gather 总数据量 = 每个 rank 发送的完整数据 * world_size
    allgather_data = num_tokens * hidden * bytes_per_element * world_size
    allgather_bw = (allgather_data / 1e9) / (allgather_time / 1000)  # GB/s

    if rank == 0:
        print(f'[all_gather] Latency: {allgather_time:.3f}ms, BW: {allgather_bw:.2f} GB/s', flush=True)
    # ========== Test 2: All-Reduce ==========
    # 每个 rank 都有完整的 num_tokens，reduce 后每个 rank 都有完整结果
    x_reduce = x.clone()  # [num_tokens, hidden]
    
    comm.Barrier()
    torch.xpu.synchronize()
    
    start_time = time.perf_counter()
    dist.all_reduce(x_reduce)
    torch.xpu.synchronize()
    end_time = time.perf_counter()
    
    allreduce_time = (end_time - start_time) * 1000  # ms
    # all_reduce 总数据量 = 输入数据量 (每个 rank 贡献相同大小)
    allreduce_data = num_tokens * hidden * bytes_per_element
    allreduce_bw = (allreduce_data / 1e9) / (allreduce_time / 1000)  # GB/s
    
    if rank == 0:
        print(f'[all_reduce] Latency: {allreduce_time:.3f}ms, BW: {allreduce_bw:.2f} GB/s', flush=True)
    
    # ========== Test 3: Reduce-Scatter ==========
    # 每个 rank 输入 world_size * num_tokens，reduce-scatter 后每个 rank 得到 num_tokens
    x_input_rs = torch.randn((num_tokens * world_size, hidden), dtype=torch.bfloat16, device=device)
    x_output_rs = torch.zeros((num_tokens, hidden), dtype=torch.bfloat16, device=device)
    
    comm.Barrier()
    torch.xpu.synchronize()
    
    start_time = time.perf_counter()
    dist.reduce_scatter_tensor(x_output_rs, x_input_rs)
    torch.xpu.synchronize()
    end_time = time.perf_counter()
    
    reducescatter_time = (end_time - start_time) * 1000  # ms
    # reduce_scatter 总数据量 = 输入数据量
    reducescatter_data = num_tokens * world_size * hidden * bytes_per_element
    reducescatter_bw = (reducescatter_data / 1e9) / (reducescatter_time / 1000)  # GB/s
    
    if rank == 0:
        print(f'[reduce_scatter] Latency: {reducescatter_time:.3f}ms, BW: {reducescatter_bw:.2f} GB/s', flush=True)
    
    # ========== Test 4: All-to-All ==========
    # 每个 rank 发送 num_tokens 给每个其他 rank，总共发送/接收 num_tokens * world_size
    x_a2a_input = torch.randn((num_tokens * world_size, hidden), dtype=torch.bfloat16, device=device)
    x_a2a_output = torch.zeros_like(x_a2a_input)
    
    comm.Barrier()
    torch.xpu.synchronize()
    
    start_time = time.perf_counter()
    dist.all_to_all_single(x_a2a_output, x_a2a_input)
    torch.xpu.synchronize()
    end_time = time.perf_counter()
    
    alltoall_time = (end_time - start_time) * 1000  # ms
    # all_to_all 总数据量 = 输入数据量
    alltoall_data = num_tokens * world_size * hidden * bytes_per_element
    alltoall_bw = (alltoall_data / 1e9) / (alltoall_time / 1000)  # GB/s
    
    if rank == 0:
        print(f'[all_to_all] Latency: {alltoall_time:.3f}ms, BW: {alltoall_bw:.2f} GB/s', flush=True)
    
    # ========== Summary ==========
    if rank == 0:
        print(f'{"="*60}', flush=True)
        print(f'[summary] Data size: {data_bytes/1e6:.2f} MB, World size: {world_size}', flush=True)
        print(f'  All-Gather:     {allgather_time:.3f}ms  ({allgather_bw:.2f} GB/s)', flush=True)
        print(f'  All-Reduce:     {allreduce_time:.3f}ms  ({allreduce_bw:.2f} GB/s)', flush=True)
        print(f'  Reduce-Scatter: {reducescatter_time:.3f}ms  ({reducescatter_bw:.2f} GB/s)', flush=True)
        print(f'  All-to-All:     {alltoall_time:.3f}ms  ({alltoall_bw:.2f} GB/s)', flush=True)
    
    # 清理
    dist.destroy_process_group()
    
    if rank == 0:
        print(f'\n========== Test completed! ==========\n', flush=True)


if __name__ == '__main__':
    main()
