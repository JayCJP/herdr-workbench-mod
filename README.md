# workbench — Herdr 标签栏「工作台」入口

在 Herdr 顶部标签栏（`+` 按钮右侧）新增一个 **工作台** 按钮，点击后用系统默认浏览器打开 `http://localhost:5432`。

## 它是怎么工作的

- 官方 `tabs` mod 是 shipped mod，每次启动会被还原，所以不能直接改它。
- 本项目克隆了 `tabs` mod 为 `tabs-workbench`，加了「工作台」按钮与 `openWorkbench()` 方法。
- 安装时需要把当前活动布局里 `tabs` 块的 `content.mod` 从 `"tabs"` 改成 `"tabs-workbench"`。
- Mod 本身不能内嵌网页（Herdr 官方限制），因此点击是**调用默认浏览器**打开 URL。

> 想改地址？编辑 `mods/tabs-workbench/main.js` 里 `openWorkbench("http://localhost:5432")` 的 URL 即可。

## 安装

### 一句话让 Agent 安装（推荐）

在 Herdr 里把下面这段发给你的 Agent：

```text
Read ~/.config/herdr-app/AGENTS.md, then install this mod:
https://github.com/<你的用户名>/herdr-workbench-mod
```

### 脚本安装（手动）

```sh
git clone https://github.com/<你的用户名>/herdr-workbench-mod.git
cd herdr-workbench-mod
./install.sh
```

脚本会：
1. 把 `mods/tabs-workbench/` 拷到 `~/.config/herdr-app/mods/`
2. 备份活动布局（`*.bak`）并把 `tabs` 块的 mod 改成 `tabs-workbench`
3. 运行 `herdr-app check` 校验

### 手工安装

1. 把 `mods/tabs-workbench/` 整个目录拷到 `~/.config/herdr-app/mods/`（Windows：`C:\Users\<你>\.config\herdr-app\mods\`）。
2. 运行 `herdr-app check ~/.config/herdr-app/mods/tabs-workbench`，应显示 `check passed`。
3. 编辑 `~/.config/herdr-app/layouts/` 下你正在用的布局（用 `herdr-app status` 看 `layout` 字段），把 `id` 为 `tabs` 的块中 `content.mod` 改为 `tabs-workbench`（先备份）。
4. 布局是热加载的，保存后标签栏就会出现「工作台」按钮。

## 卸载

1. 删除 `~/.config/herdr-app/mods/tabs-workbench/`；
2. 把布局的 `tabs` 块 `content.mod` 改回 `"tabs"`，或用安装时留下的 `*.bak` 恢复。

## 兼容性

- Herdr app（gpui-shell），macOS / Linux / Windows。
- 依赖自带：`gpui-kit`、`gpui-base`、`herdr`（由 Herdr 运行时提供）。
- 打开 URL 用平台命令：Windows `cmd /c start`、macOS `open`、Linux `xdg-open`。

## 许可

MIT
