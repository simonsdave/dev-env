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
    --volumes-from "${DUMMY_DOCKER_CONTAINER_NAME}" \
    "$DEV_ENV_DOCKER_IMAGE" \
    /bin/bash -c 'for SHELL_SCRIPT in $(find /app -name '*.sh' | egrep -v "^/app/(build|env)" | sort); do if ( [ -r "$(dirname "${SHELL_SCRIPT}")/.shellcheckignore" ] && ! grep --silent "$(basename "${SHELL_SCRIPT}")" "$(dirname "${SHELL_SCRIPT}")/.shellcheckignore" ) || [ ! -r "$(dirname "${SHELL_SCRIPT}")/.shellcheckignore" ]; then echo "$SHELL_SCRIPT" && if ! shellcheck "$SHELL_SCRIPT"; then exit 1; fi; fi; done'

docker rm "${DUMMY_DOCKER_CONTAINER_NAME}" > /dev/null

exit 0
