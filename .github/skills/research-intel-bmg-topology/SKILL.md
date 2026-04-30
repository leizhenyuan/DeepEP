---
name: research-intel-bmg-topology
description: "Research Intel B60/B70 Battlemage (BMG) GPU hardware topology, ishmem API documentation, and Level Zero IPC capabilities. Use when gathering Intel GPU hardware specs, finding ishmem equivalents for NVSHMEM operations, understanding Level Zero IPC handle lifecycle, or verifying Intel GPU sub-group size and SLM capacity for DeepEP porting."
---

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
