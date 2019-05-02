#!/usr/bin/env bash

#
# see the README.md in the same directory as this script for a
# description of why this script exists what this script does
#

set -e

if [ $# != 0 ]; then
    echo "usage: $(basename "$0")" >&2
    exit 1
fi

git log -p | docker run -i --rm "$DEV_ENV_DOCKER_IMAGE" scanrepo

exit 0
