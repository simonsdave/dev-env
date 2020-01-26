#!/usr/bin/env bash

set -e

SCRIPT_DIR_NAME="$( cd "$( dirname "$0" )" && pwd )"

VERBOSE=0

while true
do
    case "$(echo "${1:-}" | tr "[:upper:]" "[:lower:]")" in
        -v|--verbose)
            shift
            VERBOSE=1
            ;;
        *)
            break
            ;;
    esac
done

if [ $# != 0 ]; then
    echo "usage: $(basename "$0") [-v]" >&2
    exit 1
fi

find "$("${SCRIPT_DIR_NAME}/repo-root-dir.sh")" -name '*.json' | grep -v ./env | sort | while IFS='' read -r FILENAME
do
    if [ "1" -eq "${VERBOSE:-0}" ]; then
        echo -n "${FILENAME} ... "
    fi

    jq . "${FILENAME}" > /dev/null

    if [ "1" -eq "${VERBOSE:-0}" ]; then
        echo "ok"
    fi
done

exit 0
