---
name: ishmem-migration-guide
description: "Guide for migrating NVSHMEM GPU communication code to Intel ishmem for DeepEP Intel GPU porting. Use when implementing ishmem-based internode communication, mapping NVSHMEM API calls to ishmem equivalents, integrating ishmem with SYCL kernels, or verifying symmetric heap and memory ordering semantics."
---

# ishmem Migration Guide (NVSHMEM → ishmem)

## When to Use

- Implementing ishmem internode communication in SYCL kernels
- Mapping NVSHMEM calls found in DeepEP to their ishmem equivalents
- Setting up the ishmem symmetric heap from SYCL code
- Verifying memory ordering semantics around ishmem operations
- Understanding non-blocking ishmem operation completion model

## Self-Verification Policy (CRITICAL)

**Do NOT blindly trust the API mapping tables below.** When you encounter any uncertainty
about ishmem behavior, you MUST:

1. **Read the actual ishmem source code** in the workspace at `ishmem_ibgda/ishmem_ibgda/src/`.
2. **Verify the implementation** by inspecting the relevant `.cpp` / `_impl.h` files.
3. If after reading the source code the behavior is still unclear, report it as a
   `// HIGH_ISSUE:` in the generated code AND in the porting report.

### Key Source Files to Consult

| Topic | Files to Read |
|-------|---------------|
| quiet/fence semantics | `ishmem_ibgda/ishmem_ibgda/src/memory_ordering.cpp` |
| Non-blocking PUT/GET impl | `ishmem_ibgda/ishmem_ibgda/src/nbi_impl.h`, `ishmem_ibgda/ishmem_ibgda/src/nbi.cpp` |
| Blocking PUT/GET impl | `ishmem_ibgda/ishmem_ibgda/src/rma_impl.h`, `ishmem_ibgda/ishmem_ibgda/src/rma.cpp` |
| Atomic operations | `ishmem_ibgda/ishmem_ibgda/src/amo_impl.h`, `ishmem_ibgda/ishmem_ibgda/src/amo.cpp` |
| IBGDA device-side (doorbell, WQE) | `ishmem_ibgda/ishmem_ibgda/src/ibgda_device_impl.h`, `ishmem_ibgda/ishmem_ibgda/src/ibgda.cpp` |
| IBGDA types & constants | `ishmem_ibgda/ishmem_ibgda/src/ibgda_types.h`, `ishmem_ibgda/ishmem_ibgda/src/ibgda.h` |
| Synchronization / barriers | `ishmem_ibgda/ishmem_ibgda/src/synchronization.cpp` |
| Signaling operations | `ishmem_ibgda/ishmem_ibgda/src/signaling.cpp` |
| IPC (intranode) path | `ishmem_ibgda/ishmem_ibgda/src/ipc.cpp`, `ishmem_ibgda/ishmem_ibgda/src/ipc.h` |
| Runtime init / setup | `ishmem_ibgda/ishmem_ibgda/src/runtime.cpp`, `ishmem_ibgda/ishmem_ibgda/src/runtime.h` |
| Proxy (host-assist) path | `ishmem_ibgda/ishmem_ibgda/src/proxy_impl.h`, `ishmem_ibgda/ishmem_ibgda/src/proxy.cpp` |
| Public API headers | `ishmem_ibgda/ishmem_ibgda/src/ishmem.h`, `ishmem_ibgda/ishmem_ibgda/src/ishmemx.h` |
| Memory allocation | `ishmem_ibgda/ishmem_ibgda/src/malloc.cpp`, `ishmem_ibgda/ishmem_ibgda/src/memory.cpp` |
| Design docs | `ishmem_ibgda/ishmem_ibgda/docs/IBGDA_DESIGN.md`, `ishmem_ibgda/ishmem_ibgda/docs/IBGDA_STATUS_SUMMARY.md` |
| NBI guide & notes | `ishmem_ibgda/ishmem_ibgda/misc/IBGDA_NBI_GUIDE.md` |
| Example code | `ishmem_ibgda/ishmem_ibgda/examples/` |
| Tests | `ishmem_ibgda/ishmem_ibgda/test/` |

### Verification Workflow

```
For each NVSHMEM → ishmem mapping used in generated code:
  1. grep_search for the ishmem function name in ishmem_ibgda/ishmem_ibgda/src/
  2. Read the implementation to understand:
     - Does it go through proxy (host-assist) or direct device path?
     - What memory ordering does it provide?
     - Does IBGDA mode change the behavior?
  3. If semantics match NVSHMEM → use the mapping, add inline comment citing source file
  4. If semantics differ → adapt the code, document difference
  5. If semantics are UNCLEAR after reading source → mark as HIGH_ISSUE:
     // HIGH_ISSUE: ishmem_xxx() semantics unclear after inspecting <source_file>.
     //   NVSHMEM expects: <expected_behavior>
     //   ishmem source shows: <what_was_found>
     //   Risk: <what_could_go_wrong>
```

### HIGH_ISSUE Reporting Format

Any unresolved uncertainty MUST be reported using this format in generated code:

```cpp
// HIGH_ISSUE: <one-line summary>
//   Source inspected: <ishmem source file path>
//   NVSHMEM expects: <expected semantics>
//   ishmem provides: <observed or unclear semantics>
//   Risk: <correctness impact if wrong>
//   Action needed: <what human should verify>
```

## ishmem Overview

ishmem (Intel Symmetric Hierarchical Memory) is Intel's GPU-initiated communication library,
functionally equivalent to NVSHMEM. It provides:
- Symmetric heap for GPU-accessible distributed memory
- GPU kernel-initiated PUT/GET operations to remote PEs (processes)
- Ordering operations: `ishmem_quiet()`, `ishmem_fence()`
- Collective operations: `ishmem_barrier_all()`, `ishmem_sync_all()`
- Works with SYCL and Level Zero on Intel GPU
- **IBGDA mode**: GPU-direct NIC doorbell for low-latency RDMA (see `ibgda_device_impl.h`)

**Local reference**: `ishmem_ibgda/ishmem_ibgda/` (full source in workspace)

## Core API Mapping

> **IMPORTANT**: For each mapping below, VERIFY by reading the actual implementation before using.
> The source paths listed in the "Key Source Files" table above are your primary reference.

### Memory Allocation

```cpp
// NVSHMEM
void* ptr = nvshmem_malloc(size);
nvshmem_free(ptr);

// ishmem
void* ptr = ishmem_malloc(size);
ishmem_free(ptr);
```
**Verify in**: `ishmem_ibgda/ishmem_ibgda/src/malloc.cpp`

### Initialization

```cpp
// NVSHMEM (typical)
nvshmem_init();
int my_pe = nvshmem_my_pe();
int n_pes  = nvshmem_n_pes();

// ishmem
ishmem_init();
int my_pe = ishmem_my_pe();
int n_pes  = ishmem_n_pes();
```
**Verify in**: `ishmem_ibgda/ishmem_ibgda/src/ishmem.cpp`, `ishmem_ibgda/ishmem_ibgda/src/runtime.cpp`

### Blocking PUT (Sender-Initiated)

```cpp
// NVSHMEM
nvshmem_float_put(dest, src, nelems, pe);     // blocking float put
nvshmem_putmem(dest, src, bytes, pe);         // blocking raw bytes put

// ishmem
ishmem_float_put(dest, src, nelems, pe);
ishmem_putmem(dest, src, bytes, pe);
```
**Verify in**: `ishmem_ibgda/ishmem_ibgda/src/rma_impl.h` — note the IBGDA vs proxy vs IPC
code paths that `ishmem_internal_put()` can take depending on locality and IBGDA mode.

### Blocking GET (Receiver-Initiated)

```cpp
// NVSHMEM
nvshmem_float_get(dest, src, nelems, pe);
nvshmem_getmem(dest, src, bytes, pe);

// ishmem
ishmem_float_get(dest, src, nelems, pe);
ishmem_getmem(dest, src, bytes, pe);
```
**Verify in**: `ishmem_ibgda/ishmem_ibgda/src/rma_impl.h` — check `ishmem_internal_get()`.

### Non-Blocking PUT/GET

```cpp
// NVSHMEM
nvshmemx_float_put_nbi(dest, src, nelems, pe);   // non-blocking put
nvshmemx_float_get_nbi(dest, src, nelems, pe);   // non-blocking get
nvshmem_quiet();  // wait for all non-blocking ops to complete

// ishmem — NOTE: ishmem drops the 'x' prefix for NBI operations
ishmem_float_put_nbi(dest, src, nelems, pe);
ishmem_float_get_nbi(dest, src, nelems, pe);
ishmem_quiet();   // completion — MUST verify semantics (see below)
```

**Verify in**: `ishmem_ibgda/ishmem_ibgda/src/nbi_impl.h` — inspect `ishmem_internal_put_nbi()`
to understand the three code paths:
1. Node-local: direct `vec_copy_push` (IPC)
2. IBGDA enabled: `ishmemi_ibgda_device_post_put_nbi()` with spin-retry
3. Proxy fallback: `ishmemi_proxy_nonblocking_request()`

> **SELF-VERIFY**: Read `nbi_impl.h` to confirm whether NBI completion requires `ishmem_quiet()`
> or if there is an alternative completion mechanism. Check whether `ishmemi_ibgda_device_post_put_nbi`
> posts a WQE that is completed asynchronously and only guaranteed visible after `ishmem_quiet()`.

### Ordering Operations

```cpp
// NVSHMEM
nvshmem_quiet();          // wait for all non-blocking ops; ensures all data visible
nvshmem_fence();          // ordering only; does NOT wait for completion

// ishmem
ishmem_quiet();           // MUST verify completion semantics
ishmem_fence();           // MUST verify ordering-only semantics
```

**SELF-VERIFY** (read `ishmem_ibgda/ishmem_ibgda/src/memory_ordering.cpp`):

The implementation shows:
- `ishmem_fence()`: sends `FENCE` op via proxy, then issues
  `atomic_fence(sycl::memory_order::seq_cst, sycl::memory_scope::system)`.
  **Verify**: does the proxy FENCE op provide ordering-only (not completion) guarantee?
- `ishmem_quiet()`: calls `ishmemi_ibgda_device_quiet()` first (polls CQ for IBGDA direct
  doorbell completions), then sends `QUIET` op via proxy, then issues seq_cst system fence.
  **Verify**: does this guarantee all previously issued NBI data is visible at destination PE?

Also check work-group variants: `ishmemx_fence_work_group()`, `ishmemx_quiet_work_group()`.

> If after reading `memory_ordering.cpp` the semantics are still unclear (e.g., what exactly
> `ishmemi_ibgda_device_quiet()` polls for), report as HIGH_ISSUE with the specific source
> lines you inspected.

### Collective Synchronization

```cpp
// NVSHMEM
nvshmem_barrier_all();    // full barrier: all PEs, ensures prior operations visible
nvshmem_sync_all();       // sync without data ordering guarantee

// ishmem
ishmem_barrier_all();
ishmem_sync_all();
```
**Verify in**: `ishmem_ibgda/ishmem_ibgda/src/synchronization.cpp` — read to confirm whether
`ishmem_barrier_all()` implies a `quiet` (completion of all prior ops) before the barrier,
as NVSHMEM's `nvshmem_barrier_all()` does.

### Atomic Operations on Remote Memory

```cpp
// NVSHMEM — atomic ops on remote PE memory
nvshmem_float_atomic_add(dest, val, pe);
nvshmem_int_atomic_compare_swap(dest, cmp, val, pe);
nvshmem_int_atomic_fetch(dest, pe);

// ishmem
ishmem_float_atomic_add(dest, val, pe);
ishmem_int_atomic_compare_swap(dest, cmp, val, pe);
ishmem_int_atomic_fetch(dest, pe);
```
**Verify in**: `ishmem_ibgda/ishmem_ibgda/src/amo_impl.h` — check whether atomics go through
IBGDA path or proxy, and whether they are blocking or non-blocking by default.

> **IMPORTANT for DeepEP**: The CUDA internode kernels use `nvshmem_signal` / signal-based
> put operations. Check if ishmem supports signaling operations by reading
> `ishmem_ibgda/ishmem_ibgda/src/signaling.cpp`. If signaling APIs differ or are unavailable,
> report as HIGH_ISSUE.

## IBGDA (GPU-Direct NIC Doorbell) — Critical for DeepEP

DeepEP's internode kernels rely heavily on GPU-initiated RDMA. In the ishmem_ibgda fork,
this is implemented via IBGDA (InfiniBand GPU Direct Async).

**MUST READ** before generating internode kernel code:
- `ishmem_ibgda/ishmem_ibgda/src/ibgda_device_impl.h` — device-side WQE posting, doorbell,
  CQ polling, multi-QP round-robin
- `ishmem_ibgda/ishmem_ibgda/src/ibgda_types.h` — WQE structures, context types
- `ishmem_ibgda/ishmem_ibgda/src/ibgda.cpp` — host-side IBGDA setup
- `ishmem_ibgda/ishmem_ibgda/docs/IBGDA_DESIGN.md` — architecture overview

Key questions to answer by reading source:
1. How does `ishmemi_ibgda_device_post_put_nbi()` build and post a WQE?
2. How does `ishmemi_ibgda_device_quiet()` poll for completion?
3. What is the multi-QP model (`num_qps_per_pe`, round-robin)?
4. How does the staging WQ + host proxy drain work as fallback?

## Integration with SYCL Kernels

ishmem calls are made from within SYCL kernel code.

> **Platform Capabilities:**
> - `sycl::atomic_fence` is available for all memory fences
> - `sycl::atomic_ref` is available for non-system-scope atomics
> - Use tvisa only for named barriers and cache-controlled loads/stores

```cpp
queue.submit([&](sycl::handler& h) {
    h.parallel_for(
        sycl::nd_range<1>{global_size, local_size},
        [=](sycl::nd_item<1> item) [[sycl::reqd_sub_group_size(32)]] {
            int my_pe = ishmem_my_pe();
            int dest_pe = /* compute destination PE */;

            // Perform non-blocking PUT
            ishmem_float_put_nbi(dest_ptr, src_ptr, count, dest_pe);

            // Wait for completion before reading acknowledgment
            ishmem_quiet();

            // System fence to ensure visibility
            sycl::atomic_fence(sycl::memory_order::seq_cst, sycl::memory_scope::system);

            // Now safe to check completion flag on remote PE
        }
    );
});
```

**Verify**: Read `ishmem_ibgda/ishmem_ibgda/examples/` for working SYCL+ishmem kernel examples.
Check whether `ishmem_my_pe()` is callable from device code (look for `ISHMEM_DEVICE_ATTRIBUTES`
in headers).

## Work-Group Variants

ishmem provides work-group collective versions of many operations (e.g.,
`ishmemx_put_nbi_work_group`, `ishmemx_fence_work_group`, `ishmemx_quiet_work_group`).
These are important for DeepEP kernels that use warp/sub-group cooperative patterns.

**Verify in**: search for `_work_group` in `ishmem_ibgda/ishmem_ibgda/src/` to find all
available work-group variants. Key pattern from `rma_impl.h`:
- Only the group leader issues the ishmem operation
- `sycl::group_barrier(grp)` before and after the operation
- This differs from NVSHMEM where any thread can independently issue operations

> If DeepEP CUDA kernels issue NVSHMEM calls from individual threads (not just warp leaders),
> this is a **semantic difference** that must be handled. Report as HIGH_ISSUE if found.

## Common Communication Patterns

### Scatter (MoE Dispatch) — PUT Pattern

```cpp
// Each PE sends data to specific destination PEs
for (int dst_pe = 0; dst_pe < n_pes; dst_pe++) {
    if (send_count[dst_pe] > 0) {
        ishmem_float_put_nbi(
            remote_buf[my_pe],     // dest on remote PE
            local_send_buf[dst_pe], // source on local PE
            send_count[dst_pe],    // element count
            dst_pe                 // destination PE
        );
    }
}
ishmem_quiet();  // ensure all sends complete
```

### Gather (MoE Combine) — GET Pattern

```cpp
// Each PE pulls data from source PEs
for (int src_pe = 0; src_pe < n_pes; src_pe++) {
    if (recv_count[src_pe] > 0) {
        ishmem_float_get_nbi(
            local_recv_buf[src_pe], // dest on local PE
            remote_buf[my_pe],      // source on remote PE
            recv_count[src_pe],     // element count
            src_pe                  // source PE
        );
    }
}
ishmem_quiet();  // ensure all gets complete
```

## Checklist Before Using Any ishmem API in Generated Code

- [ ] Read the implementation source file for the API
- [ ] Confirm device-callable (`ISHMEM_DEVICE_ATTRIBUTES` or `__SYCL_DEVICE_ONLY__`)
- [ ] Check IBGDA vs proxy code path — which one will be active?
- [ ] Verify memory ordering guarantees match NVSHMEM equivalent
- [ ] Check if work-group variant is needed (DeepEP kernels often use cooperative patterns)
- [ ] Cite the source file in an inline comment: `// Verified: <api> semantics in <source_file>`
- [ ] If anything is unclear → HIGH_ISSUE with source lines inspected


