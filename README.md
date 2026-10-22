# 3cat 一键安装入口

国内安装推荐使用阿里云 OSS。公开文件仅有安装入口和校验信息，不含真实凭据；部署包与服务镜像仍在阿里云私有仓库，下载过程无需访问 GitHub 或 Docker Hub

## 安装

在 Linux 服务器的终端复制整行执行即可，命令会自动下载并校验，不用手动输入校验值

```bash
curl -fsSO 'https://3cat-install.oss-cn-shanghai.aliyuncs.com/install.{sh,sha256}' && sha256sum -c install.sha256 && bash install.sh
```

按提示输入阿里云镜像仓库用户名及密码，密码输入时不显示字符属于正常现象。随后进入中文向导：

1. 安装及数据保存目录默认 `/opt/3cat`，回车接受或直接输入其他完整目录
2. 网页/API 端口默认 `4000`，回车接受或直接输入其他端口
3. 核对完整数据目录和访问地址，回车确认，或输入 n/q 取消

目录已有内容时建议新的空目录，端口被占用时建议空闲端口，不覆盖原目录、不停止旧服务。输入错误时允许重新输入

如提示 sudo 密码，输入当前服务器账号的登录密码；镜像仓库密码是单独设置的访问凭证，不是阿里云 AccessKey

安装结束会显示管理页面、端口、默认账号 `admin`、每台随机生成的管理密码及数据库/Redis 连接信息，并保存到 `/opt/3cat/deploy/installation-info.txt`，权限为 `600`。默认网关端口 `4000/TCP`，PostgreSQL 和 Redis 仅在容器内网访问。请保存完成信息，不要公开包含密码的截图

支持 Linux amd64 和 systemd。Ubuntu/Debian 可按已配置软件源安装 Docker 与相关工具；下载入口需有 curl，系统包安装仍需软件源可达。普通用户会自动请求 sudo，root 用户直接执行。已有内容的安装目录会保留并拒绝覆盖，本入口用于首次安装

自定义参数可以追加在命令最后，例如 `--port 4800 --host gateway.example.com --dir /opt/3cat-new`，它们作为向导建议值。自动化可用 `--yes --dir /opt/3cat-new --port 4800` 跳过交互，仍保留校验与目录/端口保护

## 数据保存位置

选定目录下，`deploy/` 保存配置、`.env` 密码/盐值、工具和 `backups/`；`data/postgres/`、`data/redis/`、`data/attachments/`、`data/storage/` 分别保存 PostgreSQL、Redis、附件和存储策略/监控配置。新实例使用独立 Compose 与监控名称；旧实例不自动改挂载或迁移数据

整目录存放不等于可以直接复制正在写入的数据库。在线备份用配套 backup.sh，整目录迁移先停止该实例，并保留 .env、权限及属主

## 版本与维护

当前 OSS 入口版本为 `v2026.10.22-wizard1`，固定地址为 `https://3cat-install.oss-cn-shanghai.aliyuncs.com/v2026.10.22-wizard1/install.sh`，入口 SHA-256 为 `8d0a4e02c9cf967c1d71df9d2ec20c2af3f4da48e357ed40a34623b8bdbbb3a9`。根地址提供当前安装版本，配套校验文件与脚本一起更新；校验失败时不会执行安装。更新前应检查脚本不含凭据，保留旧版本

GitHub 保留入口源码与固定版本，作为维护和备用渠道。`v2026.10.22` 旧标签保持不变。17 项 Linux 安装行为测试、27 项备份/监控回归通过（1 项平台跳过）；真实隔离安装、systemd 监控、本地 bind mount、重建三个容器后的数据保持、在线备份实际恢复校验均已通过。测试使用已具备 Docker 的系统，没有重复验证空白 OS 的系统包安装
