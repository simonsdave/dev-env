#!/usr/bin/env bash

set -e

SCRIPT_DIR_NAME="$( cd "$( dirname "$0" )" && pwd )"

if [ $# != 1 ]; then
    echo "usage: $(basename "$0") <release-branch>" >&2
    exit 1
fi

RELEASE_BRANCH=${1:-}

REPO_ROOT_DIR=$(repo-root-dir.sh)

# README.md -------------------------------------------------------------------

# requires.io
sed -i '' \
    -e \
    "s|?branch=master|?branch=${RELEASE_BRANCH}|g" \
    "${REPO_ROOT_DIR}/README.md"

# CodeFactor
sed -i '' \
    -e \
    "s|/badge/master|/badge/${RELEASE_BRANCH}|g" \
    "${REPO_ROOT_DIR}/README.md"

sed -i '' \
    -e \
    "s|/overview/master|/overview/${RELEASE_BRANCH}|g" \
    "${REPO_ROOT_DIR}/README.md"

# CircleCI
sed -i '' \
    -e \
    "s|/tree/master|/tree/${RELEASE_BRANCH}|g" \
    "${REPO_ROOT_DIR}/README.md"

# codecov
sed -i '' \
    -e \
    "s|/branch/master|/branch/${RELEASE_BRANCH}|g" \
    "${REPO_ROOT_DIR}/README.md"

# don't need to do anything for docker images

# -----------------------------------------------------------------------------

rm -f "${SCRIPT_DIR_NAME}/README.rst"
build-readme-dot-rst.sh

rm -rf "${SCRIPT_DIR_NAME}/dist"
build-python-package.sh

exit 0
