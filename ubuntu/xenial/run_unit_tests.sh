#!/usr/bin/env bash

set -e

if [ $# -lt 1 ]; then
    echo "usage: $(basename "$0") <package> [<dir1> <dir2> ... <dirN>]" >&2
    exit 1
fi

PACKAGE=${1:-}
shift

nosetests \
    --with-coverage \
    --cover-branches \
    "--cover-package=$PACKAGE" \
    "$@"

exit 0
