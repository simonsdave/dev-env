#!/usr/bin/env bash

# see contributing.md for where this script fits into
# the release process

set -e

REPO_ROOT_DIR=$(git rev-parse --show-toplevel)

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
QUIET=0

while true
do
    case "${1:-}" in
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
CHANGELOG_DOT_MD=$REPO_ROOT_DIR/CHANGELOG.md
if [ ! -r "$CHANGELOG_DOT_MD" ]; then
    echo "could not find change log @ '$CHANGELOG_DOT_MD'" >&2
    exit 2
fi

#----------------------------------------------------------------------

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
confirm_ok_to_proceed "These changes to master for release look ok?"

git commit -a -m "$VERSION pre-release prep"
MASTER_RELEASE_COMMIT_ID=$(git rev-parse HEAD)

#----------------------------------------------------------------------

#
# changes to master to prep for next release
#

sed \
    -i \
    -e "s|## \\[$VERSION\\] \\- \\[$RELEASE_DATE\\]|## [%RELEASE_VERSION%] \\- [%RELEASE_DATE%]\\n\\n### Added\\n\\n- Nothing\\n\\n### Changed\\n\\n- Nothing\\n\\n### Removed\\n\\n- Nothing\\n\\n\\## [$VERSION\\] \\- \\[$RELEASE_DATE\\]|g" \
    "$CHANGELOG_DOT_MD"
# :TODO: check if the above sed command actually did anything

# the while loop pattern below looks awkward but came as a result
# dealing with https://github.com/koalaman/shellcheck/wiki/SC2044
echo_if_verbose "Looking for and executing master branch change scripts"
while IFS= read -r -d '' MASTER_BRANCH_CHANGE_SCRIPT
do
    echo_if_verbose "Executing '$MASTER_BRANCH_CHANGE_SCRIPT'"
    "$MASTER_BRANCH_CHANGE_SCRIPT"
done < <(find "$REPO_ROOT_DIR" -executable -name .prep-for-release-master-branch-changes.sh -print0)
echo_if_verbose "Done looking for and executing master branch change scripts"

git diff
confirm_ok_to_proceed "These changes to master for next release look ok?"

git commit -a -m "Prep CHANGELOG.md for next release"

#----------------------------------------------------------------------

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

# the while loop pattern below looks awkward but came as a result
# dealing with https://github.com/koalaman/shellcheck/wiki/SC2044
echo_if_verbose "Looking for and executing release branch change scripts"
while IFS= read -r -d '' RELEASE_BRANCH_CHANGE_SCRIPT
do
    echo_if_verbose "Executing '$RELEASE_BRANCH_CHANGE_SCRIPT'"
    "$RELEASE_BRANCH_CHANGE_SCRIPT" "$RELEASE_BRANCH"
done < <(find "$REPO_ROOT_DIR" -executable -name .prep-for-release-release-branch-changes.sh -print0)
echo_if_verbose "Done looking for and executing release branch change scripts"

git diff 
confirm_ok_to_proceed "These changes to $RELEASE_BRANCH look ok?"

# "git commit" will fail if there are no changes to commit
# this should be a very rare case
if ! git diff-index --quiet HEAD --; then
    git commit -a -m "$VERSION release prep"
    RELEASE_COMMIT_ID=$(git rev-parse HEAD)
fi

#----------------------------------------------------------------------

#
# all changes have been made locally - now it's time to push changes to github
#
confirm_ok_to_proceed "All changes made locally. Ok to push changes to github?"

git checkout master
git push origin master

git checkout "$RELEASE_BRANCH"
git push origin "$RELEASE_BRANCH"

git checkout master

#
# all done:-)
#
echo_if_verbose "Release should be based on commit '$RELEASE_COMMIT_ID' in branch '$RELEASE_BRANCH' with name & tag = 'v$VERSION'"

exit 0
