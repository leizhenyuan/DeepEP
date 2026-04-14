#!/usr/bin/env python
"""
XPU GPU-to-GPU P2P Bandwidth Benchmark

测量同一 CPU socket 内 GPU 之间以及跨 QPI（跨 socket）GPU 之间的带宽。

拓扑假设:
  - GPU 0-3 连接 CPU0 (socket 0)
  - GPU 4-7 连接 CPU1 (socket 1)
  - 同 socket 内 GPU 通过 PCIe 连接（理论 64 GB/s）
  - 跨 socket GPU 通过 QPI 连接

用法:
    python tests/test_xpu_p2p_bandwidth.py
    python tests/test_xpu_p2p_bandwidth.py --size 256  # 256 MB
    python tests/test_xpu_p2p_bandwidth.py --iters 50
    python tests/test_xpu_p2p_bandwidth.py --gpus 0,1,2,3,4,5,6,7
"""

import argparse
import time
import torch


def get_socket(gpu_id):
    """GPU 0-3 -> socket 0, GPU 4-7 -> socket 1"""
    return 0 if gpu_id < 4 else 1


def measure_bandwidth(src_dev, dst_dev, size_mb, warmup, iters):
    """测量从 src_dev 到 dst_dev 的单向拷贝带宽 (GB/s)"""
    size_bytes = size_mb * 1024 * 1024
    num_elements = size_bytes // 2  # bfloat16 = 2 bytes

    # 在源设备上分配并填充数据
    src_tensor = torch.ones(num_elements, dtype=torch.bfloat16, device=src_dev)
    # 在目标设备上分配接收缓冲区
    dst_tensor = torch.empty(num_elements, dtype=torch.bfloat16, device=dst_dev)

    # Warmup
    for _ in range(warmup):
        dst_tensor.copy_(src_tensor)
    torch.xpu.synchronize()

    # Timed iterations
    torch.xpu.synchronize()
    t0 = time.perf_counter()
    for _ in range(iters):
        dst_tensor.copy_(src_tensor)
    torch.xpu.synchronize()
    t1 = time.perf_counter()

    elapsed_s = t1 - t0
    total_bytes = size_bytes * iters
    bw_gbs = total_bytes / elapsed_s / 1e9

    del src_tensor, dst_tensor
    return bw_gbs, elapsed_s / iters * 1e6  # bandwidth (GB/s), latency per iter (us)


def main():
    parser = argparse.ArgumentParser(description='XPU P2P Bandwidth Benchmark')
    parser.add_argument('--size', type=int, default=128,
                        help='Transfer size in MB (default: 128)')
    parser.add_argument('--iters', type=int, default=20,
                        help='Number of timed iterations (default: 20)')
    parser.add_argument('--warmup', type=int, default=5,
                        help='Number of warmup iterations (default: 5)')
    parser.add_argument('--gpus', type=str, default=None,
                        help='Comma-separated GPU IDs (default: all available)')
    args = parser.parse_args()

    num_gpus = torch.xpu.device_count()
    if args.gpus:
        gpu_ids = [int(g) for g in args.gpus.split(',')]
    else:
        gpu_ids = list(range(num_gpus))

    print(f'Detected {num_gpus} XPU devices, testing: {gpu_ids}')
    print(f'Transfer size: {args.size} MB, iters: {args.iters}, warmup: {args.warmup}')
    print()

    # ====== 拓扑信息 ======
    print('=== Topology ===')
    for g in gpu_ids:
        print(f'  GPU {g} -> socket {get_socket(g)}')
    print()

    # ====== 测量所有 GPU 对 ======
    results = []
    for src in gpu_ids:
        for dst in gpu_ids:
            if src == dst:
                continue
            src_dev = f'xpu:{src}'
            dst_dev = f'xpu:{dst}'
            src_sock = get_socket(src)
            dst_sock = get_socket(dst)
            link = 'intra-socket (PCIe)' if src_sock == dst_sock else 'cross-QPI'

            bw, lat_us = measure_bandwidth(src_dev, dst_dev, args.size, args.warmup, args.iters)
            results.append((src, dst, src_sock, dst_sock, link, bw, lat_us))
            print(f'  GPU {src} -> GPU {dst}  [{link}]  {bw:.2f} GB/s  ({lat_us:.0f} us/iter)')

    print()

    # ====== 汇总 ======
    intra = [r for r in results if r[4] == 'intra-socket (PCIe)']
    cross = [r for r in results if r[4] == 'cross-QPI']

    print('=' * 60)
    print('=== Summary ===')
    print('=' * 60)

    if intra:
        bws = [r[5] for r in intra]
        print(f'Intra-socket (PCIe) pairs: {len(intra)}')
        print(f'  Avg: {sum(bws)/len(bws):.2f} GB/s')
        print(f'  Min: {min(bws):.2f} GB/s  (GPU {min(intra, key=lambda r: r[5])[0]} -> GPU {min(intra, key=lambda r: r[5])[1]})')
        print(f'  Max: {max(bws):.2f} GB/s  (GPU {max(intra, key=lambda r: r[5])[0]} -> GPU {max(intra, key=lambda r: r[5])[1]})')

    if cross:
        bws = [r[5] for r in cross]
        print(f'Cross-QPI pairs: {len(cross)}')
        print(f'  Avg: {sum(bws)/len(bws):.2f} GB/s')
        print(f'  Min: {min(bws):.2f} GB/s  (GPU {min(cross, key=lambda r: r[5])[0]} -> GPU {min(cross, key=lambda r: r[5])[1]})')
        print(f'  Max: {max(bws):.2f} GB/s  (GPU {max(cross, key=lambda r: r[5])[0]} -> GPU {max(cross, key=lambda r: r[5])[1]})')

    print()

    # ====== 带宽矩阵 ======
    print('=== Bandwidth Matrix (GB/s) ===')
    header = '       ' + ''.join(f'  GPU {d:<3}' for d in gpu_ids)
    print(header)
    for src in gpu_ids:
        row = f'GPU {src}  '
        for dst in gpu_ids:
            if src == dst:
                row += '    -   '
            else:
                match = [r for r in results if r[0] == src and r[1] == dst]
                if match:
                    row += f' {match[0][5]:6.2f} '
                else:
                    row += '    ?   '
        print(row)
    print()


if __name__ == '__main__':
    main()
