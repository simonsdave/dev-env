#!/usr/bin/env bash

#
# scripts in the same directory as this script and the parent directory
# are sometimes supposed to be exactly the same. this script is inserted
# into the dev-env CI pipeline to confirm that's the case. scripts are
# considered the same if thier non-comment lines are the same.
#

set -e

SCRIPT_DIR_NAME="$( cd "$( dirname "$0" )" && pwd )"

confirm_same() {
    FILENAME=${1:-}

    echo "${FILENAME}"

    IN_CONTAINER_PARENT_FILENAME=$(mktemp 2> /dev/null || mktemp -t DAS)
    grep --extended-regexp --invert-match '^[[:space:]]*#' "${SCRIPT_DIR_NAME}/../${FILENAME}" > "${IN_CONTAINER_PARENT_FILENAME}"

    IN_CONTAINER_FILENAME=$(mktemp 2> /dev/null || mktemp -t DAS)
    grep --extended-regexp --invert-match '^[[:space:]]*#' "${SCRIPT_DIR_NAME}/${FILENAME}" > "${IN_CONTAINER_FILENAME}"
    
    diff "${IN_CONTAINER_PARENT_FILENAME}" "${IN_CONTAINER_FILENAME}" > /dev/null

    rm -f "${IN_CONTAINER_FILENAME}"

    rm -f "${IN_CONTAINER_PARENT_FILENAME}"
}

if [ $# != 0 ]; then
    echo "usage: $(basename "$0")" >&2
    exit 1
fi

confirm_same check-consistent-dev-env-version.sh
confirm_same create-dummy-docker-container.sh
confirm_same repo.sh
confirm_same repo-root-dir.sh

exit 0
