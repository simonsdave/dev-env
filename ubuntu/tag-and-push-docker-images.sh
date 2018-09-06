#!/usr/bin/env bash

set -e

SCRIPT_DIR_NAME="$( cd "$( dirname "$0" )" && pwd )"

if [ $# != 4 ]; then
    echo "usage: $(basename "$0") <username> <password> <current tag> <new tag>" >&2
    exit 1
fi

USERNAME=${1:-}
PASSWORD=${2:-}
CURRENT_TAG=${3:-}
NEW_TAG=${4:-}

"$SCRIPT_DIR_NAME/xenial/tag-and-push-docker-image.sh" \
    "${USERNAME}" \
    "${PASSWORD}" \
    "${CURRENT_TAG}" \
    "${NEW_TAG}"

exit 0
