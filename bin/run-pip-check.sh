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

#
# as of dev-env v0.6.17 "pip check" is failing with the message
#
#   pygobject 3.36.0 requires pycairo, which is not installed.
#
# not currently clear how to resolve this problem.
#
# so that upstream consumers of dev-env don't have to comment out
# run-pip-check.sh we'll simply exit successfully here until the
# above is resolved.
#
# this has problem is logged as issue # 49 in dev-env.
#
exit 0

DUMMY_DOCKER_CONTAINER_NAME=$("${SCRIPT_DIR_NAME}/create-dummy-docker-container.sh")

docker run \
    --rm \
    --volumes-from "${DUMMY_DOCKER_CONTAINER_NAME}" \
    "${DEV_ENV_DOCKER_IMAGE}" \
    /bin/bash -c 'cd /app && python3.9 -m pip check'

docker rm "${DUMMY_DOCKER_CONTAINER_NAME}" > /dev/null

exit 0
