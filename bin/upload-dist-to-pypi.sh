#!/usr/bin/env bash

set -e

SCRIPT_DIR_NAME="$( cd "$( dirname "$0" )" && pwd )"

if [ $# != 1 ]; then
    echo "usage: $(basename "$0") <repo>" >&2
    exit 1
fi

REPO=${1:-}

DOT_PYPIRC=$HOME/.pypirc
if [ ! -e "${DOT_PYPIRC}" ]; then
    echo "Could not find '${DOT_PYPIRC}'" >&2
    exit 1
fi

REPO_ROOT_DIR=$("$SCRIPT_DIR_NAME/repo-root-dir.sh")
DIST_DIR=${REPO_ROOT_DIR}/dist
if [ ! -d "${DIST_DIR}" ]; then
    echo "Could not find package directory '${DIST_DIR}'" >&2
    exit 1
fi

#
# :TRICKY: little odd to explicitly address /usr/local/bin/upload-dist-to-pypi.sh
# below rather than let the PATH sort out where this script is located. however,
# with running this script for dev-env itself upload-dist-to-pypi.sh on the host
# would have been run recursively because /app/bin was the first directory in
# the docker container's path:-(
#
docker run \
    --rm \
    --volume "${REPO_ROOT_DIR}:/app" \
    --volume "${HOME}:/pypirc" \
    "${DEV_ENV_DOCKER_IMAGE}" \
    /usr/local/bin/upload-dist-to-pypi.sh "${REPO}"

exit 0
