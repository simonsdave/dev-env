#!/usr/bin/env bash

#
# see the README.md in the same directory as this script for a
# description of why this script exists what this script does
#

set -e

SCRIPT_DIR_NAME="$( cd "$( dirname "$0" )" && pwd )"

REPO_ROOT_DIR=$("${SCRIPT_DIR_NAME}/repo-root-dir.sh")

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

if [ $# != 0 ]; then
    echo "usage: $(basename "$0") [--verbose|--quiet]" >&2
    exit 1
fi

#
# .cut-release-version.sh must exist @ the top of the repo and be executable
#
DOT_CUT_RELEASE_VERSION=${REPO_ROOT_DIR}/.cut-release-version.sh
if [ ! -x "${DOT_CUT_RELEASE_VERSION}" ]; then
    echo "could not find executable '${DOT_CUT_RELEASE_VERSION}'" >&2
    exit 2
fi
VERSION=$("${DOT_CUT_RELEASE_VERSION}")
RELEASE_DATE=$(date "+%Y-%m-%d")

#
# CHANGELOG.md must exist @ the top of the repo
#
CHANGELOG_DOT_MD=${REPO_ROOT_DIR}/CHANGELOG.md
if [ ! -r "${CHANGELOG_DOT_MD}" ]; then
    echo "could not find change log @ '${CHANGELOG_DOT_MD}'" >&2
    exit 2
fi

#----------------------------------------------------------------------

#
# on the master branch update CHANGELOG.md with version # and release date (today),
# figure out what COMMIT_ID in master the release is based# off.
#

git checkout master

#
# this check is enforced so commands like "git diff" and "git commit"
# can be executed across the entire repo rather than picking out
# individual files which is important because want this script to
# provide a framework which other repos can extend (specifically other
# repos should be able to provide their own customizations to the
# release branch.
#
if ! git diff-index --quiet HEAD --; then
    echo "$(basename "$0") won't work if there are outstanding commits on master" >&2
    exit 2
fi

"${SCRIPT_DIR_NAME}/cut-changelog-dot-md.py" "${VERSION}" "${RELEASE_DATE}" "${CHANGELOG_DOT_MD}"
# :TODO: check if the above sed command actually did anything

git diff
confirm_ok_to_proceed "These changes to master for release look ok?"

git commit -a -m "${VERSION} pre-release prep"
MASTER_RELEASE_COMMIT_ID=$(git rev-parse HEAD)

#----------------------------------------------------------------------

#
# changes to master to prep for next release
#

"${SCRIPT_DIR_NAME}/add-new-changelog-dot-md-release.py" "${CHANGELOG_DOT_MD}"
# :TODO: check if the above sed command actually did anything

# the while loop pattern below looks awkward but came as a result
# dealing with https://github.com/koalaman/shellcheck/wiki/SC2044
echo_if_verbose "Looking for and executing master branch change scripts"
find "${REPO_ROOT_DIR}" -name .cut-release-master-branch-changes.sh | while IFS= read -r MASTER_BRANCH_CHANGE_SCRIPT; do
    if [ -x "${MASTER_BRANCH_CHANGE_SCRIPT}" ]; then
        echo_if_verbose "Executing '${MASTER_BRANCH_CHANGE_SCRIPT}'"
        "${MASTER_BRANCH_CHANGE_SCRIPT}"
    fi
done
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

RELEASE_BRANCH="release-${VERSION}"
git branch "${RELEASE_BRANCH}" "${MASTER_RELEASE_COMMIT_ID}"
git checkout "${RELEASE_BRANCH}"

# the while loop pattern below looks awkward but came as a result
# dealing with https://github.com/koalaman/shellcheck/wiki/SC2044
echo_if_verbose "Looking for and executing release branch change scripts"
find "${REPO_ROOT_DIR}" -name .cut-release-release-branch-changes.sh | while IFS= read -r RELEASE_BRANCH_CHANGE_SCRIPT; do
    if [ -x "${RELEASE_BRANCH_CHANGE_SCRIPT}" ]; then
        echo_if_verbose "Executing '${RELEASE_BRANCH_CHANGE_SCRIPT}'"
        "${RELEASE_BRANCH_CHANGE_SCRIPT}" "${RELEASE_BRANCH}"
    fi
done
echo_if_verbose "Done looking for and executing release branch change scripts"

git diff 
confirm_ok_to_proceed "These changes to ${RELEASE_BRANCH} look ok?"

# "git commit" will fail if there are no changes to commit
# this should be a very rare case
if ! git diff-index --quiet HEAD --; then
    git commit -a -m "${VERSION} release prep"
fi

#----------------------------------------------------------------------

#
# all changes have been made locally - now it's time to push changes to github
#
confirm_ok_to_proceed "All changes made locally. Ok to push changes to github?"

git checkout master
git push origin master

git checkout "${RELEASE_BRANCH}"
git push origin "${RELEASE_BRANCH}"

#----------------------------------------------------------------------

#
# create a github release
#
"${SCRIPT_DIR_NAME}/create-github-release.sh" "${VERSION}" "${RELEASE_BRANCH}"

#----------------------------------------------------------------------

#
# get back to the master branch so we're ready for dev now the release
# has been cut
#
git checkout master

#
# all done:-)
#
echo_if_verbose "All done!"

exit 0
