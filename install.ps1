# install.ps1 - Install code-test-agent (Trae test orchestration agent + skills)
#
# Install scope:
#   - Project (default) : <current-dir>/.trae/
#   - Global (all projects) : $HOME/.trae/
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
$rawBase = "https://raw.githubusercontent.com/GoodTimeGGB/code-test-agent/main"

# Skill names to install under <target>/skills/<name>/SKILL.md
$skillNames = @(
  "test-case-generator",
  "test-case-runner",
  "test-api-runner",
  "test-unit-runner"
)

# 1. Pick target root directory.
if ($isGlobal) {
  $targetRoot = Join-Path $HOME ".trae"
  $scope = "global (all projects)"
} else {
  $targetRoot = Join-Path (Get-Location) ".trae"
  $scope = "current project"
}

$agentDir = Join-Path $targetRoot "agents"
$skillsDir = Join-Path $targetRoot "skills"

# 2. Install the agent definition (prefer local copy next to this script).
$source = $null
if ($PSScriptRoot) {
  $localFile = Join-Path $PSScriptRoot $agentName
  if (Test-Path $localFile) { $source = $localFile }
}
if (-not $source) {
  $source = Join-Path ([System.IO.Path]::GetTempPath()) $agentName
  Write-Host "Downloading $agentName from GitHub..." -ForegroundColor Yellow
  Invoke-WebRequest -Uri "$rawBase/$agentName" -OutFile $source -UseBasicParsing
}

New-Item -ItemType Directory -Path $agentDir -Force | Out-Null
Copy-Item -Path $source -Destination (Join-Path $agentDir $agentName) -Force

# 3. Install skills. Prefer local skills/ directory, else download each SKILL.md.
$localSkills = $null
if ($PSScriptRoot) {
  $l = Join-Path $PSScriptRoot "skills"
  if (Test-Path $l) { $localSkills = $l }
}

New-Item -ItemType Directory -Path $skillsDir -Force | Out-Null
if ($localSkills) {
  Copy-Item -Path (Join-Path $localSkills "*") -Destination $skillsDir -Recurse -Force
} else {
  foreach ($name in $skillNames) {
    $destDir = Join-Path $skillsDir $name
    New-Item -ItemType Directory -Path $destDir -Force | Out-Null
    $dest = Join-Path $destDir "SKILL.md"
    Write-Host "Downloading skill $name ..." -ForegroundColor Yellow
    Invoke-WebRequest -Uri "$rawBase/skills/$name/SKILL.md" -OutFile $dest -UseBasicParsing
  }
}

Write-Host ""
Write-Host "  [OK] code-test-agent installed" -ForegroundColor Green
Write-Host "  Scope : $scope"
Write-Host "  Agent : $agentDir\$agentName"
Write-Host "  Skills: $skillsDir"
Write-Host ""
Write-Host "  Reload Trae, then invoke 'code-test-agent' and ask it to test your code." -ForegroundColor Cyan
Write-Host ""