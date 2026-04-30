# CUDA → SYCL API Mapping Reference

## Memory Management

| CUDA | SYCL | Notes |
|------|------|-------|
| `cudaMalloc(ptr, size)` | `sycl::malloc_device(size, queue)` | Returns pointer directly |
| `cudaMallocHost(ptr, size)` | `sycl::malloc_host(size, queue)` | Pinned host memory |
| `cudaMallocManaged(ptr, size)` | `sycl::malloc_shared(size, queue)` | Unified shared memory |
| `cudaFree(ptr)` | `sycl::free(ptr, queue)` | Same pointer, different API |
| `cudaMemcpy(dst, src, size, kind)` | `queue.memcpy(dst, src, size)` | Async; use `.wait()` |
| `cudaMemset(ptr, val, size)` | `queue.memset(ptr, val, size)` | Async |
| `cudaDeviceSynchronize()` | `queue.wait()` | Drains all operations |
| `cudaIpcGetMemHandle(h, ptr)` | `zeMemGetIpcHandle(ctx, alloc, h)` | Level Zero API |
| `cudaIpcOpenMemHandle(ptr, h, f)` | `zeMemOpenIpcHandle(ctx, dev, h, 0, ptr)` | Level Zero API |
| `cudaIpcCloseMemHandle(ptr)` | `zeMemCloseIpcHandle(ctx, ptr)` | Level Zero API |

## Thread / Work-Item Hierarchy

| CUDA | SYCL | BMG Notes |
|------|------|-----------|
| `threadIdx.x` | `item.get_local_id(0)` | — |
| `threadIdx.y` | `item.get_local_id(1)` | — |
| `blockIdx.x` | `item.get_group(0)` | — |
| `blockDim.x` | `item.get_local_range(0)` | — |
| `gridDim.x` | `item.get_group_range(0)` | — |
| `blockIdx.x * blockDim.x + threadIdx.x` | `item.get_global_id(0)` | — |
| `warpSize` | `sg.get_max_local_range()[0]` | **16 or 32 on BMG — VERIFY** |
| `__lane_id()` / `threadIdx.x % warpSize` | `sg.get_local_id()` | — |
| `blockDim.x / warpSize` | `item.get_local_range(0) / sg.get_max_local_range()[0]` | — |

## Synchronization Primitives

| CUDA | SYCL | Scope Notes |
|------|------|-------------|
| `__syncthreads()` | `sycl::group_barrier(item.get_group())` | Work-group scope |
| `__syncwarp()` | `sg.barrier()` | Sub-group scope (full only, no mask!) |
| `__syncwarp(mask)` | **NO DIRECT EQUIVALENT** | HIGH RISK — needs restructuring |
| `__threadfence()` | `atomic_fence(seq_cst, memory_scope::device)` | Verify device scope |
| `__threadfence_block()` | `atomic_fence(seq_cst, memory_scope::work_group)` | Verify scope |
| `__threadfence_system()` | `atomic_fence(seq_cst, memory_scope::system)` | HIGH RISK: verify NIC coverage |

## Atomic Operations

| CUDA | SYCL `atomic_ref` method | Default Order |
|------|--------------------------|---------------|
| `atomicAdd(ptr, val)` | `ref.fetch_add(val)` | Use `relaxed` unless ordering needed |
| `atomicSub(ptr, val)` | `ref.fetch_sub(val)` | — |
| `atomicExch(ptr, val)` | `ref.exchange(val)` | — |
| `atomicCAS(ptr, cmp, val)` | `ref.compare_exchange_strong(cmp, val)` | `ref` must be `seq_cst` if ordering matters |
| `atomicOr(ptr, val)` | `ref.fetch_or(val)` | — |
| `atomicAnd(ptr, val)` | `ref.fetch_and(val)` | — |
| `atomicMax(ptr, val)` | `ref.fetch_max(val)` | — |
| `atomicMin(ptr, val)` | `ref.fetch_min(val)` | — |

**Memory order template for `atomic_ref`:**
```cpp
sycl::atomic_ref<T,
    sycl::memory_order::relaxed,     // or seq_cst, acquire, release
    sycl::memory_scope::device,      // or work_group, system
    sycl::access::address_space::global_space>
    ref(*ptr);
```

## Warp / Sub-Group Operations

| CUDA | SYCL | Notes |
|------|------|-------|
| `__shfl_sync(mask, val, src)` | `sycl::select_from_group(sg, val, src)` | No mask support |
| `__shfl_xor_sync(mask, val, m)` | `sycl::permute_group_by_xor(sg, val, m)` | No mask support |
| `__shfl_down_sync(mask, val, d)` | `sycl::shift_group_left(sg, val, d)` | No mask support |
| `__shfl_up_sync(mask, val, d)` | `sycl::shift_group_right(sg, val, d)` | No mask support |
| `__ballot_sync(mask, pred)` | `sycl::reduce_over_group(sg, pred?1:0, sycl::bit_or<>())` | Approximate |
| `__any_sync(mask, pred)` | `sycl::any_of_group(sg, pred)` | No mask |
| `__all_sync(mask, pred)` | `sycl::all_of_group(sg, pred)` | No mask |
| `__reduce_add_sync(mask, val)` | `sycl::reduce_over_group(sg, val, sycl::plus<>())` | No mask |

> ⚠️ **SYCL sub-group operations have no mask parameter.** If CUDA code uses partial-warp
> operations (mask != 0xFFFFFFFF), this requires algorithm restructuring. Flag as HIGH RISK.

## Kernel Attribute Mapping

| CUDA | SYCL / icpx | Notes |
|------|-------------|-------|
| `__launch_bounds__(maxT, minB)` | `[[intel::reqd_work_group_size(maxT)]]` | Different semantics |
| `__device__ inline` | `SYCL_EXTERNAL inline` or just `inline` | In same translation unit |
| `__forceinline__` | `[[always_inline]]` | Compiler hint |
| `__restrict__` | `__restrict` | Supported in DPC++ |
| `volatile` | `volatile` | Still valid in SYCL for device code |

## CUDA Stream → SYCL Queue

| CUDA | SYCL | Notes |
|------|------|-------|
| `cudaStream_t stream` | `sycl::queue queue` | Queue is the main execution object |
| `cudaStreamCreate(&s)` | `sycl::queue q(device, props)` | — |
| `cudaStreamSynchronize(s)` | `queue.wait()` | — |
| `cudaStreamDestroy(s)` | Destructor / out of scope | RAII |
| `cudaEventCreate(&e)` | `sycl::event e = queue.submit(...)` | Events from submissions |
| `cudaEventSynchronize(e)` | `e.wait()` | — |
| `cudaStreamWaitEvent(s, e)` | `queue.submit(..., depends_on(e))` | In handler |

## IMPORTANT: Warp Size Difference

If the original CUDA code assumes `warpSize == 32` and BMG sub-group size is 16:
- All `/ warpSize` or `% warpSize` calculations change
- `__shared__` arrays sized by warp count need updating
- Shuffle operations shift different amounts
- Bank conflict patterns may change

**Always query at runtime:**
```cpp
int sg_size = item.get_sub_group().get_max_local_range()[0];
```
