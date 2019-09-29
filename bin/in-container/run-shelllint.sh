#!/usr/bin/env bash

set -e

SCRIPT_DIR_NAME="$( cd "$( dirname "$0" )" && pwd )"

VERBOSE=0

while true
do
    case "$(echo "${1:-}" | tr "[:upper:]" "[:lower:]")" in
        -v)
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

find "$("${SCRIPT_DIR_NAME}/repo-root-dir.sh")" -name '*.sh' | grep -v ./env | sort | while IFS='' read -r FILENAME
do
    if [ -r "$(dirname "${FILENAME}")/.shelllintignore" ]; then
        if grep --silent "$(basename "${FILENAME}")" "$(dirname "${FILENAME}")/.shelllintignore"; then
            if [ "1" -eq "${VERBOSE:-0}" ]; then
                echo "Ignoring ${FILENAME}"
            fi
            continue
        fi
    fi

    if [ "1" -eq "${VERBOSE:-0}" ]; then
        echo "${FILENAME}"
    fi

    shellcheck "${FILENAME}"
done

exit 0
