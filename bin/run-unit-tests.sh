#!/usr/bin/env bash

set -e

SCRIPT_DIR_NAME="$( cd "$( dirname "$0" )" && pwd )"

if [ $# != 0 ]; then
    echo "usage: $(basename "$0")" >&2
    exit 1
fi

REPO_ROOT_DIR=$("${SCRIPT_DIR_NAME}/repo-root-dir.sh")
DOT_COVERAGE=$REPO_ROOT_DIR/.coverage

#
# :TRICKY: nosetests is run inside the docker container.
# and if we simply let this happen the container would
# set the uid and gid of .coverage which can then make
# .coverage inaccessible by the host. to solve this
# problem we create an empty .coverage here (which runs
# on the host) so we can control .coverage's uid and gid.
#
echo "!coverage.py: This is a private format, don't read it directly!{}" > "$DOT_COVERAGE"
chmod a+wr "$DOT_COVERAGE"

DUMMY_DOCKER_CONTAINER_NAME=$("${SCRIPT_DIR_NAME}/create-dummy-docker-container.sh")

docker run \
    --rm \
    --security-opt "${DEV_ENV_SECURITY_OPT:-seccomp:unconfined}" \
    --volumes-from "${DUMMY_DOCKER_CONTAINER_NAME}" \
    "$DEV_ENV_DOCKER_IMAGE" \
    /bin/bash -c "cd /app && nosetests --with-coverage --cover-branches --cover-package=$(repo.sh -u)"

docker rm "${DUMMY_DOCKER_CONTAINER_NAME}" > /dev/null

if [ -e "$DOT_COVERAGE" ]; then
    sed -i '' -e "s|/app/|$REPO_ROOT_DIR/|g" "$DOT_COVERAGE"
fi

exit 0
