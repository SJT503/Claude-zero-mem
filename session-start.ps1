# zero-mem SessionStart hook (Windows PowerShell)
# Optional - auto-displays project status and recent memory on startup
#
# Install:
#   1. Copy this file to ~/.claude/hooks/
#   2. In ~/.claude/settings.json, add to hooks.SessionStart:
#      { "type": "powershell", "command": "~/.claude/hooks/zero-mem-session-start.ps1" }

$globalLog = "$env:USERPROFILE\.claude\session-log.md"
$projectsDir = "$env:USERPROFILE\.claude\projects"

# Detect current project from working directory
$projectName = Split-Path -Leaf (Get-Location)
$projectLog = "$projectsDir\$projectName\session-log.md"

# Output status banner
Write-Output "========================================"
Write-Output "  zero-mem ready"

# Project status
if (Test-Path $projectLog) {
    $firstLine = Get-Content $projectLog -First 1
    if ($firstLine -match "^# (.+)") {
        Write-Output "  $($Matches[1])"
    }
} else {
    Write-Output "  [new project] $projectName"
}

# Global log status
if (Test-Path $globalLog) {
    Write-Output "  Global log: available"
}

Write-Output "========================================"

# Return JSON to continue hook chain
Write-Output '{"continue":true}'
