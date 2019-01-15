#!/usr/bin/env bash

set -e

if [ $# -lt 3 ]; then
    echo "usage: $(basename "$0") <package> <user> <group> [<dir1> <dir2> ... <dirN>]" >&2
    exit 1
fi

PACKAGE=${1:-}
shift

USER=${1:-}
shift

GROUP=${1:-}
shift

nosetests \
    --with-coverage \
    --cover-erase \
    --cover-branches \
    "--cover-package=$PACKAGE" \
    "$@"

if [ -e "/app/.coverage" ]; then
    chown "$USER.$GROUP" "/app/.coverage"
fi

exit 0
