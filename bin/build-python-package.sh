#!/usr/bin/env bash

# https://docs.python.org/2/distutils/sourcedist.html

set -e

if [ $# != 0 ]; then
    echo "usage: $(basename "$0")" >&2
    exit 1
fi

REPO_ROOT_DIR=$(repo-root-dir.sh)

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

docker run \
    --name "$DOCKER_CONTAINER_NAME" \
    --volume "$REPO_ROOT_DIR:/app" \
    "$DEV_ENV_DOCKER_IMAGE" \
    /bin/bash -c 'cp -r /app ~; cd ~/app; python setup.py bdist_wheel sdist --formats=gztar'

DIST_DIR_IN_CONTAINER=$(docker run --rm "$DEV_ENV_DOCKER_IMAGE" /bin/bash -c 'echo ~')/app/dist
rm -rf "$REPO_ROOT_DIR/dist"
docker container cp "$DOCKER_CONTAINER_NAME:$DIST_DIR_IN_CONTAINER" "$REPO_ROOT_DIR"

docker container rm "$DOCKER_CONTAINER_NAME"

exit 0