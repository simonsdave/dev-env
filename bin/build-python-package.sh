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

#
# :TRICKY: The implementation below feels more complicated than it
# should be but was arrived at to deal with permissioning instability/inconsistency
# when the simple/obvious thing to do would be to have the "python3.7 setup.py"
# run inside the container generating packages directly into a
# directory on the host mapped into the container using --volume.
# The solution does all the generation of packages inside the container
# and then manually pulls the packages out of the container before
# manually deleting the container. It's a little awkward but it's reliable.
#
DOCKER_CONTAINER_NAME=$(openssl rand -hex 16)

DUMMY_DOCKER_CONTAINER_NAME=$("${SCRIPT_DIR_NAME}/create-dummy-docker-container.sh")

docker run \
    --name "${DOCKER_CONTAINER_NAME}" \
    --volumes-from "${DUMMY_DOCKER_CONTAINER_NAME}" \
    "${DEV_ENV_DOCKER_IMAGE}" \
    /bin/bash -c 'cd /app; python3.7 setup.py bdist sdist --formats=gztar; twine check dist/*'

docker container rm "${DUMMY_DOCKER_CONTAINER_NAME}" > /dev/null

rm -rf "${REPO_ROOT_DIR}/dist"
docker container cp "${DOCKER_CONTAINER_NAME}:/app/dist" "${REPO_ROOT_DIR}"

docker container rm "${DOCKER_CONTAINER_NAME}" > /dev/null

exit 0
