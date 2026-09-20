#!/data/data/com.termux/files/usr/bin/bash
set -e

SVC=lxc-webui
URL=https://raw.githubusercontent.com/cn4096/lxc-docker-admin/main/lxc-webui-linux-arm64-arm64
BIN="$PREFIX/bin/$SVC"
SVC_DIR="$PREFIX/var/service/$SVC"

# 0. 确认运行在 Termux 中
if [ -z "$PREFIX" ] || [ ! -d "/data/data/com.termux" ]; then
  echo "[x] 请在 Termux 中运行此脚本"
  exit 1
fi

# 1. 检查 termux-services，未安装则安装依赖并提示重启
if ! dpkg -s termux-services >/dev/null 2>&1; then
  echo "[*] 未检测到 termux-services，正在安装依赖..."
  pkg update -y
  pkg install -y curl termux-services
  echo
  echo "=================================================="
  echo " termux-services 已安装完成。"
  echo " 请完全退出 Termux（通知栏点 Exit，或输入 exit"
  echo " 关闭所有会话），然后重新打开 Termux，"
  echo " 再次运行本脚本以完成服务安装。"
  echo "=================================================="
  exit 0
fi

# 确保 curl 存在
command -v curl >/dev/null 2>&1 || pkg install -y curl

# 2. 检查服务守护进程是否已运行（装完未重启时不会运行）
if ! pidof runsvdir >/dev/null 2>&1; then
  echo
  echo "=================================================="
  echo " termux-services 已安装，但服务守护进程未运行。"
  echo " 请完全退出并重新打开 Termux 后再次运行本脚本。"
  echo "=================================================="
  exit 0
fi

# 3. 如服务已存在，先停止，便于覆盖更新
if [ -d "$SVC_DIR" ]; then
  echo "[*] 检测到已有服务，先停止..."
  sv down "$SVC" 2>/dev/null || true
fi

# 4. 下载可执行文件
echo "[*] 正在下载 $SVC ..."
curl -fL "$URL" -o "$BIN.tmp"
mv -f "$BIN.tmp" "$BIN"
chmod +x "$BIN"

# 5. 创建服务目录与启动脚本
mkdir -p "$SVC_DIR/log"
cat > "$SVC_DIR/run" <<EOF
#!/data/data/com.termux/files/usr/bin/sh
cd \$HOME
exec $BIN 2>&1
EOF
chmod +x "$SVC_DIR/run"

# 6. 日志
ln -sf "$PREFIX/share/termux-services/svlogger" "$SVC_DIR/log/run"

# 7. 启用并启动
sv-enable "$SVC"
sv up "$SVC"
sleep 2

echo
echo "[✓] 安装完成，当前状态："
sv status "$SVC"
echo
echo "查看日志： tail -f $PREFIX/var/log/sv/$SVC/current"
