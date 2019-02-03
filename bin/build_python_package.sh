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
DOCKER_CONTAINER_NAME=$(python -c "import uuid; print uuid.uuid4().hex")

docker run \
    --name "$DOCKER_CONTAINER_NAME" \
    --volume "$DEV_ENV_SOURCE_CODE:/app" \
    "$DEV_ENV_DOCKER_IMAGE" \
    /bin/bash -c "cp -r /app /tmp/; cd /tmp/app; python setup.py sdist --formats=gztar"

rm -rf "$DEV_ENV_SOURCE_CODE/dist"
mkdir "$DEV_ENV_SOURCE_CODE/dist"
docker cp "$DOCKER_CONTAINER_NAME:/tmp/app/dist/*" "$DEV_ENV_SOURCE_CODE/dist/."

docker rm "$DOCKER_CONTAINER_NAME"

set +x

ls -la "$DEV_ENV_SOURCE_CODE/dist"

exit 0
