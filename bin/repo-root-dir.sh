#!/usr/bin/env bash

#
# see the README.md in the same directory as this script for a
# description of why this script exists what this script does
#

set -e

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

git rev-parse --show-toplevel

popd > /dev/null

exit 0
