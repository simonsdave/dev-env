#!/usr/bin/env bash

set -e

usage() {
    echo "usage: $(basename "$0") [--help]" >&2
}

python3.9 setup.py bdist_wheel sdist --formats=gztar
twine check dist/*

exit 0
