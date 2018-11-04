#!/usr/bin/env bash

set -e

if [ $# != 0 ]; then
    echo "usage: $(basename "$0")" >&2
    exit 1
fi


if [[ -v DEV_ENV_SECURITY_OPT ]]; then
    DEV_ENV_SECURITY_OPT_COMMAND="--security-opt"
else
    DEV_ENV_SECURITY_OPT_COMMAND=""
fi

USER=$(stat -c "%u" "$0")
GROUP=$(stat -c "%g" "$0")
docker run --rm "${DEV_ENV_SECURITY_OPT_COMMAND:-}" "${DEV_ENV_SECURITY_OPT:-}" --volume "$DEV_ENV_SOURCE_CODE:/app" "$DEV_ENV_DOCKER_IMAGE" run_unit_tests.sh "$DEV_ENV_PACKAGE" "$USER" "$GROUP"

sed -i -e "s|/app/|$DEV_ENV_SOURCE_CODE/|g" "$DEV_ENV_SOURCE_CODE/.coverage"

exit 0
