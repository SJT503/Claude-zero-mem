---
name: zero-mem
description: zero-mem v6 — fully automated short-term memory + long-term memory (with dedup) + unified fuzzy search + project-isolated logs + type tags + on-demand weekly report. Zero API calls, zero background processes.
---

# zero-mem v6 — Zero-Cost Cross-Session Memory

> **Zero API calls. Zero background processes. Zero confirmation prompts.**
> ~800 tokens/day average — 1/4 of Claude Code native, 1/10 of claude-mem.

## Three-Layer Memory

```
L1 Short-term   session-log.md    Auto-write (one line per completed task, project-isolated)
L2 Long-term    MEMORY.md          Auto-write (AI decides what's worth persisting, with dedup)
L3 Real-time    Verbal retrieval   User asks "what was that parameter last time?"
```

## Project-Isolated Logs

```
~/.claude/
  session-log.md                            ← Global / cross-project config
  projects/
    PANoptosis_Project/session-log.md       ← PANoptosis only
    TBI_astrocyte/session-log.md            ← TBI only
```

**Write target rules**:
- Task belongs to a project → write to that project's `session-log.md`
- System config / cross-project → write to global `~/.claude/session-log.md`

## Entry Type Tags

Each line format: `  - [type] | project | what_was_done | key_output`

| Tag | Purpose | Example |
|------|---------|---------|
| `[fix]` | Bug fix / parameter correction | Results threshold 0.01→0.05 |
| `[feature]` | New feature / output | Methods section completed (1,810 words) |
| `[decision]` | Key decision | SCENIC parameter NES ≥ 3.0 confirmed |
| `[discovery]` | New finding / insight | Inflammatory regulons: Klf6/Ywhaz/Fos |
| `[config]` | System config / tool change | Removed claude-mem |

Grep `\[decision\]` to find all decisions, `\[fix\]` for all fixes.

## Project Status Line

Each project's `session-log.md` first line:
```
# PROJECT_NAME | Phase: [phase] | Last: YYYY-MM-DD
```

**Phase values**: experiment | bioinformatics | writing | submission | revision | system-setup

Update Last date at session end; adjust Phase when needed.

## Workflow

### Session Start
1. Detect current project directory
2. Read project `session-log.md` last 30 lines
3. Read global `session-log.md` last 10 lines (system-level changes)
4. Report: "[Project] Phase: X | Last: [last 3 entries summary]"

### During Session — L1 Auto-Write

**Triggers** (any one triggers auto-append, no confirmation):
- Created/completed a script or analysis
- Made substantive edits to a manuscript/document (≥5 lines changed)
- Fixed a bug or parameter error
- Installed/uninstalled/configured system-level tools
- Completed a multi-step task chain

**No trigger**: Q&A only, reading files, casual chat

**Write format**:
```
  - [type] | project_name | what_was_done | key_output
```

**Method**: Use the Edit tool to append to the corresponding project's `session-log.md` under today's date.

### During Session — L2 Auto-Write (with Dedup)

Write directly to MEMORY.md when discovering:
- Analysis parameter conventions
- Recurring problems and solutions
- Cross-project methodologies
- User explicitly says "remember this"

**Dedup before write**:
1. Read current MEMORY.md content
2. Check if same-topic entry exists (keyword match, e.g. "SCENIC param" ≈ "SCENIC threshold")
3. Exists & identical → skip, show `📝 Long-term memory exists, skipped`
4. Exists but outdated → update old entry, show `📝 Updated long-term memory: ...`
5. No match → write new entry, show `📝 Long-term memory written: ...`

### Unified Fuzzy Search

When user asks "what was X...", search across ALL memory sources:

**Search scope** (simultaneous, no priority order):
1. All project session-log.md files
2. Global session-log.md
3. MEMORY.md
4. Current project files (last resort only)

**Search strategy** (three-tier, zero API calls):
1. **Exact grep** — case-insensitive, mixed-language
2. **Substring expansion** — core word fuzzy match ("threshold" ↔ "thresholds")
3. **Tag filtering** — use `[type]` tags to narrow scope ("that bug" → `grep \[fix\]`)

### On-Demand Weekly Report

Triggered when user asks "weekly report" / "what did I do last week". Read all project logs → filter last 7 days → group by project. Never auto-generated, on-demand only.

## Comparison: Claude Code Native vs claude-mem vs zero-mem

| | Claude Code Native | claude-mem | zero-mem v6 |
|---|---|---|---|
| Write trigger | Auto | Every tool call | Once per task |
| Write cost | $0 | API call (every time) | $0 (Edit tool) |
| Session start cost | 2,000–5,000 tokens | 500–2,000 tokens | **~800 tokens** |
| Background process | Auto Dream (every 24h) | worker+chroma (persistent) | **None** |
| Token theft | None | ❌ Continuous drain | **None** |
| Semantic search | ❌ grep | ✅ Vector | ⚠️ Fuzzy search (zero-cost) |
| Capacity limit | ❌ 200-line hard cap | None | None |
| Project isolation | ❌ | ⚠️ Manual filtering | ✅ Physical separation |
| Type tags | ❌ | ✅ 8 obs types | ✅ 5 tags: `[fix]` `[feature]`... |
| Status line | ❌ | ❌ | ✅ Phase+Last |
| L2 long-term memory | ⚠️ Auto but no dedup | ❌ No concept | ✅ Auto-write + dedup |
| Weekly report | ❌ | ❌ | ✅ 7-day aggregation |
| Cross-tool readable | ✅ Markdown | ❌ ChromaDB | ✅ Markdown |

## Install

```bash
# 1. Clone or download
git clone https://github.com/SJT503/Claude-zero-mem.git

# 2. Copy the skill file
mkdir -p ~/.claude/skills/zero-mem
cp Claude-zero-mem/SKILL.md ~/.claude/skills/zero-mem/

# 3. (Optional) Install SessionStart hook for auto status display
# Add to ~/.claude/settings.json hooks.SessionStart
# See install.sh / install.ps1 for details
```

No dependencies. No API key. No database.
