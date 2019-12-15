#!/usr/bin/env bash

set -e

usage() {
    echo "usage: $(basename "$0") [--help]" >&2
}

python3 setup.py bdist_wheel sdist --formats=gztar

exit 0
