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
4. Profile: is the bottleneck PCIe bandwidth or kernel overhead?

**PCIe Gen 5 x16 theoretical**: ~128 GB/s bidirectional
**Realistic achievable**: 60-80 GB/s (DMA), 40-60 GB/s (kernel-driven)

### Priority 2: Internode Latency (ishmem / MLX NIC)

The internode path is NIC-latency-limited for small MoE expert inputs.
Optimization strategy:
1. For small messages: minimize number of NIC operations (coalesce if possible)
2. For large messages: maximize message size to approach NIC bandwidth
3. Overlap: use `ishmem_*_nbi` and do local work while transfer is in flight
4. Avoid unnecessary `ishmem_barrier_all()` — use `ishmem_quiet()` where possible

**MLX InfiniBand HDR100**: ~100 Gb/s bandwidth, ~2 µs latency (estimated)

### Priority 3: Compute Efficiency

For the actual MoE token dispatch computation:
1. Ensure work-groups are large enough to hide memory latency (≥ 128 work-items)
2. Avoid SLM bank conflicts (32-bit banks on Intel, 16 banks per Xe2-core)
3. Use `[[intel::reqd_sub_group_size(16)]]` to prevent unexpected SIMD fragmentation

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

```cpp
// Preferred: 16-wide float operations (matches SIMD16 sub-group)
sycl::vec<float, 16> data;

// Also good: 4-wide float (cache-line-aligned load)
sycl::vec<float, 4> chunk;

// Avoid: scalar loads in loops (prevents auto-vectorization)
for (int i = 0; i < N; i++)
    local_data[i] = ptr[base + i];  // ← hard to vectorize
```

## Profiling Guide for DeepEP on B60/B70

### Step 1: Identify Bottleneck Type

```bash
# Quick pass: is it compute or memory bound?
vtune -collect gpu-hotspots -knob enable-characterization-insights=true \
      -- ./deepep_bench --mode intranode

# Check "GPU Compute/Memory Bound" metrics in VTune GUI
```

### Step 2: Memory Access Analysis

```bash
# Check global memory access efficiency (coalescing)
vtune -collect gpu-hotspots \
      -knob collect-memory-bandwidth=true \
      -- ./deepep_bench --mode intranode
```

### Step 3: Communication Profiling

```bash
# Profile ishmem communication overhead
unitrace --level-zero --device-timing --host-timing \
         --output-dir ./traces \
         -- mpirun -np 2 ./deepep_bench --mode internode

# Check: how much time is in ishmem_quiet() vs actual data transfer?
```

### Step 4: SLM and Register Analysis

```bash
# Intel Advisor: memory footprint and register pressure
advisor --collect=survey --static-instruction-mix \
        --project-dir=./advisor_out \
        -- ./deepep_bench
```

## Performance Target Template

Fill in after hardware testing:

| Metric | Target | Measured | Δ vs Target | Notes |
|---|---|---|---|---|
| Intranode BW (B60 pair) | >60 GB/s | TBD | — | PCIe Gen5 x16 |
| Internode latency (4 KB) | <5 µs | TBD | — | MLX HDR100 |
| Internode BW (1 MB) | >10 GB/s | TBD | — | MLX HDR100 |
| E2E MoE dispatch (256 tokens, 8 experts) | <50 µs | TBD | — | Single node |
| E2E MoE dispatch (256 tokens, 8 experts) | <100 µs | TBD | — | 2-node |

> All targets are initial estimates and must be validated on actual B60/B70 hardware.
> Final targets should be set in consultation with the engineering team.
