#!/bin/bash
# 生成周报脚本

PROJECT_DIR="/home/jason/.openclaw/workspace-trader/projects/computer-history"
cd $PROJECT_DIR

TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
WEEK_NUMBER=$(date +%V)
YEAR=$(date +%Y)

echo "生成第 $WEEK_NUMBER 周报告 ($YEAR)..."

# 获取本周的提交
WEEK_START=$(date -d "monday" +%Y-%m-%d 2>/dev/null || date +%Y-%m-%d)

# 生成报告
REPORT_FILE="reports/weekly-report-${YEAR}-W${WEEK_NUMBER}.md"
mkdir -p reports

cat > $REPORT_FILE << EOF
# 计算机历史网站 - 周报告

**周次：** 第 $WEEK_NUMBER 周 ($YEAR)
**生成时间：** $TIMESTAMP

## 本周更新

$(git log --since="1 week ago" --oneline 2>/dev/null || echo "无更新记录")

## 统计数据

- 总提交数：$(git rev-list --count HEAD 2>/dev/null || echo 'N/A')
- 页面数量：$(ls pages/*.html 2>/dev/null | wc -l)
- CSS 文件：$(ls css/*.css 2>/dev/null | wc -l)

## 下周计划

- [ ] 检查内容完整性
- [ ] 添加新的历史事件
- [ ] 优化页面性能

---
报告自动生成 | Computer History Project
EOF

echo "周报已生成：$REPORT_FILE"

# 提交报告
git add reports/
git commit -m "docs: 生成周报 ($YEAR-W${WEEK_NUMBER})" || echo "No changes"
git push origin main

echo "周报生成完成"
