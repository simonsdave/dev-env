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

REPO_ROOT_DIR=$("${SCRIPT_DIR_NAME}/repo-root-dir.sh")

DOCKER_CONTAINER_NAME=$(openssl rand -hex 16)

DUMMY_DOCKER_CONTAINER_NAME=$("${SCRIPT_DIR_NAME}/create-dummy-docker-container.sh")

docker run \
    --name "${DOCKER_CONTAINER_NAME}" \
    --volumes-from "${DUMMY_DOCKER_CONTAINER_NAME}" \
    --security-opt "${DEV_ENV_SECURITY_OPT:-seccomp:unconfined}" \
    "${DEV_ENV_DOCKER_IMAGE}" \
    /bin/bash -c "cd /app && nosetests --with-coverage --cover-branches --cover-package=$("${SCRIPT_DIR_NAME}/repo.sh" -u) && if [ -e /app/.coverage ]; then coverage html; fi"

DOT_COVERAGE=${REPO_ROOT_DIR}/.coverage

docker container cp \
    "${DOCKER_CONTAINER_NAME}:/app/.coverage" \
    "${DOT_COVERAGE}"

COVERAGE_REPORT=$(grep directory "${REPO_ROOT_DIR}/.coveragerc" | sed -e 's|.*=[[:space:]]*||g' | sed -e 's|[[:space:]]*$||g')

# the :- is only there to avoid generating
#   SC2115: Use "${var:?}" to ensure this never expands to /
# on shell linting
rm -rf "${REPO_ROOT_DIR:-}/${COVERAGE_REPORT}"

docker container cp \
    "${DOCKER_CONTAINER_NAME}:/app/${COVERAGE_REPORT}" \
    "${REPO_ROOT_DIR}/${COVERAGE_REPORT}"

docker container rm "${DOCKER_CONTAINER_NAME}" > /dev/null

docker container rm "${DUMMY_DOCKER_CONTAINER_NAME}" > /dev/null

exit 0
