#!/usr/bin/env bash

#
# takes all command line args and passes them directly
# to the circleci command which is run inside the dev
# env docker container
#

set -e

SCRIPT_DIR_NAME="$( cd "$( dirname "$0" )" && pwd )"

if [ $# == 0 ]; then
    echo "usage: $(basename "$0") <circleci cli args>" >&2
    exit 1
fi

DUMMY_DOCKER_CONTAINER_NAME=$("${SCRIPT_DIR_NAME}/create-dummy-docker-container.sh")

docker run \
    --rm \
    --volumes-from "${DUMMY_DOCKER_CONTAINER_NAME}" \
    "$DEV_ENV_DOCKER_IMAGE" \
    circleci "$@"

docker rm "${DUMMY_DOCKER_CONTAINER_NAME}" > /dev/null

exit 0
