#!/usr/bin/env bash

set -e

SCRIPT_DIR_NAME="$( cd "$( dirname "$0" )" && pwd )"

if [ $# != 0 ]; then
    echo "usage: $(basename "$0")" >&2
    exit 1
fi

REPO_ROOT_DIR=$("${SCRIPT_DIR_NAME}/repo-root-dir.sh")

rm -f "${REPO_ROOT_DIR}/README.rst" > /dev/null
rm -f "${REPO_ROOT_DIR}/README.txt" > /dev/null

pandoc "${REPO_ROOT_DIR}/README.md" -o "${REPO_ROOT_DIR}/README.rst"
pandoc "${REPO_ROOT_DIR}/README.md" -o "${REPO_ROOT_DIR}/README.txt"

exit 0
