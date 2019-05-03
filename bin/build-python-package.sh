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

#
# :TRICKY: The implementation below feels more complicated than it
# should be but was arrived at to deal with permissioning instability/inconsistency
# when the simple/obvious thing to do would be to have the "python setup.py"
# run inside the container generating packages directly into a
# directory on the host mapped into the container using --volume.
# The solution does all the generation of packages inside the container
# and then manually pulls the packages out of the container before
# manually deleting the container. It's a little awkward but it's reliable.
#
DOCKER_CONTAINER_NAME=$(python -c "import uuid; print uuid.uuid4().hex")

DUMMY_DOCKER_CONTAINER_NAME=$("${SCRIPT_DIR_NAME}/create-dummy-docker-container.sh")

docker run \
    --name "$DOCKER_CONTAINER_NAME" \
    --volumes-from "${DUMMY_DOCKER_CONTAINER_NAME}" \
    "$DEV_ENV_DOCKER_IMAGE" \
    /bin/bash -c 'cp -r /app ~; cd ~/app; python setup.py bdist_wheel sdist --formats=gztar'

docker rm "${DUMMY_DOCKER_CONTAINER_NAME}" > /dev/null

DIST_DIR_IN_CONTAINER=$(docker run --rm "$DEV_ENV_DOCKER_IMAGE" /bin/bash -c 'echo ~')/app/dist
rm -rf "$REPO_ROOT_DIR/dist"
docker container cp "$DOCKER_CONTAINER_NAME:$DIST_DIR_IN_CONTAINER" "$REPO_ROOT_DIR"

docker container rm "$DOCKER_CONTAINER_NAME" > /dev/null

exit 0
