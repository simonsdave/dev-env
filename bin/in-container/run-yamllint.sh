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

REPO_ROOT_DIR=$("${SCRIPT_DIR_NAME}/repo-root-dir.sh")

if [ ! -e "${REPO_ROOT_DIR}/.yamllint" ]; then
    echo "could not find .yamllint in root directory of project" >&2
    exit 1
fi

find "${REPO_ROOT_DIR}" -name '*.yml' -or -name '*.yaml' | grep -v ./env | while IFS='' read -r FILENAME
do
    if [ "1" -eq "${VERBOSE:-0}" ]; then
        echo -n "${FILENAME} ... "
    fi

    yamllint -c "${REPO_ROOT_DIR}/.yamllint" "$FILENAME"

    if [ "1" -eq "${VERBOSE:-0}" ]; then
        echo "ok"
    fi
done

exit 0
