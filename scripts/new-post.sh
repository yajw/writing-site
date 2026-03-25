#!/bin/bash
# 用法: ./scripts/new-post.sh "文章标题" [tag1,tag2,...]
# 示例: ./scripts/new-post.sh "我的第一篇文章" "Go,Hugo"

WRITING_DIR="${WRITING_DIR:-$HOME/Developer/github/yajw/writing/posts}"

TITLE="$1"
TAGS="$2"

if [ -z "$TITLE" ]; then
  read -rp "请输入文章标题: " TITLE
fi

if [ -z "$TITLE" ]; then
  echo "标题不能为空"
  exit 1
fi

DATE=$(date +%Y-%m-%d)
# 空格转短横线，保留中文和英文数字
SLUG=$(echo "$TITLE" | sed 's/ /-/g; s/^-//; s/-$//')
FILENAME="${DATE}-${SLUG}.md"
FILEPATH="${WRITING_DIR}/${FILENAME}"

mkdir -p "$WRITING_DIR"

if [ -f "$FILEPATH" ]; then
  echo "文件已存在: $FILEPATH"
  open -a "Typora" "$FILEPATH"
  exit 0
fi

# 生成 tags YAML 数组
TAG_YAML=""
if [ -n "$TAGS" ]; then
  TAG_YAML="tags:"
  IFS=',' read -ra TAG_ARRAY <<< "$TAGS"
  for tag in "${TAG_ARRAY[@]}"; do
    tag=$(echo "$tag" | xargs)  # trim spaces
    TAG_YAML="${TAG_YAML}\n  - \"${tag}\""
  done
else
  TAG_YAML="tags: []"
fi

cat > "$FILEPATH" << EOF
---
title: "${TITLE}"
date: ${DATE}
draft: true
$(echo -e "$TAG_YAML")
---

EOF

echo "已创建: $FILEPATH"
open -a "Typora" "$FILEPATH"
