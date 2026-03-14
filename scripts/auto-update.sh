#!/bin/bash
# 计算机历史网站自动更新脚本

PROJECT_DIR="/home/jason/.openclaw/workspace-trader/projects/computer-history"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

cd $PROJECT_DIR

# 更新页脚时间戳
find pages -name "*.html" -exec sed -i "s/最后更新：<span id=\"last-update\">.*<\/span>/最后更新：<span id=\"last-update\">$TIMESTAMP<\/span>/g" {} \;
sed -i "s/最后更新：<span id=\"last-update\">.*<\/span>/最后更新：<span id=\"last-update\">$TIMESTAMP<\/span>/g" index.html

# 更新 JS 中的时间
cat > js/update-time.js << 'EOF'
// 自动更新时间戳
const lastUpdate = new Date().toISOString();
console.log('Last update:', lastUpdate);
EOF

# 提交更改
git add -A
git commit -m "chore: 自动更新 ($TIMESTAMP)"
git push origin main

echo "[$TIMESTAMP] 更新完成"
