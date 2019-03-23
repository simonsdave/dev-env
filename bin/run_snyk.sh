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

if [ $# != 1 ]; then
    echo "usage: $(basename "$0") [-v] <synk-token>" >&2
    exit 1
fi

SNYK_TOKEN=${1:-}

docker run \
    --rm \
    --volume "$($SCRIPT_DIR_NAME/repo-root-dir.sh):/app" \
    "$DEV_ENV_DOCKER_IMAGE" \
    run_snyk.sh "$SNYK_TOKEN"

exit 0
