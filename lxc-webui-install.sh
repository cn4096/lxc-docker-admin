wget -O /usr/local/bin/service.set https://raw.githubusercontent.com/cn4096/service_set/main/service.set && chmod +x /usr/local/bin/service.set && echo "✅ 安装成功" || echo "❌ 安装失败"
mkdir -p /opt/lxc-webui/
cd /opt/lxc-webui/
wget -O lxc-webui https://raw.githubusercontent.com/cn4096/lxc-docker-admin/main/lxc-webui-linux-arm64-arm64
chmod +x lxc-webui
service.set -I lxc-webui
