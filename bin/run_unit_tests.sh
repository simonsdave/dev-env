#!/usr/bin/env bash

set -e

while true
do
    case "${1:-}" in
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

rm -f "$DEV_ENV_SOURCE_CODE/.coverage"
touch "$DEV_ENV_SOURCE_CODE/.coverage"
chmod a+wr "$DEV_ENV_SOURCE_CODE/.coverage"

docker run \
    --rm \
    --security-opt "${DEV_ENV_SECURITY_OPT:-seccomp:unconfined}" \
    --volume "$DEV_ENV_SOURCE_CODE:/app" \
    "$DEV_ENV_DOCKER_IMAGE" \
    run_unit_tests.sh "$DEV_ENV_PACKAGE" "$@"

if [ -e "$DEV_ENV_SOURCE_CODE/.coverage" ]; then
    sed -i -e "s|/app/|$DEV_ENV_SOURCE_CODE/|g" "$DEV_ENV_SOURCE_CODE/.coverage"
fi

exit 0
