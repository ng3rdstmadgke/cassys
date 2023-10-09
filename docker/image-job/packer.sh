#!/bin/bash

set -e
printenv

/usr/sbin/update-binfmts --enable qemu-arm >/dev/null 2>&1
# 確認
# update-binfmts --display qemu-arm

echo "exec /bin/packer ${@}"
exec /bin/packer "${@}"