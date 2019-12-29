#!/usr/bin/env bash

#
# see the README.md in the same directory as this script for a
# description of why this script exists what this script does
#

set -e

usage() {
    echo "usage: $(basename "$0") [--yes|--verbose]" >&2
}

echo_if_verbose() {
    if [ "1" -eq "${VERBOSE:-0}" ]; then
        echo "$@"
    fi
    return 0
}

confirm_ok_to_proceed() {
    if [ "0" -eq "${YES:-0}" ]; then
        while true
        do
            read -p "${1:-} (y/n)> " -n 1 -r
            echo

            case "${REPLY:-}" in
                [yY])
                    break
                    ;;
                [nN])
                    exit 0
                    ;;
                *)
                    ;;
            esac
        done
    fi
    return 0
}

VERBOSE=0
YES=0

while true
do
    case "$(echo "${1:-}" | tr "[:upper:]" "[:lower:]")" in
        --help)
            shift
            usage
            exit 0
            ;;
        --yes|-y)
            shift
            YES=1
            ;;
        --verbose)
            shift
            VERBOSE=1
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

confirm_ok_to_proceed "WARNING: destructive changes are about to happen!!! Ok proceed?"

echo_if_verbose "Killing running containers ..."
for CONTAINER_ID in $(docker ps -q); do
    docker container kill "${CONTAINER_ID}"
done

echo_if_verbose "Removing exited containers ..."
for CONTAINER_ID in $(docker ps -a -q); do
    docker container rm "${CONTAINER_ID}"
done

echo_if_verbose "Removing dangling docker images ..."
docker images --filter "dangling=true" -q | while IFS='' read -r IMAGE_ID
do
    docker rmi "${IMAGE_ID}"
done

exit 0
