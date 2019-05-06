#!/usr/bin/env bash

#
# see the README.md in the same directory as this script for a
# description of why this script exists what this script does
#

set -e

SCRIPT_DIR_NAME="$( cd "$( dirname "$0" )" && pwd )"

DIR_IN_REPO=$PWD

while true
do
    case "$(echo "${1:-}" | tr "[:upper:]" "[:lower:]")" in
        -d)
            shift
            DIR_IN_REPO=${1:-}
            shift
            ;;
        *)
            break
            ;;
    esac
done

if [ $# != 0 ]; then
    echo "usage: $(basename "$0") [-d <dir-in-repo>]" >&2
    exit 1
fi

pushd "$DIR_IN_REPO" > /dev/null

REPO=$("${SCRIPT_DIR_NAME}/repo.sh")
INIT_DOT_PY=$("${SCRIPT_DIR_NAME}/repo-root-dir.sh")/${REPO//-/_}/__init__.py
grep __version__ "$INIT_DOT_PY" | sed -e "s|^.*=[[:space:]]*['\"]||g" | sed -e "s|['\"].*$||g"

popd > /dev/null

exit 0
