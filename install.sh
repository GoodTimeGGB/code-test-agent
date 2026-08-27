#!/usr/bin/env bash
# 安装 code-test-agent（代码测试智能体）到 Trae。支持本地与远程一键安装。
#
# 用法：
#   本地运行：
#     ./install.sh              安装到当前项目 ./.trae/agents/
#     ./install.sh --global     安装到全局 ~/.trae/agents/（所有项目可用）
#
#   远程一键安装：
#     curl -fsSL https://raw.githubusercontent.com/GoodTimeGGB/code-test-agent/main/install.sh | bash
#     curl -fsSL https://raw.githubusercontent.com/GoodTimeGGB/code-test-agent/main/install.sh | bash -s -- --global

set -euo pipefail

AGENT_NAME="code-test-agent.agent.md"
RAW_URL="https://raw.githubusercontent.com/GoodTimeGGB/code-test-agent/main/$AGENT_NAME"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd || true)"
LOCAL_FILE=""
if [ -n "$SCRIPT_DIR" ] && [ -f "$SCRIPT_DIR/$AGENT_NAME" ]; then
  LOCAL_FILE="$SCRIPT_DIR/$AGENT_NAME"
fi

# 1. 定位智能体定义文件：优先本地，否则从 GitHub 下载
if [ -n "$LOCAL_FILE" ]; then
  SRC="$LOCAL_FILE"
else
  echo "本地未找到 $AGENT_NAME，正在从 GitHub 下载..."
  TMP="$(mktemp -d)/$AGENT_NAME"
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$RAW_URL" -o "$TMP"
  elif command -v wget >/dev/null 2>&1; then
    wget -qO "$TMP" "$RAW_URL"
  else
    echo "错误：需要 curl 或 wget 来下载智能体文件。"
    exit 1
  fi
  SRC="$TMP"
fi

# 2. 确定安装目录
if [ "${1:-}" = "--global" ] || [ "${1:-}" = "-g" ]; then
  TARGET_DIR="$HOME/.trae/agents"
  SCOPE="全局（所有项目可用）"
else
  TARGET_DIR="$(pwd)/.trae/agents"
  SCOPE="当前项目"
fi

mkdir -p "$TARGET_DIR"
cp "$SRC" "$TARGET_DIR/$AGENT_NAME"

echo ""
echo "  [OK] code-test-agent 安装成功"
echo "  范围 : $SCOPE"
echo "  位置 : $TARGET_DIR/$AGENT_NAME"
echo ""
echo "  使用方法：在 Trae 中唤起 code-test-agent，直接说「帮我测试这段代码」「做接口测试」「跑 E2E」等。"
echo ""
