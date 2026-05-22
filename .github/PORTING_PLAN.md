# DeepEP Intel B60/B70 Porting Workflow Plan

## Project Overview

Complete port of DeepEP (MoE All-to-All communication operator library) from NVIDIA GPU (CUDA/NVSHMEM)
to Intel B60/B70 (Battlemage/BMG) GPU using the SYCL + Level Zero + ishmem stack.
No CUDA code is retained in the final implementation.

## Target Platform and Scope

| Component | NVIDIA (Original) | Intel (Target) |
|-----------|------------------|----------------|
| GPU | H100/A100 | Intel B60/B70 (Battlemage) |
| Internode comm | NVSHMEM + IBGDA + MLX NIC | ishmem + MLX CX6 NIC (GPU-initiated) |
| Programming model | CUDA | SYCL + ishmem + tvisa (asm) |
| Code strategy | — | Per-kernel SYCL rewrite with inline memory verification |

**V1 scope**: **internode path only** — intranode (`intranode.cu`, Level Zero IPC) is out of scope.

**Target kernels** (4 total):
1. `internode.cu` → dispatch kernel
2. `internode.cu` → combine kernel
3. `internode_ll.cu` → dispatch kernel (low-latency)
4. `internode_ll.cu` → combine kernel (low-latency)

---

## Workflow Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│           DeepEP Intel Porting Workflow  (sequential)           │
└─────────────────────────────────────────────────────────────────┘

Phase 1: Analysis          Phase 2: Kernel Deep-Dive
┌────────────────────┐     ┌────────────────────────┐
│ deepep-topology-   │────▶│  deepep-kernel-        │
│    analyst         │     │     analyst             │
│                    │     │                         │
│ Skills:            │     │ Skills:                 │
│ • intel-topology-  │     │ • analyze-cuda-         │
│   background       │     │   kernels               │
│                    │     │ • asm-translation-      │
│                    │     │   guide                 │
│                    │     │                         │
│                    │     │ Output:                 │
│                    │     │ 03_kernel_analysis.md   │
│ Output:            │     └──────────┬──────────────┘
│ 01_topology_       │                │
│   analysis.md      │                │
│ 02_terminology_    │                │
│   map.md           │                │
└──────────┬─────────┘                │
           │                          │
           └──────────┬───────────────┘
                      ▼
Phase 3: SYCL Kernel Generation
┌────────────────────────┐
│  sycl-code-generator   │
│                        │
│ Skills:                │
│ • sycl-translation-    │
│   patterns             │
│ • ishmem-migration-    │
│   guide                │
│ • asm-translation-     │
│   guide                │
│                        │
│ Output: csrc_sycl/ +   │
│ csrc/ binding layer    │
└──────────┬─────────────┘
           │
           ▼
Phase 4: Memory Model Verification
┌────────────────────────┐
│ memory-model-verifier  │◀── HIGH RISK → stop immediately,
│                        │               wait for human review
│ Skills:                │
│ • memory-model-        │
│   verification         │
│                        │
│ Output:                │
│ 04_memory_verif*.md    │
│ + code corrections     │
└──────────┬─────────────┘
           │
           ▼
Phase 5: Report Generation
┌────────────────────────┐
│ porting-report-        │
│    generator           │
│                        │
│ Output:                │
│ PORTING_REPORT.md      │
└────────────────────────┘
```

---

## Workflow Detail

### Phase 1 — Topology Analysis (internode focus)

| Item | Detail |
|------|--------|
| **Agent** | `deepep-topology-analyst` |
| **Skills loaded** | `intel-topology-background` |
| **Additional tools** | web search for VERIFY items (ishmem semantics, CX6+Intel GPU, BMG sub-group size, PCIe ordering) |
| **Key research targets** | `https://github.com/oneapi-src/ishmem` (API semantics), `https://github.com/intel-sandbox/ishmem_ibgda` (GPU-direct NIC ops), PCIe relaxed ordering + Intel GPU coherence |
| **Uncertainty policy** | ANY unresolved PCIe behavior or ishmem/IBGDA equivalence → **STOP and report to human before continuing** |
| **Reads** | `csrc/kernels/ibgda_device.cuh`, `csrc/kernels/internode.cu`, `csrc/kernels/configs.cuh` |
| **Writes** | `docs/porting/01_topology_analysis.md`, `docs/porting/02_terminology_map.md` |

### Phase 2 — Kernel Deep-Dive (internode kernels only)

| Item | Detail |
|------|--------|
| **Agent** | `deepep-kernel-analyst` |
| **Sub-agent** | `cuda-kernel-reader` (once per kernel) |
| **Skills** | `asm-translation-guide` |
| **Target kernels** | dispatch + combine in `internode.cu`; dispatch + combine in `internode_ll.cu`; device functions in `ibgda_device.cuh` |
| **Writes** | `docs/porting/kernels/<kernel_name>.md` (one file per kernel) |

### Phase 3a — Shared Infrastructure (once)

| Item | Detail |
|------|--------|
| **Agent** | `sycl-infra-generator` |
| **Skills loaded** | `intel-topology-background`, `ishmem-migration-guide` |
| **Reads** | `docs/porting/01_topology_analysis.md`, `docs/porting/02_terminology_map.md`, `csrc/kernels/configs.cuh` |
| **Writes** | `csrc_sycl/configs.hpp`, `csrc_sycl/utils.hpp`, `csrc_sycl/buffer.hpp`, `csrc_sycl/runtime.cpp`, `csrc_sycl/CMakeLists.txt`, updated `setup.py` |

### Phase 3b — Per-Kernel Generation + Inline Verification (repeat ×4)

Invoke `sycl-kernel-generator` once per kernel. After each invocation, **human checkpoint**
before proceeding to the next kernel.

| Invocation | Argument | Source | Output |
|-----------|----------|--------|--------|
| 1 | `internode_dispatch` | `internode.cu` dispatch | `csrc_sycl/internode_dispatch.cpp` + `tests/test_internode_dispatch_sycl.py` |
| 2 | `internode_combine` | `internode.cu` combine | `csrc_sycl/internode_combine.cpp` + `tests/test_internode_combine_sycl.py` |
| 3 | `internode_ll_dispatch` | `internode_ll.cu` dispatch | `csrc_sycl/internode_ll_dispatch.cpp` + `tests/test_internode_ll_dispatch_sycl.py` |
| 4 | `internode_ll_combine` | `internode_ll.cu` combine | `csrc_sycl/internode_ll_combine.cpp` + `tests/test_internode_ll_combine_sycl.py` |

Each invocation also performs **inline memory model verification** (Sections 0.2, 3, 5, 6 of
the checklist) and stops for human review if any 🔴 HIGH RISK item is found.

### Phase 4 — Report

| Item | Detail |
|------|--------|
| **Agent** | `porting-report-generator` |
| **Reads** | all `docs/porting/*.md`, all `csrc_sycl/` files |
| **Writes** | `docs/porting/PORTING_REPORT.md` |

---

## Agent Inventory (6 total)

| Agent | Phase | Invoked by | Responsibility |
|-------|-------|-----------|----------------|
| `deepep-topology-analyst` | 1 | user | Internode topology analysis, ishmem/CX6 VERIFY items |
| `deepep-kernel-analyst` | 2 | user | Enumerate + dispatch per-kernel analysis |
| `cuda-kernel-reader` | 2 | kernel-analyst | Deep analysis of one kernel → `docs/porting/kernels/<name>.md` |
| `sycl-infra-generator` | 3a | user | Shared infra: configs, utils, runtime, CMakeLists |
| `sycl-kernel-generator` | 3b | user (once per kernel) | One kernel: SYCL code + inline mem-model check + Python test |
| `porting-report-generator` | 4 | user | Aggregate final report |

---

## Skills Inventory (4 total)

| Skill | Loaded by | Phase | Purpose |
|-------|-----------|-------|---------|
| `intel-topology-background/` | deepep-topology-analyst, sycl-infra-generator | 1, 3a | Intel B60/B70 hardware spec + ishmem topology |
| `asm-translation-guide/` | deepep-kernel-analyst, sycl-kernel-generator | 2, 3b | PTX → Intel GPU patterns (tvisa reference) |
| `ishmem-migration-guide/` | sycl-infra-generator, sycl-kernel-generator | 3a, 3b | NVSHMEM→ishmem API mapping |
| `memory-model-verification/` | sycl-kernel-generator | 3b | Inline memory ordering checklist (per-kernel) |

---

## Context Passing

All inter-agent context is passed via the **file system**:

```
docs/porting/
├── 01_topology_analysis.md     ← Phase 1
├── 02_terminology_map.md       ← Phase 1
├── kernels/
│   ├── internode_dispatch.md       ← Phase 2
│   ├── internode_combine.md        ← Phase 2
│   ├── internode_ll_dispatch.md    ← Phase 2
│   └── internode_ll_combine.md     ← Phase 2
└── PORTING_REPORT.md           ← Phase 4

csrc_sycl/                          ← Phase 3a + 3b
├── CMakeLists.txt
├── configs.hpp
├── utils.hpp
├── buffer.hpp
├── runtime.cpp
├── internode_dispatch.cpp
├── internode_combine.cpp
├── internode_ll_dispatch.cpp
└── internode_ll_combine.cpp

tests/                              ← Phase 3b (one test per kernel)
├── test_internode_dispatch_sycl.py
├── test_internode_combine_sycl.py
├── test_internode_ll_dispatch_sycl.py
└── test_internode_ll_combine_sycl.py

csrc/                               ← Phase 3a (binding layer)
├── deep_ep.cpp
├── deep_ep.hpp
└── CMakeLists.txt
setup.py
```

---

## Risk Classification and Human-in-the-Loop Strategy

### HIGH RISK → Stop immediately, wait for human confirmation

- Memory ordering semantics uncertainty (fence/barrier behavioral differences)
- ishmem API behavioral uncertainty (especially quiet/fence/nbi operations)
- BMG hardware characteristics uncertainty (sub-group size, SLM size, cache line size)
- Level Zero IPC handle lifecycle uncertainty
- NIC operation ordering uncertainty (GPU kernel directly operating NIC)

### LOW RISK → Document and continue

- API naming differences (with clear equivalents)
- Code structure changes not affecting semantics
- Performance tuning parameters (need hardware validation, not correctness)

---

## Code Annotation Conventions

All generated SYCL code must use these standard comment markers:

```cpp
// HIGH_RISK: <description> — NEEDS VERIFICATION
// MEMORY_MODEL_ISSUE: <description>
// MEMORY_MODEL_FIX: <original op> → <new op> because <reason>
// PORTED_FROM: <original CUDA file path>
// TODO: <item requiring human attention>
```

---

## File Structure Overview

```
.github/
├── copilot-instructions.md          ← project-level Copilot instructions (always loaded)
├── PORTING_PLAN.md                  ← this document
├── prompts/
│   └── start-deepep-porting.prompt.md  ← workflow entry point
├── agents/
│   ├── deepep-topology-analyst.agent.md
│   ├── deepep-kernel-analyst.agent.md
│   ├── sycl-code-generator.agent.md
│   ├── memory-model-verifier.agent.md
│   ├── porting-report-generator.agent.md
│   └── cuda-kernel-reader.agent.md       ← retained for optional per-kernel deep-dive
└── skills/
    ├── intel-topology-background/SKILL.md
    ├── analyze-cuda-kernels/SKILL.md
    ├── asm-translation-guide/SKILL.md
    ├── ishmem-migration-guide/
    │   ├── SKILL.md
    │   └── references/nvshmem-ishmem-api-map.md
    └── memory-model-verification/
        ├── SKILL.md
        └── references/memory-ordering-checklist.md
```

---

## Usage

### Full workflow

```
/start-deepep-porting
```

### Single phase

| Phase | Agent | Argument |
|-------|-------|----------|
| 1 | `deepep-topology-analyst` | — |
| 2 | `deepep-kernel-analyst` | — |
| 3a | `sycl-infra-generator` | — |
| 3b kernel 1 | `sycl-kernel-generator` | `internode_dispatch` |
| 3b kernel 2 | `sycl-kernel-generator` | `internode_combine` |
| 3b kernel 3 | `sycl-kernel-generator` | `internode_ll_dispatch` |
| 3b kernel 4 | `sycl-kernel-generator` | `internode_ll_combine` |
| 4 | `porting-report-generator` | — |

> After each Phase 3b invocation, review the HIGH_RISK summary before invoking the next kernel.