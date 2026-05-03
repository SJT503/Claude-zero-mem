---
name: zero-mem
description: 零耗记忆zero-mem v6——全自动短记忆+全自动长记忆(带去重)+统一模糊搜索+项目分离日志+类型标签+按需周报。零API调用、零后台进程。
---

# zero-mem v6 — 零耗全自动跨会话记忆

> **零 API 调用，零后台进程，零确认打扰。**
> 日均 token 消耗 ~800，是 Claude Code 原生的 1/4，是 claude-mem 的 1/10。

## 三层记忆架构

```
L1 短记忆  session-log.md    自动写入（每任务完成即追加一行，按项目分离）
L2 长记忆  MEMORY.md         自动写入（AI判断值得持久化即直接写入，带去重）
L3 即时    口头检索           用户随口问"上次X的参数是多少"
```

## 项目分离日志

```
~/.claude/
  session-log.md                             ← 全局/跨项目配置
  projects/
    PANoptosis_Project/session-log.md        ← 只含 PANoptosis
    TBI_astrocyte/session-log.md             ← 只含 TBI
```

**写入目标判断**：
- 任务属于某个项目 → 写入该项目 `session-log.md`
- 系统配置/跨项目 → 写入全局 `~/.claude/session-log.md`

## 条目类型标签

每行格式：`  - [type] | 项目 | 做了什么 | 产出`

| 标签 | 用途 | 示例 |
|------|------|------|
| `[fix]` | bug修复/参数修正 | Results阈值 0.01→0.05 |
| `[feature]` | 新功能/新产出 | Methods章节撰写完成 |
| `[decision]` | 关键决策 | SCENIC参数确定 NES≥3.0 |
| `[discovery]` | 新发现/新认知 | 炎症regulon为Klf6/Ywhaz/Fos |
| `[config]` | 系统配置/工具变更 | claude-mem卸载 |

Grep `\[decision\]` 秒找所有决策，`\[fix\]` 秒找所有修复。

## 项目状态行

每个项目 session-log.md 首行：
```
# PROJECT_NAME | Phase: [阶段] | Last: YYYY-MM-DD
```

**Phase 可选值**：实验 | 生信分析 | 写作 | 投稿 | 修改 | 系统搭建

会话结束时自动更新 Last 日期，必要时调整 Phase。

## 工作流

### 会话启动
1. 检测当前项目目录
2. 读对应项目 `session-log.md` 最近 30 行
3. 读全局 `session-log.md` 最近 10 行（了解系统级变更）
4. 报告格式："[项目名] Phase: X | 上次 [最近3条摘要]"

### 会话中 — L1 自动写入

**触发规则**（满足任一即自动追加，不问用户）：
- 创建/完成一个脚本或分析
- 对稿件/重要文档做了实质性修改（≥5行改动）
- 修复了一个 bug 或参数错误
- 安装/卸载/配置了系统级工具
- 完成了一个多步骤任务链

**不触发**：纯问答、读取文件、闲聊

**写入格式**：
```
  - [type] | 项目名 | 做了什么 | 关键产出
```

**写入方法**：用 Edit 工具追加到对应项目的 session-log.md 当天日期段落末尾。

### 会话中 — L2 自动写入（带去重）

当发现以下类型的事实，**直接写入** MEMORY.md，不问用户：
- 分析参数约定
- 重复出现的问题及解决方案
- 跨项目通用的方法论
- 用户明确说"记住这个"的内容

**写入前去重**：
1. 先读取 MEMORY.md 当前内容
2. 检查是否已有**同一主题**的条目（关键词匹配，如"SCENIC 参数"≈"SCENIC 阈值约"）
3. 已有且内容一致 → 跳过，显示 `📝 长记忆已存在，跳过`
4. 已有但需更新 → 替换旧条目，显示 `📝 已更新长记忆：...`
5. 无重复 → 写入新条目，显示 `📝 已写入长记忆：...`

### 统一模糊搜索

用户问"之前X..."时，执行跨所有记忆源的统一搜索：

**搜索范围**（同时搜，不区分先后）：
1. 所有项目 session-log.md
2. 全局 session-log.md
3. MEMORY.md
4. 当前项目文件（仅最后手段）

**搜索策略**（三级递进，零 API 调用）：
1. **精确 grep**：不区分大小写，中英混合匹配
2. **子串扩展**：提取核心词做模糊匹配（"阈值"↔"threshold"）
3. **标签过滤**：用 `[type]` 标签缩小范围（"那个bug"→`grep \[fix\]`）

### 按需周报

用户问"上周做了什么"/"周报"时生成。读取全部项目日志 → 筛最近7天 → 按项目分组输出。不自动生成，仅按需触发。

### 记忆检索
用户问"之前X..."时检索顺序：当前项目 session-log.md → MEMORY.md → 全局 session-log.md → grep 项目文件

## 与 Claude Code 原生 + claude-mem 三方对比

| | Claude Code 原生 | claude-mem | zero-mem v6 |
|---|---|---|---|
| 写入触发 | 自动 | 每次工具调用 | 任务完成后一次 |
| 写入成本 | 0 | API调用(每次) | 0 (Edit工具) |
| 会话启动消耗 | 2000-5000 tokens | 500-2000 tokens | **~800 tokens** |
| 后台进程 | Auto Dream (24h/次) | worker+chroma (持续) | **无** |
| 偷 token | 无 | ❌ 持续消耗 | **无** |
| 语义搜索 | ❌ grep | ✅ 向量 | ⚠️ 统一模糊搜索(零成本) |
| 容量限制 | ❌ 200行硬截断 | 无 | 无 |
| 项目分离 | ❌ | ⚠️ 需筛选 | ✅ 物理隔离 |
| 类型标签 | ❌ | ✅ 8种obs | ✅ 5种 `[fix]``[feature]`... |
| 状态行 | ❌ | ❌ | ✅ Phase+Last |
| L2长记忆 | ⚠️ 自动但无去重 | ❌ 无此概念 | ✅ 自动写入+去重 |
| 按需周报 | ❌ | ❌ | ✅ 7日聚合 |
| 跨工具可读 | ✅ Markdown | ❌ ChromaDB | ✅ Markdown |

## 安装

```bash
# 1. 克隆或下载
git clone https://github.com/SJT503/Claude-zero-mem.git

# 2. 复制技能文件
mkdir -p ~/.claude/skills/zero-mem
cp zero-mem/SKILL.md ~/.claude/skills/zero-mem/

# 3. (可选) 安装 SessionStart 钩子，实现启动时自动显示项目状态
# 在 ~/.claude/settings.json 的 hooks.SessionStart 中添加:
# 详见 install.sh / install.ps1
```

无需额外依赖，无需 API key，无需数据库。
