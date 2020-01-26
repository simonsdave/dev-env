#!/usr/bin/env bash

set -e

SCRIPT_DIR_NAME="$( cd "$( dirname "$0" )" && pwd )"

if [ $# != 0 ]; then
    echo "usage: $(basename "$0")" >&2
    exit 1
fi

REPO_ROOT_DIR=$("${SCRIPT_DIR_NAME}/repo-root-dir.sh")
PACKAGE=$("${SCRIPT_DIR_NAME}/repo.sh" -u)

bandit --verbose --exclude "${REPO_ROOT_DIR}/env" -r "${REPO_ROOT_DIR}/${PACKAGE}"

exit 0
