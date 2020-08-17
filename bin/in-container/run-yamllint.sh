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

if [ -r "${REPO_ROOT_DIR}/.yamllint" ]; then
    DOT_YAMLLINT=${REPO_ROOT_DIR}/.yamllint
else
    DOT_YAMLLINT=$(mktemp 2> /dev/null || mktemp -t DAS)
    echo '---' >> "${DOT_YAMLLINT}"
    echo 'extends: default' >> "${DOT_YAMLLINT}"
fi

find "${REPO_ROOT_DIR}" -name '*.yml' -or -name '*.yaml' | grep -v ./env | while IFS='' read -r FILENAME
do
    if [ "1" -eq "${VERBOSE:-0}" ]; then
        echo -n "${FILENAME} ... "
    fi

    if [ -r "$(dirname "${FILENAME}")/.yamllintignore" ]; then
        if grep --silent "$(basename "${FILENAME}")" "$(dirname "${FILENAME}")/.yamllintignore"; then
            if [ "1" -eq "${VERBOSE:-0}" ]; then
                echo "ignoring"
            fi
            continue
        fi
    fi

    yamllint -c "${DOT_YAMLLINT}" "${FILENAME}"

    if [ "1" -eq "${VERBOSE:-0}" ]; then
        echo "ok"
    fi
done

if [ "${DOT_YAMLLINT}" != "${REPO_ROOT_DIR}/.yamllint" ]; then
    rm -f "${DOT_YAMLLINT}"
fi

exit 0
