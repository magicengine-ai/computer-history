#!/bin/bash
# 计算机历史网站内容扩充脚本

PROJECT_DIR="/home/jason/.openclaw/workspace-trader/projects/computer-history"
cd $PROJECT_DIR

# 检查是否有新内容需要添加
# 这里可以添加逻辑来：
# 1. 从 API 获取最新科技新闻
# 2. 添加新的历史事件
# 3. 更新统计数据
# 4. 添加新的公司档案

TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# 更新主 JS 文件的时间戳
cat > js/main.js << EOF
// 计算机简史 - 主脚本

// 更新时间显示
function updateLastModified() {
    const updateElement = document.getElementById('last-update');
    if (updateElement) {
        const now = new Date();
        const timeString = now.toLocaleString('zh-CN', {
            year: 'numeric',
            month: '2-digit',
            day: '2-digit',
            hour: '2-digit',
            minute: '2-digit'
        });
        updateElement.textContent = timeString;
    }
}

// 页面加载时更新时间
document.addEventListener('DOMContentLoaded', function() {
    updateLastModified();
    
    // 添加平滑滚动
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                target.scrollIntoView({
                    behavior: 'smooth'
                });
            }
        });
    });
});

// 自动更新信息
const autoUpdateInfo = {
    lastScriptRun: '$TIMESTAMP',
    version: '1.0.0'
};

console.log('Computer History Site Loaded');
console.log('Auto-update info:', autoUpdateInfo);

// 导出供其他页面使用
window.computerHistory = {
    pageData: {
        lastUpdate: new Date().toISOString(),
        visitCount: 0
    },
    updateLastModified,
    autoUpdateInfo
};
EOF

# 提交并推送
git add -A
git commit -m "chore: 定期内容维护 ($TIMESTAMP)" || echo "No changes to commit"
git push origin main

echo "[$TIMESTAMP] 内容维护完成"
