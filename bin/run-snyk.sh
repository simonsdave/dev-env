#!/usr/bin/env bash

set -e

SCRIPT_DIR_NAME="$( cd "$( dirname "$0" )" && pwd )"

PIP_INSTALL=0

while true
do
    case "$(echo "${1:-}" | tr "[:upper:]" "[:lower:]")" in
        #
        # the -p option is only expected to be used by the dev-env project itself
        #
        -p)
            shift
            PIP_INSTALL=1
            ;;
        *)
            break
            ;;
    esac
done

if [ $# != 1 ]; then
    echo "usage: $(basename "$0") [-p] <synk-token>" >&2
    exit 1
fi

SNYK_TOKEN=${1:-}

set -x
docker run \
    --rm \
    --volume "$("$SCRIPT_DIR_NAME/repo-root-dir.sh"):/app" \
    "$DEV_ENV_DOCKER_IMAGE" \
    /bin/bash -c "if [ $PIP_INSTALL == 1 ]; then cd /app && pwd && ls -la && pip install -r requirements.txt; fi && snyk auth '$SNYK_TOKEN' && snyk test /app"
set -x

exit 0
