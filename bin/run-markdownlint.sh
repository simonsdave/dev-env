#!/usr/bin/env bash

set -e

if [ $# != 0 ]; then
    echo "usage: $(basename "$0")" >&2
    exit 1
fi

docker run --rm --volume "$DEV_ENV_SOURCE_CODE:/app" "$DEV_ENV_DOCKER_IMAGE" markdownlint /app

exit 0
