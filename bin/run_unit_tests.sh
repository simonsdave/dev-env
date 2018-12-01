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

docker run \
    --rm \
    --security-opt "${DEV_ENV_SECURITY_OPT:-seccomp:unconfined}" \
    --volume "$DEV_ENV_SOURCE_CODE:/app" \
    "$DEV_ENV_DOCKER_IMAGE" \
    run_unit_tests.sh "$DEV_ENV_PACKAGE" "$@"

sed -i -e "s|/app/|$DEV_ENV_SOURCE_CODE/|g" "$DEV_ENV_SOURCE_CODE/.coverage"

exit 0
