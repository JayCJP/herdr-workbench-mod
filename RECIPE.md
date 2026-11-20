# workbench — 重建说明

给 Agent 看的简要说明：从零重建这个 mod。

## 目标

在 Herdr 标签栏的 `+` 按钮后面加一个「工作台」按钮，点击用默认浏览器打开 `http://localhost:5432`。

## 已知约束

- Herdr mod 用 `gpui-kit` 声明式 API（`div()`、`h_flex()`、`svg()`），没有 DOM，不能直接内嵌 webview/iframe/HTML。
- 官方 `tabs` mod 每次启动会被还原，不能原地改；必须克隆为 `tabs-workbench` 并改布局引用。

## 步骤

1. 复制官方 `mods/tabs/main.js` 到 `mods/tabs-workbench/main.js`，`mod.json` 设为 `{ "place": "none", "title": "Tabs" }`。
2. 在 `main.js` 的 `herdr` import 中追加 `exec, notify`。
3. 在 `Tabs extends View` 里新增方法（JSDoc + async/await + try/catch）：
   - `async openWorkbench(url)`：按 `window().platform` 分别 `exec("cmd", ["/c","start","",url])`（windows）、`exec("open",[url])`（macos）、`exec("xdg-open",[url])`（linux）；catch 里 `notify(...)`。
4. 在 `render()` 的 `tab-new` 按钮之后插入「工作台」按钮：
   - `h_flex().id("workbench-btn").h(26).px(8).gap(5)...`
   - 子元素：`svg("mods/tabs-workbench/workbench.svg").size(14)` + 文本 `"工作台"`
   - `on_click(() => this.openWorkbench("http://localhost:5432"))`
5. 画一个 `workbench.svg`：24x24 viewBox，`stroke="currentColor"` 的 layout-dashboard 图标。
6. 运行 `herdr-app check mods/tabs-workbench` 确认通过。
7. 活动时把布局（默认 `main-git-filetree`）里 `tabs` 块的 `content.mod` 改为 `tabs-workbench`。

## 验收

- `herdr-app check mods/tabs-workbench` 通过；
- 标签栏出现带图标的「工作台」按钮；
- 点击后默认浏览器打开 `http://localhost:5432`；
- `herdr-app status` 的 `errors` 为空。
