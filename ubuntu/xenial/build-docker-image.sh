#!/usr/bin/env bash

set -e

SCRIPT_DIR_NAME="$( cd "$( dirname "$0" )" && pwd )"

if [ $# != 2 ]; then
    echo "usage: $(basename "$0") <username> <tag>" >&2
    exit 1
fi

USERNAME=${1:-}
TAG=${2:-}

IMAGE_NAME="$USERNAME/xenial-dev-env:$TAG"

docker build -t "$IMAGE_NAME" "$SCRIPT_DIR_NAME/."

exit 0
