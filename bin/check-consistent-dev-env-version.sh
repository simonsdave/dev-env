#!/usr/bin/env bash

#
# see the README.md in the same directory as this script for a
# description of why this script exists what this script does
#

set -e

SCRIPT_DIR_NAME="$( cd "$( dirname "$0" )" && pwd )"

VERBOSE=0

usage() {
    echo "usage: $(basename "$0") [--verbose]" >&2
}

echo_if_verbose() {
    if [ "1" -eq "${VERBOSE:-0}" ]; then
        echo "${1:-}"
    fi
    return 0
}

normalize() {
    VERSION=${1:-}
    # intent = remove leading and trailing spaces
    # implementation removes all spaces which is fine
    # since versions shouldn't contain spaces anyway
    VERSION=${VERSION// /}
    if [[ "${VERSION}" =~ ^v.* ]]; then VERSION=${VERSION:1}; fi
    if [[ "${VERSION}" =~ ^master$ ]]; then VERSION=latest; fi
    echo ${VERSION}
}

while true
do
    case "${1:-}" in
        --verbose)
            shift
            VERBOSE=1
            ;;
        --help)
            shift
            usage
            exit 0
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

REPO_ROOT_DIR=$("${SCRIPT_DIR_NAME}/repo-root-dir.sh")

CIRCLECI_VERSION=$(grep '^\s*\-\s*image\:\s*' "${REPO_ROOT_DIR}/.circleci/config.yml" | \
    head -1 | \
    sed -e 's|^.*:||g' | \
    sed -e 's|[[:space:]]*$||g')
CIRCLECI_VERSION=$(normalize "${CIRCLECI_VERSION}")

DEV_ENV_VERSION=$(cat "${REPO_ROOT_DIR}/dev_env/dev-env-version.txt")
DEV_ENV_VERSION=$(normalize "${DEV_ENV_VERSION}")

echo_if_verbose "Comparing dev-env-version.txt of '${DEV_ENV_VERSION}' with CircelCI '${CIRCLECI_VERSION}'"

if [ "${CIRCLECI_VERSION}" != "${DEV_ENV_VERSION}" ]; then
    exit 1
fi

exit 0
