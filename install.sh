#!/usr/bin/env bash
# zero-mem macOS/Linux install
# Usage: bash install.sh
#    or: curl -fsSL https://raw.githubusercontent.com/SJT503/Claude-zero-mem/main/install.sh | bash

set -e
echo -e "\033[1;36m=== zero-mem install ===\033[0m"

SKILL_DIR="${HOME}/.claude/skills/zero-mem"
BASE_URL="https://raw.githubusercontent.com/SJT503/Claude-zero-mem/main"

# Detect if running from local clone or remote
if [ -f "$(dirname "$0")/SKILL.md" ] 2>/dev/null; then
    SRC="$(dirname "$0")"
else
    SRC=""
fi

# 1. Create skill directory
echo "[1/3] Creating skill directory: ${SKILL_DIR}"
mkdir -p "${SKILL_DIR}"

# 2. Install SKILL.md
echo "[2/3] Installing SKILL.md"
if [ -n "${SRC}" ] && [ -f "${SRC}/SKILL.md" ]; then
    cp "${SRC}/SKILL.md" "${SKILL_DIR}/SKILL.md"
else
    curl -fsSL "${BASE_URL}/SKILL.md" -o "${SKILL_DIR}/SKILL.md"
fi

# 3. (Optional) Install SessionStart hook
echo "[3/3] Installing SessionStart hook (optional)"
HOOK_DEST="${HOME}/.claude/hooks/zero-mem-session-start.sh"
mkdir -p "${HOME}/.claude/hooks"

if [ -n "${SRC}" ] && [ -f "${SRC}/session-start.ps1" ]; then
    cp "${SRC}/session-start.ps1" "${HOOK_DEST}"
elif command -v curl &> /dev/null; then
    curl -fsSL "${BASE_URL}/session-start.ps1" -o "${HOOK_DEST}"
else
    echo "  (Skipped — session-start.ps1 not available)"
fi
[ -f "${HOOK_DEST}" ] && chmod +x "${HOOK_DEST}" && echo "  Hook: ${HOOK_DEST}"

if [ -f "${HOME}/.claude/settings.json" ]; then
    echo "  [Tip] Add hook to settings.json hooks.SessionStart for auto status on startup"
    echo "        See README for details"
fi

echo ""
echo -e "\033[1;32mInstall complete!\033[0m"
echo -e "\033[1;32mRestart Claude Code to take effect.\033[0m"
