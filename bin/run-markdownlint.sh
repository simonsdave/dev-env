#!/usr/bin/env bash

set -e

SCRIPT_DIR_NAME="$( cd "$( dirname "$0" )" && pwd )"

if [ $# != 0 ]; then
    echo "usage: $(basename "$0")" >&2
    exit 1
fi

docker run \
        --rm \
        --volume "$("$SCRIPT_DIR_NAME/repo-root-dir.sh"):/app" \
        "$DEV_ENV_DOCKER_IMAGE"
        markdownlint /app

exit 0
