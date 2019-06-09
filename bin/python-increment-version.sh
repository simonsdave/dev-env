#!/usr/bin/env bash

#
# see the README.md in the same directory as this script for a
# description of why this script exists what this script does
#
# see https://github.com/fmahnke/shell-semver for details on increment_version.sh
#

set -e

SCRIPT_DIR_NAME="$( cd "$( dirname "$0" )" && pwd )"

usage() {
    echo "usage: $(basename "$0") <release-type>" >&2
}

if [ $# != 1 ]; then
    usage
    exit 1
fi

RELEASE_TYPE=${1:-}
if [[ ! ${RELEASE_TYPE} =~ [Mmp] ]]; then
    usage
    exit 1
fi

INIT_DOT_PY=$("${SCRIPT_DIR_NAME}/repo-root-dir.sh")/$("${SCRIPT_DIR_NAME}/repo.sh" -u)/__init__.py
CURRENT_VERSION=$(python-version.sh)
NEXT_VERSION=$("${SCRIPT_DIR_NAME}/increment_version.sh" "-${RELEASE_TYPE}" "${CURRENT_VERSION}")

sed \
    -i "" \
    -e "s|^[[:space:]]*__version__[[:space:]]*=[[:space:]]*['\"]${CURRENT_VERSION}['\"][[:space:]]*$|__version__ = '${NEXT_VERSION}'|g" "${INIT_DOT_PY}"

exit 0
