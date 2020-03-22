#!/usr/bin/env bash

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

EXIT_CODE=0

for FILENAME in $(find "${REPO_ROOT_DIR}" -name '*.sh' | grep -v ./env | sort); do
    if [ "1" -eq "${VERBOSE:-0}" ]; then
        echo -n "${FILENAME} ... "
    fi

    if [ -r "$(dirname "${FILENAME}")/.shelllintignore" ]; then
        if grep --silent "$(basename "${FILENAME}")" "$(dirname "${FILENAME}")/.shelllintignore"; then
            if [ "1" -eq "${VERBOSE:-0}" ]; then
                echo "ignoring"
            fi
            continue
        fi
    fi

    if ! shellcheck "${FILENAME}"; then
        EXIT_CODE=1
    else
        if [ "1" -eq "${VERBOSE:-0}" ]; then
            echo "ok"
        fi
    fi
done

exit ${EXIT_CODE}
