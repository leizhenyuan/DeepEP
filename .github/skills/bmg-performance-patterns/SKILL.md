---
name: bmg-performance-patterns
description: "Performance optimization patterns for Intel B60/B70 Battlemage (BMG) GPU. Use when tuning SYCL kernel work-group sizes, optimizing SLM (shared local memory) usage, improving PCIe bandwidth for Level Zero IPC intranode communication, tuning ishmem latency for internode, or generating Intel GPU profiling commands using VTune or unitrace."
---

# Intel B60/B70 (BMG) Performance Patterns

## When to Use

- Selecting optimal work-group and sub-group sizes for BMG kernels
- Optimizing SLM (shared local memory) usage and layout
- Improving intranode PCIe bandwidth via Level Zero IPC
- Tuning ishmem internode communication performance
- Identifying memory access coalescing issues
- Generating VTune / unitrace profiling commands for B60/B70 hardware

## BMG Architecture Key Parameters

Verify these before tuning — some are estimates:

| Parameter | Expected | Must Verify Before Use |
|---|---|---|
| Sub-group SIMD width | 16 (SIMD16) default | Check for compute kernel characteristics |
| SLM per Xe-core | 64 KB | Confirm with `device.get_info<info::device::local_mem_size>()` |
| L1 cache line | 64 bytes | Affects coalescing pattern design |
| PCIe bandwidth (B60, x16 Gen5) | ~128 GB/s theoretical | Benchmark with microbenchmark |
| Max work-group size | 1024 | Query `device.get_info<info::device::max_work_group_size>()` |
| L3 cache per tile | Varies | Check Intel Arc B-series specs |

## Optimization Patterns

### 1. Work-Group Size Selection

For communication-bound kernels (intranode/internode):
```cpp
// Prefer smaller work-groups for lower dispatch latency
constexpr int WG_SIZE_COMM = 128;  // experiment: 64, 128, 256

// For compute-heavy kernels: maximize occupancy
constexpr int WG_SIZE_COMPUTE = 256;  // typical sweet spot

// Query at runtime for portability
size_t max_wg = device.get_info<sycl::info::device::max_work_group_size>();
```

### 2. Sub-Group Size Hint

Force SIMD width explicitly to avoid auto-vectorization surprises:
```cpp
// SIMD16 (default on BMG, lower overhead)
h.parallel_for<class MyKernel>(
    sycl::nd_range<1>{global, local},
    [=](sycl::nd_item<1> item) [[intel::reqd_sub_group_size(16)]] {
        // kernel body
    }
);

// SIMD32 (higher throughput, more register pressure)
// [[intel::reqd_sub_group_size(32)]]
```

### 3. SLM Usage Optimization

```cpp
// Align SLM to sub-group width for bank-conflict-free access
constexpr int SLM_BANK_WIDTH = 4;  // 4-byte banks on Intel
constexpr int SLM_PADDING = BMG_SUBGROUP_SIZE;  // pad rows to avoid bank conflicts

// Good: sub-group reads one element per lane with no conflict
// Each lane reads: smem[sg_id * SLM_PADDING + lane_id]

// Bad: all lanes read same bank
// Each lane reads: smem[lane_id * stride] if stride causes bank collision
```

**SLM sizing**: Keep total SLM per work-group ≤ `64KB / (target concurrent WGs per Xe-core)`.
To run 2 work-groups concurrently: max 32 KB SLM per WG.

### 4. Memory Coalescing for PCIe

For intranode data transfers via Level Zero IPC:
```cpp
// GOOD: coalesced — all work-items access consecutive addresses
// Work-item i reads: ptr[group_offset + local_id]

// BAD: strided — each work-item reads with stride
// Work-item i reads: ptr[local_id * STRIDE]  ← cache line underutilization

// For gather patterns: staging through SLM can improve coalescing
// 1. Coalesced read from global → SLM
// 2. Permute in SLM
// 3. Coalesced write from SLM → global
```

### 5. Vectorized Loads

When loading aligned, consecutive data:
```cpp
// Use SYCL vec for vectorized loads — 128-bit (4x uint32) per work-item
using vec4u32 = sycl::vec<uint32_t, 4>;
vec4u32 chunk = *reinterpret_cast<const vec4u32*>(src + base_offset);
*reinterpret_cast<vec4u32*>(dst + base_offset) = chunk;

// 256-bit (8x uint32) when 32-byte alignment is guaranteed
using vec8u32 = sycl::vec<uint32_t, 8>;
vec8u32 wide = *reinterpret_cast<const vec8u32*>(src + base_offset);
```

All copy paths (IPC peer copy, layout rearrangement, token scatter/gather) must use
vectorized load/store — scalar element-by-element copy leaves PCIe bandwidth unused.

### 6. ishmem Performance Tuning

**Message size strategy**:
- Small messages (< 4 KB): latency-bound → minimize synchronization overhead
- Large messages (> 64 KB): bandwidth-bound → maximize PUT/GET size per operation
- Avoid many small individual puts; batch into one large `ishmem_putmem` if possible

**Non-blocking with overlap**:
```cpp
// Initiate all puts first, then do local compute, then quiet
for (int pe = 0; pe < n_pes; pe++) {
    if (send_count[pe] > 0)
        ishmem_putmem_nbi(remote[my_pe], local_buf[pe], send_bytes[pe], pe);
}
// Do any local work here while communication is in flight
do_local_computation();
ishmem_quiet();  // now wait for all puts to complete
```

**Avoid quiet after each put**:
```cpp
// BAD: quiet after every put → serializes all communication
for (int pe = 0; pe < n_pes; pe++) {
    ishmem_putmem_nbi(..., pe);
    ishmem_quiet();  // ← kills overlap opportunity
}

// GOOD: single quiet after all puts
for (int pe = 0; pe < n_pes; pe++)
    ishmem_putmem_nbi(..., pe);
ishmem_quiet();
```

### 7. Queue Submission Overhead

Minimize kernel launches in the critical path:
```cpp
// Use event dependencies to chain kernels without CPU synchronization
auto e1 = queue.submit([&](sycl::handler& h) { /* kernel 1 */ });
auto e2 = queue.submit([&](sycl::handler& h) {
    h.depends_on(e1);  // GPU-side dependency, no CPU stall
    /* kernel 2 */
});
// CPU continues without waiting for GPU
queue.wait();  // wait only when result needed
```

## Intel GPU Profiling Commands

```bash
# Intel VTune — GPU hotspot analysis
vtune -collect gpu-hotspots \
      -knob enable-characterization-insights=true \
      -knob sampling-interval=1 \
      -- ./build/deepep_test

# Intel VTune — GPU compute/transfer overlap
vtune -collect gpu-offload -- ./build/deepep_test

# Intel unitrace — Level Zero / OpenCL kernel trace
unitrace --level-zero --device-timing --host-timing -- ./build/deepep_test

# Intel Advisor — memory access pattern analysis
advisor --collect=survey --project-dir=./advisor_results -- ./build/deepep_test
advisor --collect=tripcounts --flop --project-dir=./advisor_results -- ./build/deepep_test
```

## Output Report Requirement

After completing any optimization pass, always output a summary report to the user.
The report must cover every change made in that pass:

```
### BMG Optimization Update — <date or pass name>

| # | Area | Change | Rationale |
|---|------|--------|-----------|
| 1 | Intranode copy | Switched to vec8u32 load/store | Saturate PCIe bandwidth |
| 2 | Work-group size | Increased from 64 to 128 | More in-flight memory requests |
| ... | ... | ... | ... |

Open questions / items needing hardware validation:
- [ ] Measured MPS on target node?
- [ ] DMA vs kernel copy bandwidth comparison done?
```

Do not skip the report even for single-item changes.

## See Also

For detailed optimization guide, see [BMG Optimization Reference](./references/bmg-optimization-guide.md).
