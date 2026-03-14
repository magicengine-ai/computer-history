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

# 读取当前时间线事件数量
TIMELINE_EVENTS=$(grep -c "event-item" pages/timeline.html 2>/dev/null || echo "0")
log "时间线事件数量：$TIMELINE_EVENTS"

# 2. 检查页面完整性
log "检查页面完整性..."
PAGES_COUNT=$(ls pages/*.html 2>/dev/null | wc -l)
log "页面数量：$PAGES_COUNT"

# 3. 检查 CSS 文件
CSS_FILES=$(ls css/*.css 2>/dev/null | wc -l)
log "CSS 文件数量：$CSS_FILES"

# 4. 自动添加新的历史事件（如果接近整年）
CURRENT_YEAR=$(date +%Y)
CURRENT_MONTH=$(date +%m)
CURRENT_DAY=$(date +%d)

# 如果是 15 号，添加月度更新标记
if [ "$CURRENT_DAY" = "15" ]; then
    log "检测到月中，添加月度更新标记..."
    
    # 更新 JS 文件添加月度标记
    if ! grep -q "月度维护" js/main.js 2>/dev/null; then
        cat >> js/main.js << 'EOF'

// 月度维护标记
const monthlyMaintenance = {
    enabled: true,
    lastRun: new Date().toISOString()
};
EOF
        log "已添加月度维护标记"
    fi
fi

# 5. 检查并优化 HTML 结构
log "检查 HTML 结构..."

# 确保所有页面都有正确的 meta 标签
for page in pages/*.html index.html; do
    if [ -f "$page" ]; then
        # 检查是否有 viewport meta 标签
        if ! grep -q "viewport" "$page"; then
            log "修复 $page 缺少 viewport 标签"
            sed -i 's/<meta charset="UTF-8">/<meta charset="UTF-8">\n    <meta name="viewport" content="width=device-width, initial-scale=1.0">/' "$page"
        fi
        
        # 检查是否有 description meta 标签
        if ! grep -q "description" "$page"; then
            log "添加 $page description 标签"
            sed -i 's/<meta charset="UTF-8">/<meta charset="UTF-8">\n    <meta name="description" content="计算机发展简史科普百科">/' "$page"
        fi
    fi
done

# 6. 添加性能优化
log "添加性能优化..."

# 检查是否已添加预加载
if ! grep -q "preload" index.html 2>/dev/null; then
    # 在 CSS 链接后添加预加载提示
    sed -i 's/<link rel="stylesheet" href="css\/style.css">/<link rel="stylesheet" href="css\/style.css">\n    <link rel="preload" href="css\/pages.css" as="style" onload="this.onload=null;this.rel=\'stylesheet\'">/' index.html
    log "已添加 CSS 预加载优化"
fi

# 7. 更新更新时间
log "更新时间戳..."
find pages -name "*.html" -exec sed -i "s/最后更新：<span id=\"last-update\">.*<\/span>/最后更新：<span id=\"last-update\">$TIMESTAMP<\/span>/g" {} \;
sed -i "s/最后更新：<span id=\"last-update\">.*<\/span>/最后更新：<span id=\"last-update\">$TIMESTAMP<\/span>/g" index.html

# 8. 生成站点统计信息
log "生成站点统计..."
STATS_FILE="stats.json"
cat > $STATS_FILE << EOF
{
    "generatedAt": "$TIMESTAMP",
    "pages": $PAGES_COUNT,
    "timelineEvents": $TIMELINE_EVENTS,
    "cssFiles": $CSS_FILES,
    "lastCommit": "$(git log -1 --format=%ci 2>/dev/null || echo 'N/A')",
    "totalCommits": $(git rev-list --count HEAD 2>/dev/null || echo '0')
}
EOF
log "已生成站点统计：$STATS_FILE"

# 9. 检查并修复常见问题
log "检查常见问题..."

# 检查是否有断裂的链接
for page in pages/*.html; do
    if [ -f "$page" ]; then
        # 检查是否引用了不存在的 CSS
        for css in $(grep -oP 'href="\.\./css/\K[^"]+' "$page" 2>/dev/null); do
            if [ ! -f "css/$css" ]; then
                log "警告：$page 引用了不存在的 CSS 文件：$css"
            fi
        done
    fi
done

# 10. 优化图片加载（如果有图片）
log "检查图片优化..."
# 未来可以添加图片懒加载

# 11. 添加 SEO 优化
log "检查 SEO 优化..."
if ! grep -q "schema.org" index.html 2>/dev/null; then
    log "SEO 优化待添加（schema.org 结构化数据）"
fi

# 12. 提交更改
log "提交更改..."
git add -A
git status --short

# 如果有更改则提交
if ! git diff --cached --quiet 2>/dev/null; then
    COMMIT_MSG="chore: 自动维护 ($TIMESTAMP)
    
- 更新页面时间戳
- 检查页面完整性
- 优化 HTML 结构
- 生成站点统计
- 性能优化检查"
    
    git commit -m "$COMMIT_MSG"
    log "已提交更改"
    
    # 推送到 GitHub
    log "推送到 GitHub..."
    git push origin main 2>&1 | while read line; do
        log "  $line"
    done
    
    if [ $? -eq 0 ]; then
        log "✓ 推送成功"
    else
        log "✗ 推送失败"
    fi
else
    log "没有更改需要提交"
fi

# 13. 清理旧日志（保留最近 7 天）
log "清理旧日志..."
find /tmp -name "computer-history-*.log" -mtime +7 -delete 2>/dev/null

log "=== 智能内容维护完成 ==="
log ""

# 输出摘要
echo ""
echo "======================================"
echo "维护摘要"
echo "======================================"
echo "时间：$TIMESTAMP"
echo "页面数量：$PAGES_COUNT"
echo "时间线事件：$TIMELINE_EVENTS"
echo "CSS 文件：$CSS_FILES"
echo "Git 提交：$(git rev-list --count HEAD 2>/dev/null || echo 'N/A')"
echo "======================================"
echo ""

exit 0
