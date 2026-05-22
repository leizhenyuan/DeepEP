# NVSHMEM → ishmem API Reference Map

## Status Notation
- ✅ VERIFIED: Confirmed equivalent behavior
- ⚠️ UNVERIFIED: Expected equivalent, needs confirmation
- 🔴 HIGH RISK: Behavior may differ, requires human verification
- ❌ NO EQUIVALENT: Needs alternative approach

## Initialization and Query

| NVSHMEM | ishmem | Status | Notes |
|---------|--------|--------|-------|
| `nvshmem_init()` | `ishmem_init()` | ⚠️ UNVERIFIED | |
| `nvshmemx_init_attr(attr)` | `ishmem_init()` | ⚠️ UNVERIFIED | attr mechanism may differ |
| `nvshmem_finalize()` | `ishmem_finalize()` | ⚠️ UNVERIFIED | |
| `nvshmem_my_pe()` | `ishmem_my_pe()` | ⚠️ UNVERIFIED | |
| `nvshmem_n_pes()` | `ishmem_n_pes()` | ⚠️ UNVERIFIED | |
| `nvshmem_ptr(ptr, pe)` | `ishmem_ptr(ptr, pe)` | ⚠️ UNVERIFIED | Returns local ptr to remote sym. heap addr |

## Memory Management

| NVSHMEM | ishmem | Status | Notes |
|---------|--------|--------|-------|
| `nvshmem_malloc(size)` | `ishmem_malloc(size)` | ⚠️ UNVERIFIED | Symmetric heap allocation |
| `nvshmem_calloc(count, size)` | `ishmem_calloc(count, size)` | ⚠️ UNVERIFIED | |
| `nvshmem_free(ptr)` | `ishmem_free(ptr)` | ⚠️ UNVERIFIED | |
| `nvshmem_align(align, size)` | `ishmem_align(align, size)` | ⚠️ UNVERIFIED | |

## RMA Operations — PUT (Blocking)

| NVSHMEM | ishmem | Status |
|---------|--------|--------|
| `nvshmem_float_put(d,s,n,pe)` | `ishmem_float_put(d,s,n,pe)` | ⚠️ UNVERIFIED |
| `nvshmem_double_put(d,s,n,pe)` | `ishmem_double_put(d,s,n,pe)` | ⚠️ UNVERIFIED |
| `nvshmem_int_put(d,s,n,pe)` | `ishmem_int_put(d,s,n,pe)` | ⚠️ UNVERIFIED |
| `nvshmem_int64_put(d,s,n,pe)` | `ishmem_int64_put(d,s,n,pe)` | ⚠️ UNVERIFIED |
| `nvshmem_putmem(d,s,b,pe)` | `ishmem_putmem(d,s,b,pe)` | ⚠️ UNVERIFIED |
| `nvshmem_float_p(d,val,pe)` | `ishmem_float_p(d,val,pe)` | ⚠️ UNVERIFIED | Single-element |

## RMA Operations — GET (Blocking)

| NVSHMEM | ishmem | Status |
|---------|--------|--------|
| `nvshmem_float_get(d,s,n,pe)` | `ishmem_float_get(d,s,n,pe)` | ⚠️ UNVERIFIED |
| `nvshmem_getmem(d,s,b,pe)` | `ishmem_getmem(d,s,b,pe)` | ⚠️ UNVERIFIED |
| `nvshmem_float_g(d,pe)` | `ishmem_float_g(d,pe)` | ⚠️ UNVERIFIED | Single-element |

## Non-Blocking RMA

| NVSHMEM | ishmem | Status | Notes |
|---------|--------|--------|-------|
| `nvshmemx_float_put_nbi(d,s,n,pe)` | `ishmem_float_put_nbi(d,s,n,pe)` | ⚠️ UNVERIFIED | |
| `nvshmemx_float_get_nbi(d,s,n,pe)` | `ishmem_float_get_nbi(d,s,n,pe)` | ⚠️ UNVERIFIED | |
| `nvshmemx_putmem_nbi(d,s,b,pe)` | `ishmem_putmem_nbi(d,s,b,pe)` | ⚠️ UNVERIFIED | |
| `nvshmemx_getmem_nbi(d,s,b,pe)` | `ishmem_getmem_nbi(d,s,b,pe)` | ⚠️ UNVERIFIED | |

## Ordering Operations — CRITICAL

| NVSHMEM | ishmem | Status | Semantic Description |
|---------|--------|--------|----------------------|
| `nvshmem_quiet()` | `ishmem_quiet()` | 🔴 HIGH RISK | Completes all prior RMAs; data visible at dest |
| `nvshmem_fence()` | `ishmem_fence()` | 🔴 HIGH RISK | Orders ops; does NOT guarantee completion |
| `nvshmem_barrier_all()` | `ishmem_barrier_all()` | 🔴 HIGH RISK | Full barrier across all PEs |
| `nvshmem_sync_all()` | `ishmem_sync_all()` | ⚠️ UNVERIFIED | Sync without data ordering |
| `nvshmem_barrier(team)` | `ishmem_team_barrier(team)` | ⚠️ UNVERIFIED | Team-scoped barrier |

> 🔴 **CRITICAL**: The semantic distinction between `quiet` and `fence` must be verified
> in ishmem documentation before any non-blocking code is implemented.

## Atomic Operations on Remote Memory

| NVSHMEM | ishmem | Status |
|---------|--------|--------|
| `nvshmem_int_atomic_add(d,v,pe)` | `ishmem_int_atomic_add(d,v,pe)` | ⚠️ UNVERIFIED |
| `nvshmem_int_atomic_fetch_add(d,v,pe)` | `ishmem_int_atomic_fetch_add(d,v,pe)` | ⚠️ UNVERIFIED |
| `nvshmem_int_atomic_compare_swap(d,c,v,pe)` | `ishmem_int_atomic_compare_swap(d,c,v,pe)` | ⚠️ UNVERIFIED |
| `nvshmem_int_atomic_fetch(d,pe)` | `ishmem_int_atomic_fetch(d,pe)` | ⚠️ UNVERIFIED |
| `nvshmem_int_atomic_set(d,v,pe)` | `ishmem_int_atomic_set(d,v,pe)` | ⚠️ UNVERIFIED |

## Wait/Signal Operations

| NVSHMEM | ishmem | Status | Notes |
|---------|--------|--------|-------|
| `nvshmem_int_wait_until(ptr, cmp, val)` | `ishmem_int_wait_until(ptr, cmp, val)` | 🔴 HIGH RISK | Spin-wait on local sym. heap value |
| `nvshmem_signal_wait_until(sig, cmp, val)` | `ishmem_uint64_wait_until(sig, cmp, val)` | 🔴 HIGH RISK | |
| `nvshmemx_signal_op(sig, val, op, pe)` | `ishmem_signal_op(sig, val, op, pe)` | ⚠️ UNVERIFIED | |

## IBGDA Equivalents

IBGDA in NVSHMEM provides GPU kernel-direct NIC operations (doorbell rings, QP management).
In ishmem, these operations are abstracted:

| NVSHMEM/IBGDA Concept | ishmem Equivalent | Notes |
|-----------------------|-------------------|-------|
| Direct NIC doorbell ring | `ishmem_put_nbi` + ishmem internals | ishmem abstracts NIC |
| QP (Queue Pair) management | Managed by ishmem runtime | Not exposed to user |
| Completion queue (CQ) | Not exposed | ishmem handles internally |
| GPU-direct RDMA | ishmem PUT/GET with GPU-side initiation | Same end-to-end model |

> The key difference: IBGDA in DeepEP does **explicit** QP/CQ management for low latency.
> ishmem abstracts this. The low-latency `internode_ll.cu` path may need special attention
> since its performance advantage over standard ishmem PUT/GET is uncertain.

## Known NVSHMEM Features Without Clear ishmem Equivalent

| Feature | Status | Action Required |
|---------|--------|-----------------|
| `nvshmemx_*_on_stream` (stream-ordered) | ❌ Need to check | Find ishmem SYCL queue-ordered variant |
| Custom transport (UCX) configuration | ❌ Different model | Verify ishmem transport config |
| IBGDA explicit NIC control | 🔴 HIGH RISK | ishmem may not expose same low-level control |
| PE teams (non-world collectives) | ⚠️ UNVERIFIED | ishmem may have team support |
