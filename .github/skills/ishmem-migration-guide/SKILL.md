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

## ishmem Overview

ishmem (Intel Symmetric Hierarchical Memory) is Intel's GPU-initiated communication library,
functionally equivalent to NVSHMEM. It provides:
- Symmetric heap for GPU-accessible distributed memory
- GPU kernel-initiated PUT/GET operations to remote PEs (processes)
- Ordering operations: `ishmem_quiet()`, `ishmem_fence()`
- Collective operations: `ishmem_barrier_all()`, `ishmem_sync_all()`
- Works with SYCL and Level Zero on Intel GPU

**Reference**: https://github.com/oneapi-src/ishmem

## Core API Mapping

### Memory Allocation

```cpp
// NVSHMEM
void* ptr = nvshmem_malloc(size);
nvshmem_free(ptr);

// ishmem
void* ptr = ishmem_malloc(size);
ishmem_free(ptr);
```

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

### Blocking PUT (Sender-Initiated)

```cpp
// NVSHMEM
nvshmem_float_put(dest, src, nelems, pe);     // blocking float put
nvshmem_putmem(dest, src, bytes, pe);         // blocking raw bytes put

// ishmem
ishmem_float_put(dest, src, nelems, pe);
ishmem_putmem(dest, src, bytes, pe);
```

### Blocking GET (Receiver-Initiated)

```cpp
// NVSHMEM
nvshmem_float_get(dest, src, nelems, pe);
nvshmem_getmem(dest, src, bytes, pe);

// ishmem
ishmem_float_get(dest, src, nelems, pe);
ishmem_getmem(dest, src, bytes, pe);
```

### Non-Blocking PUT/GET

```cpp
// NVSHMEM
nvshmemx_float_put_nbi(dest, src, nelems, pe);   // non-blocking put
nvshmemx_float_get_nbi(dest, src, nelems, pe);   // non-blocking get
nvshmem_quiet();  // wait for all non-blocking ops to complete

// ishmem
ishmem_float_put_nbi(dest, src, nelems, pe);
ishmem_float_get_nbi(dest, src, nelems, pe);
ishmem_quiet();   // same completion model
```

> ⚠️ **HIGH RISK**: Verify that `ishmem_quiet()` provides the same ordering guarantee as
> `nvshmem_quiet()`. Specifically: does it ensure all previously issued PUT data is visible
> at the destination PE before returning?

### Ordering Operations

```cpp
// NVSHMEM
nvshmem_quiet();          // wait for all non-blocking ops; ensures all data visible
nvshmem_fence();          // ordering only; does NOT wait for completion

// ishmem
ishmem_quiet();           // HIGH RISK: verify completion semantics
ishmem_fence();           // HIGH RISK: verify ordering vs quiet distinction
```

> ⚠️ **quiet vs fence**: In NVSHMEM, `quiet` guarantees completion and ordering;
> `fence` provides ordering only without waiting for completion. Verify ishmem has same semantics.

### Collective Synchronization

```cpp
// NVSHMEM
nvshmem_barrier_all();    // full barrier: all PEs, ensures prior operations visible
nvshmem_sync_all();       // sync without data ordering guarantee

// ishmem
ishmem_barrier_all();     // verify: same semantics as nvshmem_barrier_all?
ishmem_sync_all();
```

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

## Integration with SYCL Kernels

ishmem calls are made from within SYCL kernel code:

```cpp
queue.submit([&](sycl::handler& h) {
    h.parallel_for(
        sycl::nd_range<1>{global_size, local_size},
        [=](sycl::nd_item<1> item) {
            int my_pe = ishmem_my_pe();
            int dest_pe = /* compute destination PE */;

            // Perform non-blocking PUT
            ishmem_float_put_nbi(dest_ptr, src_ptr, count, dest_pe);

            // Wait for completion before reading acknowledgment
            ishmem_quiet();

            // Now safe to check completion flag on remote PE
        }
    );
});
```

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

## See Also

For complete API details, see [NVSHMEM → ishmem API Map](./references/nvshmem-ishmem-api-map.md).
