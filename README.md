# 3cat 一键安装入口

国内安装推荐使用阿里云 OSS。公开文件仅有安装入口和校验信息，不含真实凭据；部署包与服务镜像仍在阿里云私有仓库，下载过程无需访问 GitHub 或 Docker Hub

## 安装

在 Linux 服务器的终端复制整行执行即可，命令会自动下载并校验，不用手动输入校验值

```bash
curl -fsSO 'https://3cat-install.oss-cn-shanghai.aliyuncs.com/install.{sh,sha256}' && sha256sum -c install.sha256 && bash install.sh
```

按提示输入阿里云镜像仓库用户名及密码，密码输入时不显示字符属于正常现象。如提示 sudo 密码，输入当前服务器账号的登录密码；镜像仓库密码是单独设置的访问凭证，不是阿里云 AccessKey

安装结束会显示管理页面、端口、默认账号 `admin`、每台随机生成的管理密码及数据库/Redis 连接信息，并保存到 `/opt/3cat/deploy/installation-info.txt`，权限为 `600`。默认网关端口 `4000/TCP`，PostgreSQL 和 Redis 仅在容器内网访问。请保存完成信息，不要公开包含密码的截图

支持 Linux amd64 和 systemd。Ubuntu/Debian 可按已配置软件源安装 Docker 与相关工具；下载入口需有 curl，系统包安装仍需软件源可达。普通用户会自动请求 sudo，root 用户直接执行。已有内容的安装目录会保留并拒绝覆盖，本入口用于首次安装

自定义参数可以追加在命令最后，例如 `--port 4800 --host gateway.example.com --dir /opt/3cat-new`

## 版本与维护

当前 OSS 入口版本为 `v2026.10.22-oss1`，固定地址为 `https://3cat-install.oss-cn-shanghai.aliyuncs.com/v2026.10.22-oss1/install.sh`，入口 SHA-256 为 `3d467277eb7e1941d617a51bd1526f6613ba41f106c00ca023fab5943b78284f`。根地址提供当前安装版本，配套校验文件与脚本一起更新；校验失败时不会执行安装。更新前应检查脚本不含凭据，保留旧版本

GitHub 保留入口源码与固定版本，作为维护和备用渠道。`v2026.10.22` 旧标签保持不变。11 项 Linux 模拟安装测试、真实阿里云载荷获取、OSS 匿名下载与校验、自动 sudo 及已有目录保护均已验证；尚未在空白服务器执行完整系统包和 systemd 实装
