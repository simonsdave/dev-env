#!/usr/bin/env bash

set -e

if [ $# != 0 ]; then
    echo "usage: $(basename "$0")" >&2
    exit 1
fi

MARKDOWNLINT_STYLE_RB=/app/.markdownlint-style.rb
if [[ ! -r "${MARKDOWNLINT_STYLE_RB}" ]]; then
    MARKDOWNLINT_STYLE_RB=$(mktemp 2> /dev/null || mktemp -t DAS)
    echo 'all' > "${MARKDOWNLINT_STYLE_RB}"
fi

EXIT_CODE=0

for MD_FILE_NAME in $(find /app -name '*.md' | grep -v -E "^/app/(build|env)"); do
    echo "${MD_FILE_NAME}"
    if ! mdl --style "${MARKDOWNLINT_STYLE_RB}" "${MD_FILE_NAME}"; then
        EXIT_CODE=1
    fi
done

exit ${EXIT_CODE}
