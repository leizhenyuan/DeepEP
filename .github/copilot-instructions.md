# DeepEP Intel GPU Porting — Project Instructions

## Project Context

This is the **DeepEP Intel GPU porting project**. DeepEP is a specialized MoE (Mixture of Experts)
all-to-all communication operator library originally written for NVIDIA GPUs using CUDA/NVSHMEM.
The goal is to **port** it to Intel B60/B70 (Battlemage/BMG) GPUs using SYCL + Level Zero + ishmem.
The original CUDA source is **kept as a reference** for side-by-side comparison with the generated SYCL code.

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

## Output Directory Structure

```
docs/porting/            ← All analysis documents
csrc_sycl/               ← All generated SYCL source code
```

## Risk Escalation Policy

**HIGH RISK → STOP immediately and ask the human:**
- Memory ordering semantics uncertainty (fence/barrier behavioral differences)
- ishmem API behavior uncertainty (especially quiet/fence/non-blocking operations)
- Any CUDA→SYCL or NVSHMEM→ishmem equivalence that is not obviously correct
- BMG sub-group size uncertainty (affects warp-level patterns in kernels)
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
// MEMORY_MODEL_ISSUE: <description> — UNRESOLVED, requires human review
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
3. Mark any unresolved PTX as `// HIGH_RISK:` with the tvisa reference

## Source Structure Reference

```
csrc/                    ← Original CUDA source (kept for comparison with generated SYCL code)
  deep_ep.cpp/.hpp       ← Top-level C++ API
  config.hpp             ← Global configuration
  kernels/
    configs.cuh          ← CUDA configuration constants
    api.cuh              ← Kernel API declarations
    buffer.cuh           ← Buffer management
    internode.cu         ← NVSHMEM/IBGDA internode kernels (V1 target)
    internode_ll.cu      ← low-latency internode variant (V1 target)
    ibgda_device.cuh     ← NIC device-side operations (V1 target)
    intranode.cu         ← NVLink/IPC intranode kernels (out of scope for V1)
    ibgda_device.cuh     ← IBGDA NIC device-side operations
    runtime.cu           ← Runtime initialization
    layout.cu            ← Memory layout management
    launch.cuh           ← Kernel launch utilities
    utils.cuh            ← Utility functions
```
