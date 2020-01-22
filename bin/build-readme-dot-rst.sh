#!/usr/bin/env bash

#
# see the README.md in the same directory as this script for a
# description of why this script exists what this script does
#

set -e

SCRIPT_DIR_NAME="$( cd "$( dirname "$0" )" && pwd )"

GEN_README_DOT_TXT=0

while true
do
    case "$(echo "${1:-}" | tr "[:upper:]" "[:lower:]")" in
        -t|--text)
            shift
            GEN_README_DOT_TXT=1
            ;;
        *)
            break
            ;;
    esac
done

if [ $# != 0 ]; then
    echo "usage: $(basename "$0") [--text]" >&2
    exit 1
fi

REPO_ROOT_DIR=$("${SCRIPT_DIR_NAME}/repo-root-dir.sh")

DOCKER_CONTAINER_NAME=$(python3 -c "import uuid; print(uuid.uuid4().hex)")

docker run \
    --name "${DOCKER_CONTAINER_NAME}" \
    --volume "${REPO_ROOT_DIR}:/app" \
    "${DEV_ENV_DOCKER_IMAGE}" \
    /bin/bash -c 'pandoc "/app/README.md" -o "/tmp/README.rst"; pandoc "/app/README.md" -o "/tmp/README.txt"'

rm -f "${REPO_ROOT_DIR}/README.rst"
docker container cp "${DOCKER_CONTAINER_NAME}:/tmp/README.rst" "${REPO_ROOT_DIR}/README.rst"

if [[ "${GEN_README_DOT_TXT}" == "1" ]]; then
    rm -f "${REPO_ROOT_DIR}/README.txt"
    docker container cp "${DOCKER_CONTAINER_NAME}:/tmp/README.txt" "${REPO_ROOT_DIR}/README.txt"
fi

docker container rm "${DOCKER_CONTAINER_NAME}" > /dev/null

exit 0
