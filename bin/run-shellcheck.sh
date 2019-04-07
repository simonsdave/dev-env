#!/usr/bin/env bash

set -e

SCRIPT_DIR_NAME="$( cd "$( dirname "$0" )" && pwd )"

if [ $# != 0 ]; then
    echo "usage: $(basename "$0")" >&2
    exit 1
fi

DUMMY_CONTAINER_NAME=$(python -c "import uuid; print uuid.uuid4().hex")

docker create \
    -v /app \
    --name "${DUMMY_CONTAINER_NAME}" \
    alpine:3.4 \
    /bin/true \
    > /dev/null

pushd "$("${SCRIPT_DIR_NAME}/repo-root-dir.sh")" > /dev/null
tar c . | docker cp - "${DUMMY_CONTAINER_NAME}:/app/."
popd > /dev/null

docker run \
    --rm \
    --volumes-from "${DUMMY_CONTAINER_NAME}" \
    "$DEV_ENV_DOCKER_IMAGE" \
    /bin/bash -c 'for SHELL_SCRIPT in $(find /app -name \*.sh | egrep -v "^/app/(build|env)"); do echo "$SHELL_SCRIPT" && shellcheck "$SHELL_SCRIPT"; done'

docker rm "${DUMMY_CONTAINER_NAME}" > /dev/null

exit 0
