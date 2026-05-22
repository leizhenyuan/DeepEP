---
description: "Start the DeepEP Intel GPU porting workflow (internode path only). Orchestrates 4 phases: topology analysis, kernel deep-dive, per-kernel SYCL generation with inline memory verification, and final report. Use when beginning a full run or resuming from a specific phase."
argument-hint: "Optional phase to start from: 1=topology, 2=kernels, 3a=infra, 3b=kernel, 4=report"
---

# DeepEP Intel B60/B70 Porting Workflow

You are the orchestrator for porting DeepEP internode kernels from NVIDIA GPU (CUDA/NVSHMEM)
to Intel B60/B70 (Battlemage/BMG) using SYCL + ishmem.

**Scope**: internode path only — `internode.cu`, `internode_ll.cu`, `ibgda_device.cuh`.
Intranode (`intranode.cu`) is out of scope.

Execute phases in order. Each phase produces files the next phase reads.
Skip to `$ARGUMENT` phase if provided.

## Pre-Flight Check

1. `csrc/` exists with original CUDA source
2. `docs/porting/` will be created if absent
3. `csrc_sycl/` will be created if absent

---

## Phase 1 — Internode Topology Analysis
**Agent**: `deepep-topology-analyst`

- Analyzes NVSHMEM/IBGDA patterns in DeepEP internode code
- Researches Intel B60/B70 ishmem + CX6 capabilities
  - Fetches https://github.com/oneapi-src/ishmem for API semantics
  - Fetches https://github.com/intel-sandbox/ishmem_ibgda for GPU-direct NIC posting (IBGDA equivalent)
  - Searches PCIe relaxed ordering + Intel GPU coherence behavior
- Documents gaps between NVIDIA and Intel internode paths
- **ANY uncertainty about PCIe behavior, ishmem semantics, or IBGDA equivalence → STOP and report to user before continuing**

**Output**: `docs/porting/01_topology_analysis.md`

**Checkpoint**: Present HIGH RISK findings before continuing.

---

## Phase 2 — Kernel Deep-Dive (4 kernels)
**Agent**: `deepep-kernel-analyst`

Analyzes the 4 target kernels via `cuda-kernel-reader` sub-agent:
- dispatch + combine in `internode.cu`
- dispatch + combine in `internode_ll.cu`

**Outputs**: `docs/porting/kernels/internode_dispatch.md`, `internode_combine.md`,
`internode_ll_dispatch.md`, `internode_ll_combine.md`

**Checkpoint**: Present HIGH RISK items before continuing.

---

## Phase 3a — Shared Infrastructure (once)
**Agent**: `sycl-infra-generator`

Generates shared layer: configs, utils, buffer, runtime, CMakeLists, setup.py.

**Outputs**: `csrc_sycl/configs.hpp`, `utils.hpp`, `buffer.hpp`, `runtime.cpp`, `CMakeLists.txt`

**Checkpoint**: Review HIGH_RISK annotations before Phase 3b.

---

## Phase 3b — Per-Kernel Generation (repeat ×4)
**Agent**: `sycl-kernel-generator`

Invoke once per kernel. Each invocation generates SYCL code + Python test + inline
memory model verification. **Human checkpoint after each kernel.**

| Order | Argument | Output |
|-------|----------|--------|
| 1 | `internode_dispatch` | `csrc_sycl/internode_dispatch.cpp` + `tests/test_internode_dispatch_sycl.py` |
| 2 | `internode_combine` | `csrc_sycl/internode_combine.cpp` + `tests/test_internode_combine_sycl.py` |
| 3 | `internode_ll_dispatch` | `csrc_sycl/internode_ll_dispatch.cpp` + `tests/test_internode_ll_dispatch_sycl.py` |
| 4 | `internode_ll_combine` | `csrc_sycl/internode_ll_combine.cpp` + `tests/test_internode_ll_combine_sycl.py` |

> After each kernel: review HIGH_RISK output summary → confirm → invoke next.

---

## Phase 4 — Final Report
**Agent**: `porting-report-generator`

**Output**: `docs/porting/PORTING_REPORT.md`

---

## Rules

1. HIGH RISK items always surface to the user — never silently proceed.
2. Memory ordering issues found in Phase 3b are blockers — fix before next kernel.
3. All generated SYCL code must have `// PORTED_FROM:` headers.
4. Context passes via files in `docs/porting/` and `csrc_sycl/`.
