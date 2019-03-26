#!/usr/bin/env bash

set -e

SCRIPT_DIR_NAME="$( cd "$( dirname "$0" )" && pwd )"

while true
do
    case "$(echo "${1:-}" | tr "[:upper:]" "[:lower:]")" in
        --help)
            shift
            echo "usage: $(basename "$0") [--help] [<dir1> <dir2> ... <dir N>]" >&2
            exit 1
            ;;
        *)
            break
            ;;
    esac
done

nosetests --with-coverage --cover-branches "--cover-package=$("$SCRIPT_DIR_NAME/repo.sh")" "$@"

exit 0
