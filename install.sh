#!/usr/bin/env bash
set -euo pipefail
umask 077
IMAGE="crpi-nyie09t1c748gc2d.cn-shanghai.personal.cr.aliyuncs.com/dantedocker/3cat-aigateway@sha256:ae6b622f9030caa2328deeddbf3cf760f2c7fb47633b1787f16909a89a76916e"
PACKAGE_SHA256="d0729170b4bbe7a82141396b7213732be31940c66917bbedf7543f378b8c032f"
INSTALLER_SHA256="460a331aaecf3840cf01f710cf1a0c65cebbf5425f41474e8161f7c5e2813828"
[[ "$IMAGE" == crpi-nyie09t1c748gc2d.cn-shanghai.personal.cr.aliyuncs.com/dantedocker/3cat-aigateway@sha256:* ]] || exit 2
[[ "$PACKAGE_SHA256" =~ ^[a-f0-9]{64}$ && "$INSTALLER_SHA256" =~ ^[a-f0-9]{64}$ ]] || exit 2
if [ "$(id -u)" != 0 ]; then
  command -v sudo >/dev/null || { echo '请使用管理员账号登录服务器后重新执行安装命令'; exit 1; }
  exec sudo bash "$0" "$@"
fi
[ "$(uname -s)" = Linux ] && [ "$(uname -m)" = x86_64 ] || { echo '仅支持 Linux amd64'; exit 1; }
if ! command -v docker >/dev/null; then
  . /etc/os-release
  case "$ID" in ubuntu|debian) : ;; *) echo '请先安装 Docker'; exit 1 ;; esac
  apt-get update
  DEBIAN_FRONTEND=noninteractive apt-get install -y docker.io
fi
if ! docker info >/dev/null 2>&1; then
  systemctl enable --now docker
fi
WORK=$(mktemp -d /tmp/3cat-bootstrap.XXXXXXXX)
CONTAINER=""
cleanup() {
  if [ -n "$CONTAINER" ]; then docker rm "$CONTAINER" >/dev/null 2>&1 || true; fi
  rm -rf -- "$WORK"
}
trap cleanup EXIT
trap 'exit 130' HUP INT TERM
export DOCKER_CONFIG="$WORK/docker-auth"
mkdir -m 700 "$DOCKER_CONFIG"
if [ -z "${ACR_USERNAME:-}" ]; then read -r -p '阿里云镜像仓库用户名：' ACR_USERNAME < /dev/tty; fi
if [ -z "${ACR_PASSWORD:-}" ]; then read -r -s -p '阿里云镜像仓库密码：' ACR_PASSWORD < /dev/tty; printf '\n'; fi
export ACR_USERNAME ACR_PASSWORD
printf '%s\n' "$ACR_PASSWORD" | docker login --username "$ACR_USERNAME" --password-stdin "${IMAGE%%/*}"
docker pull "$IMAGE"
CONTAINER=$(docker create "$IMAGE" /not-executed)
docker cp "$CONTAINER:/install.sh" "$WORK/install.sh"
docker cp "$CONTAINER:/deploy.tar.gz" "$WORK/deploy.tar.gz"
printf '%s  %s\n' "$INSTALLER_SHA256" "$WORK/install.sh" "$PACKAGE_SHA256" "$WORK/deploy.tar.gz" | sha256sum --check --status
bash "$WORK/install.sh" --package-file "$WORK/deploy.tar.gz" --sha256 "$PACKAGE_SHA256" "$@"
