---
name: asm-translation-guide
description: "Guide for handling CUDA inline PTX assembly and finding Intel GPU (BMG) assembly equivalents for DeepEP porting. Use when encountering __asm__ volatile PTX instructions in CUDA kernels, mapping PTX ops to Intel GPU VISA/GEN assembly, or finding tvisa/Level Zero low-level equivalents. Reference tvisa (https://github.com/CaoZhongZ/tvisa) for Intel GPU assembly patterns."
---

# ASM Translation Guide (PTX → Intel GPU VISA)

## When to Use

- DeepEP CUDA kernel contains `asm volatile(...)` or `__asm__` inline PTX
- Need to understand what a PTX instruction does at the hardware level
- Looking for the Intel GPU equivalent of a PTX instruction
- SYCL high-level API does not expose the required operation
- Verifying that a low-level memory operation has the correct Intel counterpart

---

## Key Reference: tvisa

**https://github.com/CaoZhongZ/tvisa**

tvisa is a collection of Intel GPU assembly (VISA/GEN ISA) patterns implemented as
inline assembly intrinsics, specifically for use cases like low-latency
communication and GPU-initiated NIC operations — directly relevant to DeepEP porting.

When you encounter a PTX instruction with no obvious SYCL high-level equivalent,
fetch and search tvisa for the corresponding Intel pattern.

---

## Common PTX Patterns in DeepEP and Their Intel Equivalents

## Common PTX Patterns in DeepEP and Their Intel Equivalents

> **Platform Capabilities:**
> - `sycl::atomic_fence` is available and sufficient for all memory ordering
> - `sycl::atomic_ref` is available for **non-system-scope** atomics (device/work_group/sub_group)
> - For **system-scope** atomics: use `sycl::atomic_fence(seq_cst, system)` + compiler built-ins
> - tvisa `lscFence` is NOT needed for fences — use `sycl::atomic_fence` instead

### 1. Memory Fence / Ordering

```cuda
// CUDA PTX: system-scope fence
asm volatile("fence.acq_rel.sys;" ::: "memory");
```

**Intel SYCL equivalent:**
```cpp
sycl::atomic_fence(sycl::memory_order::acq_rel, sycl::memory_scope::system);
```

**Full scope mapping:**
| PTX Scope | SYCL Equivalent |
|-----------|------------------|
| `fence.acq_rel.sys` | `sycl::atomic_fence(sycl::memory_order::acq_rel, sycl::memory_scope::system)` |
| `fence.acq_rel.gpu` | `sycl::atomic_fence(sycl::memory_order::acq_rel, sycl::memory_scope::device)` |
| `fence.acq_rel.cta` | `sycl::atomic_fence(sycl::memory_order::acq_rel, sycl::memory_scope::work_group)` |
| `fence.sc.sys` | `sycl::atomic_fence(sycl::memory_order::seq_cst, sycl::memory_scope::system)` |

**HIGH RISK**: Verify that `atomic_fence(system)` guarantees visibility to CX6 NIC
for GPU-initiated RDMA. This is the PCIe equivalent of NVLink system fence.

---

### 2. MMIO Writes (NIC Doorbell — IBGDA)

```cuda
// CUDA PTX: non-cacheable store to NIC MMIO space (doorbell ring)
asm volatile("st.volatile.global.u64 [%0], %1;" :: "l"(doorbell_addr), "l"(value));
```

**Intel equivalent** — use atomic_fence + volatile store:
```cpp
// System-scope fence: ensure all prior stores are visible before doorbell
sycl::atomic_fence(sycl::memory_order::seq_cst, sycl::memory_scope::system);

// Volatile store: prevents compiler from caching/reordering the write
*(volatile uint64_t*)doorbell_ptr = value;
```

**Note**: When using ishmem high-level API (confirmed approach), doorbell
operations are handled internally by ishmem — no manual doorbell writes needed.
This section applies only if raw NIC access is required.

---

### 3. Non-Temporal / Streaming Loads and Stores

```cuda
// CUDA PTX: streaming/non-allocating load (L1 bypass)
asm volatile("ld.global.nc.L1::no_allocate.L2::256B.s32 %0, [%1];" : "=r"(val) : "l"(ptr));

// CUDA PTX: non-allocating store
asm volatile("st.global.L1::no_allocate.s32 [%0], %1;" :: "l"(ptr), "r"(val));
```

**Intel tvisa equivalent** — use `lscLoad`/`lscStore` with cache control:
```cpp
// Non-allocating load (L1 uncached, L3 cached):
// Option A: tvisa lscLoad with CacheCtrl
uint32_t val;
lscLoad<32, CacheCtrl::L1UC_L3C>(&val, (void*)ptr);

// Option B: simple volatile load (correctness preserved, cache hint lost):
int val = *(volatile int*)ptr;

// Non-allocating store:
// Option A: tvisa lscStore with CacheCtrl
lscStore<32, CacheCtrl::L1UC_L3WB>((void*)ptr, val);

// Option B: simple volatile store (correctness preserved):
*(volatile int*)ptr = val;
```

**Note**: Dropping the cache hint affects performance only, not correctness.
Prefer tvisa lscLoad/lscStore for hot paths where cache behavior matters.

---

### 4. Atomic Operations with Specific Scopes

> **Platform Capabilities:**
> - `sycl::atomic_ref` IS available for **non-system-scope** atomics (device, work_group, sub_group)
> - For **system-scope** atomics: use `sycl::atomic_fence(system)` + compiler built-ins

```cuda
// CUDA PTX: device-scope atomic
asm volatile("atom.add.u32 %0, [%1], %2;"
             : "=r"(old) : "l"(ptr), "r"(val));

// CUDA PTX: system-scope atomic
asm volatile("atom.sys.add.u32 %0, [%1], %2;"
             : "=r"(old) : "l"(ptr), "r"(val));
```

**Intel equivalent — device/work_group scope (use `sycl::atomic_ref`):**
```cpp
// Device-scope atomic add (replaces atomicAdd):
sycl::atomic_ref<uint32_t,
    sycl::memory_order::relaxed,
    sycl::memory_scope::device,
    sycl::access::address_space::global_space> ref(*ptr);
uint32_t old = ref.fetch_add(val);

// Device-scope atomic CAS (replaces atomicCAS):
sycl::atomic_ref<int,
    sycl::memory_order::acq_rel,
    sycl::memory_scope::device,
    sycl::access::address_space::global_space> ref(*ptr);
int expected = cmp;
ref.compare_exchange_strong(expected, val);
// expected now holds old value
```

**Intel equivalent — system-scope (replaces atomicAdd_system / atomicSub_system):**
```cpp
// System-scope atomic: bracket with atomic_fence(system)
sycl::atomic_fence(sycl::memory_order::seq_cst, sycl::memory_scope::system);
uint32_t old = __atomic_fetch_add(ptr, val, __ATOMIC_SEQ_CST);
sycl::atomic_fence(sycl::memory_order::seq_cst, sycl::memory_scope::system);
```

**Note**: System-scope atomics are needed only for IPC-mapped memory (cross-GPU PCIe).
For all GPU-local atomics, use `sycl::atomic_ref` with `device` scope.

---

### 5. Warp-Level Vote / Ballot (PTX)

```cuda
// PTX: ballot across warp
uint32_t mask;
asm volatile("vote.ballot.b32 %0, %1;" : "=r"(mask) : "r"((int)pred));
```

**Intel sub-group equivalent:**
```cpp
// No direct ballot — use reduce_over_group to approximate
sycl::sub_group sg = item.get_sub_group();
uint32_t mask = sycl::reduce_over_group(sg,
    pred ? (1u << sg.get_local_id()) : 0u,
    sycl::bit_or<uint32_t>());
```

---

### 6. Cache Invalidation / Prefetch

```cuda
// PTX: prefetch to L1
asm volatile("prefetch.global.L1 [%0];" :: "l"(ptr));
```

**Intel tvisa equivalent:**
```cpp
// tvisa lscPrefetch with cache control
lscPrefetch<uint32_t, 16, 32, CacheCtrl::L1C_L3C>((void*)ptr);
```

---

### 7. Named Barriers (CUDA barrier.sync N)

```cuda
// CUDA PTX: named barrier — synchronize a subset of threads in a CTA
asm volatile("barrier.sync 0, %0;" :: "r"(count * 32));
// barrier 0, waiting for `count` warps (count*32 threads)

asm volatile("barrier.sync 1, %0;" :: "r"(count * 32));
// barrier 1, different subset of warps
```

**Intel tvisa equivalent — named barriers (nbarrier):**

tvisa provides named barriers via `gateway.hpp`:
```cpp
#include "gen_visa_templates.hpp"  // includes gateway.hpp

// Initialize N named barriers at kernel start (once per work-group)
named_barrier_init<N>();  // N = number of distinct barriers needed

// Signal barrier — each participating sub_group calls this
nbarrier_signal(barrier_id, n_sub_groups);
// barrier_id: 0..N-1
// n_sub_groups: number of sub_groups participating in this barrier

// Wait on barrier — blocks until all participants have signaled
nbarrier_wait(barrier_id);
```

**Advanced: ProducerConsumer mode:**
```cpp
// For producer-consumer patterns (e.g., RDMA sender warps vs coordinator warp)
BarrierPayload barrier(
    barrier_id,
    BarrierType::ProducerConsumer,
    n_producers,   // number of producer sub_groups
    n_consumers    // number of consumer sub_groups
);
nbarrier_signal(barrier);
nbarrier_wait(barrier_id);
```

**DeepEP-specific mappings:**
| CUDA Pattern | tvisa Equivalent |
|---|---|
| `barrier.sync 0, (kNumDispatchRDMASenderWarps+1)*32` | `nbarrier_signal(0, kNumDispatchRDMASenderWarps+1); nbarrier_wait(0);` |
| `barrier.sync 1, (NUM_MAX_NVL_PEERS+1)*32` | `nbarrier_signal(1, NUM_MAX_NVL_PEERS+1); nbarrier_wait(1);` |
| `__syncthreads()` | `sycl::group_barrier(item.get_group())` or `barrier()` (tvisa full barrier) |

**Note**: tvisa `nbarrier_signal` takes the number of **sub_groups** (not threads),
while CUDA `barrier.sync` takes the number of **threads**. Convert: `n_sub_groups = n_threads / 32`.

---

## Analysis Procedure for ASM-Heavy Files

When a CUDA kernel file contains significant inline assembly:

### Step 1 — Inventory All ASM Blocks

For every `asm volatile(...)` block, record:

| Location | PTX Instruction | Operation Type | Purpose | Intel Equivalent Known? |
|---|---|---|---|---|
| line N | `st.volatile.global.u64` | MMIO write (doorbell) | Ring NIC doorbell | volatile ptr + tvisa lsc_store |
| line N | `fence.sc.sys` | System fence | Order data before doorbell | atomic_fence(system) |
| line N | `ld.cs.global.f32` | Streaming load | Read token data | plain load / tvisa lsc_load streaming |

### Step 2 — Classify Each ASM Block

| Class | Description | Risk | Intel Approach |
|---|---|---|---|
| **Performance hint only** | Prefetch, cache hint — correctness unaffected if dropped | LOW | tvisa lscLoad/lscStore with CacheCtrl |
| **Memory ordering** | Fence, membar — correctness depends on exact scope semantics | HIGH RISK | `sycl::atomic_fence` with matching scope |
| **MMIO access** | Doorbell ring, NIC register write — must preserve non-cacheability | HIGH RISK | ishmem handles internally (no manual MMIO) |
| **Named barrier** | Subset warp synchronization within CTA | MEDIUM | tvisa nbarrier_signal/nbarrier_wait |
| **Scoped atomic (non-system)** | atomicAdd/CAS with device or work_group scope | LOW | `sycl::atomic_ref` with matching scope |
| **System-scope atomic** | atomicAdd_system / atomicSub_system on IPC memory | HIGH RISK | `atomic_fence(system)` + `__atomic_*` built-in |
| **No SYCL equivalent** | Requires tvisa inline assembly pattern | MEDIUM/HARD | Search tvisa include/ |

### Step 3 — Search tvisa

Fetch https://github.com/CaoZhongZ/tvisa and search for:
- The PTX instruction name (e.g., `lsc_store`, `doorbell`, `fence`)
- The use case (e.g., "ib rdma", "nic", "notify")

tvisa contains real-world Intel GPU assembly patterns for communication use cases
that are directly applicable to DeepEP's IBGDA-equivalent internode path.

### Step 4 — Flag Unresolved ASM

Any PTX block without a confirmed Intel equivalent must be flagged:
```cpp
// HIGH_RISK: PTX 'st.volatile.global.u64' (NIC MMIO write) has no verified SYCL equivalent
// See docs/porting/04_memory_verification.md
// Candidate: volatile pointer write + atomic_fence(system) — NEEDS HARDWARE VERIFICATION
// Preferred: tvisa lsc_store<uncached> inline assembly — see https://github.com/CaoZhongZ/tvisa
```

---

## tvisa Inline Assembly vs SYCL High-Level

Use **tvisa inline assembly** when:
- High-level SYCL atomics/fences do not provide the required cache hint
- Need non-temporal (uncached) stores to MMIO regions (e.g., NIC doorbell)
- Need LSC operations with explicit cache control (streaming, uncached)
- The PTX instruction has no SYCL API equivalent

Use **SYCL high-level** when:
- Standard atomics with `memory_order`/`memory_scope` are sufficient
- `group_barrier` / sub-group operations cover the pattern
- No explicit cache hint is required for correctness
- `sycl::ext::oneapi::experimental::prefetch` covers the prefetch need

---

## Resources

| Resource | URL | Use For |
|---|---|---|
| tvisa (Intel GPU ASM patterns) | https://github.com/CaoZhongZ/tvisa | Real-world Intel GPU comm patterns |
| Intel oneAPI LSC docs | search "lsc_load lsc_store intel oneapi" | Cache-controlled memory ops |
| GEN ISA Reference | Intel developer docs | Low-level instruction reference |
