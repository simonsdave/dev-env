#!/usr/bin/env bash

set -e

echo "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^${0}^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
SCRIPT_DIR_NAME="$( cd "$( dirname "$0" )" && pwd )"

if [ $# != 0 ]; then
    echo "usage: $(basename "$0")" >&2
    exit 1
fi

set -x

echo "<<<<<${SCRIPT_DIR_NAME}>>>>>>"

REPO_ROOT_DIR=$("${SCRIPT_DIR_NAME}/repo-root-dir.sh")

rm -f "${REPO_ROOT_DIR}/README.rst" > /dev/null
rm -f "${REPO_ROOT_DIR}/README.txt" > /dev/null

pandoc "${REPO_ROOT_DIR}/README.md" -o "/tmp/README.rst"
pandoc "${REPO_ROOT_DIR}/README.md" -o "/tmp/README.txt"

echo "======================================"
ls -la "${REPO_ROOT_DIR}"
echo "======================================"
ls -la /tmp
echo "======================================"

set +x

exit 0
