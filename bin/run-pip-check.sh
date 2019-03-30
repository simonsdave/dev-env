#!/usr/bin/env bash

set -e

if [ $# != 0 ]; then
    echo "usage: $(basename "$0")" >&2
    exit 1
fi

docker run --rm --volume "$(repo-root-dir.sh):/app" "$DEV_ENV_DOCKER_IMAGE" /bin/bash -c 'cd /app && pip check'

exit 0
