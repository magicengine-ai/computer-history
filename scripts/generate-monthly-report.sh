#!/bin/bash
# 生成月报脚本

PROJECT_DIR="/home/jason/.openclaw/workspace-trader/projects/computer-history"
cd $PROJECT_DIR

TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
MONTH=$(date +%m)
YEAR=$(date +%Y)

echo "生成月度报告 ($YEAR-$MONTH)..."

# 生成报告
REPORT_FILE="reports/monthly-report-${YEAR}-${MONTH}.md"
mkdir -p reports

# 获取上月第一天和今天
LAST_MONTH_START=$(date -d "last month" +%Y-%m-01 2>/dev/null || echo "$YEAR-$MONTH-01")

cat > $REPORT_FILE << EOF
# 计算机历史网站 - 月报告

**月份：** $YEAR 年 $MONTH 月
**生成时间：** $TIMESTAMP

## 本月更新

### 内容更新
$(git log --since="$LAST_MONTH_START" --oneline 2>/dev/null || echo "无更新记录")

### 统计数据

- 总提交数：$(git rev-list --count HEAD 2>/dev/null || echo 'N/A')
- 页面数量：$(ls pages/*.html 2>/dev/null | wc -l)
- CSS 文件：$(ls css/*.css 2>/dev/null | wc -l)
- JS 文件：$(ls js/*.js 2>/dev/null | wc -l)

### 自动维护记录

- 智能维护运行次数：$(grep -c "智能内容维护完成" /tmp/computer-history-maintenance.log 2>/dev/null || echo 'N/A')
- 内容增强运行次数：$(grep -c "内容增强完成" /tmp/computer-history-enhancement.log 2>/dev/null || echo 'N/A')

## 下月计划

- [ ] 检查并更新所有页面内容
- [ ] 添加新的科技公司发展历史
- [ ] 优化移动端体验
- [ ] 添加更多互动元素

## 问题与建议

$(if [ -f /tmp/computer-history-maintenance.log ]; then
    grep "警告\|错误\|失败" /tmp/computer-history-maintenance.log 2>/dev/null | tail -10 || echo "无重大问题"
else
    echo "无日志记录"
fi)

---
报告自动生成 | Computer History Project
EOF

echo "月报已生成：$REPORT_FILE"

# 提交报告
git add reports/
git commit -m "docs: 生成月报 ($YEAR-$MONTH)" || echo "No changes"
git push origin main

echo "月报生成完成"
