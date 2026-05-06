---
name: intel-topology-background
description: "Intel B60/B70 (Xe2/BMG) hardware specification and intranode/internode topology background for DeepEP porting. Contains BMG GPU specs, known PCIe switch deployment topology, Level Zero IPC intranode path, ishmem + CX6 internode path, and key differences from NVIDIA H100. Load as static prior knowledge; unresolved VERIFY items require web research or hardware team."
---

# Intel B60/B70 (Xe2/BMG) — Hardware Topology Background

This skill is **static prior knowledge** combined with **known deployment topology**.
Facts marked ✅ are established. Items marked ⚠️ VERIFY require web research or hardware team.

---

## Intel B60/B70 Hardware Specifications

| Parameter | Value | Status |
|-----------|-------|--------|
| GPU architecture | Xe2 (Battlemage / BMG) | ✅ |
| GPU product name | Intel Arc B580 (B60) / B770 (B70) | ✅ |
| Xe2-core count | 20 (B580) | ✅ |
| Vector engine width | 512-bit per Xe2-core | ✅ |
| GDDR6 memory | 12 GB (B580) | ✅ |
| Memory bandwidth | ~456 GB/s (B580) | ✅ |
| PCIe interface | PCIe Gen5 x8 (B580) | ⚠️ VERIFY x8 vs x16 |
| Sub-group (SIMD) width | SIMD32 available | ⚠️ VERIFY for specific kernel types |
| SLM per Xe2-core | 64 KB | ⚠️ VERIFY |
| L2 cache | ~4 MB | ⚠️ VERIFY |
| Cache line size | 64 bytes | ⚠️ VERIFY |
| Max work-group size | 1024 | ⚠️ VERIFY |

---

## Known Deployment Topology (Ground Truth)

The actual deployment hardware for this porting project:

```
Single Node:
  CPU (Intel)
   │
  PCIe switch
   ├── GPU0 (Intel B60/B70, Battlemage)
   ├── GPU1 (Intel B60/B70, Battlemage)
   └── CX6 NIC (Mellanox ConnectX-6, InfiniBand HDR 200 Gb/s)

Multi-Node:
  [CPU ─ PCIe sw ─ GPU0, GPU1, CX6] ── InfiniBand ── [CPU ─ PCIe sw ─ GPU0, GPU1, CX6]
```

### Critical Implications of This Topology

| Implication | Detail |
|-------------|--------|
| No NVLink | GPU↔GPU intranode is PCIe P2P only — NOT cache-coherent |
| PCIe P2P coherence gap | After GPU0 writes to GPU1 IPC memory, GPU1 may need explicit cache invalidation |
| CX6 on same PCIe switch | GPUDirect RDMA is physically possible (NIC shares PCIe switch with GPUs) |
| PCIe relaxed ordering | Assume RO=1 — posted writes may arrive out of order across PCIe |
| No NVSwitch | No full-mesh GPU fabric; GPU↔GPU bandwidth limited by PCIe switch throughput |

---

## Intranode Path: Level Zero IPC + PCIe P2P

### Mechanism

```
GPU0 process:
  ze_mem_handle = zeMemGetIpcHandle(ptr)  ← get exportable handle
  send handle to GPU1 process (via socket or MPI)

GPU1 process:
  peer_ptr = zeMemOpenIpcHandle(handle)   ← map GPU0 memory into GPU1 virtual space
  // Now GPU1 kernel can read/write peer_ptr — goes over PCIe P2P
```

### Key Differences from NVIDIA CUDA IPC + NVLink

| Aspect | NVIDIA (CUDA IPC + NVLink) | Intel (Level Zero IPC + PCIe) |
|--------|---------------------------|-------------------------------|
| Coherence | Cache-coherent (NVLink) | NOT coherent (PCIe P2P) ⚠️ |
| After write visibility | Immediate (NVLink L2 coherent) | Requires fence or flush ⚠️ VERIFY |
| Bandwidth | ~900 GB/s (NVLink 4.0) | ~60-80 GB/s (PCIe Gen5 x8/x16) |
| Latency | Low (NVSwitch fabric) | Higher (PCIe switch round-trip) |
| Handle lifetime | Per-process | ⚠️ VERIFY Level Zero handle lifecycle |

### Memory Ordering for Intranode (PCIe, non-coherent)

Assuming PCIe relaxed ordering (RO=1), the producer-consumer pattern requires:
```cpp
// Producer (GPU0):
data_buf[idx] = value;
sycl::atomic_fence(sycl::memory_order::seq_cst,
                   sycl::memory_scope::system);   // ← system-scope fence (PCIe ordering)
*(volatile uint32_t*)&flag = 1;                   // write flag

// Consumer (GPU1):
uint32_t f;
do {
    sycl::atomic_fence(sycl::memory_order::seq_cst,
                       sycl::memory_scope::system); // ← fence before each poll
    f = *(volatile uint32_t*)&flag;
} while (f == 0);
sycl::atomic_fence(sycl::memory_order::seq_cst,
                   sycl::memory_scope::system);     // ← acquire after flag seen
// safe to read data_buf[idx]
```

> ⚠️ `sycl::atomic_ref<system>` acquire/release alone is **NOT reliable** on B60 for
> cross-PCIe producer-consumer patterns. Use explicit `atomic_fence(seq_cst, system)`.

---

## Internode Path: ishmem + CX6 GPUDirect RDMA

### Physical Path

```
GPU HBM ──PCIe── CX6 NIC ──InfiniBand HDR── CX6 NIC ──PCIe── Remote GPU HBM
         ↑                                            ↑
    GPUDirect RDMA                               GPUDirect RDMA
    (NIC DMA’s                                   (NIC DMA’s
     directly from                                directly to
     GPU HBM)                                     GPU HBM)
```

### ishmem

ishmem (Intel OpenSHMEM) provides a symmetric heap abstraction over GPU RDMA, analogous to NVSHMEM:

| NVSHMEM | ishmem | Notes |
|---------|--------|-------|
| `nvshmem_malloc` | `ishmem_malloc` | symmetric heap allocation |
| `nvshmem_putmem_nbi` | `ishmem_putmem_nbi` | non-blocking PUT |
| `nvshmem_getmem_nbi` | `ishmem_getmem_nbi` | non-blocking GET |
| `nvshmem_quiet()` | `ishmem_quiet()` | wait for NIC DMA completion ⚠️ VERIFY semantics |
| `nvshmem_fence()` | `ishmem_fence()` | order operations ⚠️ VERIFY |
| `nvshmem_barrier_all()` | `ishmem_barrier_all()` | collective barrier |
| `nvshmem_ptr(ptr, pe)` | `ishmem_ptr(ptr, pe)` | local pointer to remote sym. heap |

> All ishmem API mappings marked ⚠️ VERIFY until confirmed against ishmem docs:
> https://github.com/oneapi-src/ishmem

### IBGDA Equivalent on Intel+CX6

| Question | Status |
|----------|--------|
| Does ishmem support GPU-kernel-initiated NIC operations (no CPU round-trip)? | ⚠️ VERIFY |
| Does CX6 + Intel GPU support GPUDirect RDMA (intel-peermem module)? | ⚠️ VERIFY |
| Is there a doorbell-ring equivalent in ishmem for Intel GPU? | ⚠️ VERIFY via tvisa / ishmem source |

### Memory Ordering for Internode (GPU → NIC → Remote GPU)

```
[1] GPU writes data to ishmem symmetric heap
[2] atomic_fence(seq_cst, system)   ← flush GPU L2 so NIC DMA sees the data ⚠️ VERIFY
[3] ishmem_put_nbi(data, ...)        ← NIC DMA issues RDMA write
[4] ishmem_quiet()                  ← wait for NIC DMA completion
[5] ishmem_put(flag, 1, remote_pe)  ← send notification (AFTER quiet)
[6] Remote GPU polls flag with system-scope fence
[7] Remote GPU reads data
```

---

## Summary: NVIDIA H100 vs Intel B60/B70

| Capability | NVIDIA H100 SXM | Intel B60/B70 |
|------------|----------------|---------------|
| Intranode bandwidth | 900 GB/s (NVLink 4.0) | ~60-80 GB/s (PCIe) |
| Intranode coherence | ✅ cache-coherent (NVLink) | ❌ NOT coherent (PCIe) |
| Intranode mechanism | CUDA IPC + NVLink P2P | Level Zero IPC + PCIe P2P |
| Internode RDMA | GPUDirect RDMA + IBGDA | GPUDirect RDMA + ishmem ⚠️ |
| GPU-direct NIC posting | ✅ IBGDA (GPU writes WQE) | ⚠️ VERIFY with ishmem/CX6 |
| Memory fence for NIC | `__threadfence_system()` + PTX st.volatile | `atomic_fence(seq_cst, system)` + volatile |
| Sub-group width | 32 (warp) | 16 or 32 (SIMD16/32) ⚠️ VERIFY |
| SLM per SM/Xe-core | 228 KB | 64 KB ⚠️ VERIFY |


# Research Intel BMG Topology

## When to Use

- Understanding the Intel B60/B70 physical intranode/internode topology (PCIe + CX6)
- Identifying what GPUDirect RDMA capabilities exist for Intel GPU + MLX CX6
- Verifying whether ishmem provides GPU-direct NIC posting (IBGDA equivalent)
- Finding ishmem API equivalents for NVSHMEM calls
- Checking PCIe coherence requirements for Level Zero IPC intranode writes
- Verifying BMG sub-group size and memory model fences

---

## Known Deployment Topology (Ground Truth)

```
Single Node:
  CPU ──PCIe switch──┬── GPU0 (Intel B60/B70, Battlemage)
                     ├── GPU1 (Intel B60/B70, Battlemage)
                     └── CX6 NIC (Mellanox ConnectX-6, InfiniBand HDR)

Multi-Node:
  [CPU──PCIe sw──GPU0,GPU1,CX6] ──InfiniBand── [CPU──PCIe sw──GPU0,GPU1,CX6]
```

**Established facts from this topology:**
- GPU↔GPU intranode: PCIe peer-to-peer only (no NVLink, no NVSwitch)
- GPU↔NIC: same PCIe switch → GPUDirect RDMA is physically possible
- Internode RDMA: CX6 DMA's from/to GPU HBM via PCIe BAR mapping

---

## Key Topology Questions to Research

### Intranode (PCIe P2P via Level Zero IPC)

| Question | Why It Matters |
|---|---|
| Does Level Zero IPC enable GPU0→GPU1 direct BAR access? | Intranode data transfer mechanism |
| Is PCIe P2P coherent on Intel platforms? | Whether explicit flush is needed after IPC write |
| What fence/barrier is needed after Level Zero IPC write? | Correctness of intranode synchronization |
| What is practical GPU↔GPU PCIe P2P bandwidth on B60/B70? | Performance ceiling for intranode |

**Key difference from NVIDIA**: NVLink is cache-coherent — `__threadfence_system()` is sufficient.
PCIe P2P is NOT cache-coherent. On Intel, the receiver GPU may not see the write without
an explicit invalidate. **This must be verified.**

### Internode (ishmem + CX6 GPUDirect RDMA)

| Question | Why It Matters |
|---|---|
| Does CX6 support GPUDirect RDMA with Intel GPU (B60/B70)? | Core enablement question |
| What kernel module enables Intel GPU + CX6 P2P? (`intel-peermem`?) | Deployment requirement |
| Does ishmem use GPU-direct RDMA, or CPU-proxy RDMA? | Latency difference: ~1-2 µs vs ~5-10 µs |
| Is there an IBGDA equivalent? (GPU posts WQE to CX6 directly?) | Low-latency path feasibility |
| What fence is needed before CX6 can DMA from GPU HBM? | Memory ordering correctness |
| After CX6 writes to remote GPU HBM, is GPU cache invalidated? | Remote read correctness |

---

## Critical Parameters to Verify

| Parameter | Why Critical | Must Answer Before |
|---|---|---|
| Sub-group size (16 or 32?) | All warp-equivalent operations | Code generation |
| SLM size per Xe-core | Shared memory buffer sizing | Code generation |
| Cache line size | Memory coalescing patterns | Performance tuning |
| PCIe generation + lanes (GPU slot) | Intranode bandwidth ceiling | Performance targets |
| PCIe generation + lanes (NIC slot) | Internode bandwidth ceiling | Performance targets |
| `ishmem_quiet()` ordering scope | Safety of non-blocking puts | Memory verification |
| Level Zero IPC PCIe coherence | Whether explicit flush needed | Memory verification |
| CX6 + Intel GPU GPUDirect RDMA | Internode path enablement | Deployment |

---

## Resource URLs

### Intel B60/B70 Hardware Specs
- ARK: https://ark.intel.com (search "Intel Arc B580" / "B770")
- Intel Arc Architecture: https://www.intel.com/content/www/us/en/developer/articles/technical/intel-arc-gpu-architecture.html

### ishmem Documentation
- GitHub: https://github.com/oneapi-src/ishmem

### Level Zero IPC API
- Spec: https://spec.oneapi.io/level-zero/latest/ (search "IPC")

### ConnectX-6 + Intel GPU GPUDirect RDMA
- Mellanox/NVIDIA docs: search "ConnectX-6 GPUDirect RDMA Intel"
- Intel docs: search "Level Zero peer memory" or "intel-peermem"
