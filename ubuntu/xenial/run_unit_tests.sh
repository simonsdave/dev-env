#!/usr/bin/env bash

set -e

if [ $# != 3 ]; then
    echo "usage: $(basename "$0") <package> <user> <group>" >&2
    exit 1
fi

PACKAGE=${1:-}
USER=${2:-}
GROUP=${3:-}

nosetests \
    --with-coverage \
    --cover-erase \
    --cover-branches \
    "--cover-package=$PACKAGE"

chown "$USER.$GROUP" "/app/.coverage"

exit 0
