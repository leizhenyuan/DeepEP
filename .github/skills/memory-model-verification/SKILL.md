---
name: memory-model-verification
description: "Verify memory ordering and coherence correctness in SYCL/ishmem code ported from CUDA/NVSHMEM. Use when auditing generated SYCL code for memory model issues, checking fence and barrier semantics, verifying ishmem ordering operations, reviewing Level Zero IPC PCIe coherence, or building the memory verification report for DeepEP porting."
---

# Memory Model Verification

## When to Use

- Auditing generated SYCL/ishmem code for memory ordering correctness
- Verifying that SYCL fences cover the same scope as CUDA `__threadfence*`
- Checking that `ishmem_quiet()` placements are correct after non-blocking ops
- Reviewing Level Zero IPC memory access patterns for PCIe coherence
- Building `docs/porting/04_memory_verification.md`

## Verification Checklist

See [Memory Ordering Checklist](./references/memory-ordering-checklist.md) for detailed per-pattern checks.

## Critical Differences: CUDA vs SYCL Memory Model

### 1. `__syncwarp(mask)` — No SYCL Equivalent

SYCL `sub_group::barrier()` covers all sub-group members with no mask support.
If `mask != 0xFFFFFFFF`, the code needs restructuring.

**Check**: Search for any partial-warp patterns in original `csrc/kernels/`:
```bash
grep -n "__syncwarp" csrc/kernels/*.cu csrc/kernels/*.cuh | grep -v "0xffffffff\|~0"
```

### 2. `__threadfence_system()` and NIC Ordering

In CUDA, `__threadfence_system()` ensures writes are visible to all agents including the CPU
and NIC hardware. The SYCL equivalent `atomic_fence(seq_cst, memory_scope::system)` should
cover the same agents — but this **must be verified** for BMG + MLX NIC configuration.

**The key question**: Does SYCL `memory_scope::system` on BMG cover memory visible to the
MLX NIC? If not, the IBGDA-equivalent NIC operations are incorrectly ordered.

### 3. Default Atomic Memory Order

CUDA atomics (`atomicAdd`, `atomicCAS`, etc.) operate with `relaxed` ordering but have
implicit sequentially consistent behavior at the hardware level on some architectures.
SYCL `atomic_ref` requires explicit memory order specification.

**Check**: Verify that every `atomicCAS` used as a flag/semaphore uses `seq_cst` or
at minimum `acq_rel`, not `relaxed`.

### 4. ishmem quiet vs fence Semantics

- `nvshmem_quiet()`: All previously issued non-blocking operations are complete; data is
  visible at the destination before `quiet` returns.
- `nvshmem_fence()`: Provides ordering between previous and subsequent operations, but does
  NOT guarantee completion of non-blocking ops.

Verify ishmem has the same distinction. If ishmem uses different semantics, all patterns
using `nvshmem_fence()` need review.

### 5. Level Zero IPC PCIe Coherence

NVLink provides automatic cache coherence across GPUs in intranode communication.
PCIe + Level Zero IPC may require explicit cache flush/invalidate depending on whether
the Level Zero IPC allocation uses cache-coherent PCIe (snoop) or non-coherent (no-snoop).

**Check**: Verify Level Zero IPC memory coherence mode for B60/B70.

## Verification Search Patterns

Run these searches on `csrc_sycl/`:

```bash
# Find all memory fences — check scope is correct
grep -rn "atomic_fence" csrc_sycl/

# Find all barriers — check level (work_group vs sub_group)
grep -rn "group_barrier\|sub_group.*barrier\|sg\.barrier" csrc_sycl/

# Find all ishmem ordering operations — check placement
grep -rn "ishmem_quiet\|ishmem_fence\|ishmem_barrier" csrc_sycl/

# Find all atomic operations — check memory order
grep -rn "atomic_ref\|fetch_add\|fetch_or\|compare_exchange\|exchange" csrc_sycl/

# Find all HIGH_RISK annotations
grep -rn "HIGH_RISK\|MEMORY_MODEL_ISSUE" csrc_sycl/
```

## Output Template

For each issue found, document:

```markdown
### Issue N: [Brief Title]
- **Location**: `csrc_sycl/<file>:line`
- **Original CUDA**: `<original operation>`
- **Current SYCL**: `<current translation>`
- **Problem**: <description of the potential issue>
- **Required action**: <what needs to be verified or changed>
- **Severity**: BLOCKER / HIGH / MEDIUM
```
