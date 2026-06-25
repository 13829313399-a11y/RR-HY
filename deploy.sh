#!/usr/bin/env bash
# 河源工具门户 - 一键部署脚本
# 用法：在服务器终端运行
#   curl -fsSL https://raw.githubusercontent.com/13829313399-a11y/RR-HY/main/deploy.sh | bash
set -e

echo "===== [1/4] 安装 nginx 和 git ====="
apt-get update -qq
apt-get install -y -qq nginx git

echo "===== [2/4] 拉取最新代码 ====="
rm -rf /var/www/RR-HY
git clone --depth 1 https://github.com/13829313399-a11y/RR-HY.git /var/www/RR-HY

echo "===== [3/4] 配置 nginx ====="
cat > /etc/nginx/sites-available/default <<'NGINXCONF'
server {
    listen 80 default_server;
    root /var/www/RR-HY/dist;
    index index.html;
    location / {
        try_files $uri $uri/ /index.html;
    }
}
NGINXCONF

echo "===== [4/4] 测试并重启 nginx ====="
nginx -t
systemctl restart nginx
systemctl enable nginx

echo ""
echo "============================================"
echo "  部署完成！浏览器访问： http://118.178.234.133"
echo "============================================"
