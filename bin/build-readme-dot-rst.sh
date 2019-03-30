#!/usr/bin/env bash

set -e

if [ $# != 0 ]; then
    echo "usage: $(basename "$0")" >&2
    exit 1
fi

REPO_ROOT_DIR=$(repo-root-dir.sh)

#
# :TRICKY: The implementation below feels more complicated than it
# should be but was arrived at to deal with permissioning instability/inconsistency
# when the simple/obvious thing to do would be to have the "pandoc README.md README.rst"
# run inside the container generating README.rst directly into a
# directory on the host mapped into the container using --volume.
# The solution does all the generation of README.rst inside the container
# and then manually pulls it out of the container before manually deleting
# the container. It's a little awkward but it's reliable.
#
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
