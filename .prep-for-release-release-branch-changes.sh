#!/usr/bin/env bash

set -e

SCRIPT_DIR_NAME="$( cd "$( dirname "$0" )" && pwd )"

if [ $# != 1 ]; then
    echo "usage: $(basename "$0") <release-branch>" >&2
    exit 1
fi

RELEASE_BRANCH=${1:-}

pushd "$SCRIPT_DIR_NAME"

sed -i -e \
    "s|?branch=master|?branch=$RELEASE_BRANCH|g" \
    "README.md"

sed -i -e \
    "s|(docs|(https://github.com/simonsdave/dev-env/tree/$RELEASE_BRANCH/docs|g" \
    "README.md"

pandoc README.md -o README.rst
python setup.py sdist --formats=gztar

popd

exit 0
