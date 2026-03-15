// 计算机简史 - 主脚本

// 搜索功能
function search() {
    const query = document.getElementById('searchInput').value.trim();
    if (query) {
        window.location.href = `pages/search.html?q=${encodeURIComponent(query)}`;
    }
}

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

// 页面可见性数据
const pageData = {
    lastUpdate: new Date().toISOString(),
    visitCount: 0
};

// 记录访问
pageData.visitCount++;

// 导出供其他页面使用
window.computerHistory = {
    pageData,
    updateLastModified
};

// 月度维护标记
const monthlyMaintenance = {
    enabled: true,
    lastRun: new Date().toISOString()
};
