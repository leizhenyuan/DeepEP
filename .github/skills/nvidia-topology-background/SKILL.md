---
name: nvidia-topology-background
description: "NVIDIA H100 SXM hardware specification and intranode/internode topology background for DeepEP porting. Contains H100 specs, NVLink/NVSwitch intranode topology, IBGDA/InfiniBand internode topology, and the hardware properties DeepEP relies on. Load as static prior knowledge — no runtime discovery needed."
---

# NVIDIA H100 SXM — Hardware Topology Background

This skill is **static prior knowledge**. All facts below are established hardware
specifications for the NVIDIA H100 SXM platform that DeepEP was originally designed for.

---

## H100 SXM Hardware Specifications

| Parameter | Value |
|-----------|-------|
| GPU architecture | Hopper (GH100) |
| HBM3 memory | 80 GB per GPU |
| HBM memory bandwidth | 3.35 TB/s per GPU |
| NVLink version | NVLink 4.0 |
| NVLink bandwidth per GPU | 900 GB/s total bidirectional |
| PCIe slot | PCIe Gen5 x16 (~128 GB/s) |
| L2 cache | 50 MB |
| SM count | 132 SMs |
| Warp size | 32 threads |
| Shared memory per SM | up to 228 KB |
| Cache line size | 128 bytes |

---

## Intranode Topology: NVSwitch + NVLink Fabric

### Physical Layout (8-GPU H100 SXM Node)

```
                    Host CPU + DRAM
                 PCIe Gen5 x16 │
          ┌───────────────────────────────────────────────┐
          │           NVSwitch fabric (4x NVSwitch chips)          │
          │   GPU0 ── GPU1 ── GPU2 ── GPU3 ── GPU4 ── GPU5 ── GPU6 ── GPU7  │
          │        all pairs connected via NVLink 4.0 (full mesh)  │
          └───────────────────────────────────────────────┘
```

### Key Properties

**1. NVLink bandwidth**: 900 GB/s bidirectional per GPU vs PCIe Gen5 x16 ~128 GB/s.
GPU-to-GPU transfers are ~7x faster than going through PCIe.

**2. NVLink is cache-coherent**: A GPU write to peer GPU memory via NVLink is immediately
visible to the remote GPU’s L2 cache — no explicit cache flush needed on the writer side,
no cache invalidation needed on the reader side.

**3. No CPU involvement**: All GPU-to-GPU traffic flows through the NVSwitch fabric without
touching CPU or PCIe. The CPU path is only used for host ↔ GPU transfers.

**4. CUDA IPC**: `cudaIpcGetMemHandle` / `cudaIpcOpenMemHandle` provide a handle mechanism
for one process to map another GPU’s allocation. After mapping, direct NVLink P2P reads/writes
are used transparently.

### What DeepEP Relies On (Intranode)

- `intranode.cu` uses `__threadfence_system()` + flag write as the **sole synchronization**
  between producer and consumer GPUs. This works **only because NVLink is cache-coherent** —
  the data written to peer memory is visible before the flag write is observed.
- Buffer pointers in `intranode.cu` are obtained via CUDA IPC handles. After opening,
  the pointer behaves like local device memory due to NVLink coherence.

---

## Internode Topology: InfiniBand + GPUDirect RDMA + IBGDA

### Physical Layout (Multi-Node)

```
 Node 0:                                    Node 1:
 CPU + DRAM                                 CPU + DRAM
    │ PCIe                                     │ PCIe
    ├─ GPU0 ┐                               ├─ GPU0 ┐
    ├─ GPU1 │──────────────────────────├─ GPU1 │
    └─ MLX HCA ┘ ─── InfiniBand HDR ─── └─ MLX HCA ┘
         ↑ PCIe                                    ↑ PCIe
    GPUDirect RDMA:                           GPUDirect RDMA:
    NIC DMA’s directly                        NIC DMA’s directly
    from GPU HBM                              to GPU HBM
```

### GPUDirect RDMA

The NIC (HCA) performs DMA directly to/from GPU HBM via PCIe BAR mapping —
the CPU is **not in the data path**. This requires:
- The GPU and HCA to be on the same PCIe root complex (or switch with P2P enabled)
- The `nvidia-peermem` kernel module loaded
- RDMA operations target GPU virtual addresses (registered with `ibv_reg_mr`)

### NVSHMEM

NVSHMEM provides a symmetric heap abstraction over GPU RDMA. Key operations:
- `nvshmem_put*`: GPU-issued PUT (writes to remote PE’s symmetric heap)
- `nvshmem_get*`: GPU-issued GET (reads from remote PE’s symmetric heap)
- `nvshmem_quiet()`: wait for all outstanding PUT/GET DMAs to complete
- `nvshmem_fence()`: order operations (but does not wait for completion)
- `nvshmem_barrier_all()`: collective barrier across all PEs

### IBGDA (InfiniBand GPU Direct Async)

IBGDA is an advanced mode where the **GPU kernel directly posts Work Queue Entries (WQEs)**
to the NIC’s QP (Queue Pair) — no CPU involvement per operation:

```
CPU path (traditional):   GPU → CPU (signal) → ibv_post_send() → NIC → RDMA
IBGDA path:               GPU → mmio write to NIC QP doorbell → NIC → RDMA
```

IBGDA eliminates the CPU round-trip per message, reducing latency from ~5-10 µs to ~1-2 µs.
DeepEP uses IBGDA (via NVSHMEM IBGDA backend) to achieve this low latency.

**Memory ordering chain for IBGDA**:
```
[1] GPU writes data to symmetric heap
[2] __threadfence_system()    ← ensures GPU L2 writeback visible to NIC DMA
[3] GPU writes WQE to NIC QP doorbell (MMIO write via PTX st.volatile.global.u64)
[4] NIC reads data from GPU HBM, sends RDMA write
[5] nvshmem_quiet()           ← wait for NIC DMA completion
[6] GPU writes notification flag to remote
[7] Remote GPU polls flag
```

### What DeepEP Relies On (Internode)

- `ibgda_device.cuh`: GPU kernel directly writes NIC QP doorbell via PTX MMIO
- `__threadfence_system()` before doorbell write: ensures data is flushed from GPU L2
  before the NIC DMA reads it
- `nvshmem_quiet()` before writing notification flag: ensures RDMA write completed
- `internode.cu` / `internode_ll.cu`: all use NVSHMEM PUT + IBGDA for low-latency path

---

## Hardware Properties DeepEP Assumes (Gap Analysis Input)

| Property | H100 SXM | Required for DeepEP? |
|----------|----------|---------------------|
| Cache-coherent P2P (intranode) | ✅ NVLink coherent | ✅ YES — no explicit flush between GPU writes |
| GPU-direct NIC DMA (internode) | ✅ GPUDirect RDMA | ✅ YES — no CPU in data path |
| GPU posts NIC doorbell directly | ✅ IBGDA | ✅ YES — eliminates CPU round-trip latency |
| Warp size = 32 | ✅ fixed | Encoded in kernel launch configs |
| `__threadfence_system()` orders NIC DMA | ✅ verified on Hopper | ⚠️ Needs verification on Intel |


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

