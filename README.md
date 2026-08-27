# code-test-agent · 代码测试智能体

一个自包含的 Trae 智能体：**测试流程编排专家**。你只需说"帮我测试代码"，它会自动识别测试类型、调度内置测试技能、跑完全流程并给出结构化报告。

仓库地址：**https://github.com/GoodTimeGGB/code-test-agent**

覆盖三类测试：

| 测试类型 | 适用场景 | 底层技能 |
|---------|---------|---------|
| **UI 测试（E2E）** | 页面功能、端到端流程、用户交互 | test-case-generator → test-case-runner |
| **接口测试（API）** | Controller、REST API、后端契约 | test-api-runner |
| **单元测试（Unit）** | Service/Mapper 逻辑、覆盖率 | test-unit-runner |

> 这四个技能是 Trae **内置技能**，随 Trae 提供，无需额外下载。本智能体只是"指挥官"，安装一个文件即可。

---

## ⚡ 最快：复制一句话给 AI 自动安装

在 **Trae / 任意 AI Agent 对话框**里，直接粘贴下面这句话并发送，AI 会自动完成下载安装：

```
请帮我安装 code-test-agent 智能体：用 PowerShell 执行 `iex (irm https://raw.githubusercontent.com/GoodTimeGGB/code-test-agent/main/install.ps1)`，安装到当前项目的 .trae/agents 目录，装完告诉我怎么用。
```

> 想装成**全局**（所有项目可用），把命令换成：
> `$g=1; iex (irm https://raw.githubusercontent.com/GoodTimeGGB/code-test-agent/main/install.ps1) -Global`

---

## 🖥️ 方式二：终端一键安装

### Windows（PowerShell）

```powershell
# 安装到当前项目
iex (irm https://raw.githubusercontent.com/GoodTimeGGB/code-test-agent/main/install.ps1)

# 安装到全局（所有项目可用）
$g=1; iex (irm https://raw.githubusercontent.com/GoodTimeGGB/code-test-agent/main/install.ps1) -Global
```

### macOS / Linux（bash）

```bash
# 安装到当前项目
curl -fsSL https://raw.githubusercontent.com/GoodTimeGGB/code-test-agent/main/install.sh | bash

# 安装到全局
curl -fsSL https://raw.githubusercontent.com/GoodTimeGGB/code-test-agent/main/install.sh | bash -s -- --global
```

> 公司网络若访问 GitHub 受限，可在 raw 链接前加镜像前缀，例如 `https://ghproxy.com/https://raw.githubusercontent.com/...`。

---

## 📦 方式三：克隆仓库本地安装

```bash
git clone https://github.com/GoodTimeGGB/code-test-agent.git
cd code-test-agent

# Windows
powershell -ExecutionPolicy Bypass -File install.ps1        # 项目级
powershell -ExecutionPolicy Bypass -File install.ps1 -Global # 全局

# macOS / Linux
./install.sh            # 项目级
./install.sh --global   # 全局
```

### 手动安装

直接把 `code-test-agent.agent.md` 复制到任一位置：

- 项目级：`<你的项目>/.trae/agents/code-test-agent.agent.md`（随项目走，团队共享）
- 全局级：`~/.trae/agents/code-test-agent.agent.md`（所有项目可用）

安装后重新加载 Trae 窗口，智能体即生效。

---

## 使用

在 Trae 中唤起 **code-test-agent**，用自然语言描述即可：

```
帮我对 src/services/order.service.ts 写单元测试
```
```
测一下用户登录的接口，Controller 在 src/controllers/auth.controller.ts
```
```
对这个页面跑一遍 E2E，重点验证下单流程
```

智能体会：
1. 自动判定测试类型（类型不明会先问你）
2. 调用对应内置技能生成测试用例
3. UI 测试在用例生成后会先请你确认；接口/单元测试由技能内部处理确认
4. 真实执行测试，输出通过率 / 覆盖率 / 失败项等结构化报告

---

## 团队共享（随 Git 提交）

把智能体放进项目 `.trae/agents/` 并提交仓库，团队成员拉取后即共享同一份测试编排规范：

```
your-project/
└── .trae/
    └── agents/
        └── code-test-agent.agent.md
```

---

## 仓库文件说明

```
code-test-agent/
├── code-test-agent.agent.md   # 智能体定义（核心，唯一必需文件）
├── install.ps1                # Windows 安装脚本（支持远程一键安装）
├── install.sh                 # macOS / Linux 安装脚本（支持远程一键安装）
└── README.md                  # 本说明
```

---

## 卸载

删除对应的智能体文件即可：

```powershell
Remove-Item .\.trae\agents\code-test-agent.agent.md          # 项目级
Remove-Item "$env:USERPROFILE\.trae\agents\code-test-agent.agent.md"  # 全局级
```
