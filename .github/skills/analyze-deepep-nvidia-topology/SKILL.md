---
name: analyze-deepep-nvidia-topology
description: "Analyze NVIDIA GPU topology usage patterns in DeepEP source code. Use when identifying how DeepEP uses NVLink, NVSHMEM, CUDA IPC handles, IBGDA NIC operations, warp synchronization, and memory ordering primitives. Covers both physical hardware topology analysis (why NVLink/RDMA) and code-level pattern extraction from csrc/."
---

# Analyze DeepEP NVIDIA Topology

## When to Use

- Understanding the H100 SXM physical hardware topology that DeepEP was designed for
- Explaining *why* NVLink is used for intranode (not PCIe) and *why* RDMA/IBGDA for internode
- Identifying all hardware assumptions baked into DeepEP code
- Cataloging NVSHMEM/IBGDA API calls and their hardware dependencies
- Building the hardware gap analysis between NVIDIA and Intel B60/B70

---

## Part 1 — Hardware Topology Background

Before reading any code, establish the hardware context. DeepEP is designed for
**H100 SXM (or A100 SXM) in a multi-node InfiniBand cluster**.

### Why Intranode Uses NVLink (Not PCIe)

In an 8-GPU H100 SXM node:

```
┌─────────────────────────────────────────────────────────┐
│                    Host (CPU + DRAM)                     │
│          PCIe Gen5 x16                PCIe Gen5 x16      │
│               │                            │             │
│          NVSwitch 0                   NVSwitch 1         │
│        /   |   |   \                /   |   |   \        │
│     GPU0 GPU1 GPU2 GPU3          GPU4 GPU5 GPU6 GPU7     │
│      └─────────── NVLink 4.0 fabric ─────────────┘      │
└─────────────────────────────────────────────────────────┘
```

**NVLink 4.0 bandwidth**: 900 GB/s total bidirectional per GPU
**PCIe Gen5 x16 bandwidth**: ~128 GB/s
**Ratio**: NVLink is ~7x faster than PCIe for GPU-to-GPU transfers

Additionally: **NVLink is cache-coherent** (GPU P2P writes are visible to the remote GPU's
L2 cache without explicit flush). PCIe P2P is NOT cache-coherent — writes bypass the
remote GPU's cache hierarchy entirely.

**This is why `intranode.cu` can use `__threadfence_system()` + flag write as the only
synchronization**: NVLink coherence guarantees the data is visible before the flag.

### Why Internode Uses RDMA + IBGDA (Not NVLink, Not MPI)

NVLink is a **physical fabric** — it only connects GPUs within the same chassis/node.
For internode communication, the path is:

```
GPU HBM ──PCIe── MLX ConnectX HCA ──InfiniBand── MLX ConnectX HCA ──PCIe── Remote GPU HBM
         ↑                                                                   ↑
    GPUDirect RDMA:                                                   GPUDirect RDMA:
    NIC DMAs directly                                                 NIC DMAs directly
    from/to GPU HBM                                                   to/from GPU HBM
    (no CPU copy)                                                     (no CPU copy)
```

**GPUDirect RDMA**: The MLX HCA can access GPU HBM directly over PCIe using BAR mapping,
without any CPU memory copies. This is a physical PCIe peer-to-peer capability.

**Why not MPI?**: MPI is CPU-driven. For every message: GPU→CPU copy → CPU posts to NIC →
NIC sends → CPU on remote side polls → CPU→GPU copy. This adds ~5-10 µs CPU overhead per message.

**Why NVSHMEM over raw RDMA?**: GPU kernels cannot call into the CPU-side MPI/libibverbs stack.
NVSHMEM provides a GPU-callable API backed by RDMA.

**Why IBGDA specifically?**: Standard NVSHMEM PUT uses a CPU-proxy model:
GPU signals a CPU thread → CPU calls libibverbs to post WQE → NIC transfers data.
IBGDA eliminates the CPU proxy: the **GPU kernel writes directly to the NIC's Work Queue
Element (WQE) ring buffer** via MMIO mapping, then rings the NIC doorbell register.
This reduces per-message latency from ~5-10 µs to ~1-2 µs.

### Bandwidth Reference Table

| Path | Bandwidth | Latency | Coherence |
|------|-----------|---------|-----------|
| H100 HBM3 local | 3.35 TB/s | ~100 ns | coherent |
| NVLink 4.0 (per GPU, total) | 900 GB/s | <1 µs | coherent (GPA) |
| PCIe Gen5 x16 | 128 GB/s | 1-2 µs | NOT GPU-cache-coherent |
| IB HDR (per port) | ~25 GB/s | 1-2 µs | DMA (not cache-coherent) |
| CPU-proxy RDMA | ~25 GB/s | 5-10 µs | adds CPU round-trip |
| IBGDA (GPU-direct NIC) | ~25 GB/s | 1-2 µs | eliminates CPU round-trip |

---

## Part 2 — Code-Level Analysis

### Scan CUDA IPC (Intranode) Patterns

```bash
grep -rn "cudaIpcGetMemHandle\|cudaIpcOpenMemHandle\|cudaIpcCloseMemHandle" csrc/
grep -rn "EnablePeerAccess\|cudaDeviceCanAccessPeer" csrc/
```

**For each result, ask**: Does this code assume NVLink coherence, or does it add explicit
flush/invalidate? If it assumes coherence — that assumption breaks on PCIe.

### Scan NVSHMEM API Calls (Internode)

```bash
grep -rn "nvshmem_\|nvshmemx_" csrc/ | grep -v "^Binary"
```

Group by type: allocation, blocking PUT/GET, non-blocking PUT/GET (`_nbi`), ordering (`quiet`/`fence`), collectives.

### Scan IBGDA Patterns (Hardware-Level NIC Access)

```bash
cat csrc/kernels/ibgda_device.cuh
grep -n "doorbell\|wqe\|qp_\|sq_\|cq_\|lkey\|rkey\|mmio" csrc/kernels/ibgda_device.cuh
```

For IBGDA, answer:
- How does the GPU find the NIC's WQE ring buffer? (mapped via CUDA memory?)
- How does the GPU ring the NIC doorbell? (write to MMIO address)
- What memory fence is needed before the doorbell write?
  → `__threadfence_system()` ensures all WQE data writes are visible to NIC (PCIe coherence)
- How does the GPU poll for completion? (CQ ring buffer polling vs interrupt)

### Scan Memory Ordering Primitives

```bash
grep -rn "__threadfence_system\|__threadfence\b\|__threadfence_block" csrc/kernels/
grep -rn "__syncthreads\|__syncwarp" csrc/kernels/
grep -rn "atomicCAS\|atomicAdd\|atomicExch\|atomicOr" csrc/kernels/
```

**For each `__threadfence_system()`**: what is it ordering before what?
- Before NIC doorbell write → ensures WQE data visible to NIC (IBGDA pattern)
- Before flag write → ensures data visible to CPU/remote GPU (NVLink coherence assumed)

### Scan Thread Hierarchy Assumptions

```bash
grep -rn "warpSize\|== 32\|/ 32\|% 32\|WARP_SIZE\|__shfl_sync\|__ballot_sync" csrc/kernels/
```

### Extract Hardware-Encoded Constants

Read `csrc/kernels/configs.cuh` completely. For each constant, ask:
- Does this encode an InfiniBand MTU? (typical: 4 KB MTU)
- Does this encode NVLink transfer granularity?
- Does this encode H100 SM count or warp size?
- Does this encode HBM page size or cache line size?

---

## Analysis Goal

The output of this skill must answer the central question for Intel porting:

> **"DeepEP relies on NVLink cache coherence for intranode and GPU-direct NIC access (IBGDA)
> for internode. Intel B60/B70 has neither NVLink nor native IBGDA. What does each piece of
> DeepEP code assume about these properties, and what must change?"**

