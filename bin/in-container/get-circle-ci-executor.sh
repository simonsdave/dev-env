#!/usr/bin/env bash

SCRIPT_DIR_NAME="$( cd "$( dirname "$0" )" && pwd )"

usage() {
    echo "usage: $(basename "$0") [--config <circle ci config file>]" >&2
}

CIRCLECI_CONFIG=$("${SCRIPT_DIR_NAME}/repo-root-dir.sh")/.circleci/config.yml

while true
do
    case "$(echo "${1:-}" | tr "[:upper:]" "[:lower:]")" in
        --help)
            shift
            usage
            exit 0
            ;;
        --config)
            shift
            CIRCLECI_CONFIG=${1:-}
            shift
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

if [[ ! -f "${CIRCLECI_CONFIG}" ]]; then
    echo ">>>${CIRCLECI_CONFIG}<<< does not exist" >&2
    exit 2
fi

grep 'image:' < "${CIRCLECI_CONFIG}" | \
    head -1 | \
    sed -e 's|^.*\-[[:space:]]*image\:[[:space:]]*||g' |
    sed -e 's|[[:space:]]*$||g'

exit 0
