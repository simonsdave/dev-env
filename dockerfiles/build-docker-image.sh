#!/usr/bin/env bash

set -e

SCRIPT_DIR_NAME="$( cd "$( dirname "$0" )" && pwd )"

if [ $# != 1 ]; then
    echo "usage: $(basename "$0") <image-name>" >&2
    exit 1
fi

IMAGE_NAME=${1:-}

CONTEXT_DIR=$(mktemp -d 2> /dev/null || mktemp -d -t DAS)

# note - can't use repo-root-dir.sh
pushd "$(git rev-parse --show-toplevel)/bin/in-container"
tar zvcf "${CONTEXT_DIR}/scripts.tar.gz" ./*.sh
popd

cp "${SCRIPT_DIR_NAME}/requirements.txt" "${CONTEXT_DIR}/."

docker build \
    -t "${IMAGE_NAME}" \
    --file "${SCRIPT_DIR_NAME}/Dockerfile" \
    "${CONTEXT_DIR}"

rm -rf "${CONTEXT_DIR}"

exit 0
