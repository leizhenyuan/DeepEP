---
description: "Start the DeepEP Intel GPU porting workflow. Orchestrates all 6 phases sequentially: topology analysis, kernel analysis, SYCL code generation, memory model verification, performance tuning, and final report generation. Use when beginning a full porting run or resuming from a specific phase."
argument-hint: "Optional phase number to start from: 1=topology, 2=kernels, 3=codegen, 4=memory, 5=perf, 6=report"
---

# DeepEP Intel B60/B70 Porting Workflow

You are the orchestrator for porting DeepEP from NVIDIA GPU (CUDA/NVSHMEM) to Intel B60/B70 (Battlemage/BMG) GPU using SYCL + Level Zero + ishmem.

Execute the phases listed below **in order**. Each phase produces output files that the next phase reads.
If `$ARGUMENT` is provided as a phase number, skip directly to that phase.

## Pre-Flight Check

Before starting, verify:
1. `csrc/` directory exists with original CUDA source
2. `docs/porting/` directory will be created if absent
3. `csrc_sycl/` directory will be created if absent

## Phase Execution

### Phase 1 — Topology Analysis & Terminology Mapping
**Agent**: `deepep-topology-analyst`

This agent uses sub-agents to:
- Analyze how DeepEP uses NVIDIA topology (NVLink, NVSHMEM, IBGDA, CUDA IPC)
- Research Intel B60/B70 (Battlemage) hardware topology and ishmem capabilities
- Build a complete NVIDIA → Intel terminology and API mapping

**Expected outputs**:
- `docs/porting/01_topology_analysis.md`
- `docs/porting/02_terminology_map.md`

**Checkpoint**: After Phase 1 completes, present any HIGH RISK findings to the user before continuing.

---

### Phase 2 — CUDA Kernel Deep-Dive Analysis
**Agent**: `deepep-kernel-analyst`

This agent dispatches the `cuda-kernel-reader` sub-agent for each kernel file:
- `csrc/kernels/runtime.cu`
- `csrc/kernels/layout.cu`
- `csrc/kernels/intranode.cu`
- `csrc/kernels/internode.cu`
- `csrc/kernels/internode_ll.cu`
- `csrc/kernels/ibgda_device.cuh`
- Supporting headers: `api.cuh`, `configs.cuh`, `utils.cuh`

**Expected output**:
- `docs/porting/03_kernel_analysis.md`

**Checkpoint**: After Phase 2 completes, present HIGH RISK items to the user before continuing.

---

### Phase 3 — SYCL Code Generation
**Agent**: `sycl-code-generator`

This agent reads Phase 1 and Phase 2 outputs, then generates:
- Complete SYCL + Level Zero + ishmem implementation in `csrc_sycl/`
- Uses `ishmem-migration-guide` and `asm-translation-guide` skills

**Expected outputs**:
- `csrc_sycl/` (complete SYCL codebase)
- `docs/porting/03b_generation_notes.md` (decisions and open questions)

**Checkpoint**: After Phase 3, pause and let the user review HIGH_RISK annotations in generated code.

---

### Phase 4 — Memory Model Verification
**Agent**: `memory-model-verifier`

This agent audits all generated SYCL/ishmem code for memory ordering and coherence correctness.

> **CRITICAL**: Any unresolved memory ordering issue is a BLOCKER. The agent MUST stop and
> report to the user rather than guessing at a fix.

**Expected outputs**:
- `docs/porting/04_memory_verification.md`
- Corrected code in `csrc_sycl/` (with `// MEMORY_MODEL_FIX:` annotations)

**Checkpoint**: Present ALL memory model issues to user, regardless of risk level.

---

### Phase 5 — Performance Tuning
**Agent**: `bmg-performance-tuner`

This agent optimizes the verified SYCL code for Intel B60/B70 (BMG) hardware.

> **NOTE**: Performance tuning parameters (work-group size, SLM layout, etc.) need validation
> on actual hardware. The agent will document requirements and leave final numbers for human validation.

**Expected outputs**:
- `docs/porting/05_performance_report.md`
- Optimized code in `csrc_sycl/` (with `// PERF_OPT:` annotations)

---

### Phase 6 — Final Porting Report
**Agent**: `porting-report-generator`

This agent aggregates all analysis documents and code annotations into the final report.

**Expected output**:
- `docs/porting/PORTING_REPORT.md`

---

## Important Rules

1. **Never skip a phase** — each phase feeds the next.
2. **HIGH RISK items always surface to the user** — agents must not silently proceed.
3. **Memory ordering issues are blockers** — Phase 4 must complete before Phase 5.
4. **All generated code must include** `// PORTED_FROM:` header comments.
5. **Context is passed via files** — agents write to `docs/porting/` and read from there.
