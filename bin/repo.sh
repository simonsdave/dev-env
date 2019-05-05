#!/usr/bin/env bash

#
# see the README.md in the same directory as this script for a
# description of why this script exists what this script does
#

set -e

DIR_IN_REPO=$PWD
DASH_TO_UNDERSCORE=0

while true
do
    case "$(echo "${1:-}" | tr "[:upper:]" "[:lower:]")" in
        -d)
            shift
            DIR_IN_REPO=${1:-}
            shift
            ;;
        -u)
            shift
            DASH_TO_UNDERSCORE=1
            ;;
        *)
            break
            ;;
    esac
done

if [ $# != 0 ]; then
    echo "usage: $(basename "$0") [-d <dir-in-repo>] [-u]" >&2
    exit 1
fi

pushd "$DIR_IN_REPO" > /dev/null

RV=$(git config --get remote.origin.url | sed -e 's|^.*/||g' | sed -e 's|.git||g')

if [ 0 -eq "$DASH_TO_UNDERSCORE" ]; then
    echo "$RV"
else
    echo "${RV//-/_}"
fi

popd > /dev/null

exit 0
