#!/usr/bin/env bash

set -e

SCRIPT_DIR_NAME="$( cd "$( dirname "$0" )" && pwd )"

if [ $# != 0 ]; then
    echo "usage: $(basename "$0")" >&2
    exit 1
fi

DUMMY_DOCKER_CONTAINER_NAME=$("${SCRIPT_DIR_NAME}/create-dummy-docker-container.sh")

docker run \
    --rm \
    --volumes-from "${DUMMY_DOCKER_CONTAINER_NAME}" \
    "$DEV_ENV_DOCKER_IMAGE" \
    /bin/bash -c 'for SHELL_SCRIPT in $(find /app -name \*.sh | egrep -v "^/app/(build|env)"); do echo "$SHELL_SCRIPT" && shellcheck "$SHELL_SCRIPT"; done'

docker rm "${DUMMY_DOCKER_CONTAINER_NAME}" > /dev/null

exit 0
