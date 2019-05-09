#!/usr/bin/env bash

#
# see the README.md in the same directory as this script for a
# description of why this script exists what this script does
#
# see https://github.com/fmahnke/shell-semver for details on increment_version.sh
#

set -e

SCRIPT_DIR_NAME="$( cd "$( dirname "$0" )" && pwd )"

INIT_DOT_PY=$("${SCRIPT_DIR_NAME}/repo-root-dir.sh")/$("${SCRIPT_DIR_NAME}/repo.sh" -u)/__init__.py
CURRENT_VERSION=$(python-version.sh)
NEXT_VERSION=$("${SCRIPT_DIR_NAME}/increment_version.sh" "$@" "${CURRENT_VERSION}")

sed \
    -i "" \
    -e "s|^[[:space:]]*__version__[[:space:]]*=[[:space:]]*['\"]${CURRENT_VERSION}['\"][[:space:]]*$|__version__ = '${NEXT_VERSION}'|g" "${INIT_DOT_PY}"

exit 0
