#!/usr/bin/env bash

set -e

if [ $# != 0 ]; then
    echo "usage: $(basename "$0") [<dir1> <dir2> ... <dir N>]" >&2
    exit 1
fi

USER=$(stat -c "%u" "$0")
GROUP=$(stat -c "%g" "$0")

DIRS=$*

docker run \
    --rm \
    --security-opt "${DEV_ENV_SECURITY_OPT:-seccomp:unconfined}" \
    --volume "$DEV_ENV_SOURCE_CODE:/app" \
    "$DEV_ENV_DOCKER_IMAGE" \
    run_unit_tests.sh "$DEV_ENV_PACKAGE" "$USER" "$GROUP" "${DIRS[@]}"

sed -i -e "s|/app/|$DEV_ENV_SOURCE_CODE/|g" "$DEV_ENV_SOURCE_CODE/.coverage"

exit 0
