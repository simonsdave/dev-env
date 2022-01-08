#!/usr/bin/env bash

#
# see the README.md in the same directory as this script for a
# description of why this script exists what this script does
#

set -e

usage() {
    echo "usage: $(basename "$0") [--dev-env-version <version>]" >&2
}

check_version_number() {
    DEV_ENV_VERSION=${1:-}

    if [ "${DEV_ENV_VERSION}" == "latest" ]; then
        return 0
    fi

    if [[ "${DEV_ENV_VERSION}" =~ ^v[0-9]+\.[0-9]+ ]]; then
        return 0
    fi

    echo "invalid dev env version >>>${DEV_ENV_VERSION}<<<" >&2
    exit 1
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
            check_version_number "${DEV_ENV_VERSION}"
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

if [ "${VIRTUAL_ENV:-}" == "" ]; then
    echo "Virtual env not activated - could not find environment variable VIRTUAL_ENV" >&2
    exit 2
fi

if [ "${DEV_ENV_VERSION:-}" == "" ]; then
    REPO_ROOT_DIR=$(git rev-parse --show-toplevel)
    DEV_ENV_VERSION=$(grep 'image:' < "${REPO_ROOT_DIR}/.circleci/config.yml" | head -1 | sed -e 's|[[:space:]]*$||g' | sed -e 's|^.*dev-env:||g')
    check_version_number "${DEV_ENV_VERSION}"
fi

if [ "${DEV_ENV_VERSION:-}" == "latest" ]; then
    DEV_ENV_VERSION=master
fi

pip install "git+https://github.com/simonsdave/dev-env.git@${DEV_ENV_VERSION}"

INCREMENT_VERSION_DOT_SH=${VIRTUAL_ENV}/bin/increment_version.sh
curl -s -L -o "${INCREMENT_VERSION_DOT_SH}" "https://raw.githubusercontent.com/fmahnke/shell-semver/master/increment_version.sh"
chmod a+x "${INCREMENT_VERSION_DOT_SH}"

exit 0
