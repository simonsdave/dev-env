#!/usr/bin/env bash

#
# See in_container/repo.sh for details
#

set -e

SCRIPT_DIR_NAME="$( cd "$( dirname "$0" )" && pwd )"

"$SCRIPT_DIR_NAME/in_container/repo.sh" "$@"

exit 0
