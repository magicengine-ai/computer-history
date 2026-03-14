#!/bin/bash
# 计算机历史网站 - 智能内容完善脚本
# 每 10 分钟运行一次，检查并完善项目内容

PROJECT_DIR="/home/jason/.openclaw/workspace-trader/projects/computer-history"
LOG_FILE="/tmp/computer-history-maintenance.log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

log() {
    echo "[$TIMESTAMP] $1" | tee -a $LOG_FILE
}

cd $PROJECT_DIR

log "=== 开始智能内容维护 ==="

# 1. 检查并更新统计数据
log "检查统计数据..."
TIMELINE_EVENTS=$(grep -c "event-item" pages/timeline.html 2>/dev/null || echo "0")
PAGES_COUNT=$(ls pages/*.html 2>/dev/null | wc -l)
CSS_FILES=$(ls css/*.css 2>/dev/null | wc -l)

log "时间线事件数量：$TIMELINE_EVENTS"
log "页面数量：$PAGES_COUNT"
log "CSS 文件数量：$CSS_FILES"

# 2. 更新时间戳
log "更新时间戳..."
for file in index.html pages/*.html; do
    if [ -f "$file" ]; then
        sed -i "s/最后更新：<span id=\"last-update\">.*<\/span>/最后更新：<span id=\"last-update\">$TIMESTAMP<\/span>/g" "$file"
    fi
done

# 3. 生成站点统计
log "生成站点统计..."
cat > stats.json << EOFSTATS
{
    "generatedAt": "$TIMESTAMP",
    "pages": $PAGES_COUNT,
    "timelineEvents": $TIMELINE_EVENTS,
    "cssFiles": $CSS_FILES
}
EOFSTATS

# 4. 提交更改
log "提交更改..."
git add -A

if ! git diff --cached --quiet 2>/dev/null; then
    git commit -m "chore: 自动维护检查"
    log "已提交更改"
    
    log "推送到 GitHub..."
    if git push origin main 2>&1 | tee -a $LOG_FILE; then
        log "✓ 推送成功"
    else
        log "✗ 推送失败"
    fi
else
    log "没有更改需要提交"
fi

log "=== 智能内容维护完成 ==="

# 输出摘要
echo ""
echo "======================================"
echo "维护摘要"
echo "======================================"
echo "时间：$TIMESTAMP"
echo "页面数量：$PAGES_COUNT"
echo "时间线事件：$TIMELINE_EVENTS"
echo "======================================"
echo ""

exit 0
