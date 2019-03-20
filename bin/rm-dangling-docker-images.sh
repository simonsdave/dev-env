#!/usr/bin/env bash
#
# Remove all dangling images.
#
# Helpful reference(s):
# -- https://docs.docker.com/engine/reference/commandline/images/#filtering
#

set -e

docker images --filter "dangling=true" -q | while IFS='' read -r IMAGE_ID
do
    docker rmi "$IMAGE_ID"
done

exit 0
