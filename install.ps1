# zero-mem Windows Installer
# Usage: Right-click install.ps1 -> "Run with PowerShell"
#    or: powershell -ExecutionPolicy Bypass -File install.ps1

$ErrorActionPreference = "Stop"
Write-Host "=== zero-mem install ===" -ForegroundColor Cyan

# 1. Create skill directory
$skillDir = "$env:USERPROFILE\.claude\skills\zero-mem"
Write-Host "[1/3] Creating skill directory: $skillDir"
New-Item -ItemType Directory -Force -Path $skillDir | Out-Null

# 2. Copy SKILL.md
Write-Host "[2/3] Installing SKILL.md"
Copy-Item -Path "$PSScriptRoot\SKILL.md" -Destination "$skillDir\SKILL.md" -Force

# 3. (Optional) Install SessionStart hook
Write-Host "[3/3] Installing SessionStart hook (optional)"
$settingsFile = "$env:USERPROFILE\.claude\settings.json"
$hookScript = "$PSScriptRoot\session-start.ps1"

if (Test-Path $hookScript) {
    $hookDest = "$env:USERPROFILE\.claude\hooks\zero-mem-session-start.ps1"
    New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.claude\hooks" | Out-Null
    Copy-Item -Path $hookScript -Destination $hookDest -Force
    Write-Host "  Hook script copied to: $hookDest"

    if (Test-Path $settingsFile) {
        Write-Host "  [Tip] To auto-display project status on startup, add this hook to settings.json"
        Write-Host "        See README.md for details"
    }
} else {
    Write-Host "  (Skipped - session-start.ps1 not found)"
}

Write-Host ""
Write-Host "Install complete!" -ForegroundColor Green
Write-Host "Restart Claude Code to take effect." -ForegroundColor Green
