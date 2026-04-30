---
name: analyze-cuda-kernels
description: "Systematically analyze DeepEP CUDA kernel implementations for Intel GPU porting. Use when deep-diving into specific kernel files (intranode.cu, internode.cu, internode_ll.cu, layout.cu, runtime.cu, ibgda_device.cuh), extracting all synchronization patterns and NVSHMEM operations, or preparing per-kernel porting analysis with complexity assessments."
---

# Analyze DeepEP CUDA Kernels

## When to Use

- Deep analysis of DeepEP kernel implementation logic
- Extracting all synchronization and memory ordering operations (exhaustive)
- Preparing data for SYCL translation
- Understanding NVSHMEM/IBGDA usage patterns per kernel
- Assessing porting complexity before code generation

## Kernel Analysis Order

Always process in dependency order:

1. `csrc/kernels/configs.cuh` — constants (read first, informs all others)
2. `csrc/kernels/utils.cuh` — utility functions
3. `csrc/kernels/buffer.cuh` — buffer types and management
4. `csrc/kernels/runtime.cu` — initialization and lifecycle
5. `csrc/kernels/layout.cu` — buffer allocation and memory layout
6. `csrc/kernels/intranode.cu` — IPC/PCIe intranode kernels
7. `csrc/kernels/internode.cu` — NVSHMEM internode kernels
8. `csrc/kernels/internode_ll.cu` — low-latency internode variant
9. `csrc/kernels/ibgda_device.cuh` — IBGDA NIC device-side operations
10. `csrc/kernels/api.cuh`, `csrc/kernels/launch.cuh` — API and launch utilities

## Per-File Analysis Template

For each file, fill in this template:

```markdown
## File: <filename>

### Purpose
[1-2 sentences describing what this file implements]

### Algorithm
[Description of the main algorithm or protocol]

### Thread Hierarchy
- Grid: [how grid dimensions are chosen]
- Block: [block size, fixed or dynamic]
- Warp operations: [list of __shfl*, __ballot*, __syncwarp* found]
- Hardcoded size assumptions: [any /32, *32, warpSize==32, etc.]

### Memory Layout
- Global: [buffer naming, access pattern, stride]
- Shared (__shared__): [size, layout, bank conflict risk]
- Registers: [notable register-heavy patterns]

### Synchronization Inventory
| Line | Primitive | Arguments | Scope | Purpose |
|------|-----------|-----------|-------|---------|
| N | __syncthreads() | — | block | Barrier after SLM write |
| N | __threadfence_system() | — | system | Ordering before NIC |

### NVSHMEM Operations
| Line | Function | Type | Direction | Size | Ordering | Notes |
|------|----------|------|-----------|------|----------|-------|
| N | nvshmem_float_put | float | PUT | N floats | blocking | |

### Porting Complexity
| Item | Complexity | SYCL/ishmem Approach |
|------|-----------|---------------------|
| Thread indexing | EASY | item.get_global_id() |
| __syncthreads | EASY | group_barrier(g) |
| __syncwarp(0xFFFF...) | MEDIUM | sg.barrier() |
| nvshmem_quiet | MEDIUM | ishmem_quiet() — verify scope |

### HIGH RISK Items
- [Item 1: line, description, question for human]
```

## Complexity Classification Guide

| Level | Meaning | Example |
|---|---|---|
| EASY | Direct SYCL equivalent, no semantic difference | `__syncthreads()` → `group_barrier(g)` |
| MEDIUM | Requires careful translation, verify semantics | `nvshmem_quiet()` → `ishmem_quiet()` |
| HARD | No direct equivalent, needs design decision | PTX inline assembly, partial warp sync |
| HIGH RISK | Behavior unclear, needs human input | `__threadfence_system()` + NIC doorbell ordering |

## Critical Patterns to Never Miss

### Must Document Precisely
- Every `__syncwarp(mask)` — record the exact mask and what threads it covers
- Every `__threadfence_system()` — what write is being ordered before what read?
- Every non-blocking NVSHMEM call — where is the corresponding `nvshmem_quiet()`?
- Every `atomicCAS` used as a spin-lock — what's the memory ordering assumption?

### Common Porting Traps in DeepEP Context
- NVSHMEM non-blocking puts followed by CPU-side quiet checks — ishmem equivalent?
- Warp-stride accesses assuming `warpSize == 32` — will break on SIMD16 sub-groups
- `__threadfence_system()` before writing to NIC-accessible memory — critical for IBGDA
- Shared memory bank conflicts designed for 32-thread warps — recalculate for 16-thread sub-groups
