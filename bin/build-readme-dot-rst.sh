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

REPO_ROOT_DIR=$("$SCRIPT_DIR_NAME/repo-root-dir.sh")

DOCKER_CONTAINER_NAME=$(python -c "import uuid; print uuid.uuid4().hex")

docker run \
    --name "$DOCKER_CONTAINER_NAME" \
    --volume "$REPO_ROOT_DIR:/app" \
    "$DEV_ENV_DOCKER_IMAGE" \
    pandoc "/app/README.md" -o "/tmp/README.rst"

rm -f "$REPO_ROOT_DIR/README.rst"
docker container cp "$DOCKER_CONTAINER_NAME:/tmp/README.rst" "$REPO_ROOT_DIR/README.rst"

docker container rm "$DOCKER_CONTAINER_NAME"

exit 0
