# install.ps1 - Install code-test-agent (Trae test orchestration agent)
#
# Install scope:
#   - Project (default) : <current-dir>/.trae/agents/
#   - Global (all projects) : $HOME/.trae/agents/
#
# One-line install:
#   Project: iex (irm https://raw.githubusercontent.com/GoodTimeGGB/code-test-agent/main/install.ps1)
#   Global : $env:CTA_GLOBAL='1'; iex (irm https://raw.githubusercontent.com/GoodTimeGGB/code-test-agent/main/install.ps1)
#
# Local file:
#   powershell -ExecutionPolicy Bypass -File install.ps1
#   powershell -ExecutionPolicy Bypass -File install.ps1 -Global

$ErrorActionPreference = "Stop"

$isGlobal = $false
if ($args -and $args -contains '-Global') {
  $isGlobal = $true
}
if ($env:CTA_GLOBAL -eq '1') {
  $isGlobal = $true
}

$agentName = "code-test-agent.agent.md"
$rawUrl = "https://raw.githubusercontent.com/GoodTimeGGB/code-test-agent/main/$agentName"

# 1. Locate the agent definition: prefer local copy next to this script, else download from GitHub.
$source = $null
if ($PSScriptRoot) {
  $localFile = Join-Path $PSScriptRoot $agentName
  if (Test-Path $localFile) { $source = $localFile }
}
if (-not $source) {
  $source = Join-Path ([System.IO.Path]::GetTempPath()) $agentName
  Write-Host "Downloading $agentName from GitHub..." -ForegroundColor Yellow
  Invoke-WebRequest -Uri $rawUrl -OutFile $source -UseBasicParsing
}

# 2. Pick target directory.
if ($isGlobal) {
  $targetDir = Join-Path $HOME ".trae\agents"
  $scope = "global (all projects)"
} else {
  $targetDir = Join-Path (Get-Location) ".trae\agents"
  $scope = "current project"
}

New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
$target = Join-Path $targetDir $agentName
Copy-Item -Path $source -Destination $target -Force

Write-Host ""
Write-Host "  [OK] code-test-agent installed" -ForegroundColor Green
Write-Host "  Scope: $scope"
Write-Host "  Path : $target"
Write-Host ""
Write-Host "  Reload Trae, then invoke 'code-test-agent' and ask it to test your code." -ForegroundColor Cyan
Write-Host ""