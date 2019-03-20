#!/usr/bin/env bash
#
# Remove all dangling images.
#
# Helpful reference(s):
# -- https://docs.docker.com/engine/reference/commandline/images/#filtering
#

set -e

docker rmi $(docker images --filter "dangling=true" -q)

exit 0
