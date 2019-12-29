#!/usr/bin/env bash

set -e

SCRIPT_DIR_NAME="$( cd "$( dirname "$0" )" && pwd )"

if [ $# != 0 ]; then
    echo "usage: $(basename "$0")" >&2
    exit 1
fi

find "$("${SCRIPT_DIR_NAME}/repo-root-dir.sh")" -name '*.json' | grep -v ./env | sort | while IFS='' read -r FILENAME
do
    echo -n "${FILENAME} ... "

    jq . "${FILENAME}" > /dev/null

    echo "ok"
done

exit 0
