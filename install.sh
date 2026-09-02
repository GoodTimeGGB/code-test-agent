#!/usr/bin/env bash
# 安装 code-test-agent（代码测试智能体 + 测试技能）到 Trae。支持本地与远程一键安装。
#
# 用法：
#   本地运行：
#     ./install.sh              安装到当前项目 ./.trae/
#     ./install.sh --global     安装到全局 ~/.trae/（所有项目可用）
#
#   远程一键安装：
#     curl -fsSL https://raw.githubusercontent.com/GoodTimeGGB/code-test-agent/main/install.sh | bash
#     curl -fsSL https://raw.githubusercontent.com/GoodTimeGGB/code-test-agent/main/install.sh | bash -s -- --global

set -euo pipefail

AGENT_NAME="code-test-agent.agent.md"
RAW_BASE="https://raw.githubusercontent.com/GoodTimeGGB/code-test-agent/main"
SKILL_NAMES=(test-case-generator test-case-runner test-api-runner test-unit-runner)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd || true)"

# 1. 确定安装根目录
if [ "${1:-}" = "--global" ] || [ "${1:-}" = "-g" ]; then
  TARGET_ROOT="$HOME/.trae"
  SCOPE="全局（所有项目可用）"
else
  TARGET_ROOT="$(pwd)/.trae"
  SCOPE="当前项目"
fi

AGENT_DIR="$TARGET_ROOT/agents"
SKILLS_DIR="$TARGET_ROOT/skills"
mkdir -p "$AGENT_DIR" "$SKILLS_DIR"

# 2. 安装智能体定义文件：优先本地，否则从 GitHub 下载
LOCAL_FILE=""
if [ -n "$SCRIPT_DIR" ] && [ -f "$SCRIPT_DIR/$AGENT_NAME" ]; then
  LOCAL_FILE="$SCRIPT_DIR/$AGENT_NAME"
fi

if [ -n "$LOCAL_FILE" ]; then
  cp "$LOCAL_FILE" "$AGENT_DIR/$AGENT_NAME"
else
  echo "本地未找到 $AGENT_NAME，正在从 GitHub 下载..."
  TMP="$(mktemp -d)/$AGENT_NAME"
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$RAW_BASE/$AGENT_NAME" -o "$TMP"
  elif command -v wget >/dev/null 2>&1; then
    wget -qO "$TMP" "$RAW_BASE/$AGENT_NAME"
  else
    echo "错误：需要 curl 或 wget 来下载智能体文件。"
    exit 1
  fi
  cp "$TMP" "$AGENT_DIR/$AGENT_NAME"
fi

# 3. 安装技能：优先本地 skills/ 目录，否则逐个从 GitHub 下载 SKILL.md
if [ -n "$SCRIPT_DIR" ] && [ -d "$SCRIPT_DIR/skills" ]; then
  cp -R "$SCRIPT_DIR/skills/." "$SKILLS_DIR/"
else
  for name in "${SKILL_NAMES[@]}"; do
    mkdir -p "$SKILLS_DIR/$name"
    echo "正在下载技能 $name ..."
    if command -v curl >/dev/null 2>&1; then
      curl -fsSL "$RAW_BASE/skills/$name/SKILL.md" -o "$SKILLS_DIR/$name/SKILL.md"
    elif command -v wget >/dev/null 2>&1; then
      wget -qO "$SKILLS_DIR/$name/SKILL.md" "$RAW_BASE/skills/$name/SKILL.md"
    else
      echo "错误：需要 curl 或 wget 来下载技能文件。"
      exit 1
    fi
  done
fi

echo ""
echo "  [OK] code-test-agent 安装成功"
echo "  范围   : $SCOPE"
echo "  智能体 : $AGENT_DIR/$AGENT_NAME"
echo "  技能   : $SKILLS_DIR"
echo ""
echo "  使用方法：在 Trae 中唤起 code-test-agent，直接说「帮我测试这段代码」「做接口测试」「跑 E2E」等。"
echo ""