curl -o /usr/local/bin/service.set https://raw.githubusercontent.com/cn4096/service_set/main/service.set && chmod +x /usr/local/bin/service.set && echo "✅ 绿色程序配置中..." || echo "❌ 安装失败"
mkdir -p /opt/lxc-webui/
echo "✅创建程序目录 /opt/lxc-webui/"
cd /opt/lxc-webui/
curl -o lxc-webui https://raw.githubusercontent.com/cn4096/lxc-docker-admin/main/lxc-webui-linux-arm64-arm64
chmod +x lxc-webui
service.set -I lxc-webui
echo "✅LXC面板设置完成"
LOCAL_IP=$(hostname -I | awk '{print $1}')
echo ""
echo "🔗 请使用 http://$LOCAL_IP:6080 访问服务,用户名密码是: admin admin"
echo ""
