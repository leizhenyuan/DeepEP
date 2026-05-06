# Memory Ordering Verification Checklist

## How to Use

Work through this checklist for every file in `csrc_sycl/`. Mark each item as:
- ✅ PASS: Verified correct
- ⚠️ REVIEW: Needs further verification
- 🔴 FAIL: Incorrect or uncertain, requires human decision
- N/A: Not applicable to this file

---

## Background: Memory Ordering Assumptions for This Project

### PCIe Relaxed Ordering (Intranode)

**Assume PCIe operates under relaxed ordering (RO=1).** This means:
- GPU→GPU posted writes via PCIe P2P may arrive at the peer GPU out of order
- A GPU L1/L2 cache line written by the producer GPU is NOT automatically visible to the
  consumer GPU — PCIe P2P is not cache-coherent (unlike NVLink)
- A `memory_scope::device` fence on the *producer* only orders within that GPU's own memory system;
  it does NOT guarantee visibility across the PCIe link to the peer GPU
- **Correct scope for cross-GPU visibility: `memory_scope::system`**

### IBGDA / ishmem Ordering (Internode)

GPU-initiated RDMA (ishmem PUT) has a multi-step ordering chain. Each step requires explicit ordering:

```
Producer GPU:
  [1] write data to symmetric heap (GPU local memory)
  [2] atomic_fence(seq_cst, system)  ← ensure data visible to NIC DMA
  [3] ishmem_put / ishmem_put_nbi    ← NIC DMA reads data, sends RDMA write
  [4] ishmem_quiet()                 ← wait for NIC DMA to complete

Remote GPU (Consumer):
  [5] (RDMA write arrives — remote memory updated by NIC)
  [6] poll flag with acquire semantics ← see ishmem notification
  [7] read data                       ← must happen AFTER [6]
```

**Key gap**: there is no automatic "happens-before" across the PCIe+IB link.
Each arrow in the chain above requires an explicit ordering primitive.

### Intel B60 `atomic_ref<system>` Limitation — CRITICAL

**On Intel B60 (Xe2/BMG), `sycl::atomic_ref` with `memory_scope::system` is NOT reliably
usable for cross-device producer-consumer synchronization over PCIe.**

The root cause is a hardware limitation: the Xe2 GPU memory model does not guarantee
that a `memory_scope::system` acquire/release on an `atomic_ref` will issue the PCIe-level
ordering primitives needed to make the operation visible across the PCIe switch to a peer
GPU or NIC. The compiler may emit a weaker instruction than required.

**Consequence**: the following pattern that works on NVIDIA (via UVM / NVLink coherence)
or on x86 (via TSO) is UNSAFE on B60 PCIe P2P:

```cpp
// ❌ UNSAFE on Intel B60 — atomic_ref<system> may not issue PCIe-level fence
sycl::atomic_ref<int, sycl::memory_order::acq_rel,
                 sycl::memory_scope::system,
                 sycl::access::address_space::global_space> flag_ref(flag);
flag_ref.store(1);   // producer: MAY NOT be visible to peer GPU
while (flag_ref.load() == 0) {}  // consumer: MAY NOT see peer GPU's store
```

**Required replacement**: use an explicit `atomic_fence` AROUND plain relaxed atomic
or volatile operations, to force the PCIe ordering at the fence boundary:

```cpp
// ✅ SAFE on Intel B60 — explicit fence carries PCIe ordering responsibility
// Producer:
data_buf[idx] = value;                                  // plain store
sycl::atomic_fence(sycl::memory_order::seq_cst,          // ← PCIe fence
                   sycl::memory_scope::system);
*(volatile int*)&flag = 1;                              // plain/volatile store

// Consumer:
int f;
do {
    sycl::atomic_fence(sycl::memory_order::seq_cst,      // ← PCIe fence
                       sycl::memory_scope::system);
    f = *(volatile int*)&flag;                           // re-read
} while (f == 0);
sycl::atomic_fence(sycl::memory_order::seq_cst,          // ← acquire barrier
                   sycl::memory_scope::system);
// Now safe to read data_buf[idx]
```

> **Rule**: On Intel B60, `atomic_fence(seq_cst, system)` is the load-bearing primitive
> for cross-PCIe ordering. `atomic_ref<system>` alone is insufficient and must NOT be
> used as the sole ordering mechanism for cross-GPU or GPU↔NIC synchronization.

---

## Section 0: Producer-Consumer Pattern Inventory

For every producer-consumer pair in the ported code, verify the complete ordering chain.

### 0.1 — Intranode Producer-Consumer (PCIe IPC)

| # | Check | Scope Required | Status |
|---|-------|---------------|--------|
| 0.1.1 | Producer: all data stores are ordered before the flag/signal write | `memory_scope::system` | |
| 0.1.2 | Producer: flag write uses `memory_order::release` (or stronger) with `memory_scope::system` | inspect atomic_ref | |
| 0.1.3 | Consumer: flag poll uses `memory_order::acquire` (or stronger) with `memory_scope::system` | inspect atomic_ref | |
| 0.1.4 | Consumer: data reads are ordered AFTER the acquire flag read (no reordering across acquire) | code review | |
| 0.1.5 | 🔴 HIGH RISK: `memory_scope::system` on BMG covers peer GPU memory via PCIe — VERIFY | hardware docs | |
| 0.1.6 | No producer-consumer pair relies on `memory_scope::device` for cross-GPU visibility | grep | |

**Canonical intranode producer-consumer pattern (Intel B60 safe):**
```cpp
// Producer (GPU 0):
data_buf[idx] = value;                               // plain data write
sycl::atomic_fence(sycl::memory_order::seq_cst,      // ← PCIe fence (load-bearing)
                   sycl::memory_scope::system);
*(volatile uint32_t*)&flag = 1;                      // plain/volatile flag write

// Consumer (GPU 1, spinning):
uint32_t f;
do {
    sycl::atomic_fence(sycl::memory_order::seq_cst,  // ← PCIe fence before each read
                       sycl::memory_scope::system);
    f = *(volatile uint32_t*)&flag;
} while (f == 0);
sycl::atomic_fence(sycl::memory_order::seq_cst,      // ← acquire barrier after flag seen
                   sycl::memory_scope::system);
// Now safe to read data_buf[idx]
```

> Do NOT rely solely on `atomic_ref<system>` acquire/release for this pattern on B60 —
> see **Background: Intel B60 `atomic_ref<system>` Limitation**.

### 0.2 — Internode Producer-Consumer (ishmem / RDMA)

| # | Check | Status |
|---|-------|--------|
| 0.2.1 | Producer issues `atomic_fence(seq_cst, system)` BEFORE ishmem PUT to ensure NIC sees latest data | |
| 0.2.2 | Producer calls `ishmem_quiet()` before signaling remote consumer (flag/counter update) | |
| 0.2.3 | Remote flag/counter is updated via a SEPARATE ishmem PUT AFTER `ishmem_quiet()` on data PUT | |
| 0.2.4 | Consumer polls flag using `ishmem_atomic_fetch` (or equivalent) with sufficient ordering | |
| 0.2.5 | Consumer reads data only AFTER observing the flag — no speculation across the flag load | |
| 0.2.6 | 🔴 HIGH RISK: does `ishmem_quiet()` guarantee all prior PUT data is visible at remote before return? | ishmem docs | |

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

Pay special attention to any fence that separates a data write from a flag/signal write —
this is the producer side of a producer-consumer pair and requires `system` scope on PCIe.

| # | Check | Method | Status |
|---|-------|--------|--------|
| 3.1 | `__threadfence()` → `atomic_fence(seq_cst, device)` | grep comparison | |
| 3.2 | `__threadfence_block()` → `atomic_fence(seq_cst, work_group)` | grep comparison | |
| 3.3 | `__threadfence_system()` → `atomic_fence(seq_cst, system)` | grep comparison | |
| 3.4 | 🔴 HIGH RISK: `memory_scope::system` on BMG covers MLX NIC memory — VERIFY with hardware team | hardware docs | |
| 3.5 | No `__threadfence*` was silently dropped during translation | diff count | |
| 3.6 | 🔴 PCIe RELAXED ORDERING: any fence separating data write from cross-GPU flag write uses `system` scope, NOT `device` | code review | |
| 3.7 | In PTX: `fence.sc.sys` always maps to `atomic_fence(seq_cst, system)` — never downgraded to `device` | grep asm | |

## Section 4: Atomic Operation Memory Ordering

### Intel B60: `atomic_ref<system>` Is Insufficient for Cross-PCIe Ordering

> 🔴 **KNOWN HARDWARE LIMITATION on Intel B60 (Xe2/BMG)**: `sycl::atomic_ref` with
> `memory_scope::system` acquire/release semantics does NOT reliably provide PCIe-level
> ordering for **cross-PCIe producer-consumer synchronization** (GPU↔peer GPU or GPU↔NIC).
> Use **`atomic_fence(seq_cst, system)`** as the explicit ordering primitive instead.
>
> This limitation is **scoped to PCIe-connected peers with `memory_scope::system`**.
> `atomic_ref` with `memory_scope::device` for intra-GPU atomics (e.g., local counters,
> intra-work-group flags) is unaffected and remains correct.

| # | Check | Method | Status |
|---|-------|--------|--------|
| 4.1 | 🔴 No `atomic_ref<system>` is used as the sole ordering mechanism for cross-GPU flags — must be replaced with `atomic_fence(seq_cst, system)` + plain/volatile access | grep `memory_scope::system` in `atomic_ref` | |
| 4.2 | Spin-wait flags polled by remote GPU use `atomic_fence(seq_cst, system)` before each flag re-read | code review | |
| 4.3 | Flag writes visible to remote GPU use `atomic_fence(seq_cst, system)` BEFORE the flag write, not after | code review | |
| 4.4 | `atomicAdd` / `atomic_ref` for pure intra-GPU accumulation (no remote visibility) may use `device` scope — acceptable | code review | |
| 4.5 | `atomic_ref` address space is `global_space` for global memory, `local_space` for SLM | inspect | |
| 4.6 | No plain C++ `std::atomic` used in device code (not valid in SYCL kernels) | grep | |
| 4.7 | 🔴 Any `atomicCAS` used as cross-GPU lock: replaced with `atomic_fence(seq_cst, system)` + volatile compare pattern | grep | |
| 4.8 | All uses of `atomic_ref<system>` are audited and annotated with their intended scope — cross-GPU uses flagged as HIGH RISK | grep audit | |

## Section 5: ishmem Ordering Correctness

| # | Check | Method | Status |
|---|-------|--------|--------|
| 5.1 | Every `ishmem_put_nbi` (non-blocking PUT) for data has a corresponding `ishmem_quiet()` before remote read | trace | |
| 5.2 | Every `ishmem_get_nbi` (non-blocking GET) has `ishmem_quiet()` before using the data locally | trace | |
| 5.3 | `ishmem_quiet()` is called AFTER all non-blocking ops, not interleaved | code trace | |
| 5.4 | `ishmem_fence()` is only used where ordering (not completion) was intended | intent check | |
| 5.5 | 🔴 HIGH RISK: `ishmem_quiet()` semantic matches `nvshmem_quiet()` — verify with ishmem docs | docs check | |
| 5.6 | `ishmem_barrier_all()` placement matches `nvshmem_barrier_all()` in original | trace | |
| 5.7 | No blocking ishmem op is called from inside a conditional where some work-items skip it | divergence check | |

## Section 6: IBGDA / GPU-Initiated NIC Operation Ordering

This section covers the ordering chain for GPU-direct RDMA paths (ishmem internode).
Each step in the chain must be explicitly ordered — there is no implicit happens-before.

### 6.1 — Producer Side (Sender GPU)

| # | Check | Status |
|---|-------|--------|
| 6.1.1 | All data stores to symmetric heap complete BEFORE ishmem PUT is issued | |
| 6.1.2 | `atomic_fence(seq_cst, system)` is present BETWEEN data stores and ishmem PUT call | |
| 6.1.3 | 🔴 HIGH RISK: does `atomic_fence(system)` on BMG flush GPU L2 so NIC DMA sees the data? | |
| 6.1.4 | For NIC doorbell writes (PTX `st.volatile.global.u64`): volatile ptr write + fence replaces MMIO write — VERIFY non-cacheability | |
| 6.1.5 | `ishmem_quiet()` is called before producer writes the remote notification flag | |
| 6.1.6 | The notification flag PUT is a SEPARATE operation issued after `ishmem_quiet()` on data PUTs | |

### 6.2 — Consumer Side (Receiver GPU)

| # | Check | Status |
|---|-------|--------|
| 6.2.1 | Consumer polls notification flag with `memory_order::acquire`, `memory_scope::system` | |
| 6.2.2 | All data accesses are sequenced AFTER the acquire load of the notification flag | |
| 6.2.3 | 🔴 HIGH RISK: when RDMA write completes at remote, is the data immediately visible to GPU reads? Or does remote GPU need an explicit cache invalidation? | |
| 6.2.4 | No consumer reads data from RDMA-written region before the notification flag is observed | |

### 6.3 — Full Chain Ordering Audit

For each internode producer-consumer pair, trace and document the full ordering chain:

```
[producer]  data = value
[producer]  atomic_fence(seq_cst, system)      ← Step A
[producer]  ishmem_put_nbi(data, ...)           ← Step B: NIC DMA issues
[producer]  ishmem_quiet()                      ← Step C: NIC DMA completes
[producer]  ishmem_put(flag, 1, consumer_pe)    ← Step D: notification
[network]   RDMA write → remote memory          ← Step E (in-flight)
[consumer]  while (flag.load(acquire,sys)==0){} ← Step F
[consumer]  read data                           ← Step G
```

| # | Check | Status |
|---|-------|--------|
| 6.3.1 | Step A→B ordering: fence before ishmem call — present in code? | |
| 6.3.2 | Step B→C ordering: quiet before notification — present in code? | |
| 6.3.3 | Step C→D ordering: notification only after quiet — present in code? | |
| 6.3.4 | Step D→F ordering: flag arrives after data (RDMA ordering) — VERIFY with ishmem/IB docs | |
| 6.3.5 | Step F→G ordering: consumer acquire load prevents data read reorder — present in code? | |

## Section 7: Level Zero IPC PCIe Coherence (Intranode)

| # | Check | Method | Status |
|---|-------|--------|--------|
| 7.1 | After writing to IPC-mapped peer memory, a system-scope fence is issued before the flag write | code review | |
| 7.2 | 🔴 HIGH RISK: PCIe snoop vs no-snoop mode for Level Zero IPC allocations on B60/B70 — if no-snoop, peer GPU needs explicit cache invalidation before reading | hardware docs | |
| 7.3 | IPC handle lifecycle: get → export → import → use → close in correct order | code trace | |
| 7.4 | No use-after-close of IPC handles | lifetime analysis | |
| 7.5 | Original code assumed NVLink cache coherence — all such assumptions replaced with explicit fences | code review | |
| 7.6 | 🔴 PCIe RELAXED ORDERING: producer GPU's flag write via IPC uses system-scope release; consumer's flag poll uses system-scope acquire | grep | |

## Section 8: Symmetric Heap Usage

| # | Check | Method | Status |
|---|-------|--------|--------|
| 8.1 | All `ishmem_malloc` allocations are on all PEs (symmetric) | code review | |
| 8.2 | Symmetric heap pointer arithmetic is correct for ishmem (same offset on all PEs) | trace | |
| 8.3 | `ishmem_ptr(ptr, pe)` used correctly to get local pointer to remote PE's sym. heap | inspect | |

## Section 9: General Correctness

| # | Check | Method | Status |
|---|-------|--------|--------|
| 9.1 | No CUDA-specific memory qualifier (`__device__`, `__constant__`, `__shared__`) in SYCL code | grep | |
| 9.2 | No `volatile` used as substitute for proper acquire/release — only used for MMIO writes | review | |
| 9.3 | All `HIGH_RISK` annotations have been either resolved or escalated to human | grep count | |
| 9.4 | All `MEMORY_MODEL_ISSUE` annotations are documented in `04_memory_verification.md` | grep count | |

---

## Critical Questions Requiring Human Expert Input

These cannot be answered from documentation alone; require hardware team or vendor support:

1. **PCIe P2P + system-scope fence**: On Intel B60/B70 with PCIe relaxed ordering,
   does `atomic_fence(seq_cst, memory_scope::system)` guarantee that all prior GPU stores
   to peer GPU memory (via Level Zero IPC) are visible to the remote GPU before the fence returns?
   Or does the remote GPU additionally need an explicit cache invalidation?

2. **BMG + MLX NIC**: Does `atomic_fence(seq_cst, system)` on B60/B70 flush the GPU L2
   such that the MLX CX6 NIC can safely DMA-read the flushed data? What is the exact
   GPU→NIC ordering boundary on this PCIe switch topology?

3. **ishmem_quiet() completeness**: Does `ishmem_quiet()` guarantee that (a) all prior
   `ishmem_put_nbi` data has been DMA-read from local GPU memory by the NIC AND (b) the RDMA
   writes have been acknowledged as complete at the remote side? Or only (a)?

4. **Remote visibility after RDMA write**: After the remote NIC completes an RDMA write to the
   remote GPU's symmetric heap, does the remote GPU see the new data immediately on the next
   load? Or does it require an explicit cache invalidation / fence on the consumer side?

5. **ishmem + SYCL work-item interaction**: If multiple work-items in a kernel call
   `ishmem_put_nbi`, does a single `ishmem_quiet()` called by one work-item drain all
   outstanding puts from all work-items? Or must each work-item call `ishmem_quiet()` independently?

6. **PCIe relaxed ordering + flag pattern**: For the intranode producer-consumer flag pattern
   (GPU0 writes data to GPU1 IPC buffer, then writes flag), is `atomic_fence(seq_cst, system)`
   on GPU0 sufficient to prevent the flag from arriving at GPU1 before the data? Or does the
   PCIe switch itself reorder transactions independently of the issuing GPU's fence?

7. **Intel B60 `atomic_ref<system>` compiler codegen**: What instruction does the Intel GPU
   compiler emit for `atomic_ref<system>` acquire load and release store on Xe2/BMG?
   Does it emit an `lsc_fence` with system scope, or a weaker per-GPU fence? This determines
   whether `atomic_ref<system>` is safe for cross-PCIe producer-consumer patterns or must
   always be replaced with an explicit `atomic_fence(seq_cst, system)` + plain/volatile access.


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
