#!/usr/bin/env bash

SCRIPT_DIR_NAME="$( cd "$( dirname "$0" )" && pwd )"

usage() {
    echo "usage: $(basename "$0")" >&2
}

while true
do
    case "$(echo "${1:-}" | tr "[:upper:]" "[:lower:]")" in
        --help)
            shift
            usage
            exit 0
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

REPO_ROOT_DIR=$("${SCRIPT_DIR_NAME}/repo-root-dir.sh")

grep 'image:' < "${REPO_ROOT_DIR}/.circleci/config.yml" | \
    tail -1 | \
    sed -e 's|^.*\-[[:space:]]*image\:[[:space:]]*||g' |
    sed -e 's|[[:space:]]*$||g'

exit 0
