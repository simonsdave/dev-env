#!/usr/bin/env bash

set -e

SCRIPT_DIR_NAME="$( cd "$( dirname "$0" )" && pwd )"

if [ $# != 1 ]; then
    echo "usage: $(basename "$0") <synk-token>" >&2
    exit 1
fi

SNYK_TOKEN=${1:-}

docker run \
    --rm \
    --volume "$("$SCRIPT_DIR_NAME/repo-root-dir.sh"):/app" \
    "$DEV_ENV_DOCKER_IMAGE" \
    run-snyk.sh "$SNYK_TOKEN"

exit 0
