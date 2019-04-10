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

grep '^\s*\-\s*image\:\s*' "$("${SCRIPT_DIR_NAME}/repo-root-dir.sh")/.circleci/config.yml" | \
    head -1 | \
    sed -e 's|^.*:||g' | \
    sed -e 's|[[:space:]]*$||g'

exit 0
