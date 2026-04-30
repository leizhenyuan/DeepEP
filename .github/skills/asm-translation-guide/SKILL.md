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

### 1. Memory Fence / Ordering

```cuda
// CUDA PTX: system-scope fence (visible to NIC via PCIe)
asm volatile("fence.sc.sys;" ::: "memory");
// or
asm volatile("membar.sys;" ::: "memory");
```

**Intel SYCL equivalent:**
```cpp
sycl::atomic_fence(sycl::memory_order::seq_cst,
                   sycl::memory_scope::system);
```

**HIGH RISK**: `fence.sc.sys` in PTX guarantees visibility to all system agents including NIC.
Whether `memory_scope::system` on BMG provides the same guarantee for CX6 DMA must be verified.

Check tvisa for: `lsc_fence`, `lsc_store`, memory scope patterns.

---

### 2. MMIO Writes (NIC Doorbell — IBGDA)

```cuda
// CUDA PTX: non-cacheable store to NIC MMIO space (doorbell ring)
asm volatile("st.volatile.global.u64 [%0], %1;" :: "l"(doorbell_addr), "l"(value));
// or via inline PTX with .cs (cache streaming) / .wt (write-through) qualifiers
asm volatile("st.cs.global.u64 [%0], %1;" :: "l"(addr), "l"(val));
```

**Intel equivalent** — use a `volatile` pointer write to prevent compiler reordering,
preceded by a system-scope fence to ensure GPU store visibility to the NIC:
```cpp
// System-scope fence: ensure all prior stores are visible before doorbell
sycl::atomic_fence(sycl::memory_order::seq_cst,
                   sycl::memory_scope::system); // HIGH_RISK: verify CX6 visibility on BMG

// Volatile store: prevents compiler from caching/reordering the write
*(volatile uint64_t*)doorbell_ptr = value;
```

**Note**: `volatile` prevents *compiler* reordering but does NOT guarantee hardware
cache bypass on Intel GPU. For confirmed uncached semantics, use tvisa inline assembly:
```cpp
// Preferred: tvisa lsc_store pattern (no-cache, guaranteed MMIO-safe)
// See https://github.com/CaoZhongZ/tvisa for the verified lsc_store<uncached> pattern
```

**Check tvisa for**: doorbell write patterns, MMIO access patterns, `lsc_store` with
uncached or streaming semantics.

---

### 3. Non-Temporal / Streaming Loads and Stores

```cuda
// CUDA PTX: streaming load (L1 bypass, data not expected to be reused)
asm volatile("ld.cs.global.f32 %0, [%1];" : "=f"(val) : "l"(ptr));

// CUDA PTX: non-temporal store (evict-first / streaming)
asm volatile("st.cs.global.f32 [%0], %1;" :: "l"(ptr), "f"(val));
```

**Intel equivalent** — SYCL has no portable streaming cache hint at the high-level API.
Use plain loads/stores (correctness preserved, cache hint lost) or tvisa inline assembly:
```cpp
// Plain fallback — no cache hint, functionally correct:
float val = *ptr;          // streaming load fallback
*ptr = val;                // non-temporal store fallback

// Preferred: tvisa lsc_load / lsc_store with streaming hint (inline assembly)
// See https://github.com/CaoZhongZ/tvisa for verified streaming patterns
```

**Note**: Dropping the cache hint affects performance only, not correctness.

---

### 4. Atomic Operations with Specific Scopes

```cuda
// CUDA PTX: system-scope atomic (visible to CPU and NIC)
asm volatile("atom.sys.add.u32 %0, [%1], %2;"
             : "=r"(old) : "l"(ptr), "r"(val));
```

**Intel SYCL equivalent:**
```cpp
sycl::atomic_ref<uint32_t,
    sycl::memory_order::relaxed,
    sycl::memory_scope::system,          // system scope — covers CPU and NIC
    sycl::access::address_space::global_space> ref(*ptr);
uint32_t old = ref.fetch_add(val);
```

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

**Intel equivalent** — use SYCL built-in prefetch (no cache-level control):
```cpp
// SYCL prefetch (hints to hardware, cache level not specified)
sycl::ext::oneapi::experimental::prefetch(ptr, sizeof(float) * 16);
```

For L1-targeted prefetch, use tvisa inline assembly:
```cpp
// See https://github.com/CaoZhongZ/tvisa for lsc_prefetch with L1 cache hint
```

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

| Class | Description | Risk |
|---|---|---|
| **Performance hint only** | Prefetch, cache hint — correctness unaffected if dropped | LOW |
| **Memory ordering** | Fence, membar — correctness depends on exact scope semantics | HIGH RISK |
| **MMIO access** | Doorbell ring, NIC register write — must preserve non-cacheability | HIGH RISK |
| **No SYCL equivalent** | Requires tvisa inline assembly pattern | MEDIUM/HARD |

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
