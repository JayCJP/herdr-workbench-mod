#!/usr/bin/env bash
# 安装 herdr-workbench mod：拷贝到 Herdr 配置目录，改活动布局指向它，并校验。
set -e

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
SRC="$REPO_DIR/mods/tabs-workbench"

# 兼容 $HERDR_APP_HOME；否则用默认配置目录
APP_HOME="${HERDR_APP_HOME:-$HOME/.config/herdr-app}"
DST="$APP_HOME/mods/tabs-workbench"
LAYOUTS="$APP_HOME/layouts"

if ! command -v herdr-app >/dev/null 2>&1; then
  echo "错误：找不到 herdr-app 命令，请先安装 Herdr 并确保它在 PATH 中。" >&2
  exit 1
fi

# 1. 拷贝 mod
mkdir -p "$APP_HOME/mods"
if [ -d "$DST" ]; then
  echo "已存在 $DST，先备份为 ${DST}.bak"
  rm -rf "${DST}.bak"
  mv "$DST" "${DST}.bak"
fi
cp -R "$SRC" "$DST"
echo "已复制 mod 到 $DST"

# 2. 找到活动布局并改 tabs 块的 mod 引用
STATUS="$(herdr-app status 2>/dev/null || true)"
LAYOUT_NAME="$(printf '%s' "$STATUS" | grep -o '"layout"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | cut -d'"' -f4)"
if [ -z "$LAYOUT_NAME" ]; then
  echo "无法从 herdr-app status 读取活动布局，跳过布局修改。" >&2
  echo "请按 README 手动把活动布局中 tabs 块的 content.mod 改为 tabs-workbench。" >&2
else
  LAYOUT_FILE="$LAYOUTS/$LAYOUT_NAME.json"
  if [ ! -f "$LAYOUT_FILE" ]; then
    echo "找不到布局文件 $LAYOUT_FILE，跳过布局修改。" >&2
  else
    cp "$LAYOUT_FILE" "$LAYOUT_FILE.bak"
    # 用 python 精确改 JSON，避免正则误伤
    python - "$LAYOUT_FILE" <<'PY'
import json, sys
path = sys.argv[1]
with open(path, encoding='utf-8') as f:
    data = json.load(f)
def walk(node):
    if node.get('id') == 'tabs' and isinstance(node.get('content'), dict):
        node['content']['mod'] = 'tabs-workbench'
        return True
    for child in node.get('children', []):
        if walk(child):
            return True
    return False
if not walk(data):
    raise SystemExit('布局中没有找到 id=tabs 的块')
with open(path, 'w', encoding='utf-8', newline='') as f:
    json.dump(data, f, ensure_ascii=False, separators=(',', ':'))
print('已更新活动布局:', path)
PY
  fi
fi

# 3. 校验
herdr-app check "$DST"
echo "安装完成。布局为热加载，标签栏应出现「工作台」按钮。"
