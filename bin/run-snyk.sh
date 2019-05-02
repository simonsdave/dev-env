#!/usr/bin/env bash

#
# see the README.md in the same directory as this script for a
# description of why this script exists what this script does
#

set -e

SCRIPT_DIR_NAME="$( cd "$( dirname "$0" )" && pwd )"

PIP_INSTALL=0

while true
do
    case "$(echo "${1:-}" | tr "[:upper:]" "[:lower:]")" in
        #
        # the -p option is only expected to be used by the dev-env project itself
        #
        -p)
            shift
            PIP_INSTALL=1
            ;;
        *)
            break
            ;;
    esac
done

if [ $# != 1 ]; then
    echo "usage: $(basename "$0") [-p] <synk-token>" >&2
    exit 1
fi

SNYK_TOKEN=${1:-}

DUMMY_DOCKER_CONTAINER_NAME=$("${SCRIPT_DIR_NAME}/create-dummy-docker-container.sh")

docker run \
    --rm \
    --volumes-from "${DUMMY_DOCKER_CONTAINER_NAME}" \
    "$DEV_ENV_DOCKER_IMAGE" \
    /bin/bash -c "if [ $PIP_INSTALL == 1 ]; then pushd /app > /dev/null && pip install -r requirements.txt > /dev/null && popd > /dev/null; fi && snyk auth '$SNYK_TOKEN' && snyk test /app"

docker rm "${DUMMY_DOCKER_CONTAINER_NAME}" > /dev/null

exit 0
