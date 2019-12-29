#!/usr/bin/env bash

#
# see the README.md in the same directory as this script for a
# description of why this script exists what this script does
#

set -e

SCRIPT_DIR_NAME="$( cd "$( dirname "$0" )" && pwd )"

if [ $# != 0 ]; then
    echo "usage: $(basename "$0")" >&2
    exit 1
fi

DUMMY_DOCKER_CONTAINER_NAME=$("${SCRIPT_DIR_NAME}/create-dummy-docker-container.sh")

docker run \
    --rm \
    --name "${DOCKER_CONTAINER_NAME}" \
    --volumes-from "${DUMMY_DOCKER_CONTAINER_NAME}" \
    "${DEV_ENV_DOCKER_IMAGE}" \
    /bin/bash -c 'for JSON_FILE_NAME in $(find /app -name '*.json' | egrep -v "^/app/(build|env)"); do echo -n "${JSON_FILE_NAME} ... " && if jq . "${JSON_FILE_NAME}" > /dev/null; then echo "ok"; else exit 1; fi; done'

docker rm "${DUMMY_DOCKER_CONTAINER_NAME}" > /dev/null

exit 0
