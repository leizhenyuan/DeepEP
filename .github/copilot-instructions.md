# DeepEP Intel GPU Porting — Project Instructions

## Project Context

This is the **DeepEP Intel GPU porting project**. DeepEP is a specialized MoE (Mixture of Experts)
all-to-all communication operator library originally written for NVIDIA GPUs using CUDA/NVSHMEM.
The goal is to **completely rewrite** it for Intel B60/B70 (Battlemage/BMG) GPUs using SYCL + Level Zero + ishmem.
No CUDA code is retained in the final implementation.

## Target Platform Summary

| Component | NVIDIA (Original) | Intel (Target) |
|-----------|------------------|----------------|
| GPU | H100/A100 | Intel B60/B70 (Arc Battlemage/BMG) |
| Intranode comm | NVLink / CUDA IPC | PCIe + Level Zero IPC handles |
| Internode comm | NVSHMEM + IBGDA | ishmem + MLX CX6 (GPU-initiated RDMA) |
| Network NIC | Mellanox ConnectX (MLX) InfiniBand | Mellanox ConnectX-6 (CX6) InfiniBand HDR |
| Programming model | CUDA | SYCL (high-level) + Level Zero (low-level) |
| Low-latency comm | NVSHMEM non-blocking + IBGDA | ishmem non-blocking + direct NIC ops |

## Known Physical Deployment Topology

```
Single Node:
  CPU ──PCIe switch──┬── GPU0 (Intel B60/B70)
                     ├── GPU1 (Intel B60/B70)
                     └── CX6 NIC (Mellanox ConnectX-6, IB HDR)

Multi-Node:
  [CPU──PCIe sw──GPU0,GPU1,CX6] ──InfiniBand── [CPU──PCIe sw──GPU0,GPU1,CX6]
```

**Critical topology differences from NVIDIA H100 SXM:**
- **No NVLink**: GPU↔GPU intranode is PCIe P2P only — NOT cache-coherent (NVLink is coherent)
- **PCIe coherence gap**: After GPU writes to IPC peer memory, remote GPU may need explicit cache
  invalidation before reading. On NVLink this is handled automatically.
- **CX6 shares PCIe switch with GPUs**: enables GPUDirect RDMA (NIC DMA directly from GPU HBM)
  — same principle as NVIDIA, but via PCIe switch instead of NVSwitch

## Key Terminology Mapping (Quick Reference)

| CUDA/NVIDIA Concept | SYCL/Intel Equivalent | Notes |
|--------------------|----------------------|-------|
| Thread block | Work-group (`nd_item::get_group()`) | — |
| Warp (32 threads) | Sub-group (`sycl::sub_group`) | BMG: 16 or 32 threads — VERIFY |
| Shared memory | Local memory / SLM (`local_accessor`) | — |
| `__global__` kernel | SYCL kernel (`parallel_for`) | — |
| `threadIdx.x` | `item.get_local_id(0)` | — |
| `blockIdx.x` | `item.get_group(0)` | — |
| `__syncthreads()` | `sycl::group_barrier(g)` | — |
| `__syncwarp()` | `sg.barrier()` | No mask support in SYCL! |
| `__threadfence()` | `atomic_fence(seq_cst, device)` | VERIFY scope semantics |
| `__threadfence_system()` | `atomic_fence(seq_cst, system)` | VERIFY covers NIC memory |
| `cudaMalloc` | `sycl::malloc_device(queue)` | — |
| CUDA IPC handle | `ze_ipc_mem_handle_t` (Level Zero) | Different lifecycle model |
| NVSHMEM | ishmem | Intel's OpenSHMEM implementation |
| `nvshmem_quiet()` | `ishmem_quiet()` | VERIFY ordering guarantee |
| `nvshmem_fence()` | `ishmem_fence()` | VERIFY vs quiet semantics |
| `nvshmem_barrier_all()` | `ishmem_barrier_all()` | Full collective |
| IBGDA device-side NIC ops | ishmem NIC operations | ishmem abstracts NIC access |

## Output Directory Structure

```
docs/porting/            ← All analysis documents
csrc_sycl/               ← All generated SYCL source code
```

## Risk Escalation Policy

**HIGH RISK → STOP immediately and ask the human:**
- Memory ordering semantics uncertainty (fence/barrier behavioral differences)
- ishmem API behavior uncertainty (especially quiet/fence/non-blocking operations)
- BMG hardware characteristics uncertainty (sub-group size, SLM size, cache line size)
- Level Zero IPC handle lifecycle uncertainty
- NIC operation ordering uncertainty (GPU kernel directly operating NIC)

**LOW RISK → Document and continue:**
- API naming differences with clear equivalents
- Code structure changes not affecting semantics
- Performance tuning parameters (need hardware validation, not correctness)

## Code Annotation Conventions

All generated SYCL code must use these standard comment markers:
```cpp
// PORTED_FROM: csrc/kernels/<original_file>
// HIGH_RISK: <description> — NEEDS HUMAN VERIFICATION
// MEMORY_MODEL_FIX: <cuda_op> → <sycl_op> because <reason>
// MEMORY_MODEL_ISSUE: <description> — UNRESOLVED, SEE docs/porting/04_memory_verification.md
// TODO: <item requiring human attention>
```

## Inline Assembly (PTX) Policy

DeepEP CUDA kernels contain `asm volatile(...)` PTX blocks for:
- **System-scope fences** (`fence.sc.sys`) — ordering GPU writes before NIC DMA
- **MMIO writes** (`st.volatile.global.u64`) — NIC doorbell ring for IBGDA
- **Non-temporal stores/loads** (`st.cs`, `ld.cs`) — cache streaming hints

**Never silently drop or ignore inline assembly.** When porting:
1. Load the `asm-translation-guide` skill
2. Reference https://github.com/CaoZhongZ/tvisa for Intel GPU equivalents
3. Use ESIMD (`sycl/ext/intel/esimd.hpp`) for operations requiring explicit cache control
4. Mark any unresolved PTX as `// HIGH_RISK:` with the tvisa reference

## Source Structure Reference

```
csrc/                    ← Original CUDA source (read-only reference)
  deep_ep.cpp/.hpp       ← Top-level C++ API
  config.hpp             ← Global configuration
  kernels/
    configs.cuh          ← CUDA configuration constants
    api.cuh              ← Kernel API declarations
    buffer.cuh           ← Buffer management
    intranode.cu         ← NVLink/IPC intranode kernels
    internode.cu         ← NVSHMEM internode kernels
    internode_ll.cu      ← Low-latency internode variant
    ibgda_device.cuh     ← IBGDA NIC device-side operations
    runtime.cu           ← Runtime initialization
    layout.cu            ← Memory layout management
    launch.cuh           ← Kernel launch utilities
    utils.cuh            ← Utility functions
```
