#!/usr/bin/env bash

#
# see the README.md in the same directory as this script for a
# description of why this script exists what this script does
#

set -e

if [ $# != 0 ]; then
    echo "usage: $(basename "$0")" >&2
    exit 1
fi

REPO_ROOT_DIR=$(git rev-parse --show-toplevel)
REPO=$(basename "$REPO_ROOT_DIR")
INIT_DOT_PY=$REPO_ROOT_DIR/${REPO//-/_}/__init__.py
CURRENT_VERSION=$(grep __version__ "$INIT_DOT_PY" | sed -e "s|^.*=[[:space:]]*['\"]||g" | sed -e "s|['\"].*$||g")

prep-for-release.sh "$CURRENT_VERSION"

exit 0
