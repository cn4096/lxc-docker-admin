#!/bin/sh

# 检测下载工具
if command -v curl >/dev/null 2>&1; then
    DOWNLOAD_CMD="curl -L -o"
elif command -v wget >/dev/null 2>&1; then
    DOWNLOAD_CMD="wget -O"
else
    echo "❌ 错误：系统未安装 curl 或 wget，请先安装其中之一。"
    exit 1
fi

# 检测系统架构
ARCH=$(uname -m)
case "$ARCH" in
    aarch64 | arm64)
        WEBUI_FILE="lxc-webui-linux-arm64-arm64"
        ;;
    x86_64 | amd64)
        WEBUI_FILE="lxc-webui-linux-amd64-x64"
        ;;
    *)
        echo "❌ 错误：不支持的系统架构：$ARCH"
        exit 1
        ;;
esac
echo "✅ 检测到系统架构：$ARCH，使用文件：$WEBUI_FILE"

# 下载 service.set（优先使用 /usr/local/bin，失败则使用 /usr/bin）
TARGET_DIR="/usr/local/bin"
[ -d "$TARGET_DIR" ] || TARGET_DIR="/usr/bin"

$DOWNLOAD_CMD "$TARGET_DIR/service.set" https://raw.githubusercontent.com/cn4096/service_set/main/service.set && \
chmod +x "$TARGET_DIR/service.set" && \
echo "✅ 绿色程序配置到 $TARGET_DIR/service.set " || \
echo "❌ 安装失败 $TARGET_DIR/service.set "

# 创建程序目录
mkdir -p /opt/lxc-webui/
echo "✅ 创建程序目录 /opt/lxc-webui/"

# 下载 lxc-webui
cd /opt/lxc-webui/ || exit 1
$DOWNLOAD_CMD lxc-webui "https://raw.githubusercontent.com/cn4096/lxc-docker-admin/main/$WEBUI_FILE" && \
chmod +x lxc-webui && \
service.set -I lxc-webui && \
echo "✅ LXC面板设置完成" || \
echo "❌ LXC面板安装失败"

# 获取本机 IP（兼容 Debian 与 OpenWrt）
if hostname -I >/dev/null 2>&1; then
    LOCAL_IP=$(hostname -I | awk '{print $1}')
else
    LOCAL_IP=$(ip -4 route get 1 2>/dev/null | awk '{print $7; exit}')
fi
[ -z "$LOCAL_IP" ] && LOCAL_IP=$(ip -4 addr show 2>/dev/null | awk '/inet /{print $2}' | grep -v '^127' | cut -d/ -f1 | head -n1)

# 显示访问信息
echo ""
echo "🔗 请使用 http://$LOCAL_IP:6080 访问服务，用户名密码是：admin admin"
echo ""
