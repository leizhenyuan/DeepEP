---
name: sycl-translation-patterns
description: "Reference patterns for translating CUDA code to SYCL/DPC++ for Intel GPU. Use when generating SYCL equivalents of CUDA kernels, converting CUDA memory management to SYCL, translating CUDA thread hierarchy to SYCL work-items/work-groups, or converting CUDA synchronization primitives. Includes warp-to-sub-group translation and atomic operation mapping."
---

# SYCL Translation Patterns

## When to Use

- Translating CUDA `__global__` kernels to SYCL `parallel_for`
- Converting CUDA memory management (`cudaMalloc`, `cudaMemcpy`) to SYCL equivalents
- Translating CUDA thread hierarchy (`threadIdx`, `blockIdx`) to SYCL
- Converting synchronization primitives (`__syncthreads`, `__threadfence*`)
- Translating warp operations (`__shfl_sync`, `__ballot_sync`) to sub-group operations

## Core Patterns

### Kernel Launch

```cuda
// CUDA
kernel<<<grid, block, smem_bytes>>>(args);
```

```cpp
// SYCL
queue.submit([&](sycl::handler& h) {
    sycl::local_accessor<T, 1> smem(smem_size, h);
    h.parallel_for(
        sycl::nd_range<1>{global_size, local_size},
        [=](sycl::nd_item<1> item) {
            // kernel body
        }
    );
});
```

### Thread Indexing

```cuda
// CUDA
int tid    = threadIdx.x;
int bid    = blockIdx.x;
int bsz    = blockDim.x;
int global = threadIdx.x + blockIdx.x * blockDim.x;
```

```cpp
// SYCL
int tid    = item.get_local_id(0);
int bid    = item.get_group(0);
int bsz    = item.get_local_range(0);
int global = item.get_global_id(0);
```

### Shared Memory → SLM

```cuda
// CUDA
__shared__ float smem[256];
__shared__ float smem2[N];  // dynamic via template
```

```cpp
// SYCL
// Static: local_accessor declared in submit lambda
sycl::local_accessor<float, 1> smem(256, h);

// Inside kernel: access via smem[index]
```

### Block/Group Barrier

```cuda
__syncthreads();
```

```cpp
sycl::group_barrier(item.get_group());
```

### Warp → Sub-Group

```cuda
// Get warp (sub-group in SYCL)
// CUDA: implicit warp of 32 threads
```

```cpp
// SYCL: explicit sub_group
sycl::sub_group sg = item.get_sub_group();
int lane = sg.get_local_id();          // threadIdx within warp
int sg_size = sg.get_local_range()[0]; // warpSize equivalent (16 or 32 on BMG)
```

### Warp Barrier

```cuda
__syncwarp();                // Full warp
__syncwarp(mask);            // ⚠ PARTIAL WARP — NO SYCL EQUIVALENT
```

```cpp
sg.barrier();                // Full sub-group barrier — covers ALL sub-group members
// HIGH_RISK: partial-mask __syncwarp has no SYCL equivalent
// If mask != 0xFFFFFFFF, this requires code restructuring
```

### Memory Fences

```cuda
__threadfence();             // device scope
__threadfence_block();       // block scope
__threadfence_system();      // system scope (covers host + NIC)
```

```cpp
// SYCL equivalents
sycl::atomic_fence(sycl::memory_order::seq_cst,
                   sycl::memory_scope::device);      // __threadfence()
sycl::atomic_fence(sycl::memory_order::seq_cst,
                   sycl::memory_scope::work_group);  // __threadfence_block()
sycl::atomic_fence(sycl::memory_order::seq_cst,
                   sycl::memory_scope::system);      // __threadfence_system()
// HIGH_RISK: verify that memory_scope::system covers NIC-accessible memory on BMG
```

### Atomics

```cuda
atomicAdd(ptr, val)
atomicCAS(ptr, compare, val)
atomicExch(ptr, val)
atomicOr(ptr, val)
atomicMax(ptr, val)
```

```cpp
// SYCL: atomic_ref with explicit memory order
// Default CUDA atomics use relaxed ordering — VERIFY if stronger order is needed
sycl::atomic_ref<T, sycl::memory_order::relaxed,
                    sycl::memory_scope::device,
                    sycl::access::address_space::global_space> ref(*ptr);
ref.fetch_add(val);
ref.compare_exchange_strong(compare, val);  // atomicCAS
ref.exchange(val);                           // atomicExch
ref.fetch_or(val);                           // atomicOr
ref.fetch_max(val);                          // atomicMax
```

> **WARNING**: CUDA default atomics are `relaxed` order. If the original code relies on
> ordering guarantees around the atomic, use `acquire`/`release`/`seq_cst` explicitly.

### Warp Shuffle → Sub-Group Permutation

```cuda
__shfl_sync(mask, val, src_lane)
__shfl_xor_sync(mask, val, lane_mask)
__shfl_down_sync(mask, val, delta)
__shfl_up_sync(mask, val, delta)
```

```cpp
// SYCL: sub-group collective operations (no mask support)
sycl::select_from_group(sg, val, src_lane)      // __shfl_sync
sycl::permute_group_by_xor(sg, val, lane_mask)  // __shfl_xor_sync
sycl::shift_group_left(sg, val, delta)           // __shfl_down_sync
sycl::shift_group_right(sg, val, delta)          // __shfl_up_sync
// HIGH_RISK: SYCL shuffle operates on all sub-group members; masked partial shuffles
// require algorithmic restructuring
```

### Ballot → Sub-Group All/Any/Reduce

```cuda
uint32_t mask = __ballot_sync(0xFFFFFFFF, pred);
bool any  = __any_sync(0xFFFFFFFF, pred);
bool all  = __all_sync(0xFFFFFFFF, pred);
```

```cpp
// SYCL sub-group reductions (no mask)
uint32_t bits = sycl::reduce_over_group(sg, (pred ? 1u : 0u), sycl::bit_or<uint32_t>());  // ballot approx
bool any  = sycl::any_of_group(sg, pred);
bool all  = sycl::all_of_group(sg, pred);
```

## See Also

For complete API mapping tables, see [CUDA→SYCL Mapping Reference](./references/cuda-sycl-mapping.md).
