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

REPO_ROOT_DIR=$("${SCRIPT_DIR_NAME}/repo-root-dir.sh")

CIRCLECI_VERSION=$(grep '^\s*\-\s*image\:\s*' "${REPO_ROOT_DIR}/.circleci/config.yml" | \
    head -1 | \
    sed -e 's|^.*:||g' | \
    sed -e 's|[[:space:]]*$||g')

DEV_ENV_VERSION=$(cat "${REPO_ROOT_DIR}/dev_env/dev-env-version.txt")
echo ">>>$DEV_ENV_VERSION<<<"

exit 0
