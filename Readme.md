# LXC WebUI

类 PVE 风格的 主机/LXC/Docker/容器/文件/ Web管理界面，单二进制部署。

## 特性

- 📊 实时仪表盘（CPU / 内存 / 磁盘 / 网络 / 负载）
- 📦 容器管理（创建 / 启动 / 停止 / 删除 / 配置编辑）
- 💻 Web 控制台（xterm.js，含宿主机终端）
- 🖼️ 镜像管理（SimpleStreams 在线镜像 + 本地镜像上传）
- 📸 快照管理
- 🌐 端口转发（iptables DNAT 可视化）
- 🔥 防火墙管理（iptables 入站/出站规则，自锁保护）
- 🚇 frpc 内网穿透（代理规则管理 + 进程控制）
- 📁 文件管理（宿主机文件浏览 / 编辑 / 上传 / 下载）
- ⚙️ 进程管理 / 计划任务 / 服务管理
- 🔄 OTA 自动更新
- 📶 网速测试（上行 / 下行 / 延迟）

## 快速开始


### 1. 下载运行

+ X86
```bash

## X86
wget -O lxc-webui https://raw.githubusercontent.com/cn4096/lxc-docker-admin/refs/heads/main/lxc-webui-linux-amd64-x64

chmod +x lxc-webui

./lxc-webui

```
+ ARM
  
```bash

## ARM
wget -O lxc-webui https://raw.githubusercontent.com/cn4096/lxc-docker-admin/refs/heads/main/lxc-webui-linux-arm64-arm64

chmod +x lxc-webui

./lxc-webui

```

首次启动会自动生成 `config.yaml`，访问 `http://你的IP:6080`，默认账号：

```
用户名：admin
密码：  admin
```

登录后会弹出初始化向导，**请立即修改密码**。

### 2. 设置开机自启

```bash
cp lxc-webui.service /etc/systemd/system/
systemctl enable --now lxc-webui
journalctl -u lxc-webui -f   # 查看日志
```



## nginx 反代（推荐）

建议通过 nginx 代理并启用 HTTPS，不要直接将 6080 暴露到公网：

```nginx
server {
    listen 80;
    server_name your.domain.com;
    location / {
        proxy_pass http://127.0.0.1:6080;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
    }
}
```

配置反代后，可在防火墙页面添加规则屏蔽 6080 的外部访问。添加此类规则时系统会弹出风险提示，确认后保存即可，WebUI 通过 127.0.0.1 仍可正常访问。


## 注意事项

- 需要 **root 权限**运行（lxc-* 命令要求）
- 首次登录后必须修改默认密码
- `jwt_secret` 一旦生成不要手动修改，否则所有已登录用户的 token 立即失效
- 文件管理器默认根目录为 `/opt`，可在设置页修改
## 常用手机按键
| 按键 | 转义序列 |
|---|---|
| Tab | `\t` |
| ESC | `\x1b` |
| Ctrl+C | `\x03` |
| Ctrl+D | `\x04` |
| Ctrl+Z | `\x1a` |
| Ctrl+L（清屏） | `\x0c` |
| Ctrl+A（行首） | `\x01` |
| Ctrl+E（行尾） | `\x05` |
| Ctrl+U（清行） | `\x15` |
| Ctrl+K（删至行尾） | `\x0b` |
| Ctrl+W（删词） | `\x17` |
| ↑ 上箭头 | `\x1b[A` |
| ↓ 下箭头 | `\x1b[B` |
| → 右箭头 | `\x1b[C` |
| ← 左箭头 | `\x1b[D` |
| Home | `\x1b[H` |
| End | `\x1b[F` |
| PageUp | `\x1b[5~` |
| PageDown | `\x1b[6~` |
| Delete（向后删） | `\x1b[3~` |

