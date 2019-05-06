#!/usr/bin/env bash

#
# see the README.md in the same directory as this script for a
# description of why this script exists what this script does
#

set -e

if [ $# != 0 ]; then
    echo "usage: $(basename "$0")" >&2
    exit 1
fi

REPO_ROOT_DIR=$(git rev-parse --show-toplevel)
DEV_ENV_VERSION=$(cat "${REPO_ROOT_DIR}/dev_env/dev-env-version.txt")
if [ "${DEV_ENV_VERSION:-}" == "latest" ]; then DEV_ENV_VERSION=master; fi

pip install "git+https://github.com/simonsdave/dev-env.git@$DEV_ENV_VERSION"

REPO_DOT_SH_DIR=$(dirname "$(command -v repo.sh)")
INCREMENT_VERSION_DOT_SH=${REPO_DOT_SH_DIR}/increment_version.sh
curl -s -L -o "${INCREMENT_VERSION_DOT_SH}" "https://raw.githubusercontent.com/fmahnke/shell-semver/master/increment_version.sh"
chmod a+x "${INCREMENT_VERSION_DOT_SH}"

exit 0
