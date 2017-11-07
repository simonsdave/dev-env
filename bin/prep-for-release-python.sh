#!/usr/bin/env bash

#
# prep-for-release-python.sh is a python specific wrapper around
# the general purpose prep-for-release.sh. To run prep-for-release.sh
# you need the release version number. For Python projects this
# version number can be extracted from the project's __init__.py
# file.
#

set -e

if [ $# != 0 ]; then
    echo "usage: $(basename "$0")" >&2
    exit 1
fi

REPO_ROOT_DIR=$(git rev-parse --show-toplevel)
REPO=$(basename "$REPO_ROOT_DIR")
INIT_DOT_PY=$REPO_ROOT_DIR/${REPO//-/_}/__init__.py
CURRENT_VERSION=$(grep __version__ "$INIT_DOT_PY" | sed -e "s|^.*=\\s*['\"]||g" | sed -e "s|['\"].*$||g")

prep-for-release.sh "$CURRENT_VERSION"

exit 0
