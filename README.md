# 3cat 一键安装入口

仅分发安装引导脚本，不包含网关源码、部署数据或镜像仓库凭据。安装载荷及服务镜像仍位于阿里云私有仓库，执行时需要有拉取权限的仓库账号密码

## 安装

在自己有写权限的可信目录中执行下面一条命令，先下载并核验 SHA-256，再以 root 权限安装

```bash
curl -4 -fsSL --connect-timeout 15 --max-time 60 https://raw.githubusercontent.com/dongbeixiaohuo/3cat-installer/v2026.10.22/install.sh -o 3cat-install.sh && echo '7afe12b6f696aaa4f3128f14c74e88acb66b51761e4439babcd9a7d340858079  3cat-install.sh' | sha256sum -c - && sudo bash ./3cat-install.sh
```

支持 Linux amd64 和 systemd。Ubuntu/Debian 可按已配置软件源安装 Docker 与相关工具；其他系统需事先准备依赖。系统工具安装仍需对应软件源可达

默认管理账号为 `admin`，密码每台随机生成，成功后显示访问地址、端口及各服务连接信息，同时保存到 `/opt/3cat/deploy/installation-info.txt`，权限为 `600`。网关默认端口 `4000/TCP`；PostgreSQL 和 Redis 仅在容器内网访问

可在命令末尾追加 `--port 4800 --host gateway.example.com --dir /opt/3cat-new`。已有内容的目录会被保留并拒绝覆盖；本入口用于首次安装，已有实例使用配套升级工具。安装时按提示输入阿里云镜像仓库用户名和密码，仓库密码不回显，不写入本仓库或部署包

版本 `v2026.10.22` 固定安装载荷 digest 和包、脚本 SHA-256。11 项 Linux 模拟安装测试、真实阿里云载荷拉取及校验已通过，尚未在空白服务器执行完整系统工具和 systemd 实装
