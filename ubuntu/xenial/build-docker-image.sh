#!/usr/bin/env bash

set -e

SCRIPT_DIR_NAME="$( cd "$( dirname "$0" )" && pwd )"

if [ $# != 2 ]; then
    echo "usage: $(basename "$0") <username> <tag>" >&2
    exit 1
fi

USERNAME=${1:-}
TAG=${2:-}

CONTEXT_DIR=$(mktemp -d 2> /dev/null || mktemp -d -t DAS)

pushd "$(git rev-parse --show-toplevel)/bin/in_container"
tar zcvf "$CONTEXT_DIR/in_container_sh_scripts.tar.gz" ./*.sh
popd

cp "$SCRIPT_DIR_NAME/requirements.txt" "$CONTEXT_DIR/."

IMAGE_NAME="$USERNAME/xenial-dev-env:$TAG"

docker build -t "$IMAGE_NAME" --file "$SCRIPT_DIR_NAME/Dockerfile" "$CONTEXT_DIR"

exit 0
