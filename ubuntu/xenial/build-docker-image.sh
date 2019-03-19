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

#
# Dockerfile copied to context directory because some
# CI builds were generating the error
#
#   Dockerfile must be within the build context
#
# This is is a function of the docker version but still
# need to deal with the reality.
#
cp "$SCRIPT_DIR_NAME/Dockerfile" "$CONTEXT_DIR/."

pushd "$(git rev-parse --show-toplevel)/bin/in_container"
tar zcvf "$CONTEXT_DIR/in_container_sh_scripts.tar.gz" ./*.sh
popd

cp "$SCRIPT_DIR_NAME/requirements.txt" "$CONTEXT_DIR/."

IMAGE_NAME="$USERNAME/xenial-dev-env:$TAG"

docker build -t "$IMAGE_NAME" --file "$CONTEXT_DIR/Dockerfile" "$CONTEXT_DIR"

exit 0
