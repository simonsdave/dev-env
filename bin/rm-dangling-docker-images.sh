#!/usr/bin/env bash

#
# see the README.md in the same directory as this script for a
# description of why this script exists what this script does
#

set -e

docker images --filter "dangling=true" -q | while IFS='' read -r IMAGE_ID
do
    docker rmi "$IMAGE_ID"
done

exit 0
