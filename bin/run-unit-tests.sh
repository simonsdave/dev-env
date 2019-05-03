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
DOT_COVERAGE=${REPO_ROOT_DIR}/.coverage

echo "!coverage.py: This is a private format, don't read it directly!{}" > "${DOT_COVERAGE}"
chmod a+wr "${DOT_COVERAGE}"

DOCKER_CONTAINER_NAME=$(python -c "import uuid; print uuid.uuid4().hex")

DUMMY_DOCKER_CONTAINER_NAME=$("${SCRIPT_DIR_NAME}/create-dummy-docker-container.sh")

# sed is run inside the container because that means we con control
# the OS and thus sed version
docker run \
    --name "${DOCKER_CONTAINER_NAME}" \
    --volumes-from "${DUMMY_DOCKER_CONTAINER_NAME}" \
    --security-opt "${DEV_ENV_SECURITY_OPT:-seccomp:unconfined}" \
    "${DEV_ENV_DOCKER_IMAGE}" \
    /bin/bash -c "cd /app && nosetests --with-coverage --cover-branches --cover-package=$("${SCRIPT_DIR_NAME}/repo.sh" -u) && if [ -e /app/.coverage ]; then coverage html && sed -i -e 's|/app/|${REPO_ROOT_DIR}/|g' /app/.coverage; fi"

docker container cp \
    "${DOCKER_CONTAINER_NAME}:/app/.coverage" \
    "${DOT_COVERAGE}"

COVERAGE_REPORT=$(grep directory .coveragerc | sed -e 's|.*=[[:space:]]*||g' | sed -e 's|[[:space:]]*$||g')

rm -rf "${REPO_ROOT_DIR:-}/${COVERAGE_REPORT:-}"

docker container cp \
    "${DOCKER_CONTAINER_NAME}:/app/${COVERAGE_REPORT}" \
    "${REPO_ROOT_DIR}/${COVERAGE_REPORT}"

docker container rm "${DOCKER_CONTAINER_NAME}" > /dev/null

docker container rm "${DUMMY_DOCKER_CONTAINER_NAME}" > /dev/null

exit 0
