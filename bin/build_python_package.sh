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
    --security-opt "${DEV_ENV_SECURITY_OPT:-seccomp:unconfined}" \
    "$DEV_ENV_DOCKER_IMAGE" \
    python setup.py sdist --formats=gztar

# /bin/bash -c 'mkdir ~/newapp; cp -r /app ~/newapp/.; cd ~/newapp/app; python setup.py sdist --formats=gztar; echo "--------------------"; echo ~; ls -la ~/newapp/app/dist; echo "--------------------"'

# rm -rf "$DEV_ENV_SOURCE_CODE/dist"
# mkdir "$DEV_ENV_SOURCE_CODE/dist"
# docker cp "$DOCKER_CONTAINER_NAME:/newapp/app/dist/*" "$DEV_ENV_SOURCE_CODE/dist/."

docker rm "$DOCKER_CONTAINER_NAME"

ls -la "$DEV_ENV_SOURCE_CODE/dist"

set +x

exit 0
