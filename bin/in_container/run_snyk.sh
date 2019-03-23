#!/usr/bin/env bash

set -e

SCRIPT_DIR_NAME="$( cd "$( dirname "$0" )" && pwd )"

while true
do
    case "$(echo "${1:-}" | tr "[:upper:]" "[:lower:]")" in
        -v)
            shift
            ;;
        *)
            break
            ;;
    esac
done

if [ $# != 1 ]; then
    echo "usage: $(basename "$0") [-v] <synk-token>" >&2
    exit 1
fi

SNYK_TOKEN=${1:-}

snyk auth "$SNYK_TOKEN" && snyk test "$("$SCRIPT_DIR_NAME/repo-root-dir.sh")"

exit 0
