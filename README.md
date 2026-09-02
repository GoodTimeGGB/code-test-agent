# code-test-agent · 代码测试智能体

一个自包含的 **测试流程编排专家** 智能体。你只需说"帮我测试代码"，它会自动识别测试类型、调度底层测试技能、跑完全流程并给出结构化报告。

仓库地址：**https://github.com/GoodTimeGGB/code-test-agent**

覆盖三类测试：

| 测试类型 | 适用场景 | 底层技能 |
|---------|---------|---------|
| **UI 测试（E2E）** | 页面功能、端到端流程、用户交互 | test-case-generator → test-case-runner |
| **接口测试（API）** | Controller、REST API、后端契约 | test-api-runner |
| **单元测试（Unit）** | Service/Mapper 逻辑、覆盖率 | test-unit-runner |

---

## 支持的工具

本智能体本质是一个「Markdown + YAML frontmatter」文件，凡是支持自定义子代理 / 智能体的 AI 编码工具均可安装使用：

| 工具 | 项目级目录 | 全局目录 | 智能体文件扩展名 |
|------|-----------|---------|----------------|
| **Trae** | `<项目>/.trae/agents/` | `~/.trae/agents/` | `.agent.md` |
| **CodeBuddy Code** | `<项目>/.codebuddy/agents/` | `~/.codebuddy/agents/` | `.md` |
| **Claude Code** | `<项目>/.claude/agents/` | `~/.claude/agents/` | `.md` |
| 其他（Cursor 等） | 参见各工具官方文档的 `agents/` 目录 | 同左 | `.md` / `.agent.md` |

> **⚠️ 技能依赖说明（重要）**：智能体编排调用的四个测试技能（test-case-generator / test-case-runner / test-api-runner / test-unit-runner）为 **Trae 环境下的技能**。在 Trae 中开箱即用；在 CodeBuddy、Claude Code 等其他工具中使用时，智能体的**编排逻辑与测试用例规范可复用**，但需确保对应工具中已存在同等能力的测试技能，否则只能完成"用例设计"，无法自动执行与出报告。

---

## 前置条件

- 已安装 **Trae**（或 **CodeBuddy Code** / **Claude Code** 等其他支持自定义子代理的工具）
- **Windows**：PowerShell 5.1+，或 Git Bash / WSL（用于 shell 脚本）
- **macOS / Linux**：bash + `curl` 或 `wget`
- 目标项目已可正常构建运行（接口 / 单元测试需后端环境；UI 测试需可访问页面或 Playwright 环境）

---

## ⚡ 方式一：复制一句话给 AI 自动安装（跨平台通用）

在 **Trae / CodeBuddy / Claude Code 等任意 AI Agent 对话框**里，直接粘贴下面这句话并发送，AI 会自动完成下载与安装：

```
请帮我安装 code-test-agent 智能体：执行 `curl -fsSL https://raw.githubusercontent.com/GoodTimeGGB/code-test-agent/main/install.sh | bash`，安装到当前项目的 .trae/agents 目录，装完告诉我怎么用。
```

> 想装成**全局**（所有项目可用），把命令末尾换成 `| bash -s -- --global`。
>
> 本仓库同时提供 Windows 与 macOS 双脚本，见下方「方式二」；「方式一」改用 bash 版是为了让 AI 在任意操作系统上都能自动执行同一句指令。

---

## 🖥️ 方式二：终端一键安装

### Windows（PowerShell）

打开 PowerShell（在目标项目根目录执行），运行：

```powershell
# 安装到当前项目
iex (irm https://raw.githubusercontent.com/GoodTimeGGB/code-test-agent/main/install.ps1)

# 安装到全局（所有项目可用）
$env:CTA_GLOBAL='1'; iex (irm https://raw.githubusercontent.com/GoodTimeGGB/code-test-agent/main/install.ps1)
```

### macOS / Linux（bash）

打开终端（在目标项目根目录执行），运行：

```bash
# 安装到当前项目
curl -fsSL https://raw.githubusercontent.com/GoodTimeGGB/code-test-agent/main/install.sh | bash

# 安装到全局（所有项目可用）
curl -fsSL https://raw.githubusercontent.com/GoodTimeGGB/code-test-agent/main/install.sh | bash -s -- --global
```

> 公司网络若访问 GitHub 受限，可在 raw 链接前加镜像前缀，例如 `https://ghproxy.com/https://raw.githubusercontent.com/...`。

---

## 📦 方式三：克隆仓库本地安装

```bash
git clone https://github.com/GoodTimeGGB/code-test-agent.git
cd code-test-agent
```

### Windows（PowerShell）

```powershell
powershell -ExecutionPolicy Bypass -File install.ps1           # 项目级
powershell -ExecutionPolicy Bypass -File install.ps1 -Global    # 全局
```

### macOS / Linux（bash）

```bash
./install.sh            # 项目级
./install.sh --global   # 全局
```

---

## 📄 方式四：手动安装（多工具通用）

以 Trae 为例；改用 CodeBuddy / Claude Code 时，把目录与扩展名替换为上方「支持的工具」表中的对应值即可。

### Windows / macOS 通用步骤

1. 下载 `code-test-agent.agent.md` 文件：
   ```bash
   curl -fsSL -o code-test-agent.agent.md https://raw.githubusercontent.com/GoodTimeGGB/code-test-agent/main/code-test-agent.agent.md
   ```
2. 放入对应目录：

   | 工具 | 项目级路径 | 全局路径 |
   |------|-----------|---------|
   | Trae | `<项目>/.trae/agents/code-test-agent.agent.md` | `~/.trae/agents/code-test-agent.agent.md` |
   | CodeBuddy | `<项目>/.codebuddy/agents/code-test-agent.md` | `~/.codebuddy/agents/code-test-agent.md` |
   | Claude Code | `<项目>/.claude/agents/code-test-agent.md` | `~/.claude/agents/code-test-agent.md` |

   - **Windows** 下 `~` 即 `C:\Users\<你的用户名>`；手动创建目录可用：
     ```powershell
     New-Item -ItemType Directory -Force -Path .\.trae\agents
     ```
   - **macOS / Linux** 下 `~` 即 `/Users/<用户名>` 或 `/home/<用户名>`；执行：
     ```bash
     mkdir -p .trae/agents
     ```

3. 重启 / 重新加载对应工具窗口，智能体即生效。

> 若拷贝到 CodeBuddy / Claude Code，需将其扩展名改为 `.md`（如 `code-test-agent.md`）。

---

## 使用

在工具中唤起 **code-test-agent**，用自然语言描述即可：

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
2. 调用对应技能生成测试用例
3. UI 测试在用例生成后会先请你确认；接口/单元测试由技能内部处理确认
4. 真实执行测试，输出通过率 / 覆盖率 / 失败项等结构化报告

---

## 测试用例示例

以下示例展示三类测试各自的输入与预期产物，帮助你快速上手判断"该怎么问、会得到什么"。

### 1. 单元测试（Unit）

**输入：**

```
帮我对 src/services/order.service.ts 的 createOrder 方法写单元测试，覆盖正常下单、库存不足、参数非法三种情况。
```

**产出（用例矩阵节选）：**

| 编号 | 测试方法 | 输入 | 预期结果 | 覆盖分支 |
|------|---------|------|---------|---------|
| UT-01 | shouldCreateOrderSuccessfully | 合法订单参数 | 返回订单对象，状态为 CREATED | 主流程 |
| UT-02 | shouldFailWhenStockInsufficient | 库存为 0 | 抛出 InsufficientStockException | 异常分支 |
| UT-03 | shouldRejectInvalidParams | 金额为负数 | 抛出 IllegalArgumentException | 参数校验 |

执行后额外输出 Jacoco 覆盖率报告；若行覆盖率 < 80%，报告中会标注 **⚠️ 覆盖率达标失败**。

### 2. 接口测试（API）

**输入：**

```
测一下用户登录接口，Controller 在 src/controllers/auth.controller.ts，包括成功、密码错误、账号不存在三种场景。
```

**产出（用例表格 + 可执行性分级）：**

| 编号 | 接口 | 方法 | 请求示例 | 期望响应 | 可执行性 |
|------|------|------|---------|---------|---------|
| API-01 | /api/auth/login | POST | `{username, password}` 正确 | 200 + token | A（可自动执行） |
| API-02 | /api/auth/login | POST | 密码错误 | 401 + 错误码 | A（可自动执行） |
| API-03 | /api/auth/login | POST | 账号不存在 | 404 + 错误码 | B（需预置数据） |

执行后生成 Postman Collection JSON，并全量执行所有用例；每个用例标注 **A（可直接跑）/ B（需预置）/ C（需人工）** 分级。

### 3. UI 测试（E2E）

**输入：**

```
对这个页面的下单流程跑一遍 E2E，重点验证：加入购物车 → 结算 → 支付成功跳转。
```

**产出（7 列标准用例表）：**

| 编号 | 用例名称 | 前置条件 | 操作步骤 | 预期结果 | 优先级 | 备注 |
|------|---------|---------|---------|---------|--------|------|
| E2E-01 | 加入购物车 | 已登录 | 点击商品 → 点"加入购物车" | 购物车角标 +1 | P0 | — |
| E2E-02 | 提交订单 | 购物车有商品 | 点"去结算"→ 填写地址 | 生成待支付订单 | P0 | — |
| E2E-03 | 支付成功跳转 | 有待支付订单 | 完成支付 | 跳转成功页 | P1 | 需测试环境 |

> 注意：UI 测试采用两阶段——先生成用例表并**等你确认**，确认后才开始真实执行并生成报告。

---

## 团队共享（随 Git 提交）

把智能体放进项目 `agents/` 目录并提交仓库，团队成员拉取后即共享同一份测试编排规范：

```
your-project/
└── .trae/
    └── agents/
        └── code-test-agent.agent.md
```

> 改用 CodeBuddy / Claude Code 时，对应为 `.codebuddy/agents/`、`.claude/agents/`。

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
# Windows（Trae 为例）
Remove-Item .\.trae\agents\code-test-agent.agent.md           # 项目级
Remove-Item "$env:USERPROFILE\.trae\agents\code-test-agent.agent.md"  # 全局级
```

```bash
# macOS / Linux（Trae 为例）
rm .trae/agents/code-test-agent.agent.md           # 项目级
rm ~/.trae/agents/code-test-agent.agent.md         # 全局级
```