#!/usr/bin/env bash

#
# see the README.md in the same directory as this script for a
# description of why this script exists what this script does
#

set -e

for CONTAINER_ID in $(docker ps -q); do
    docker container kill "${CONTAINER_ID}"
done

for CONTAINER_ID in $(docker ps -a -q); do
    docker container rm "${CONTAINER_ID}"
done

exit 0
