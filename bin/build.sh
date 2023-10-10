#!/bin/bash

function usage {
cat >&2 <<EOS
イメージ生成ジョブ実行コマンド

[usage]
 $0 ARCH SETTING_FILE

[args]
  ARCH:
    OS のアーキテクチャ
    - arm64 : 64bit 用のイメージ
    - armhf : 32bit 用のイメージ
  SETTING_FILE:
    イメージ生成ジョブの設定ファイル

[options]
 -h | --help:
   ヘルプを表示

[example]
  # arm64 用のイメージを生成する
  $0 arm64 setting/my-setting.yml

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

[ "${#args[@]}" != 2 ] && usage
ARCH="${args[0]}"
SETTING_FILE="${args[1]}"

if [ "$ARCH" != "arm64" -a "$ARCH" != "armhf" ]; then
  echo "ARCH には arm64 または armhf を指定してください" >&2
  exit 1
fi

if [ ! -f "$SETTING_FILE" ]; then
  echo "設定ファイル $SETTING_FILE が存在しません" >&2
  exit 1
fi

set -e

# 設定ファイルのコピー
cp $SETTING_FILE $PROJECT_ROOT/image-job/cassys/ansible/host_vars/${ARCH}.yml

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
    make build-$ARCH