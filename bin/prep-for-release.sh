#!/usr/bin/env bash

# see contributing.md for where this script fits into
# the release process

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
RELEASE_DATE=$(date "+%Y-%m-%d")

#
# CHANGELOG.md must exist @ the top of the repo
#
CHANGELOG_DOT_MD=$(git rev-parse --show-toplevel)/CHANGELOG.md
if [ ! -r "$CHANGELOG_DOT_MD" ]; then
    echo "could not find change log @ '$CHANGELOG_DOT_MD'" >&2
    exit 2
fi

#
# on the master branch update CHANGELOG.md with version # and release date (today),
# put CHANGELOG.md in good shape for the next release and
# figure out what COMMIT_ID in master the release is based# off.
#
git checkout master

# this check is enforced so commands like "git diff" and "git commit"
# can be executed across the entire repo rather than picking out
# individual files which is important because want this script to
# provide a framework which other repos can extend (specifically other
# repos should be able to provide their own customizations to the
# release branch.
if ! git diff-index --quiet HEAD --; then
    echo "$(basename "$0") won't work if there are outstanding commits on master" >&2
    exit 2
fi

sed \
    -i \
    -e "s|## \\[%RELEASE_VERSION%\\] \\- \\[%RELEASE_DATE%\\]|## \\[$VERSION\\] \\- \\[$RELEASE_DATE\\]|g" \
    "$CHANGELOG_DOT_MD"
# :TODO: check if the above sed command actually did anything

git diff
confirm_ok_to_proceed "These changes to master look ok?"

git commit -a -m "$VERSION pre-release prep"
MASTER_RELEASE_COMMIT_ID=$(git rev-parse HEAD)

sed \
    -i \
    -e "s|## \\[$VERSION\\] \\- \\[$RELEASE_DATE\\]|## [%RELEASE_VERSION%] \\- [%RELEASE_DATE%]\\n\\n### Added\\n\\n- Nothing\\n\\n### Changed\\n\\n- Nothing\\n\\n### Removed\\n\\n- Nothing\\n\\n\\## [$VERSION\\] \\- \\[$RELEASE_DATE\\]|g" \
    "$CHANGELOG_DOT_MD"
# :TODO: check if the above sed command actually did anything

git diff
confirm_ok_to_proceed "These changes to master look ok?"

git commit -a -m "Prep CHANGELOG.md for next release"

# :TODO: does this push need to be here? can we put the master
# and release branch pushes in the same spot so all changes
# to both the master and release branches are made locally
# and then together pushed to the remote branches?
git push origin master

#
# create release branch from the right commit on the master branch,
# change links in various files to point to the release branch rather
# than master (this is most of the reason that this whole script
# and associated process exist:-), confirm the changes look good
# and finally commit the changes
#

RELEASE_BRANCH="release-$VERSION"
git branch "$RELEASE_BRANCH" "$MASTER_RELEASE_COMMIT_ID"
git checkout "$RELEASE_BRANCH"

#------------------------------
#
# this is the part of this script that should be customized
# for the specifics of a repo
#

sed \
    -i \
    -e "s|\\?branch=master|?branch=$RELEASE_BRANCH|g" \
    "$SCRIPT_DIR_NAME/../README.md"
# :TODO: check if the above sed command actually did anything

sed \
    -i \
    -e "s|\\/master\\/|\\/$RELEASE_BRANCH\\/|g" \
    "$SCRIPT_DIR_NAME/../ubuntu/trusty/create_dev_env.sh"
# :TODO: check if the above sed command actually did anything

sed \
    -i \
    -e "s|\\/master\\/|\\/$RELEASE_BRANCH\\/|g" \
    "$SCRIPT_DIR_NAME/../ubuntu/trusty/Vagrantfile"
# :TODO: check if the above sed command actually did anything

#
#------------------------------

git diff 
confirm_ok_to_proceed "These changes to $RELEASE_BRANCH look ok?"

git commit -a -m "$VERSION release prep"
RELEASE_COMMIT_ID=$(git rev-parse HEAD)

git push origin "$RELEASE_BRANCH"

echo_if_verbose "Release should be based on commit '$RELEASE_COMMIT_ID' in branch '$RELEASE_BRANCH' with name & tag = 'v$VERSION'"

git checkout master

exit 0