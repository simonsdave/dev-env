# Using ```prep-for-release.sh```

:TODO: add intro

## Conventions

* have a ```CHANGELOG.md``` in a repo's root directory
* ```CHANGELOG.md``` has a specific format
* for each release a new branch (```release-<version>```) is created
based on the current version of master
* repos may contain things like ```README.md``` with references to
branch specific badges and these branch references need to be
updated prior to cutting a release

## The Basics

* :TODO: complete me please

## Release Branch Change Scripts

As an example, your repo
probably contains a ```README.md``` in the repo's root directory and there's
a link to a build badge.

```
[![Build Status](https://travis-ci.org/simonsdave/dev-env.svg?branch=master)](https://travis-ci.org/simonsdave/dev-env)
```

This kind of build badge should be updated when cutting a release
and ```prep-for-release.sh``` will do that for you automatically
if you create a script called ```.prep-for-release-branch-changes.sh```
and put it in the repo's root directory.

```bash
#!/usr/bin/env bash

set -e

SCRIPT_DIR_NAME="$( cd "$( dirname "$0" )" && pwd )"

if [ $# != 1 ]; then
    echo "usage: $(basename "$0") <release-branch>" >&2
    exit 1
fi

RELEASE_BRANCH=${1:-}

search_and_replace() {
    if ! git diff --quiet "${2:-}"; then exit 1; fi
    sed -i -e "${1:-}" "${2:-}"
    if git diff --quiet "${2:-}"; then exit 2; fi
    return 0
}

search_and_replace \
    "s|\\?branch=master|?branch=$RELEASE_BRANCH|g" \
    "$SCRIPT_DIR_NAME/README.md"

exit 0
```

You can have any number of scripts called ```.prep-for-release-branch-changes.sh```
in any directory of the repo. ```prep-for-release.sh``` will find all
the scripts named ```.prep-for-release-branch-changes.sh``` and run them
when creating the release branch.
