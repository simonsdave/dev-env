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

#
# :TRICKY: want to use this script to run for app repos
# as well as the dev-env repo. All works for app repos
# but with dev-env the "docker run" below runs run-markdownlint.sh
# and since the dev-env docker build puts /app/bin
# at the start of the PATH, the docker run will actually
# run this script instead of the intended script in the
# in-container directory.
#
if [[ "/app/bin/${0##*/}" == "${0}" ]]; then
    "${SCRIPT_DIR_NAME}/in-container/${0##*/}" "$@"
    exit $?
fi

DUMMY_DOCKER_CONTAINER_NAME=$("${SCRIPT_DIR_NAME}/create-dummy-docker-container.sh")

DOCKER_CONTAINER_NAME=$(openssl rand -hex 16)

docker run \
    --name "${DOCKER_CONTAINER_NAME}" \
    --volumes-from "${DUMMY_DOCKER_CONTAINER_NAME}" \
    "${DEV_ENV_DOCKER_IMAGE}" \
    "${0##*/}" "$@"

REPO_ROOT_DIR=$("${SCRIPT_DIR_NAME}/repo-root-dir.sh")

rm -f "${REPO_ROOT_DIR}/README.rst"
docker container cp "${DOCKER_CONTAINER_NAME}:/app/README.rst" "${REPO_ROOT_DIR}/README.rst"

if [[ "${GEN_README_DOT_TXT}" == "1" ]]; then
    rm -f "${REPO_ROOT_DIR}/README.txt"
    docker container cp "${DOCKER_CONTAINER_NAME}:/app/README.txt" "${REPO_ROOT_DIR}/README.txt"
fi

docker container rm "${DOCKER_CONTAINER_NAME}" > /dev/null

docker container rm "${DUMMY_DOCKER_CONTAINER_NAME}" > /dev/null

exit 0
