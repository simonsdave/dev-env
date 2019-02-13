#!/usr/bin/env bash

set -e

TIMEZONE=EST

while true
do
    case "$(echo "${1:-}" | tr "[:upper:]" "[:lower:]")" in
        --timezone)
            shift
            TIMEZONE=${1:-EST}
            shift
            ;;
        *)
            break
            ;;
    esac
done

if [ $# != 4 ]; then
    echo "usage: $(basename "$0") [--timezone <timezone>] <github username> <github email> <github public key> <github private key>" >&2
    exit 1
fi

if [ ! -r "provision.sh" ]; then
    echo "Can't read 'provision.sh'"
    exit 1
fi

if [ ! -r "${3:-}" ]; then
    echo "Can't read SSH public key file '${3:-}'"
    exit 1
fi
BASE64_ENCODED_GITHUB_SSH_PUBLIC_KEY=$(base64 < "${3:-}")

if [ ! -r "${4:-}" ]; then
    echo "Can't read SSH private key file '${4:-}'"
    exit 1
fi
BASE64_ENCODED_GITHUB_SSH_PRIVATE_KEY=$(base64 < "${4:-}")

VAGRANT_GITHUB_USERNAME=${1:-} \
    VAGRANT_GITHUB_EMAIL=${2:-} \
    VAGRANT_BASE64_ENCODED_GITHUB_SSH_PUBLIC_KEY=$BASE64_ENCODED_GITHUB_SSH_PUBLIC_KEY \
    VAGRANT_BASE64_ENCODED_GITHUB_SSH_PRIVATE_KEY=$BASE64_ENCODED_GITHUB_SSH_PRIVATE_KEY \
    VAGRANT_TIMEZONE=$TIMEZONE \
    vagrant up

exit $?
