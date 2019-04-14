#!/usr/bin/env bash

set -e

SCRIPT_DIR_NAME="$( cd "$( dirname "$0" )" && pwd )"

if [ $# != 0 ]; then
    echo "usage: $(basename "$0")" >&2
    exit 1
fi

REPO_ROOT_DIR=$("${SCRIPT_DIR_NAME}/repo-root-dir.sh")

find "${REPO_ROOT_DIR}" -name '*.yml' -or -name '*.yaml' | grep -v ./env | while IFS='' read -r FILENAME
do
    echo "$FILENAME"
    yamllint -c "${REPO_ROOT_DIR}/.yamllint" "$FILENAME"
done

exit 0
