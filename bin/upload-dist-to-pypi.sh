#!/usr/bin/env bash

set -e

if [ $# != 1 ]; then
    echo "usage: $(basename "$0") <repo>" >&2
    exit 1
fi

REPO=${1:-}

DOT_PYPIRC=$HOME/.pypirc
if [ ! -e "$DOT_PYPIRC" ]; then
    echo "Could not find '$DOT_PYPIRC'" >&2
    exit 1
fi

DIST_DIRECTORY=$(repo-root-dir.sh)/dist
if [ ! -d "$DIST_DIRECTORY" ]; then
    echo "Could not find package directory '$DIST_DIRECTORY'" >&2
    exit 1
fi

docker run \
    --rm \
    --volume "$(repo-root-dir.sh):/app" \
    --volume "$HOME:/pypirc" \
    "$DEV_ENV_DOCKER_IMAGE" \
    upload-dist-to-pypi.sh "$REPO"

exit 0