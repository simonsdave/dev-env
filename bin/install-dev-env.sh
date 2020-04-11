#!/usr/bin/env bash

#
# see the README.md in the same directory as this script for a
# description of why this script exists what this script does
#

set -e

usage() {
    echo "usage: $(basename "$0") [--dev-env-version <version>]" >&2
}

DEV_ENV_VERSION=""

while true
do
    case "$(echo "${1:-}" | tr "[:upper:]" "[:lower:]")" in
        --dev-env-version)
            # the only known user of this command line option is cloudfeaster's
            # install-dev-env-scripts.sh script
            shift
            DEV_ENV_VERSION=${1:-}
            shift
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

if [ "${DEV_ENV_VERSION:-}" == "" ]; then
    REPO_ROOT_DIR=$(git rev-parse --show-toplevel)
    DEV_ENV_VERSION=$(grep 'image:' < "${REPO_ROOT_DIR}/.circleci/config.yml" | tail -1 | sed -e 's|[[:space:]]*$||g' | sed -e 's|^.*dev-env:||g')
    if [ "${DEV_ENV_VERSION:-}" == "latest" ]; then DEV_ENV_VERSION=master; fi
fi

python3.7 -m pip install "git+https://github.com/simonsdave/dev-env.git@${DEV_ENV_VERSION}"

REPO_DOT_SH_DIR=$(dirname "$(command -v repo.sh)")
INCREMENT_VERSION_DOT_SH=${REPO_DOT_SH_DIR}/increment_version.sh
curl -s -L -o "${INCREMENT_VERSION_DOT_SH}" "https://raw.githubusercontent.com/fmahnke/shell-semver/master/increment_version.sh"
chmod a+x "${INCREMENT_VERSION_DOT_SH}"

exit 0
