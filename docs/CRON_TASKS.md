# 计算机历史网站 - Cron 任务说明

## 📋 已配置的定时任务

### 1. 智能维护（每 10 分钟）⭐
**脚本：** `scripts/smart-maintenance.sh`
**Cron:** `*/10 * * * *`

**执行内容：**
- ✅ 检查页面完整性
- ✅ 统计时间线事件数量
- ✅ 统计页面和 CSS 文件数量
- ✅ 更新所有页面的时间戳
- ✅ 生成站点统计文件 (stats.json)
- ✅ 自动提交并推送到 GitHub
- ✅ 记录详细日志

**日志位置：** `/tmp/computer-history-maintenance.log`

---

### 2. 内容增强（每天凌晨 2 点）
**脚本：** `scripts/content-enhancement.sh`
**Cron:** `0 2 * * *`

**执行内容：**
- 周一：检查并添加最新科技新闻
- 周三：更新统计数据
- 周五：检查内容完整性
- 周日：生成本周更新标记
- 月初：添加月度总结

**日志位置：** `/tmp/computer-history-enhancement.log`

---

### 3. 周报生成（每周日午夜）
**脚本：** `scripts/generate-weekly-report.sh`
**Cron:** `0 0 * * 0`

**执行内容：**
- 生成周报 Markdown 文件
- 记录本周 Git 提交
- 统计页面和数据变化
- 制定下周计划

**报告位置：** `reports/weekly-report-YYYY-Www.md`

---

### 4. 月报生成（每月 1 号凌晨 3 点）
**脚本：** `scripts/generate-monthly-report.sh`
**Cron:** `0 3 1 * *`

**执行内容：**
- 生成月报 Markdown 文件
- 统计本月所有更新
- 分析自动维护记录
- 识别问题和建议
- 制定下月计划

**报告位置：** `reports/monthly-report-YYYY-MM.md`

---

## 📊 查看任务状态

### 查看已安装的 Cron 任务
```bash
crontab -l
```

### 查看最新日志
```bash
# 智能维护日志（最新）
tail -f /tmp/computer-history-maintenance.log

# 内容增强日志
tail -f /tmp/computer-history-enhancement.log

# 查看最近的维护记录
grep "智能内容维护完成" /tmp/computer-history-maintenance.log | tail -10
```

### 查看站点统计
```bash
cat stats.json
```

### 查看 Git 提交历史
```bash
cd /home/jason/.openclaw/workspace-trader/projects/computer-history
git log --oneline -20
```

---

## 🔧 手动运行脚本

### 运行智能维护
```bash
/home/jason/.openclaw/workspace-trader/projects/computer-history/scripts/smart-maintenance.sh
```

### 运行内容增强
```bash
/home/jason/.openclaw/workspace-trader/projects/computer-history/scripts/content-enhancement.sh
```

### 生成周报
```bash
/home/jason/.openclaw/workspace-trader/projects/computer-history/scripts/generate-weekly-report.sh
```

### 生成月报
```bash
/home/jason/.openclaw/workspace-trader/projects/computer-history/scripts/generate-monthly-report.sh
```

---

## 📈 自动化效果

### 每 10 分钟自动执行：
1. **检查项目状态** - 页面数量、事件数量、文件完整性
2. **更新时间戳** - 所有页面显示最新维护时间
3. **生成统计** - stats.json 记录当前状态
4. **自动提交** - 有更改自动 commit 并 push
5. **日志记录** - 详细记录每次维护情况

### 每天自动执行：
- 根据星期几执行不同的内容增强任务
- 检查和优化内容质量

### 每周自动执行：
- 生成周报，记录一周的更新
- 分析项目发展趋势

### 每月自动执行：
- 生成月报，总结整月工作
- 分析维护记录和问题
- 规划下月发展方向

---

## 🎯 项目自动完善机制

### 自动检测并修复：
- ✅ 缺失的 meta 标签（viewport, description）
- ✅ 断裂的 CSS 引用
- ✅ 过时的时间戳
- ✅ 缺失的统计文件

### 自动优化：
- ✅ HTML 结构检查
- ✅ CSS 预加载提示
- ✅ SEO 优化建议

### 自动报告：
- ✅ 实时日志记录
- ✅ 周报/月报生成
- ✅ 统计数据跟踪

---

## 📝 示例日志输出

```
[2026-03-15 01:33:38] === 开始智能内容维护 ===
[2026-03-15 01:33:38] 检查统计数据...
[2026-03-15 01:33:38] 时间线事件数量：42
[2026-03-15 01:33:38] 页面数量：5
[2026-03-15 01:33:38] CSS 文件数量：3
[2026-03-15 01:33:38] 更新时间戳...
[2026-03-15 01:33:38] 生成站点统计...
[2026-03-15 01:33:38] 提交更改...
[2026-03-15 01:33:38] 已提交更改
[2026-03-15 01:33:38] 推送到 GitHub...
[2026-03-15 01:33:38] ✓ 推送成功
[2026-03-15 01:33:38] === 智能内容维护完成 ===
```

---

## 🚀 下一步优化

### 计划添加的功能：
- [ ] 集成科技新闻 API，自动添加最新新闻
- [ ] 自动检测并添加新的历史事件
- [ ] 性能监控和自动优化
- [ ] 自动回复 Issue 和 PR
- [ ] 自动生成 changelog

---

**最后更新：** 2026-03-15
**维护状态：** ✅ 正常运行
