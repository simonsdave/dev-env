#!/usr/bin/env bash

#
# see the README.md in the same directory as this script for a
# description of why this script exists what this script does
#

set -e

if [ $# != 0 ]; then
    echo "usage: $(basename "$0")" >&2
    exit 1
fi

DOT_COVERAGE=$(repo-root-dir.sh)/.coverage
if [ -e "${DOT_COVERAGE}" ]; then
    codecov -f "${DOT_COVERAGE}"
fi

exit 0
