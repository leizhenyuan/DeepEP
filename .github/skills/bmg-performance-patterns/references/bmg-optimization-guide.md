# Intel B60/B70 (Battlemage/BMG) Optimization Reference

## Hardware Architecture Summary

Intel B60/B70 (Arc Battlemage) is based on the Xe2 (BMG) microarchitecture.
Key differences from the previous Xe (Alchemist/DG2) generation:
- Xe2 cores replace Xe cores (higher IPC, improved vector engine)
- Vector Engine: 512-bit (8x 64-bit or 16x 32-bit or 32x 16-bit)
- Sub-group (SIMD) width: More inclined towards simd32
- L1 cache: shared with SLM (software-partitioned)

> All values marked VERIFY — confirm against Intel Arc B-series official documentation.

## Performance Tuning Priorities for MoE All-to-All

### Priority 1: Intranode Bandwidth (Level Zero IPC / PCIe)

The intranode path is PCIe-limited. Optimization strategy:
1. Maximize transfer granularity — avoid many small transfers
2. Use 128-byte (2 cache line) aligned transfers where possible
3. Write directly from GPU global memory to IPC peer memory — no SLM staging needed
4. **Verify PCIe Max Payload Size (MPS)**: insufficient MPS causes PCIe TLP fragmentation and severe bandwidth degradation. Check and align MPS across the PCIe switch, GPU, and NIC:
   ```bash
   # Check current MPS for all PCIe devices
   sudo lspci -vvv | grep -i "maxpayload\|MaxPayload"
   # Or per-device:
   sudo setpci -s <BDF> CAP_EXP+8.w
   ```
   All devices under the same PCIe switch should use the same MPS (typically 256 B or 512 B).
5. **Consider Level Zero DMA copy** (`zeCommandListAppendMemoryCopy`) instead of kernel-driven copy for large bulk transfers — DMA engines operate independently of EU occupancy and can achieve higher effective PCIe bandwidth:
   ```cpp
   // Level Zero DMA copy (host-initiated, async)
   zeCommandListAppendMemoryCopy(cmdList, dst, src, size,
                                  nullptr, 0, nullptr);
   zeCommandListClose(cmdList);
   zeCommandQueueExecuteCommandLists(queue, 1, &cmdList, fence);
   ```
6. Profile: is the bottleneck PCIe bandwidth, MPS fragmentation, or kernel launch overhead?

**PCIe Gen 5 x16 theoretical**: ~128 GB/s bidirectional
**Realistic achievable**: 60-80 GB/s (DMA), 40-60 GB/s (kernel-driven)

### Priority 2: Internode Latency (ishmem / MLX NIC)

The internode path is NIC-latency-limited for small MoE expert inputs.
Optimization strategy:
1. For small messages: minimize number of NIC operations (coalesce if possible)
2. For large messages: maximize message size to approach NIC bandwidth
3. Overlap: use `ishmem_*_nbi` and do local work while transfer is in flight
4. Avoid unnecessary `ishmem_barrier_all()` — use `ishmem_quiet()` where possible

**MLX NIC specs — run on target node to get actual values:**
```bash
# NIC model and PCIe slot info
lspci | grep -i mellanox

# Link speed and width (replace 'mlx5_0' with actual device name)
ibstat mlx5_0 | grep -E "CA type|State|Physical state|Rate|Link layer"

# Active port rate (in Gb/s)
cat /sys/class/infiniband/mlx5_0/ports/1/rate
```

### Priority 3: Memory Access Efficiency

DeepEP kernels are memory-bound (scatter/gather, IPC copy, layout rearrangement) — there is
no significant compute. Optimization strategy focuses on maximizing memory throughput:
1. Use large enough work-groups to issue enough in-flight memory requests (≥ 128 work-items)
2. Ensure coalesced global memory access — sequential work-item lanes should access sequential addresses
3. Use vectorized load/store for all copy paths — prefer `sycl::vec<uint32_t, 4>` (128-bit) or `sycl::vec<uint32_t, 8>` (256-bit) per work-item to saturate PCIe/HBM bandwidth
4. Avoid SLM bank conflicts if SLM is used for index/offset staging
5. Use `[[intel::reqd_sub_group_size(32)]]` to prevent SIMD fragmentation and maintain coalescing

## Work-Group Size Recommendation Matrix

| Kernel Type | Recommended WG Size | Sub-Group Size | Notes |
|---|---|---|---|
| Token scatter (intranode, PCIe) | 128 | 16 | PCIe BW bound, not compute bound |
| Token gather (intranode, IPC read) | 128 | 16 | Same as scatter |
| ishmem PUT dispatch | 64-128 | 16 | NIC latency bound |
| Expert computation (compute-heavy) | 256-512 | 16 or 32 | Compute throughput optimized |
| Memory layout rearrangement | 256 | 16 | Memory bandwidth bound |

## SLM Bank Conflict Analysis

Intel GPU SLM banks:
- 32 banks, 4 bytes each
- Bank number for address `A`: `(A / 4) % 32`

**Conflict-free patterns**:
```cpp
// Each sub-group lane accesses different bank
// Lane i reads: smem[i * sizeof(float)]  → bank (i % 32) ← OK if SG size ≤ 32
```

**Conflict-causing patterns**:
```cpp
// All lanes access same bank (stride = 32 * sizeof(float))
// Lane i reads: smem[i * 32 * sizeof(float)] → all land on bank 0 ← BAD
```

**Fix**: Pad SLM arrays to break stride alignment:
```cpp
// Add 1 element padding to avoid bank conflicts with 32-bank SLM
constexpr int SLM_ROW = 32 + 1;  // 33 instead of 32 floats per row
```

## Vectorization Hints for BMG

BMG's 512-bit vector engine works best with 16x FP32 or 8x FP64 operations.

For DeepEP copy kernels (intranode IPC copy, layout rearrangement), always use vectorized
load/store to maximize memory bus utilization:

```cpp
// Preferred copy pattern: 128-bit (4x uint32) per work-item
using vec4u32 = sycl::vec<uint32_t, 4>;
vec4u32 chunk = *reinterpret_cast<const vec4u32*>(src + i);
*reinterpret_cast<vec4u32*>(dst + i) = chunk;

// Even better if alignment allows: 256-bit (8x uint32) per work-item
using vec8u32 = sycl::vec<uint32_t, 8>;
```

```cpp
// Avoid: scalar word-by-word copy — leaves vector engine idle
for (int i = 0; i < N; i++)
    dst[i] = src[i];  // ← scalar, not vectorized
```


## Performance Target Template

Fill in after hardware testing:

| Metric | Target | Measured | Δ vs Target | Notes |
|---|---|---|---|---|
| Intranode BW (B60 pair) | >60 GB/s | TBD | — | PCIe Gen5 x16 |
| Internode latency (4 KB) | TBD | TBD | — | run ibstat on target node |
| Internode BW (1 MB) | TBD | TBD | — | run ibstat on target node |
| E2E MoE dispatch (256 tokens, 8 experts) | <50 µs | TBD | — | Single node |
| E2E MoE dispatch (256 tokens, 8 experts) | <100 µs | TBD | — | 2-node |

> All targets are initial estimates and must be validated on actual B60/B70 hardware.
> Final targets should be set in consultation with the engineering team.
