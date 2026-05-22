# DeepEP V1 Frontend Compatibility Analysis

## Overview

This document analyzes whether the current SYCL dispatch kernel (`csrc_sycl/internode_dispatch.hpp`)
can be called from DeepEP V1's existing frontend, what is missing, and whether V1 and V2 share
the same frontend.

---

## Q1: Can the SYCL Dispatch Kernel Be Called from V1's Frontend?

**No — not without a SYCL C++ API layer.**

### Current V1 Call Chain (CUDA)

```
Python                          C++                              CUDA Kernel
─────────────────────────────────────────────────────────────────────────────
Buffer.dispatch()
  └─ Buffer.internode_dispatch()
       └─ self.runtime.internode_dispatch(...)
              │                 (pybind11)
              └──────────────── legacy::Buffer::internode_dispatch()
                                  ├─ internode::notify_dispatch(..., cudaStream_t)
                                  │    CPU busy-wait on moe_recv_counter
                                  └─ internode::dispatch(..., cudaStream_t)
```

### SYCL Kernel Function Signatures

The SYCL kernel launch functions in `csrc_sycl/internode_dispatch.hpp` have **matching parameter
lists** to the CUDA originals in `csrc/kernels/legacy/internode.cu`, except:

| Parameter | CUDA | SYCL |
|-----------|------|------|
| Stream | `cudaStream_t stream` | `sycl::queue& queue` |

This means the kernel-level interface is compatible. However, the **entire C++ Buffer class**
(`csrc/legacy/buffer.hpp`) that wraps these kernel calls is CUDA-specific:

| Dependency | Used For |
|------------|----------|
| `ATen/cuda/CUDAContext.h` | CUDA stream, device properties |
| `cuda_runtime.h` | `cudaMallocHost`, `cudaHostGetDevicePointer`, `cudaMemcpy`, `cudaDeviceSynchronize` |
| `at::cuda::CUDAStream` | Stream management, `stream_wait()` |
| `shared_memory::MemHandle` | CUDA IPC handles for intranode NVLink buffers |
| `nvshmem::init()` / `nvshmem::alloc()` | NVSHMEM symmetric heap for RDMA buffer |
| `nvshmem::barrier()` | Cross-rank synchronization |

**Conclusion**: The SYCL kernel functions are signature-compatible but cannot be called because
there is no SYCL equivalent of the C++ `legacy::Buffer` class that manages memory allocation,
IPC setup, RDMA initialization, tensor allocation, and the 2-phase launch sequence.

---

## Q2: What Is Missing in the V1 Frontend for SYCL?

### Layer-by-Layer Gap Analysis

#### Layer 1: Kernel Level (Partial — dispatch only)

| Component | CUDA Status | SYCL Status |
|-----------|------------|-------------|
| `internode::notify_dispatch()` | ✅ `internode.cu` | ✅ `internode_dispatch.hpp` |
| `internode::dispatch()` | ✅ `internode.cu` | ✅ `internode_dispatch.hpp` |
| `internode::cached_notify()` | ✅ `internode.cu` | ❌ Not ported |
| `internode::combine()` | ✅ `internode.cu` | ❌ Not ported |
| `internode::get_source_meta_bytes()` | ✅ `internode.cu` | ❌ Not ported (trivial) |
| `internode_ll::dispatch()` | ✅ `internode_ll.cu` | ❌ Not ported |
| `internode_ll::combine()` | ✅ `internode_ll.cu` | ❌ Not ported |
| `layout::get_dispatch_layout()` | ✅ `layout.cu` | ❌ Not ported |
| `intranode::*()` | ✅ `intranode.cu` | ❌ Not ported (out of scope) |

#### Layer 2: C++ Buffer API (`csrc/legacy/buffer.hpp` → needs `csrc_sycl/legacy/buffer.hpp`)

This is the **biggest missing piece**. Needs a full SYCL port of the `legacy::Buffer` class:

| Sub-component | CUDA Original | SYCL Replacement Needed |
|---------------|---------------|------------------------|
| Constructor memory alloc | `cudaMalloc`, `cudaMemset` | `sycl::malloc_device`, `queue.memset` |
| Host-pinned counters | `cudaMallocHost(cudaHostAllocMapped)` + `cudaHostGetDevicePointer` | `sycl::malloc_host` or `sycl::malloc_shared` (USM) |
| IPC buffer exchange | `shared_memory::MemHandle` (CUDA IPC) | Level Zero `zeMemGetIpcHandle` / `zeMemOpenIpcHandle` |
| RDMA buffer alloc | `nvshmem::alloc()` | `ishmem_malloc()` |
| RDMA init | `nvshmem::init(unique_id, rank, ...)` | `ishmem_init()` (MPI-based bootstrap) |
| RDMA barrier | `nvshmem::barrier()` | `ishmem_barrier_all()` |
| Stream management | `at::cuda::CUDAStream` | `sycl::queue` (no ATen SYCL integration) |
| Stream wait | `cudaStreamWaitEvent` | `queue.ext_oneapi_submit_barrier({event})` |
| Device properties | `cudaGetDeviceProperties` | `sycl::device::get_info<>()` |
| Tensor allocation | `torch::empty({...}, torch::kCUDA)` | `torch::empty({...}, torch::kXPU)` or manual USM |
| `internode_dispatch()` method | Calls CUDA kernel functions | Must call SYCL launch functions |
| `internode_combine()` method | Calls CUDA kernel functions | ❌ Kernel not yet ported |
| `register_apis()` pybind11 | Registers CUDA Buffer | Must register SYCL Buffer |

#### Layer 3: Backend Runtime (`csrc/kernels/backend/`)

| Component | CUDA | SYCL Needed |
|-----------|------|-------------|
| `nvshmem.cu` — init, alloc, barrier, team | ✅ | `ishmem.cpp` — ishmem_init, ishmem_malloc, ishmem_barrier_all |
| `nccl.cu` — NCCL Gin comm handle | ✅ (V2 only) | ❌ Not needed for V1 |
| `cuda_driver.cu` — cuTensorMap, cuMem* | ✅ | ❌ Not needed (TMA removed) |

#### Layer 4: Shared Utilities (`csrc/utils/`)

| Component | CUDA | SYCL Needed |
|-----------|------|-------------|
| `shared_memory.hpp` — CUDA IPC allocator | ✅ | Level Zero IPC allocator |
| `event.hpp` — EventHandle | ✅ | SYCL event wrapper |

#### Layer 5: Python Frontend (`deep_ep/buffers/legacy.py`)

| Sub-component | Change Needed |
|---------------|---------------|
| NVSHMEM env vars | Replace with ishmem env vars (or remove — ishmem uses MPI bootstrap) |
| `_C.Buffer(rank, num_ranks, ...)` | Must bind to SYCL Buffer class |
| `runtime.get_local_nvshmem_unique_id()` | Replace with ishmem MPI-based init (no unique_id exchange) |
| `runtime.sync(device_ids, ipc_handles, root_unique_id)` | Adapt for Level Zero IPC + ishmem |
| `runtime.internode_dispatch(...)` | Signature matches, but C++ implementation must change |

#### Layer 6: Build System (`setup.py`)

| Item | Change |
|------|--------|
| `CUDAExtension` | Replace with SYCL compilation (icpx + `-fsycl`) |
| NVSHMEM link flags | Replace with ishmem link flags |
| NCCL link flags | Remove for V1 (or keep if shared with V2) |
| nvcc flags | Replace with icpx/dpcpp flags |
| `TORCH_CUDA_ARCH_LIST` | Remove (Intel has no arch list) |
| CUDA driver link | Remove `-lcuda`, add Level Zero `-lze_loader` |

#### Layer 7: JIT Runtime (`csrc/jit/`)

| Component | Notes |
|-----------|-------|
| JIT compilation | V2 uses JIT for kernel compilation. V1 does not use JIT. Can be skipped for V1. |

---

## Q3: Do V1 and V2 Share the Same Frontend?

**No. V1 and V2 have completely separate frontend stacks.**

### Comparison Table

| Aspect | V1 (Legacy) | V2 (Elastic) |
|--------|------------|--------------|
| Python class | `deep_ep.Buffer` | `deep_ep.ElasticBuffer` |
| Python file | `deep_ep/buffers/legacy.py` | `deep_ep/buffers/elastic.py` |
| C++ class | `deep_ep::legacy::Buffer` | `deep_ep::elastic::Buffer` |
| C++ file | `csrc/legacy/buffer.hpp` | `csrc/elastic/buffer.hpp` |
| Config | `deep_ep::legacy::Config` (5 chunked token params) | Inline params, no separate Config struct |
| Handle type | `Tuple[Tensor, ...]` (10 elements) | `EPHandle` class with named attributes |
| Kernel architecture | 2 separate kernels (notify_dispatch + dispatch) | 1 fused kernel (hybrid_dispatch.cuh) |
| Communication lib | NVSHMEM + IBGDA | NCCL Gin (GPU-initiated NCCL) |
| Backend file | `csrc/kernels/backend/nvshmem.cu` | `csrc/kernels/backend/nccl.cu` |
| Kernel location | `csrc/kernels/legacy/internode.cu` | `csrc/kernels/elastic/dispatch.hpp` + `csrc/kernels/hybrid_dispatch.cuh` |
| Kernel compilation | Static (compiled at build time) | JIT (compiled at runtime via `csrc/jit/`) |
| C++ namespace | `deep_ep::legacy` | `deep_ep::elastic` |
| Scale-up/scale-out | Implicit (NVL peers = scale-up, RDMA ranks = scale-out) | Explicit (`num_scaleup_ranks`, `num_scaleout_ranks`) |
| NCCL dependency | ❌ No | ✅ Yes (NCCL Gin) |
| NVSHMEM dependency | ✅ Yes | ❌ No |

### Shared Components

Both V1 and V2 share:
- `python_api.cpp` — single pybind11 module entry point (`_C`) registering both
- `deep_ep/__init__.py` — imports both `Buffer` and `ElasticBuffer`
- `deep_ep/utils/` — event handling, math utilities, environment checks
- `csrc/kernels/backend/cuda_driver.cu` — CUDA driver utilities
- `setup.py` — single build system compiling both

### Python `__init__.py` Exports Both

```python
from .buffers.legacy import Buffer        # V1
from .buffers.elastic import ElasticBuffer, EPHandle  # V2
```

### Implication for Porting

Since V1 and V2 are independent, porting V1 to SYCL does **not** require touching V2 code.
The SYCL V1 port can be built as a separate extension module, or the existing `python_api.cpp`
can conditionally compile V1-SYCL alongside V2-CUDA (or V2 can be disabled entirely for Intel).

---

## Summary & Recommended Next Steps

### Current State
- ✅ SYCL dispatch kernel (`internode_dispatch.hpp`) — signature-compatible with CUDA
- ✅ SYCL infrastructure (`configs.hpp`, `utils.hpp`, `buffer.hpp`, `exception.hpp`)
- ❌ No SYCL C++ Buffer class (the critical glue layer)
- ❌ No SYCL runtime/backend (ishmem init, Level Zero IPC)
- ❌ No Python bindings for SYCL Buffer
- ❌ No SYCL build system
- ❌ Combine kernel not ported
- ❌ Low-latency kernels not ported
- ❌ Layout kernel not ported

### Recommended Priority (for minimal dispatch end-to-end)

1. **`csrc_sycl/runtime.cpp`** — ishmem init/alloc/barrier wrapper functions
2. **`csrc_sycl/ipc.hpp`** — Level Zero IPC handle management
3. **`csrc_sycl/legacy/buffer.hpp`** — SYCL Buffer class with `internode_dispatch()` method
4. **`csrc_sycl/python_api.cpp`** — pybind11 bindings for SYCL Buffer
5. **`deep_ep/buffers/legacy_sycl.py`** — Python wrapper (or modify `legacy.py` with backend switch)
6. **`csrc_sycl/CMakeLists.txt`** — Already exists, needs extension
7. **Port `get_source_meta_bytes()`** — Trivial (returns `sizeof(SourceMeta)`)
8. **Port `layout.cu` → `layout.cpp`** — `get_dispatch_layout()` kernel
