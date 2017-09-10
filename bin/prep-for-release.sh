#!/usr/bin/env bash

set -e

SCRIPT_DIR_NAME="$( cd "$( dirname "$0" )" && pwd )"

echo_if_verbose() {
    if [ "1" -eq "${VERBOSE:-0}" ]; then
        echo "${1:-}"
    fi
    return 0
}

confirm_ok_to_proceed() {
    if [ "0" -eq "${QUIET:-0}" ]; then
        while true
        do
            read -p "${1:-} (y/n)> " -n 1 -r
            echo

            case "${REPLY,,}" in
                y)
                    break
                    ;;
                n)
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
QUIET=0

while true
do
    case "${1,,}" in
        --verbose)
            shift
            VERBOSE=1
            ;;
        --quiet)
            shift
            QUIET=1
            ;;
        *)
            break
            ;;
    esac
done

if [ $# != 1 ]; then
    echo "usage: $(basename "$0") [--verbose|--quiet] <version>" >&2
    exit 1
fi

VERSION=${1:-}

#
# update CHANGELOG.md with version # and release date (today),
# get CHANGELOG.md in good shape for the next release and
# figure out what COMMIT_ID in master the release is based# off.
#
git checkout master

sed \
    -i \
    -e "s|%RELEASE_VERSION%|$VERSION|g" \
    "$SCRIPT_DIR_NAME/../CHANGELOG.md"

sed \
    -i \
    -e "s|%RELEASE_DATE%|$(date "+%Y-%m-%d")|g" \
    "$SCRIPT_DIR_NAME/../CHANGELOG.md"

git diff
confirm_ok_to_proceed "These changes to master look ok?"

git commit "$SCRIPT_DIR_NAME/../CHANGELOG.md" -m "$VERSION pre-release prep"
MASTER_RELEASE_COMMIT_ID=$(git rev-parse HEAD)

sed \
    -i \
    -e "s|## \\[$VERSION\\]|## [%RELEASE_VERSION%] - [%RELEASE_DATE%]\\n\\n## \\[$VERSION\\]|g" \
    "$SCRIPT_DIR_NAME/../CHANGELOG.md"

exit 0
git commit "$SCRIPT_DIR_NAME/../CHANGELOG.md" -m "Add CHANGELOG.md placeholder for next release"

git push origin master

#
# create release branch from the right commit on the master branch,
# change links in various files to point to the release branch rather
# than master (this is most of the reason that this whole script
# and associated process exist:-), confirm the changes look good
# and finally commit the changes
#

RELEASE_BRANCH="release-$VERSION"
git checkout -b "$RELEASE_BRANCH" master "$MASTER_RELEASE_COMMIT_ID"

sed \
    -i \
    -e "s|\\?branch=master|?branch=$RELEASE_BRANCH|g" \
    "$SCRIPT_DIR_NAME/../README.md"

git commit "$SCRIPT_DIR_NAME/../README.md" -m "$VERSION release prep"
RELEASE_COMMIT_ID=$(git rev-parse HEAD)

git push origin "$VERSION"

echo_if_verbose "Release should be based on commit '$RELEASE_COMMIT_ID' in branch '$RELEASE_BRANCH' with name & tag = 'v$VERSION'"

# https://github.com/simonsdave/dev-env/releases/new

exit 1

echo ">>>$VERSION<<<"
exit 0

