#!/bin/bash

function usage {
cat >&2 <<EOS
イメージ生成ジョブをローカルで実行するコマンド (デバッグ用)

[usage]
 $0

[options]
 -h | --help:
   ヘルプを表示
EOS
exit 1
}

PROJECT_ROOT="$(cd $(dirname $0)/..; pwd)"
source $PROJECT_ROOT/bin/lib/setting.sh

args=()
while [ "$#" != 0 ]; do
  case $1 in
    -h | --help   ) usage;;
    -* | --*      ) echo "$1 : 不正なオプションです" >&2; exit 1 ;;
    *             ) args+=("$1") ;;
  esac
  shift
done

[ "${#args[@]}" != 0 ] && usage

set -e
cd $PROJECT_ROOT

# docker build
docker build \
  --rm \
  -f docker/image-job/Dockerfile \
  -t $APP_NAME/image-job .

# docker network
NETWORK_EXISTS="$(docker network inspect $NETWORK_NAME >/dev/null 2>&1; echo $?)"
if [ "$NETWORK_EXISTS" = 1 ]; then
  docker network create --driver bridge --subnet "$NETWORK_CIDR" $NETWORK_NAME
fi

# https://github.com/solo-io/packer-plugin-arm-image#running-with-docker
docker run \
    --rm \
    -ti \
    --network $NETWORK_NAME \
    --privileged \
    -v /dev:/dev \
    -v $PROJECT_ROOT/.build:/build:ro \
    -v $PROJECT_ROOT/.build/packer_cache:/build/packer_cache \
    -v $PROJECT_ROOT/.build/output-arm-image:/build/output-arm-image \
    -v $PROJECT_ROOT/image-job:/image-job \
    -e PACKER_CACHE_DIR=/build/packer_cache \
    $APP_NAME/image-job:latest \
    /bin/bash