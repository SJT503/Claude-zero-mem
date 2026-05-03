# zero-mem · Zero-Cost Memory for Claude Code

> Fully automated cross-session memory system for Claude Code.
> **Zero API calls. Zero background processes. Zero confirmation prompts.**

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-Skill-blue)](https://claude.ai/claude-code)

---

## Why You Need It

Every new Claude Code session starts with amnesia.

| Pain Point | What Happens |
|------------|--------------|
| "Where did I leave off last time?" | Re-read code, re-navigate files |
| "What threshold did I use for SCENIC?" | Dig through old chats |
| "What did I do last week?" | Frantic recall before meetings |
| "Was this a bug or intentional?" | Fix the same issue twice |

**zero-mem solves all of this.** Auto-log every task. Auto-report progress on next launch.

---

## In One Line

```
zero-mem = the memory OS for Claude Code.
Enough. No theft. No nagging.
```

---

## Comparison: Three Memory Solutions

| | Claude Code Native | claude-mem | **zero-mem** |
|---|---|---|---|
| 💰 **Tokens per session** | 2,000–5,000 | 2,000–8,000+ | **~800** ✨ |
| 🏠 **Background process** | Auto Dream (every 24h) | worker + ChromaDB (persistent) | **None** ✨ |
| 🔋 **API quota theft** | None | ❌ Continuous drain | **None** ✨ |
| 🔍 **Search** | grep (exact match) | ✅ Vector semantic search | ⚠️ Unified fuzzy search (zero-cost) |
| 📏 **Capacity** | ❌ 200-line hard cap | Unlimited | Unlimited |
| 📂 **Project isolation** | ❌ Mixed together | ⚠️ Manual filtering | ✅ Physical separation |
| 🏷️ **Entry tags** | ❌ | ✅ 8 obs types | ✅ 5 tags: `[fix]` `[feature]` `[decision]` `[discovery]` `[config]` |
| 📊 **Status line** | ❌ | ❌ | ✅ Phase + Last date |
| 🧠 **Long-term dedup** | ❌ | ❌ | ✅ Pre-write dedup check |
| 📋 **On-demand weekly report** | ❌ | ❌ | ✅ Type "weekly" → instant report |
| 📝 **Cross-tool readable** | ✅ Markdown | ❌ ChromaDB-locked | ✅ Plain Markdown |
| 🚀 **Install complexity** | Built-in | Plugin + DB + daemon | **Single file** |
| 💸 **Extra cost** | $0 | Uncontrolled background drain | **$0** ✨ |

> claude-mem's **only** advantage is vector semantic search. But it comes at the cost of **background token theft**.
> If you can type a keyword instead of a vague description, zero-mem wins across the board.

---

## Who Is It For?

| You | Why |
|-----|-----|
| 🧑‍💻 **Developers** | Switch projects without mental replay |
| 🔬 **Researchers** | Parameters auto-remembered, weekly reports on demand |
| ✍️ **Writers** | Full edit history tracked across sessions |
| 🎓 **Grad Students** | Advisor wants progress? Open Claude Code — instant answer |
| 🏢 **PMs** | Track decisions and progress across sessions |
| 🤖 **AI Power Users** | Stop burning 2,000+ tokens/day on memory overhead |

**Not for you?** If you only ask Claude Code one-off questions, you don't need memory.

---

## Core Features

### L1 · Short-Term Memory (Auto)

Each completed task appends one line to session-log:

```
  - [feature] | TBI_astrocyte | Methods section completed (1,810 words) | 12 subsections
  - [fix] | TBI_astrocyte | Results threshold 0.01→0.05 | Synced with code
  - [decision] | PANoptosis | SCENIC parameter NES ≥ 3.0 | Standard confirmed
```

### L2 · Long-Term Memory (Auto + Dedup)

Worth persisting? → Auto-write to MEMORY.md → Dedup check → No duplicates.

### Project Isolation

Each project gets its own log. No cross-contamination:

```
~/.claude/projects/
  PANoptosis/session-log.md    ← PANoptosis only
  TBI_astrocyte/session-log.md ← TBI only
  MyApp/session-log.md         ← MyApp only
```

### Unified Fuzzy Search

"That threshold fix" → Auto-searches all project logs → Instantly finds `[fix] Results threshold 0.01→0.05`

**Three-tier strategy** (zero API calls):
1. **Exact grep** — case-insensitive, mixed-language
2. **Substring expansion** — "threshold" ↔ "thresholds"
3. **Tag filtering** — "that bug" → `grep \[fix\]`

### On-Demand Weekly Report

Say "weekly report" → All projects, last 7 days, grouped by project. Never auto-generated, on-demand only.

---

## Install

### One-Line

```bash
# macOS / Linux
curl -fsSL https://raw.githubusercontent.com/SJT503/Claude-zero-mem/main/install.sh | bash

# Windows (PowerShell)
iwr -UseBasicParsing -Uri https://raw.githubusercontent.com/SJT503/Claude-zero-mem/main/install.ps1 | iex
```

### Manual (3 steps)

```bash
# 1. Copy the skill file
mkdir -p ~/.claude/skills/zero-mem
cp SKILL.md ~/.claude/skills/zero-mem/

# 2. (Optional) Subscribe SessionStart hook for auto status display
# Edit ~/.claude/settings.json, add session-start.ps1 to hooks.SessionStart

# 3. Restart Claude Code. Done.
```

**No dependencies.** No API key. No database. No background process. No npm install. No Docker.

---

## Project Structure

```
zero-mem/
├── README.md            ← You're reading this
├── SKILL.md             ← Core skill (copy to ~/.claude/skills/zero-mem/)
├── install.sh           ← macOS/Linux installer
├── install.ps1          ← Windows installer (PowerShell)
├── session-start.ps1    ← (Optional) SessionStart hook script
├── CHANGELOG.md         ← Version history
└── LICENSE              ← MIT
```

---

## Changelog

| Version | Highlights |
|---------|------------|
| v1 | Three-layer memory architecture (L1+L2+L3) |
| v2 | L1 fully automated (no confirmation prompts) |
| v3 | L2 fully automated (no confirmation prompts) |
| v4 | Project-isolated logs + `[type]` tags + status line |
| v5 | L2 dedup check + on-demand weekly report |
| v6 | Unified fuzzy search (cross-project, zero-cost) |

---

## FAQ

**Q: Does it conflict with Claude Code's built-in MEMORY.md?**
No. zero-mem uses an independent `session-log.md` for short-term memory and enhances MEMORY.md with dedup for long-term memory. They share MEMORY.md as mutual backup.

**Q: How many tokens does it consume?**
~800 tokens per session start (30 lines project log + 10 lines global log). Writes use the Edit tool at ~10–20 tokens each. **Average < 1,500 tokens/day.**

**Q: Why not use a vector database for semantic search?**
Vector search requires API calls (embeddings) or a local model. zero-mem's principle is **zero API calls**. For a 30-line window, grep + tag filtering covers 90%+ of retrieval needs.

**Q: Can teams share it?**
Both `session-log.md` and `MEMORY.md` are plain Markdown — you can `git commit` and share them. However, zero-mem has no built-in sync mechanism (yet).

---

## License

MIT © 2026
