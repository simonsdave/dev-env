#!/usr/bin/env bash

#
# see the README.md in the same directory as this script for a
# description of why this script exists what this script does
#

set -e

SCRIPT_DIR_NAME="$( cd "$( dirname "$0" )" && pwd )"

#
# :TRICKY: want to use this script to run for app repos
# as well as the dev-env repo. All works for app repos
# but with dev-env the "docker run" below runs run-markdownlint.sh
# and since the dev-env docker build puts /app/bin
# at the start of the PATH, the docker run will actually
# run this script instead of the intended script in the
# in-container directory.
#
if [[ "/app/bin/${0##*/}" == "${0}" ]]; then
    "${SCRIPT_DIR_NAME}/in-container/${0##*/}" "$@"
    exit $?
fi

DUMMY_DOCKER_CONTAINER_NAME=$("${SCRIPT_DIR_NAME}/create-dummy-docker-container.sh")

docker run \
    --rm \
    --name "${DOCKER_CONTAINER_NAME}" \
    --volumes-from "${DUMMY_DOCKER_CONTAINER_NAME}" \
    "${DEV_ENV_DOCKER_IMAGE}" \
    "${0##*/}" "$@"

docker rm "${DUMMY_DOCKER_CONTAINER_NAME}" > /dev/null

exit 0
