# zero-mem Windows Installer
# Usage: Right-click install.ps1 -> "Run with PowerShell"
#    or: iwr -Uri https://raw.githubusercontent.com/SJT503/Claude-zero-mem/main/install.ps1 | iex

$ErrorActionPreference = "Stop"
Write-Host "=== zero-mem install ===" -ForegroundColor Cyan

$skillDir = "$env:USERPROFILE\.claude\skills\zero-mem"
$baseUrl = "https://raw.githubusercontent.com/SJT503/Claude-zero-mem/main"

# Detect source: local clone or remote pipe
$localSrc = if ($PSScriptRoot -and (Test-Path "$PSScriptRoot\SKILL.md")) { $PSScriptRoot } else { $null }

# 1. Create skill directory
Write-Host "[1/3] Creating skill directory: $skillDir"
New-Item -ItemType Directory -Force -Path $skillDir | Out-Null

# 2. Install SKILL.md
Write-Host "[2/3] Installing SKILL.md"
if ($localSrc) {
    Copy-Item -Path "$localSrc\SKILL.md" -Destination "$skillDir\SKILL.md" -Force
} else {
    Invoke-WebRequest -Uri "$baseUrl/SKILL.md" -OutFile "$skillDir\SKILL.md"
}

# 3. (Optional) Install SessionStart hook
Write-Host "[3/3] Installing SessionStart hook (optional)"
$hookDest = "$env:USERPROFILE\.claude\hooks\zero-mem-session-start.ps1"
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.claude\hooks" | Out-Null

if ($localSrc -and (Test-Path "$localSrc\session-start.ps1")) {
    Copy-Item -Path "$localSrc\session-start.ps1" -Destination $hookDest -Force
} else {
    try {
        Invoke-WebRequest -Uri "$baseUrl/session-start.ps1" -OutFile $hookDest
    } catch {
        Write-Host "  (Skipped — session-start.ps1 download failed)"
    }
}
if (Test-Path $hookDest) { Write-Host "  Hook: $hookDest" }

$settingsFile = "$env:USERPROFILE\.claude\settings.json"
if (Test-Path $settingsFile) {
    Write-Host "  [Tip] Add hook to settings.json hooks.SessionStart for auto status on startup"
}

Write-Host ""
Write-Host "Install complete!" -ForegroundColor Green
Write-Host "Restart Claude Code to take effect." -ForegroundColor Green
