# install.ps1 - 安装 code-test-agent（代码测试智能体）到 Trae
#
# 本地运行：从脚本同目录读取 code-test-agent.agent.md
# 远程运行（iex）：本地无文件时自动从 GitHub 下载
#
# 用法：
#   安装到当前项目（默认）：
#     powershell -ExecutionPolicy Bypass -File install.ps1
#     iex (irm https://raw.githubusercontent.com/GoodTimeGGB/code-test-agent/main/install.ps1)
#   安装到全局（所有项目可用）：
#     powershell -ExecutionPolicy Bypass -File install.ps1 -Global
#     $g=1; iex (irm https://raw.githubusercontent.com/GoodTimeGGB/code-test-agent/main/install.ps1) -Global

param(
  [switch]$Global
)

$ErrorActionPreference = "Stop"
$agentName = "code-test-agent.agent.md"
$rawUrl = "https://raw.githubusercontent.com/GoodTimeGGB/code-test-agent/main/$agentName"

# 1. 定位智能体定义文件：优先本地脚本同目录，否则从 GitHub 下载
$localFile = if ($PSScriptRoot) { Join-Path $PSScriptRoot $agentName } else { $null }
if ($localFile -and (Test-Path $localFile)) {
  $source = $localFile
} else {
  $tempFile = Join-Path ([System.IO.Path]::GetTempPath()) $agentName
  Write-Host "本地未找到 $agentName，正在从 GitHub 下载..." -ForegroundColor Yellow
  Invoke-WebRequest -Uri $rawUrl -OutFile $tempFile -UseBasicParsing
  $source = $tempFile
}

# 2. 确定安装目录
if ($Global) {
  $targetDir = Join-Path $env:USERPROFILE ".trae\agents"
  $scope = "全局（所有项目可用）"
} else {
  $targetDir = Join-Path (Get-Location) ".trae\agents"
  $scope = "当前项目"
}

New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
$target = Join-Path $targetDir $agentName
Copy-Item -Path $source -Destination $target -Force

Write-Host ""
Write-Host "  [OK] code-test-agent 安装成功" -ForegroundColor Green
Write-Host "  范围 : $scope"
Write-Host "  位置 : $target"
Write-Host ""
Write-Host "  使用方法：在 Trae 中唤起 code-test-agent，直接说「帮我测试这段代码」「做接口测试」「跑 E2E」等。" -ForegroundColor Cyan
Write-Host ""
