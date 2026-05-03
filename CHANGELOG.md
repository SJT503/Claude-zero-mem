# Changelog

---

## v6 (2026-05-03)

### Added
- **Unified fuzzy search**: Zero-cost fuzzy search across all memory sources. Three-tier strategy (exact grep → substring expansion → tag filtering), covering `[fix]`/`[feature]`/`[decision]`/`[discovery]`/`[config]` tags
- **Rebrand**: mem-bridge → zero-mem / 零耗记忆
- **Three-party comparison table**: Claude Code native vs claude-mem vs zero-mem, full dimension comparison

### Improved
- Search scope: all project session-logs + global session-log + MEMORY.md + project files (four-level parallel)
- Mixed-language fuzzy matching ("阈值" ↔ "threshold")

---

## v5 (2026-05-03)

### Added
- **L2 dedup check**: Auto-check existing entries before writing long-term memory. Keyword-based topic matching with skip/update/add operations
- **On-demand weekly report**: Say "weekly report" → auto-generate last 7 days summary across all projects, grouped by project

### Removed
- SessionEnd hook retired (was the source of auto-generated empty entry pollution)

---

## v4 (2026-05-03)

### Added
- **Project-isolated logs**: Each project gets its own `session-log.md`, physically separated
- **Type tags**: 5 tags — `[fix]` `[feature]` `[decision]` `[discovery]` `[config]`
- **Status line**: Each project log first line `# PROJECT | Phase: X | Last: YYYY-MM-DD`
- **Phase values**: experiment | bioinformatics | writing | submission | revision | system-setup

### Improved
- Auto-detect write target (project-level vs global)

---

## v3 (2026-05-03)

### Added
- L2 fully automated: AI judges what's worth persisting → writes directly to MEMORY.md, no confirmation

---

## v2 (2026-05-03)

### Added
- L1 fully automated: auto-append session-log after each task, no confirmation

---

## v1 (2026-05-03)

### Initial Release
- Three-layer memory: L1 short-term + L2 long-term + L3 verbal retrieval
- Auto-read project log on session start
- L1 manual write (prompted after each task)
