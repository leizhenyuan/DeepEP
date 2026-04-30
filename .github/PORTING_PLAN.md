# DeepEP Intel B60/B70 移植工作流计划

## 项目概述

将 DeepEP（MoE All-to-All 通信算子库）从 NVIDIA GPU (CUDA/NVSHMEM) 完全移植到 Intel B60/B70 (Battlemage/BMG) GPU，使用 SYCL + Level Zero + ishmem 技术栈。

## 目标平台

| 项目 | NVIDIA (原) | Intel (目标) |
|------|------------|-------------|
| GPU | H100/A100 | Intel B60/B70 (Battlemage) |
| 节点内通信 | NVLink / CUDA IPC | PCIe + Level Zero IPC handles |
| 节点间通信 | NVSHMEM + IBGDA + MLX NIC | ishmem + MLX NIC (GPU kernel 直接操作) |
| 编程模型 | CUDA | SYCL (高层) + Level Zero (底层控制) |
| 代码策略 | - | 完全 SYCL 重写，不保留 CUDA 代码 |

---

## 工作流架构

```
┌─────────────────────────────────────────────────────────────────┐
│              DeepEP Intel 移植工作流 (顺序执行)                   │
└─────────────────────────────────────────────────────────────────┘

Phase 1: Analysis          Phase 2: Kernel Deep-Dive
┌────────────────────┐     ┌────────────────────────┐
│ deepep-topology-   │────▶│  deepep-kernel-        │
│    analyst         │     │     analyst             │
│                    │     │                         │
│ Sub-agents:        │     │ Sub-agents:             │
│ • nvidia-topology- │     │ • cuda-kernel-reader    │
│   reader           │     │   (per kernel file)     │
│ • intel-bmg-       │     │                         │
│   researcher       │     │ Output:                 │
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
Phase 3: Code Generation
┌────────────────────────┐
│  sycl-code-generator   │
│                        │
│ Skills:                │
│ • sycl-translation-    │
│   patterns             │
│ • ishmem-migration-    │
│   guide                │
│                        │
│ Output: csrc_sycl/     │
└──────────┬─────────────┘
           │
           ▼
Phase 4: Memory Model Verification
┌────────────────────────┐
│ memory-model-verifier  │◀── HIGH RISK → 立即暂停
│                        │              等待人工确认
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
Phase 5: Performance Tuning
┌────────────────────────┐
│  bmg-performance-      │
│     tuner              │
│                        │
│ Skills:                │
│ • bmg-performance-     │
│   patterns             │
│                        │
│ Output:                │
│ 05_performance_        │
│   report.md            │
│ + optimized code       │
└──────────┬─────────────┘
           │
           ▼
Phase 6: Report Generation
┌────────────────────────┐
│ porting-report-        │
│    generator           │
│                        │
│ Output:                │
│ PORTING_REPORT.md      │
└────────────────────────┘
```

---

## Agent 清单 (9个)

### 主 Agents (用户可直接调用, 6个)

| Agent 文件 | 对应 Step | 职责 | 主要输出 |
|-----------|---------|------|---------|
| `deepep-topology-analyst.agent.md` | Step 1+2+3 | 分析 NVIDIA 拓扑、研究 BMG 拓扑、建立术语映射 | `01_topology_analysis.md`, `02_terminology_map.md` |
| `deepep-kernel-analyst.agent.md` | Step 4 | 逐文件分析 CUDA kernel 实现逻辑 | `03_kernel_analysis.md` |
| `sycl-code-generator.agent.md` | Step 5 | 生成 SYCL + Level Zero + ishmem 代码 | `csrc_sycl/` |
| `memory-model-verifier.agent.md` | Step 6 | 验证 memory ordering & coherence 正确性 | `04_memory_verification.md` + 代码修正 |
| `bmg-performance-tuner.agent.md` | Step 7 | Intel BMG 性能优化 | `05_performance_report.md` + 优化后代码 |
| `porting-report-generator.agent.md` | Step 8 | 汇总生成移植报告 | `PORTING_REPORT.md` |

### Sub-Agents (仅被主 Agent 调用, 3个)

| Agent 文件 | 调用方 | 职责 |
|-----------|------|------|
| `nvidia-topology-reader.agent.md` | topology-analyst | 只读分析 DeepEP CUDA/NVSHMEM 源码 |
| `intel-bmg-researcher.agent.md` | topology-analyst | 研究 BMG 硬件规格 + ishmem API |
| `cuda-kernel-reader.agent.md` | kernel-analyst | 逐文件深度分析 CUDA kernel |

---

## Skills 清单 (7个)

| Skill 目录 | 使用方 | 用途 |
|-----------|------|------|
| `analyze-deepep-nvidia-topology/` | nvidia-topology-reader | 扫描 DeepEP 源码的 NVIDIA 拓扑模式 |
| `research-intel-bmg-topology/` | intel-bmg-researcher | 获取 BMG 硬件规格和 ishmem API 文档 |
| `analyze-cuda-kernels/` | cuda-kernel-reader | 系统化分析 CUDA kernel 实现的方法论 |
| `sycl-translation-patterns/` | sycl-code-generator | CUDA→SYCL 翻译参考模式 + API 映射表 |
| `ishmem-migration-guide/` | sycl-code-generator | NVSHMEM→ishmem 迁移参考 |
| `memory-model-verification/` | memory-model-verifier | SYCL/ishmem memory ordering 检查清单 |
| `bmg-performance-patterns/` | bmg-performance-tuner | Intel BMG GPU 性能优化模式 |

---

## 上下文传递机制

所有 agent 间的上下文通过 **文件系统** 传递：

```
docs/porting/
├── 01_topology_analysis.md     ← Phase 1 产出
├── 02_terminology_map.md       ← Phase 1 产出
├── 03_kernel_analysis.md       ← Phase 2 产出
├── 03b_generation_notes.md     ← Phase 3 产出（可选）
├── 04_memory_verification.md   ← Phase 4 产出
├── 05_performance_report.md    ← Phase 5 产出
└── PORTING_REPORT.md           ← Phase 6 产出（最终报告）

csrc_sycl/
├── CMakeLists.txt
├── configs.hpp
├── utils.hpp
├── runtime.cpp
├── layout.cpp
├── buffer.hpp
├── intranode.cpp               ← IPC/PCIe 节点内通信
├── internode.cpp               ← ishmem 节点间通信
├── internode_ll.cpp            ← 低延迟节点间变体
└── ibgda_device.hpp            ← NIC 设备端操作
```

---

## 风险分级与人机协作策略

### 高风险 → 立即暂停，等待人工确认

- Memory ordering 语义不确定（fence/barrier 行为差异）
- ishmem API 具体行为不确定（尤其 quiet/fence/nbi 操作）
- BMG 硬件特性不确定（sub-group size、SLM size、cache line size）
- Level Zero IPC handle 生命周期管理不确定
- NIC 操作顺序不确定（GPU kernel 直接操作 NIC 的内存序）

### 低风险 → 记录问题，继续执行

- API 命名差异（有明确对应关系）
- 代码结构调整（不涉及语义差异）
- 性能调优参数（需要硬件验证，但不影响正确性）

---

## 代码标注规范

所有生成的 SYCL 代码中使用统一注释标记：

```cpp
// HIGH_RISK: <描述> — NEEDS VERIFICATION
// MEMORY_MODEL_ISSUE: <描述>
// MEMORY_MODEL_FIX: <原始操作> → <新操作> because <理由>
// PORTED_FROM: <原 CUDA 文件路径>
// TODO: <需要人工处理的事项>
```

---

## 文件结构总览

```
.github/
├── copilot-instructions.md          ← 项目级 Copilot 指令（始终加载）
├── PORTING_PLAN.md                  ← 本文档
├── prompts/
│   └── start-deepep-porting.prompt.md  ← 工作流入口
├── agents/
│   ├── deepep-topology-analyst.agent.md
│   ├── deepep-kernel-analyst.agent.md
│   ├── sycl-code-generator.agent.md
│   ├── memory-model-verifier.agent.md
│   ├── bmg-performance-tuner.agent.md
│   ├── porting-report-generator.agent.md
│   ├── nvidia-topology-reader.agent.md   ← sub-agent
│   ├── intel-bmg-researcher.agent.md     ← sub-agent
│   └── cuda-kernel-reader.agent.md       ← sub-agent
└── skills/
    ├── analyze-deepep-nvidia-topology/SKILL.md
    ├── research-intel-bmg-topology/SKILL.md
    ├── analyze-cuda-kernels/SKILL.md
    ├── sycl-translation-patterns/
    │   ├── SKILL.md
    │   └── references/cuda-sycl-mapping.md
    ├── ishmem-migration-guide/
    │   ├── SKILL.md
    │   └── references/nvshmem-ishmem-api-map.md
    ├── memory-model-verification/
    │   ├── SKILL.md
    │   └── references/memory-ordering-checklist.md
    └── bmg-performance-patterns/
        ├── SKILL.md
        └── references/bmg-optimization-guide.md
```

---

## 使用说明

### 启动完整工作流

在 VS Code Copilot Chat 中输入：
```
/start-deepep-porting
```

### 单独运行某个阶段
在 Agent 选择器中选择对应 agent，例如：
- 重新运行 Phase 4：选择 `memory-model-verifier`
- 重新生成代码：选择 `sycl-code-generator`

### 查看当前风险项
每个 phase 完成后查看对应的分析文档，所有 HIGH RISK 项会在 `PORTING_REPORT.md` 中汇总。
