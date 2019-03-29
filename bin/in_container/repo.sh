#!/usr/bin/env bash

#
# Assuming the PWD is any directory of a git repo, echo to stdout the repo name.
# To do the same for any directory other than the PWD use the -d command line switch.
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
    echo "usage: $(basename "$0") [-d] <dir-in-repo>" >&2
    exit 1
fi

pushd "$DIR_IN_REPO" > /dev/null

git config --get remote.origin.url | sed -e 's|^.*/||g' | sed -e 's|.git||g'

popd > /dev/null

exit 0
