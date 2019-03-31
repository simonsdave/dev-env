#!/usr/bin/env bash

set -e

if [ $# != 1 ]; then
    echo "usage: $(basename "$0") <repo>" >&2
    exit 1
fi

REPO=${1:-}

twine upload /app/dist/* -r "$REPO" --config-file /pypirc/.pypirc

exit 0
