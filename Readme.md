# LXC WebUI

类 PVE 风格的 主机/LXC/Docker/容器/文件/ Web管理界面，偷懒代替ssh,单二进制文件部署，支持X86和ARM .

<img width="1340" height="865" alt="image" src="https://github.com/user-attachments/assets/ffd6d751-8b98-409b-ae1a-b47d1bc3e959" />


## 特性

- 📊 实时仪表盘（CPU 多框框显示 / 内存 / 磁盘 / 网络 / 负载）
- 📦 容器管理（创建 / 启动 / 停止 / 重启 / 删除 / 配置编辑 / 自动启动 / 容器内服务管理）
- 💻 Web 控制台（含宿主机终端，手机软键盘适配）
- 🖼️ 镜像管理（SimpleStreams 在线镜像 / 自定义镜像源 / 本地镜像上传）
- 📸 快照管理（创建 / 恢复 / 删除）
- 🌐 端口转发（iptables DNAT 可视化管理）
- 🔥 防火墙管理（iptables 入站/出站规则，自锁保护）
- 🚇 frpc 内网穿透（代理规则管理 + 进程控制）
- 🐳 Docker 管理（容器 / 镜像 / Compose 项目管理）
- 🌐 Nginx 管理（多实例 / 站点配置 / 启停 / 配置回滚）
- 📁 文件管理（宿主机文件浏览 / 编辑 / 上传 / 下载 / 新建 / 重命名）
- ⚙️ 进程管理 / 计划任务 / 服务管理
- 💾 磁盘信息（物理磁盘 / 分区 / 健康状态查看）
- 🔬 性能基准测试（CPU 单核/多核 / 内存 / 磁盘读写 / 压力测试）
- 📶 网速测试（上行 / 下行 / 延迟）
- 🔖 收藏夹（URL 书签快速访问 + 备忘便签）用来管理多个lxc界面.
- 🌐 界面自定义 `./static/index.html`前端界面.
- 🌐 集中管理，支持远程访问控制(无需公网,内置中继服务器/cf)。
## 快速开始
### -1. 前言
+ 起因： 搞这个程序,仅仅是我捡垃圾`k20p手机+ubuntu26`，看着它性能这么强` 8核 + 12G + 512G`，所以就想着搞PVE的，但是不支持，
 
+ 折腾：就自己折腾lxc，又懒开ssh所以,搞着搞着就搞成这样了。
 
+ 安全： 这个工具是自带宿主机终端的，有所有权限，***无需root的账号密码***，

  务必修改本系统的登录用户名和密码，用户名***不要*** 用 `root/admin`
  
  6080端口 ***不要*** 直接暴露在公网。使用nginx域名访问就安全了。

+ 爆破：密码错了5次就要等5分钟，所以，爆破密码，基本上要10年8年的。
### -1.0 漏洞

**审计重点：** 无管理员账号/密码时，是否存在被爆破或免密远程注入控制主机的漏洞

**核心结论：不存在"无用户名密码"的裸奔状态，也没有免密直达 root 的注入漏洞。** 

这套代码在鉴权设计上做得相当扎实，明显是被人认真审计过并逐条修复过的（代码注释里多处写着"审计里线上那把""早期实现""关键修复"）。


### 0. 系统要求
 debian/ubuntu 有完整的lxc功能,其他系统openwrt等没有完整的lxc功能.(依赖系统的 `systemctl`)

### 0.1 一键下载安装

 `root`用户通过下面脚本可以一键安装，服务自启动,支持`Debian/ubuntu/centos/openwrt`等. 

+ 支持`curl`
```
sudo curl -s https://raw.githubusercontent.com/cn4096/lxc-docker-admin/main/lxc-webui-install.sh | bash
```

+ 支持`wget`
```
wget -O /tmp/lxc-webui-install.sh https://raw.githubusercontent.com/cn4096/lxc-docker-admin/main/lxc-webui-install.sh
chmod +x /tmp/lxc-webui-install.sh
/tmp/lxc-webui-install.sh
```

### 1. 下载运行

+ X86
```bash

## X86
wget -O lxc-webui https://raw.githubusercontent.com/cn4096/lxc-docker-admin/main/lxc-webui-linux-amd64-x64

chmod +x lxc-webui

./lxc-webui

```
+ ARM
  
```bash

## ARM
wget -O lxc-webui https://raw.githubusercontent.com/cn4096/lxc-docker-admin/main/lxc-webui-linux-arm64-arm64

chmod +x lxc-webui

./lxc-webui

```

首次启动会自动生成 `config.yaml`，访问 `http://你的IP:6080`，默认账号：

```
用户名：admin
密码：  admin
```

登录后会弹出初始化向导，**请立即修改用户名和密码**。

### 2. 设置开机自启

```bash
wget -O /usr/local/bin/service.set https://raw.githubusercontent.com/cn4096/service_set/main/service.set && chmod +x /usr/local/bin/service.set && echo "✅ 安装成功" || echo "❌ 安装失败"
service.set lxc-webui
```
### 命令行启动参数（可选）

程序支持一组可选启动参数，用于**首次部署时预置初始账号与集中管理配置**。查看帮助：

```bash
./lxc-webui-xxx -h
```

| 参数 | 示例 | 说明 |
|------|------|------|
| `-u` | `-u "admin"` | 默认用户名（默认 `admin`） |
| `-p` | `-p "password"` | 默认密码（默认 `admin`） |
| `-rs` | `-rs "guest"` | 启用集中管理**服务器**模式，并打开【允许访客凭 ID 远程访问】；参数值作为服务器 token（可为空） |
| `-rc` | `-rc "url"` | 设置服务器 URL 并启用集中管理**客户端**模式，自动连接该 URL |
| `-rct` | `-rct "token"` | 集中管理**客户端**连接服务器时使用的 token（可为空） |
| `-h` | `-h` | 显示参数用法并退出 |

**优先级（关键）：已修改的配置文件 > 启动参数 > 程序内置默认值。**

- `-u` / `-p` **仅在 `config.yaml` 不存在时**用于生成初始账号；配置文件已存在则完全忽略这两个参数（以文件为准）。
- `-rs` / `-rc` / `-rct` **仅在 `config_relay.json` 不存在时**用于生成初始集中管理配置；配置文件已存在则忽略（以文件为准）。
- 三者判定都以「配置文件是否存在」为准——即"用户改过配置就以最新配置文件为准，没有配置文件就以启动参数为准，没有启动参数就用默认值"。


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
## 控制台自定义功能键
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

