#!/usr/bin/env bash

set -e

if [ $# != 1 ]; then
    echo "usage: $(basename "$0") <package>" >&2
    exit 1
fi

PACKAGE=${1:-}

nosetests \
    --with-coverage \
    --cover-erase \
    --cover-branches \
    "--cover-package=$PACKAGE"

exit 0
