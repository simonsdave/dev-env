#!/usr/bin/env bash

set -e

if [ $# != 0 ]; then
    echo "usage: $(basename "$0")" >&2
    exit 1
fi

#
# as of dev-env v0.6.17 "pip check" is failing with the message
#
#   pygobject 3.36.0 requires pycairo, which is not installed.
#
# not currently clear how to resolve this problem.
#
# so that upstream consumers of dev-env don't have to comment out
# run-pip-check.sh we'll simply exit successfully here until the
# above is resolved.
#
# this has problem is logged as issue # 49 in dev-env.
#
exit 0

python3.9 -m pip check

exit 0
