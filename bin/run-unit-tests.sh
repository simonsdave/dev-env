#!/usr/bin/env bash

set -e

SCRIPT_DIR_NAME="$( cd "$( dirname "$0" )" && pwd )"

if [ $# != 0 ]; then
    echo "usage: $(basename "$0")" >&2
    exit 1
fi

DOCKER_CONTAINER_NAME=$(python -c "import uuid; print uuid.uuid4().hex")

DUMMY_DOCKER_CONTAINER_NAME=$("${SCRIPT_DIR_NAME}/create-dummy-docker-container.sh")

docker run \
    --name "$DOCKER_CONTAINER_NAME" \
    --volumes-from "${DUMMY_DOCKER_CONTAINER_NAME}" \
    --security-opt "${DEV_ENV_SECURITY_OPT:-seccomp:unconfined}" \
    "$DEV_ENV_DOCKER_IMAGE" \
    /bin/bash -c "cd /app && nosetests --with-coverage --cover-branches --cover-package=$("${SCRIPT_DIR_NAME}/repo.sh" -u)"

REPO_ROOT_DIR=$("${SCRIPT_DIR_NAME}/repo-root-dir.sh")
DOT_COVERAGE=$REPO_ROOT_DIR/.coverage
set -x
docker container cp "$DOCKER_CONTAINER_NAME:/app/.coverage" "$DOT_COVERAGE"
if [ -e "$DOT_COVERAGE" ]; then
    ls -la "$DOT_COVERAGE"
    sed -i '' -e "s|/app/|$REPO_ROOT_DIR/|g" "$DOT_COVERAGE"
fi
set +x

docker container rm "$DOCKER_CONTAINER_NAME" > /dev/null

docker rm "${DUMMY_DOCKER_CONTAINER_NAME}" > /dev/null

exit 0
