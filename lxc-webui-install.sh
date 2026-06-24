curl -o /usr/local/bin/service.set https://raw.githubusercontent.com/cn4096/service_set/main/service.set && chmod +x /usr/local/bin/service.set && echo "✅ 安装成功" || echo "❌ 安装失败"
mkdir -p /opt/lxc-webui/
cd /opt/lxc-webui/
curl -o lxc-webui https://raw.githubusercontent.com/cn4096/lxc-docker-admin/main/lxc-webui-linux-arm64-arm64
chmod +x lxc-webui
service.set -I lxc-webui
LOCAL_IP=$(hostname -I | awk '{print $1}')
echo "🔗 请使用 http://$LOCAL_IP:6080 访问服务"
