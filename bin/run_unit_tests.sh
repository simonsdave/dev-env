#!/usr/bin/env bash

set -e

if [ $# != 0 ]; then
    echo "usage: $(basename "$0")" >&2
    exit 1
fi

USER=$(stat -c "%u" "$0")
GROUP=$(stat -c "%g" "$0")

docker run --rm --volume "$DEV_ENV_SOURCE_CODE:/app" "$DEV_ENV_DOCKER_IMAGE" run_unit_tests.sh "$USER" "$GROUP" "$DEV_ENV_PACKAGE"

exit 0
