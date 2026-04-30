# Memory Ordering Verification Checklist

## How to Use

Work through this checklist for every file in `csrc_sycl/`. Mark each item as:
- ✅ PASS: Verified correct
- ⚠️ REVIEW: Needs further verification
- 🔴 FAIL: Incorrect or uncertain, requires human decision
- N/A: Not applicable to this file

---

## Section 1: Work-Group Barrier Correctness

| # | Check | Method | Status |
|---|-------|--------|--------|
| 1.1 | Every `__syncthreads()` in original is replaced by `group_barrier(item.get_group())` | grep comparison | |
| 1.2 | No `group_barrier` is placed inside a divergent branch (all work-items must reach it) | code review | |
| 1.3 | Group barrier scope is `work_group`, not `sub_group` or `device` | inspect calls | |

## Section 2: Sub-Group Barrier Correctness

| # | Check | Method | Status |
|---|-------|--------|--------|
| 2.1 | `__syncwarp(0xFFFFFFFF)` → `sg.barrier()` (full sub-group, OK) | grep | |
| 2.2 | No `__syncwarp(partial_mask)` was silently translated — would be incorrect | grep original | |
| 2.3 | Sub-group width assumption: if original uses warpSize==32 arithmetic, it's updated for BMG | code search | |

## Section 3: Memory Fence Scope Correctness

| # | Check | Method | Status |
|---|-------|--------|--------|
| 3.1 | `__threadfence()` → `atomic_fence(seq_cst, device)` | grep comparison | |
| 3.2 | `__threadfence_block()` → `atomic_fence(seq_cst, work_group)` | grep comparison | |
| 3.3 | `__threadfence_system()` → `atomic_fence(seq_cst, system)` | grep comparison | |
| 3.4 | 🔴 HIGH RISK: `system` scope on BMG covers MLX NIC memory — VERIFY with hardware team | hardware docs | |
| 3.5 | No `__threadfence*` was silently dropped during translation | diff count | |

## Section 4: Atomic Operation Memory Ordering

| # | Check | Method | Status |
|---|-------|--------|--------|
| 4.1 | All `atomicCAS` used as spin-lock/flag use `seq_cst` or `acq_rel`, not `relaxed` | code review | |
| 4.2 | `atomicAdd` used for pure accumulation (no ordering needed) uses `relaxed` (OK) | code review | |
| 4.3 | `atomic_ref` address space is `global_space` for global memory, `local_space` for SLM | inspect | |
| 4.4 | No plain C++ `std::atomic` used in device code (not valid in SYCL kernels) | grep | |

## Section 5: ishmem Ordering Correctness

| # | Check | Method | Status |
|---|-------|--------|--------|
| 5.1 | Every `nvshmemx_*_nbi` (non-blocking PUT) has a corresponding `ishmem_quiet()` before remote read | trace | |
| 5.2 | Every `nvshmemx_*get_nbi` (non-blocking GET) has `ishmem_quiet()` before using the data | trace | |
| 5.3 | `ishmem_quiet()` scope covers ALL outstanding non-blocking ops, not just a subset | docs check | |
| 5.4 | `ishmem_fence()` is only used where ordering (not completion) was intended in original | intent check | |
| 5.5 | 🔴 HIGH RISK: `ishmem_quiet()` semantic matches `nvshmem_quiet()` — verify with ishmem docs | docs check | |
| 5.6 | `ishmem_barrier_all()` placement matches `nvshmem_barrier_all()` in original | trace | |
| 5.7 | No blocking ishmem op is called from inside a conditional where some work-items skip it | divergence check | |

## Section 6: Level Zero IPC PCIe Coherence

| # | Check | Method | Status |
|---|-------|--------|--------|
| 6.1 | After writing to IPC-mapped peer memory, remote GPU can read without explicit flush | Level Zero docs | |
| 6.2 | 🔴 HIGH RISK: PCIe snoop vs no-snoop mode for Level Zero IPC allocations on B60/B70 | hardware docs | |
| 6.3 | IPC handle lifecycle: get → export → import → use → close in correct order | code trace | |
| 6.4 | No use-after-close of IPC handles | lifetime analysis | |
| 6.5 | NVLink vs PCIe coherence difference: original code may assume stronger NVLink coherence | code review | |

## Section 7: Symmetric Heap Usage

| # | Check | Method | Status |
|---|-------|--------|--------|
| 7.1 | All `ishmem_malloc` allocations are on all PEs (symmetric) | code review | |
| 7.2 | Symmetric heap pointer arithmetic is correct for ishmem (same offset on all PEs) | trace | |
| 7.3 | `ishmem_ptr(ptr, pe)` used correctly to get local pointer to remote PE's sym. heap | inspect | |

## Section 8: General Correctness

| # | Check | Method | Status |
|---|-------|--------|--------|
| 8.1 | No CUDA-specific memory qualifier (`__device__`, `__constant__`, `__shared__`) in SYCL code | grep | |
| 8.2 | No `volatile` memory access pattern that relies on CUDA-specific visibility guarantees | review | |
| 8.3 | All `HIGH_RISK` annotations have been either resolved or escalated to human | grep count | |
| 8.4 | All `MEMORY_MODEL_ISSUE` annotations are documented in `04_memory_verification.md` | grep count | |

---

## Critical Questions Requiring Human Expert Input

These cannot be answered from documentation alone; require hardware team or vendor support:

1. **BMG + MLX NIC**: Does `atomic_fence(seq_cst, system)` in SYCL on B60/B70 guarantee
   visibility to MLX NIC HCA memory? Or is an additional PCIe write-combining flush needed?

2. **ishmem_quiet() scope**: Does it complete operations from ALL threads in the kernel,
   or only from the calling thread's perspective?

3. **Level Zero IPC PCIe cache coherence**: Is the peer memory access through Level Zero IPC
   handles cache-coherent (snoop enabled)? If not, is an explicit `zeCommandListAppendMemoryBarrier`
   needed before the remote GPU reads?

4. **Sub-group barrier on BMG**: Is `sg.barrier()` truly equivalent to `__syncwarp()` in terms
   of ordering guarantees, or does BMG require an additional fence for inter-sub-group visibility?

5. **ishmem + SYCL kernel interaction**: If multiple work-items in a kernel call `ishmem_put_nbi`,
   do all those puts become visible to a single `ishmem_quiet()` called by one work-item?
   Or must each work-item call `ishmem_quiet()` independently?
