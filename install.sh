#!/usr/bin/env bash
# zero-mem macOS/Linux 安装脚本
# 用法: bash install.sh 或 curl ... | bash

set -e
echo -e "\033[1;36m=== zero-mem 安装 ===\033[0m"

SKILL_DIR="${HOME}/.claude/skills/zero-mem"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 1. 创建技能目录
echo "[1/3] 创建技能目录: ${SKILL_DIR}"
mkdir -p "${SKILL_DIR}"

# 2. 复制 SKILL.md
echo "[2/3] 安装 SKILL.md"
cp "${SCRIPT_DIR}/SKILL.md" "${SKILL_DIR}/SKILL.md"

# 3. (可选) 安装 SessionStart 钩子
echo "[3/3] 安装 SessionStart 钩子（可选）"
HOOK_SCRIPT="${SCRIPT_DIR}/session-start.sh"

if [ -f "${HOOK_SCRIPT}" ]; then
    HOOK_DEST="${HOME}/.claude/hooks/zero-mem-session-start.sh"
    mkdir -p "${HOME}/.claude/hooks"
    cp "${HOOK_SCRIPT}" "${HOOK_DEST}"
    chmod +x "${HOOK_DEST}"
    echo "  钩子脚本已复制到: ${HOOK_DEST}"

    SETTINGS_FILE="${HOME}/.claude/settings.json"
    if [ -f "${SETTINGS_FILE}" ]; then
        echo "  [提示] 如需 SessionStart 自动显示项目状态，请在 settings.json 中手动添加 hook"
        echo "         详见 README.md 安装说明"
    fi
else
    echo "  (跳过 — session-start.sh 不在当前目录)"
fi

echo ""
echo -e "\033[1;32m安装完成!\033[0m"
echo -e "\033[1;32m重启 Claude Code 即可生效。\033[0m"
echo ""
echo -e "\033[1;30m验证: 下次启动 Claude Code 时会自动读取项目 session-log\033[0m"
