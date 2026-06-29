#!/bin/bash

# 检测下载工具
if command -v curl &> /dev/null; then
    DOWNLOAD_CMD="curl -L -o"
elif command -v wget &> /dev/null; then
    DOWNLOAD_CMD="wget -O"
else
    echo "❌ 错误：系统未安装 curl 或 wget，请先安装其中之一。"
    exit 1
fi

# 下载 service.set
TARGET_DIR="[ -d /usr/local/bin ] && echo /usr/local/bin || echo /usr/bin"; \
$DOWNLOAD_CMD "$(eval $TARGET_DIR)/service.set" https://raw.githubusercontent.com/cn4096/service_set/main/service.set && \
chmod +x "$(eval $TARGET_DIR)/service.set" && \
echo "✅ 绿色程序配置中..." || \
echo "❌ 安装失败"

# 创建程序目录
mkdir -p /opt/lxc-webui/
echo "✅ 创建程序目录 /opt/lxc-webui/"

# 下载 lxc-webui
cd /opt/lxc-webui/ || exit 1
$DOWNLOAD_CMD lxc-webui https://raw.githubusercontent.com/cn4096/lxc-docker-admin/main/lxc-webui-linux-arm64-arm64 && \
chmod +x lxc-webui && \
service.set -I lxc-webui && \
echo "✅ LXC面板设置完成" || \
echo "❌ LXC面板安装失败"

# 显示访问信息
LOCAL_IP=$(hostname -I | awk '{print $1}')
echo ""
echo "🔗 请使用 http://$LOCAL_IP:6080 访问服务，用户名密码是：admin admin"
echo ""
