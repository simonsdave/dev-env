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

MARKDOWNLINT_STYLE_RB=${REPO_ROOT_DIR}/.markdownlint-style.rb
if [[ ! -r "${MARKDOWNLINT_STYLE_RB}" ]]; then
    MARKDOWNLINT_STYLE_RB=$(mktemp 2> /dev/null || mktemp -t DAS)
    echo 'all' > "${MARKDOWNLINT_STYLE_RB}"
fi

EXIT_CODE=0

for MD_FILE_NAME in $(find "${REPO_ROOT_DIR}" -name '*.md' | grep -v ./env | sort); do
    if [ "1" -eq "${VERBOSE:-0}" ]; then
        echo -n "${MD_FILE_NAME} ... "
    fi

    if ! mdl --style "${MARKDOWNLINT_STYLE_RB}" "${MD_FILE_NAME}"; then
        EXIT_CODE=1
    else
        if [ "1" -eq "${VERBOSE:-0}" ]; then
            echo "ok"
        fi
    fi
done

exit ${EXIT_CODE}
