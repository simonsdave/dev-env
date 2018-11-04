#!/usr/bin/env bash

set -e

if [ $# -lt 3 ]; then
    echo "usage: $(basename "$0") <package> <user> <group> [<dir1> <dir2> ... <dir N>]" >&2
    exit 1
fi

PACKAGE=${1:-}
shift

USER=${1:-}
shift

GROUP=${1:-}
shift

echo nosetests \
    --with-coverage \
    --cover-erase \
    --cover-branches \
    "--cover-package=$PACKAGE" \
    "$@"

chown "$USER.$GROUP" "/app/.coverage"

exit 0
