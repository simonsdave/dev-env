# Using ```prep-for-release.sh```

:TODO: add intro

* ```master``` / ```main``` github branches are [protected](https://docs.github.com/en/github/administering-a-repository/managing-a-branch-protection-rule)
* per standard [GitHub flow](https://guides.github.com/introduction/flow/)
  * changes are made to topic / feature branches
  * [create pull requests](https://docs.github.com/en/github/collaborating-with-issues-and-pull-requests/creating-a-pull-request) to merge changes from feature branches into ```master``` / ```main``` branch

```bash
~> git status
On branch master
Your branch is up to date with 'origin/master'.

nothing to commit, working tree clean
~> # create branch
~> git branch use-python-semantic-release
~> # switch to branch
~> git checkout use-python-semantic-release
Switched to branch 'use-python-semantic-release'
~> git status
On branch use-python-semantic-release
nothing to commit, working tree clean
~> git diff CHANGELOG.md
feat: add sem release placeholder to CHANGELOG.md
diff --git a/CHANGELOG.md b/CHANGELOG.md
index bd4701b..aeebfb2 100644
--- a/CHANGELOG.md
+++ b/CHANGELOG.md
@@ -4,19 +4,7 @@ All notable changes to this project will be documented in this file.
 Format of this file follows [these](http://keepachangelog.com/) guidelines.
 This project adheres to [Semantic Versioning](http://semver.org/).

-## [%RELEASE_VERSION%] - [%RELEASE_DATE%]
-
-### Added
-
-* Nothing
-
-### Changed
-
-* Nothing
-
-### Removed
-
-* Nothing
+<!--next-version-placeholder-->

 ## [1.22.0] - [2020-12-27]

~> git commit CHANGELOG.md
[use-python-semantic-release 3b4c3a9] feat: add sem release placeholder to CHANGELOG.md
 1 file changed, 1 insertion(+), 13 deletions(-)
~> git push origin use-python-semantic-release
Enumerating objects: 5, done.
Counting objects: 100% (5/5), done.
Delta compression using up to 12 threads
Compressing objects: 100% (3/3), done.
Writing objects: 100% (3/3), 1.01 KiB | 1.01 MiB/s, done.
Total 3 (delta 2), reused 0 (delta 0), pack-reused 0
remote: Resolving deltas: 100% (2/2), completed with 2 local objects.
remote:
remote: Create a pull request for 'use-python-semantic-release' on GitHub by visiting:
remote:      https://github.com/simonsdave/dev-env-testing/pull/new/use-python-semantic-release
remote:
To github.com:simonsdave/dev-env-testing.git
 * [new branch]      use-python-semantic-release -> use-python-semantic-release
~> 
```

```bash
~> run-semantic-release.sh print-version --current
1.23.0%
~> run-semantic-release.sh print-version
1.24.0%
~>

```bash
~> run-semantic-release.sh changelog --verbosity=DEBUG
~>
```

* [8 Jun '15 - We fail to follow SemVer – and why it needn’t matter by Stephan Bönnemann at JSConf Budapest 2015](https://youtu.be/tc2UgG5L7WM)
* [relekang / python-semantic-release](https://github.com/relekang/python-semantic-release) - this
  is a Python implementation of [semantic-release](https://github.com/semantic-release/semantic-release)
  for JS - getting started docs are [here](https://python-semantic-release.readthedocs.io/en/latest/#getting-started)
* [Semantic Versioning Specification](https://semver.org/) - remember SemVer describes the "public API"
* [Angular Commit Message Format](https://github.com/angular/angular/blob/master/CONTRIBUTING.md#-commit-message-format)
* configuration in ```setup.cfg```
  per [these](https://python-semantic-release.readthedocs.io/en/latest/configuration.html#configuration)
  instructions
* [An Introduction to Github Actions](https://gabrieltanner.org/blog/an-introduction-to-github-actions)
* [Using semantic-release with GitHub Actions](https://github.com/semantic-release/semantic-release/blob/master/docs/recipes/github-actions.md)
* [Setting up python-semantic-release on GitHub Actions](https://python-semantic-release.readthedocs.io/en/latest/automatic-releases/github-actions.html)

```ini
[semantic_release]
version_variable = dev_env_testing/__init__.py:__version__
```

```markdown
# Change Log

All notable changes to this project will be documented in this file.
Format of this file follows [these](http://keepachangelog.com/) guidelines.
This project adheres to [Semantic Versioning](http://semver.org/).

<!--next-version-placeholder-->
```

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

```markdown
[![Build Status](https://travis-ci.org/simonsdave/dev-env.svg?branch=master)](https://travis-ci.org/simonsdave/dev-env)
```

This kind of build badge should be updated when cutting a release
and ```prep-for-release.sh``` will do that for you automatically
if you create a script called ```.prep-for-release-release-branch-changes.sh```
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

You can have any number of scripts called ```.prep-for-release-release-branch-changes.sh```
in any directory of the repo. ```prep-for-release.sh``` will find all
the scripts named ```.prep-for-release-release-branch-changes.sh``` and run them
when creating the release branch.

## What Next

* take a look at [my other projects on github](https://github.com/simonsdave)
  for examples of how ```dev-env``` is being used
* as you start to integrate ```dev-env``` into your projects
  some feedback would be great - create [issues](../../../issues) and/or
  send me an e-mail [simonsdave@gmail.com](mailto:simonsdave@gmail.com) - thanks in advance!
