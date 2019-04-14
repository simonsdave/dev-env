#!/usr/bin/env bash

set -e

SCRIPT_DIR_NAME="$( cd "$( dirname "$0" )" && pwd )"

if [ $# != 0 ]; then
    echo "usage: $(basename "$0")" >&2
    exit 1
fi

if [ ! -e "$(repo-root-dir.sh)/.yamllint" ]; then
    echo "could not find .yamllint in root directory of project" >&2
    exit 1
fi

DUMMY_DOCKER_CONTAINER_NAME=$("${SCRIPT_DIR_NAME}/create-dummy-docker-container.sh")

docker run \
    --rm \
    --volumes-from "${DUMMY_DOCKER_CONTAINER_NAME}" \
    "$DEV_ENV_DOCKER_IMAGE" \
    /bin/bash -c 'for YAML_FILE_NAME in $(find /app -name '*.yml' -or -name '*.yaml' | egrep -v "^/app/(build|env)"); do echo "$YAML_FILE_NAME" && yamllint -c /app/.yamllint "$YAML_FILE_NAME"; done'

docker rm "${DUMMY_DOCKER_CONTAINER_NAME}" > /dev/null

exit 0
