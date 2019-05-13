#!/usr/bin/env bash

#
# this is a private script (for now) which is intended only to be
# used by ```cut-release.sh```.
#
# helpful references to understand this code
# -- https://developer.github.com/v3/repos/releases/#create-a-release
# -- https://developer.github.com/v3/repos/releases/#upload-a-release-asset
# -- https://curl.haxx.se/docs/manpage.html
# -- inspiration from https://gist.github.com/foca/38d82e93e32610f5241709f8d5720156
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

GITHUB_PERSONAL_ACCESS_TOKEN=$(git config --global github.token || true)
if [ "" == "${GITHUB_PERSONAL_ACCESS_TOKEN:-}" ]; then
    echo "error getting github access token" >&2
    exit 1
fi

REPO=$(git config --get remote.origin.url | sed -e 's|^.*:||g' | sed -e 's|.git||g')
if ! curl -s --fail -o /dev/null -u ":${GITHUB_PERSONAL_ACCESS_TOKEN}" "https://api.github.com/repos/${REPO}/releases"; then
    echo "error verifying github personal access token is usable" >&2
    exit 1
fi

CREATE_RELEASE_PAYLOAD=$(
  jq --null-input \
     --arg tag "${TAG}" \
     --arg branch "${RELEASE_BRANCH}" \
     --arg body "$(changelog-dot-md-release-comments.py "${VERSION}" "${CHANGELOG_DOT_MD}")" \
     '{ tag_name: $tag, name: $tag, target_commitish: $branch, body: $body, draft: false, prerelease: false }'
)

CREATE_RELEASE_OUTPUT=$(mktemp 2> /dev/null || mktemp -t DAS)

curl \
    -s \
    -u ":${GITHUB_PERSONAL_ACCESS_TOKEN}" \
    -o "${CREATE_RELEASE_OUTPUT}" \
    -X POST \
    -H 'Content-Type: application/json' \
    --data-binary "${CREATE_RELEASE_PAYLOAD}" \
    "https://api.github.com/repos/${REPO}/releases"

ASSET_UPLOAD_URL=$(jq -r .upload_url "${CREATE_RELEASE_OUTPUT}")
if [ "null" == "${ASSET_UPLOAD_URL}" ]; then
    echo "error creating release - error details in '${CREATE_RELEASE_OUTPUT}'" >&2
    exit 1
fi
ASSET_UPLOAD_URL=${ASSET_UPLOAD_URL%%{*}

rm -f "${CREATE_RELEASE_OUTPUT}"

find "${REPO_ROOT_DIR}/dist" -name \* | while IFS= read -r ASSET; do
    case "${ASSET##*.}" in
        whl)
            ASSET_CONTENT_TYPE=application/octet-stream
            ;;
        gz)
            ASSET_CONTENT_TYPE=application/x-gzip
            ;;
        *)
            echo_if_verbose "ignorning '${ASSET}' because couldn't derive content type"
            continue
            ;;
    esac

    UPLOAD_ASSET_OUTPUT=$(mktemp 2> /dev/null || mktemp -t DAS)

    curl \
        -s \
        -u ":${GITHUB_PERSONAL_ACCESS_TOKEN}" \
        -o "${UPLOAD_ASSET_OUTPUT}" \
        --header "Content-Type:${ASSET_CONTENT_TYPE}" \
        --data-binary "@${ASSET}" \
        "${ASSET_UPLOAD_URL}?name=$(basename "${ASSET}")"

    if [ "null" == "$(jq -r .browser_download_url "${UPLOAD_ASSET_OUTPUT}")" ]; then
        echo "error uploading asset '${ASSET}' - error details in '${UPLOAD_ASSET_OUTPUT}'" >&2
        exit 1
    fi
done

echo_if_verbose "Successfully created github release - branch='${RELEASE_BRANCH}'; tag='${TAG}'"

exit 0
