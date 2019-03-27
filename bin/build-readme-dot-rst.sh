#!/usr/bin/env bash

set -e

usage() {
    echo "usage: $(basename "$0") [--help]" >&2
}

while true
do
    case "$(echo "${1:-}" | tr "[:upper:]" "[:lower:]")" in
        --help)
            shift
            usage
            exit 1
            ;;
        *)
            break
            ;;
    esac
done

if [ $# != 0 ]; then
    usage
    exit 1
fi

#
# :TRICKY: The implementation below feels more complicated than it
# should be but was arrived at to deal with permissioning instability/inconsistency
# when the simple/obvious thing to do would be to have the "python /app/README.md /app/README.rst"
# run inside the container generating README.rst directly into a
# directory on the host mapped into the container using --volume.
# The solution does all the generation of README.rst inside the container
# and then manually pulls the README.rst out of the container before
# manually deleting the container. It's a little awkward but it's reliable.
#
DOCKER_CONTAINER_NAME=$(python -c "import uuid; print uuid.uuid4().hex")

docker run \
    --name "$DOCKER_CONTAINER_NAME" \
    --volume "$DEV_ENV_SOURCE_CODE:/app" \
    "$DEV_ENV_DOCKER_IMAGE" \
    /bin/bash -c 'pandoc /app/README.md -o ~/README.rst'

HOME_DIR_IN_CONTAINER=$(docker run --rm "$DEV_ENV_DOCKER_IMAGE" /bin/bash -c 'echo ~')
rm -f "$DEV_ENV_SOURCE_CODE/README.rst"
docker container cp "$DOCKER_CONTAINER_NAME:$HOME_DIR_IN_CONTAINER/README.rst" "$DEV_ENV_SOURCE_CODE"

docker container rm "$DOCKER_CONTAINER_NAME"

exit 0
