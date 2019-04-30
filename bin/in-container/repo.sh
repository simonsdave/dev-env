#!/usr/bin/env bash

#
# Assuming the PWD is any directory of a git repo, echo to stdout the repo name.
# To do the same for any directory other than the PWD use the -d command line switch.
#
# This project was started primarily to support python projects. One of the common
# conventions with a python project is to have a single package generated per repo
# and the name of the repo is the same name as the generated package. Further, if
# the repo name contains a dash (ex a-great-tool) the generated package name is
# the same as the repo name with dashes replaced by underscores (ex a_great_tool).
# The optional -u command line switch replaces all dashes in the repo name with
# underscores.
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
