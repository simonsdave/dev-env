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

find "$("${SCRIPT_DIR_NAME}/repo-root-dir.sh")" -name \*.sh | grep -v ./env | while IFS='' read -r FILENAME
do
    if [ "1" -eq "${VERBOSE:-0}" ]; then
        echo "$FILENAME"
    fi
    MNT_DIR=$(dirname "$FILENAME")
    MNT_FILE=$(basename "$FILENAME")
    docker run --rm -v "$MNT_DIR:/mnt" koalaman/shellcheck:latest "$MNT_FILE"
done

exit 0
