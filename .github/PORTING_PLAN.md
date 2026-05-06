# DeepEP Intel B60/B70 Porting Workflow Plan

## Project Overview

Complete port of DeepEP (MoE All-to-All communication operator library) from NVIDIA GPU (CUDA/NVSHMEM)
to Intel B60/B70 (Battlemage/BMG) GPU using the SYCL + Level Zero + ishmem stack.
No CUDA code is retained in the final implementation.

## Target Platform

| Component | NVIDIA (Original) | Intel (Target) |
|-----------|------------------|----------------|
| GPU | H100/A100 | Intel B60/B70 (Battlemage) |
| Intranode comm | NVLink / CUDA IPC | PCIe + Level Zero IPC handles |
| Internode comm | NVSHMEM + IBGDA + MLX NIC | ishmem + MLX NIC (GPU-initiated) |
| Programming model | CUDA | SYCL (high-level) + Level Zero (low-level) + visa (asm) |
| Code strategy | — | Complete SYCL rewrite — no CUDA retained, only functional at first step |

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

For each phase: agent responsible, sub-agents invoked, and skills loaded.

### Phase 1 — Topology Analysis

| Item | Detail |
|------|--------|
| **Agent** | `deepep-topology-analyst` |
| **Sub-agents** | none |
| **Skills loaded** | `intel-topology-background` |
| **Additional tools** | web search to resolve ⚠️ VERIFY items in intel-topology-background |
| **Writes** | `docs/porting/01_topology_analysis.md`, `docs/porting/02_terminology_map.md` |

### Phase 2 — Kernel Deep-Dive

| Item | Detail |
|------|--------|
| **Agent** | `deepep-kernel-analyst` |
| **Sub-agents** | none |
| **Skills loaded** | `analyze-cuda-kernels`, `asm-translation-guide` |
| **Reads** | all files in `csrc/kernels/` (analysis is per kernel, not per file) |
| **Writes** | `docs/porting/03_kernel_analysis.md` |

### Phase 3 — SYCL Kernel Generation

| Item | Detail |
|------|--------|
| **Agent** | `sycl-code-generator` |
| **Sub-agents** | none |
| **Skills loaded** | `ishmem-migration-guide`, `asm-translation-guide` |
| **Reads** | `docs/porting/01_topology_analysis.md`, `docs/porting/02_terminology_map.md`, `docs/porting/03_kernel_analysis.md`, `csrc/kernels/` |
| **Writes** | `csrc_sycl/` (all kernel + runtime + layout files), `csrc/deep_ep.cpp`, `csrc/deep_ep.hpp`, `setup.py`, `CMakeLists.txt` |

### Phase 4 — Memory Model Verification

| Item | Detail |
|------|--------|
| **Agent** | `memory-model-verifier` |
| **Sub-agents** | none |
| **Skills loaded** | `memory-model-verification` |
| **Reads** | all files in `csrc_sycl/`, `docs/porting/03_kernel_analysis.md` |
| **Writes** | `docs/porting/04_memory_verification.md` + in-place code corrections in `csrc_sycl/` |
| **Human-in-loop** | STOP on any HIGH RISK item — do not proceed until human confirms |

### Phase 5 — Report Generation

| Item | Detail |
|------|--------|
| **Agent** | `porting-report-generator` |
| **Sub-agents** | none |
| **Skills loaded** | none |
| **Reads** | all `docs/porting/*.md`, `csrc_sycl/` |
| **Writes** | `docs/porting/PORTING_REPORT.md` |

---

## Agent Inventory (5 total)

| Agent file | Phase | Responsibility | Primary output |
|-----------|-------|---------------|----------------|
| `deepep-topology-analyst.agent.md` | Phase 1 | Load topology backgrounds, resolve VERIFY items, build terminology map | `01_topology_analysis.md`, `02_terminology_map.md` |
| `deepep-kernel-analyst.agent.md` | Phase 2 | Per-kernel analysis of all CUDA kernel implementations | `03_kernel_analysis.md` |
| `sycl-code-generator.agent.md` | Phase 3 | Generate SYCL + Level Zero + ishmem code; port binding layer | `csrc_sycl/`, updated `csrc/`, `setup.py` |
| `memory-model-verifier.agent.md` | Phase 4 | Verify memory ordering & coherence correctness | `04_memory_verification.md` + corrections |
| `porting-report-generator.agent.md` | Phase 5 | Aggregate and generate final porting report | `PORTING_REPORT.md` |

---

## Skills Inventory (5 total)

| Skill directory | Loaded by | Phase | Purpose |
|----------------|-----------|-------|---------|
| `intel-topology-background/` | deepep-topology-analyst | 1 | Intel B60/B70 hardware spec + known PCIe/ishmem topology — static prior knowledge |
| `analyze-cuda-kernels/` | deepep-kernel-analyst | 2 | Methodology for systematic CUDA kernel analysis |
| `asm-translation-guide/` | deepep-kernel-analyst, sycl-code-generator | 2, 3 | PTX inline assembly → Intel GPU equivalent patterns (tvisa reference) |
| `ishmem-migration-guide/` | sycl-code-generator | 3 | NVSHMEM→ishmem migration reference |
| `memory-model-verification/` | memory-model-verifier | 5 | SYCL/ishmem memory ordering verification checklist |

---

## Context Passing Mechanism

All inter-agent context is passed via the **file system**:

```
docs/porting/
├── 01_topology_analysis.md     ← Phase 1 output
├── 02_terminology_map.md       ← Phase 1 output
├── 03_kernel_analysis.md       ← Phase 2 output
├── 04_memory_verification.md   ← Phase 5 output
└── PORTING_REPORT.md           ← Phase 6 output (final report)

csrc_sycl/                          ← Phase 3 output
├── CMakeLists.txt
├── configs.hpp
├── utils.hpp
├── runtime.cpp
├── layout.cpp
├── buffer.hpp
├── intranode.cpp               ← IPC/PCIe intranode communication
├── internode.cpp               ← ishmem internode communication
├── internode_ll.cpp            ← low-latency internode variant
└── ibgda_device.hpp            ← NIC device-side operations

csrc_sycl/                          ← Phase 3 output (kernels)
csrc/                               ← Phase 3 output (binding layer)
├── deep_ep.cpp                 ← pybind11 bindings (CUDA → SYCL queue/device)
├── deep_ep.hpp                 ← C++ API (CUDA IPC → Level Zero IPC)
└── CMakeLists.txt              ← icpx compiler, SYCL flags
setup.py                            ← Phase 3 update (icpx build)
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

### Start the full workflow

In VS Code Copilot Chat:
```
/start-deepep-porting
```

### Run a single phase

Select the corresponding agent in the Agent picker, for example:
- Re-run Phase 1: select `deepep-topology-analyst`
- Re-run Phase 2: select `deepep-kernel-analyst`
- Re-run Phase 3: select `sycl-code-generator`
- Re-run Phase 4: select `memory-model-verifier`
- Re-run Phase 5: select `porting-report-generator`

### Review current risk items

After each phase completes, check the corresponding analysis document.
All HIGH RISK items are aggregated in `PORTING_REPORT.md`.

