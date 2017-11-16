#!/usr/bin/env bash

set -e

SCRIPT_DIR_NAME="$( cd "$( dirname "$0" )" && pwd )"

if [ $# != 1 ]; then
    echo "usage: $(basename "$0") <release-branch>" >&2
    exit 1
fi

RELEASE_BRANCH=${1:-}

search_and_replace() {
    if ! git diff --quiet "${2:-}"; then exit 2; fi
    sed -i -e "${1:-}" "${2:-}"
    if git diff --quiet "${2:-}"; then exit 2; fi
    return 0
}

search_and_replace \
    "s|\\/master\\/|\\/$RELEASE_BRANCH\\/|g" \
    "$SCRIPT_DIR_NAME/create_dev_env.sh"

search_and_replace \
    "s|\\/master\\/|\\/$RELEASE_BRANCH\\/|g" \
    "$SCRIPT_DIR_NAME/Vagrantfile"

search_and_replace \
    "s|dev-env.git@master|dev-env.git@$RELEASE_BRANCH|g" \
    "$SCRIPT_DIR_NAME/provision.sh"

exit 0
