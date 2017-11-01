#!/usr/bin/env bash

set -e

SCRIPT_DIR_NAME="$( cd "$( dirname "$0" )" && pwd )"

if [ $# != 1 ]; then
    echo "usage: $(basename "$0") <release-branch>" >&2
    exit 1
fi

RELEASE_BRANCH=${1:-}

sed -i -e \
    "s|\\?branch=master|?branch=$RELEASE_BRANCH|g" \
    "$SCRIPT_DIR_NAME/README.md"

exit 0
