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
    "${DEV_ENV_DOCKER_IMAGE}" \
    /bin/bash -c 'for MD_FILE_NAME in $(find /app -name "*.md" | grep -E "^/app/(build|env)"); do echo "${MD_FILE_NAME}" && if ! mdl --style /app/.markdownlint-style.rb "${MD_FILE_NAME}"; then exit 1; fi; done; exit 0'

docker rm "${DUMMY_DOCKER_CONTAINER_NAME}" > /dev/null

exit 0
