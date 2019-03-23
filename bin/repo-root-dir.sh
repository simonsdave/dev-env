#!/usr/bin/env bash

#
# Assuming the PWD is any directory of a git repo, echo to stdout the repo's
# root directory. To do the same for any directory other than the PWD use the
# -d command line switch.
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
