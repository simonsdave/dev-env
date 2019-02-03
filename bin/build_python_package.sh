#!/usr/bin/env bash

# https://docs.python.org/2/distutils/sourcedist.html

set -e

usage() {
    echo "usage: $(basename "$0")" >&2
}

while true
do
    case "${1:-}" in
        --help)
            shift
            usage
            exit 1
            ;;
        *)
            break
            ;;
    esac
done

if [ $# != 0 ]; then
    usage
    exit 1
fi

set -x
rm -rf "$DEV_ENV_SOURCE_CODE/dist"
mkdir "$DEV_ENV_SOURCE_CODE/dist"
chmod a+rw "$DEV_ENV_SOURCE_CODE/dist"

docker run \
    --rm \
    --volume "$DEV_ENV_SOURCE_CODE:/app" \
    "$DEV_ENV_DOCKER_IMAGE" \
    python setup.py sdist --formats=gztar
set +x

ls -la "$DEV_ENV_SOURCE_CODE/dist"

exit 0
