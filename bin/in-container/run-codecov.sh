#!/usr/bin/env bash

set -e

if [ $# != 0 ]; then
    echo "usage: $(basename "$0")" >&2
    exit 1
fi

codecov

exit 0
