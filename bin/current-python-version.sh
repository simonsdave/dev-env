#!/usr/bin/env bash

#
# In a typical python project you would expect to find an __init__.py
# containing the version number for the project. The version number is
# expected to appear on a single line in the __init.py looking something
# like:
#
#   __version__ = '1.2.0'
#
# This script extracts the version number from __init__.py and writes
# it to stdout.
#
# Assumptions
#
# -- the python project is in a git repo
#
# -- the PWD is somewhere in the git repo - this assumption can be
#    overridden using the -d command line option.
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

REPO_ROOT_DIR=$(git rev-parse --show-toplevel)
REPO=$(basename "$REPO_ROOT_DIR")
INIT_DOT_PY=$REPO_ROOT_DIR/${REPO//-/_}/__init__.py
grep __version__ "$INIT_DOT_PY" | sed -e "s|^.*=[[:space:]]*['\"]||g" | sed -e "s|['\"].*$||g"

popd > /dev/null

exit 0