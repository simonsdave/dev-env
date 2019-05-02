#!/usr/bin/env bash

#
# see the README.md in the same directory as this script for a
# description of why this script exists what this script does
#

set -e

SCRIPT_DIR_NAME="$( cd "$( dirname "$0" )" && pwd )"

if [ $# != 0 ]; then
    echo "usage: $(basename "$0")" >&2
    exit 1
fi

DUMMY_CONTAINER_NAME=$(python -c "import uuid; print uuid.uuid4().hex")

# explict pull to create opportunity to swallow stdout
docker pull alpine:3.4 > /dev/null

docker create \
    -v /app \
    --name "${DUMMY_CONTAINER_NAME}" \
    alpine:3.4 \
    /bin/true \
    > /dev/null

pushd "$("${SCRIPT_DIR_NAME}/repo-root-dir.sh")" > /dev/null
tar c . | docker cp - "${DUMMY_CONTAINER_NAME}:/app/."
popd > /dev/null

echo "${DUMMY_CONTAINER_NAME}"

exit 0
