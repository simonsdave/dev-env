#!/usr/bin/env bash

#
# this is a private script (for now) which is intended only to be
# used by ```cut-release.sh```.
#

set -e

SCRIPT_DIR_NAME="$( cd "$( dirname "$0" )" && pwd )"

REPO_ROOT_DIR=$("${SCRIPT_DIR_NAME}/repo-root-dir.sh")

CHANGELOG_DOT_MD=${REPO_ROOT_DIR}/CHANGELOG.md

echo_if_verbose() {
    if [ "1" -eq "${VERBOSE:-0}" ]; then
        echo "${1:-}"
    fi
    return 0
}

VERBOSE=0

while true
do
    case "${1:-}" in
        --verbose)
            shift
            VERBOSE=1
            ;;
        *)
            break
            ;;
    esac
done

if [ $# != 2 ]; then
    echo "usage: $(basename "$0") [--verbose] <version> <release-branch>" >&2
    exit 1
fi

VERSION=${1:-}
RELEASE_BRANCH=${2:-}

TAG=v${VERSION:-}

GITHUB_PERSONAL_ACCESS_TOKEN=$(git config --global github.token)
if [ "" == "${GITHUB_PERSONAL_ACCESS_TOKEN:-}" ]; then
    echo "error getting github access token" >&2
    exit 1
fi

REPO=$(git config --get remote.origin.url | sed -e 's|^.*:||g' | sed -e 's|.git||g')
if ! curl -s -o /dev/null -u ":${GITHUB_PERSONAL_ACCESS_TOKEN}" "https://api.github.com/repos/${REPO}/releases"; then
    echo "error verifying github personal access token is usable" >&2
    exit 1
fi

CREATE_RELEASE_PAYLOAD=$(
  jq --null-input \
     --arg tag "${TAG}" \
     --arg branch "${RELEASE_BRANCH}" \
     --arg body "$(changelog-dot-md-release-comments.py --github "${VERSION}" "${CHANGELOG_DOT_MD}")" \
     '{ tag_name: $tag, name: $tag, target_commitish: $branch, body: $body, draft: false, prerelease: false }'
)

CREATE_RELEASE_ERROR_OUTPUT=$(mktemp 2> /dev/null || mktemp -t DAS)

if ! HTTP_STATUS_CODE=$(curl \
    -s \
    -u ":${GITHUB_PERSONAL_ACCESS_TOKEN}" \
    -o "${CREATE_RELEASE_ERROR_OUTPUT}" \
    -X POST \
    -H 'Content-Type: application/json' \
    -w '%{http_code}' \
    --data-binary "${CREATE_RELEASE_PAYLOAD}" \
    "https://api.github.com/repos/${REPO}/releases") \
    || \
    [ "${HTTP_STATUS_CODE}" != "201" ];
then
    echo "error creating github release - see errors @ '${CREATE_RELEASE_ERROR_OUTPUT}'" >&2
    exit 1
fi

rm -f "${CREATE_RELEASE_ERROR_OUTPUT}"

echo_if_verbose "Created github release - branch='${RELEASE_BRANCH}'; tag='${TAG}'"

exit 0

#----------------------------------------------------------------------

#
# with the new release branch created we can now create the github release
#

# 
# -- creating a release @ https://developer.github.com/v3/repos/releases/#create-a-release
#
# -- https://developer.github.com/v3/auth/#basic-authentication
# -- create a personal access tokens @ https://github.com/settings/tokens/new ... only need repo access
# -- save personal access token git config --global github.token TOKEN
# -- GITHUB_PERSONAL_ACCESS_TOKEN=$(git config --global github.token)
#
# -- REPO=$(git config --get remote.origin.url | sed -e 's|^.*:||g' | sed -e 's|.git||g')
# -- curl -u :$GITHUB_PERSONAL_ACCESS_TOKEN https://api.github.com/repos/${REPO}/releases
# -- validate token = test $? after executing curl -s -o /dev/null -u :${GITHUB_PERSONAL_ACCESS_TOKEN} https://api.github.com/repos/${REPO}/releases
#
# -- changelog-dot-md-release-comments.py --github "${VERSION}" "${REPO_ROOT_DIR}/CHANGELOG.md"
#
# -- application/x-gzip
# -- application/octet-stream
#
# -- [Small shell script to create GitHub releases from the command line](https://gist.github.com/foca/38d82e93e32610f5241709f8d5720156)
#
# "name": "dev_env-0.5.14-py2-none-any.whl",
# "content_type": "application/octet-stream",
# "browser_download_url": "https://github.com/simonsdave/dev-env/releases/download/v0.5.14/dev_env-0.5.14-py2-none-any.whl"
# 
# "name": "dev_env-0.5.14.tar.gz",
# "content_type": "application/x-gzip",
# "browser_download_url": "https://github.com/simonsdave/dev-env/releases/download/v0.5.14/dev_env-0.5.14.tar.gz"
#

