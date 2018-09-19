#!/usr/bin/env bash

set -e

if [ $# != 3 ]; then
    echo "usage: $(basename "$0") <user> <group> <package>" >&2
    exit 1
fi

USER=${1:-}
GROUP=${2:-}
PACKAGE=${3:-}

nosetests \
    --with-coverage \
    --cover-erase \
    --cover-branches \
    "--cover-package=$PACKAGE"

chown "$USER.$GROUP" /app/.coverage

exit 0
