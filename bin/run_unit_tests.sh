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

#
# :TRICKY: nosetests is run inside the docker container.
# and if we simply let this happen the container would
# set the uid and gid of .coverage which can then make
# .coverage inaccessible by the host. to solve this
# problem we create an empty .coverage here (which runs
# on the host) so we can control .coverage's uid and gid.
#
echo "!coverage.py: This is a private format, don't read it directly!{}" > "$DEV_ENV_SOURCE_CODE/.coverage"
chmod a+wr "$DEV_ENV_SOURCE_CODE/.coverage"

docker run \
    --rm \
    --security-opt "${DEV_ENV_SECURITY_OPT:-seccomp:unconfined}" \
    --volume "$DEV_ENV_SOURCE_CODE:/app" \
    "$DEV_ENV_DOCKER_IMAGE" \
    nosetests --with-coverage --cover-branches "--cover-package=$DEV_ENV_PACKAGE" "$@"

if [ -e "$DEV_ENV_SOURCE_CODE/.coverage" ]; then
    sed -i -e "s|/app/|$DEV_ENV_SOURCE_CODE/|g" "$DEV_ENV_SOURCE_CODE/.coverage"
fi

exit 0
