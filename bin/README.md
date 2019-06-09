This directory contains a collection of scripts which simplify working with your development environment.
For example, it should be easy to figure out the root directory of the git repo in which you're working
regardless of whether you're trying to do that on the host machine, in the ```dev_env``` or in a CI/CD pipeline.
Not only should it be easy but it should also be consistent. So, for example, the task of determining
the root directory of your git repo is accomplished by calling ```repo-root-dir.sh```.

References

* [Shell Parameter Expansion](https://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html)

# Repo Info

## [repo.sh](repo.sh)

Assuming the PWD is any directory of a git repo, echo to stdout the repo name.
To do the same for any directory other than the PWD use the -d command line switch.

This project was started primarily to support python projects. One of the common
conventions with a python project is to have a single package generated per repo
and the name of the repo is the same name as the generated package. Further, if
the repo name contains a dash (ex a-great-tool) the generated package name is
the same as the repo name with dashes replaced by underscores (ex a_great_tool).
The optional -u command line switch replaces all dashes in the repo name with
underscores.

The example below illustrates what's described above.

```bash
~> echo $PWD
/Users/simonsdave/dev-env/bin
~> ./repo.sh
dev-env
~> ./repo.sh -u
dev_env
~> cd
~> pwd
/Users/simonsdave
~> /Users/simonsdave/dev-env/bin/repo.sh -d /Users/simonsdave/dev-env
dev-env
~>
```

## [repo-root-dir.sh](repo-root-dir.sh)

Assuming the PWD is any directory of a git repo, echo to stdout the repo's
root directory. How's this useful? Assume you have a shell script in some
child directory of the repo that needs to find a script in the bin directory
of the repo. Also assume that the same script could be moved to a different
child directory. Using ```repo-root-dir.sh``` reduces the likihood of
forgetting to change the script when its moved between child directories.

The example below illustrates what's described above.

```bash
~> pwd
/Users/simonsdave/dev-env/bin
~> ./repo-root-dir.sh
/Users/simonsdave/dev-env
~>
```

## [python-version.sh](python-version.sh)

In a typical python project you would expect to find an ```__init__.py```
containing the version number for the project. The version number is
expected to appear on a single line in the ```__init__.py``` looking something
like:

```python
__version__ = '1.2.0'
```

This script extracts the version number from __init__.py and writes
it to stdout.

Assumptions

* the python project is in a git repo
* if the repo is called de-mo, the ```__init__.py``` containing the version
number will be found in ```de_mo/__init__.py``` relative to the top of
the project's repo - note that "-" was transformed to a "_" which is
done for all underscores
* the PWD is somewhere in the git repo - this assumption can be
overridden using the -d command line option.

The example below illustrates what's described above.

```bash
~> pwd
/Users/simonsdave/dev-env/bin
~> cat $(repo-root-dir.sh)/dev_env/__init__.py
__version__ = '0.5.16'
~> python-version.sh
0.5.16
~>
```

## [python-increment-version.sh](python-increment-version.sh)

* ```python-increment-version.sh``` increments a Python project's version number
* the sequence below illustrates how ```python-increment-version.sh``` can be used

```bash
~> python-increment-version.sh
usage: python-increment-version.sh <release-type>
~> python-increment-version.sh M
~> echo $?
0
~> git diff
diff --git a/dev_env/__init__.py b/dev_env/__init__.py
index e7a8889..1f356cc 100644
--- a/dev_env/__init__.py
+++ b/dev_env/__init__.py
@@ -1 +1 @@
-__version__ = '0.5.20'
+__version__ = '1.0.0'
~> python-increment-version.sh m
~> git diff
diff --git a/dev_env/__init__.py b/dev_env/__init__.py
index e7a8889..1a72d32 100644
--- a/dev_env/__init__.py
+++ b/dev_env/__init__.py
@@ -1 +1 @@
-__version__ = '0.5.20'
+__version__ = '1.1.0'
~> python-increment-version.sh p
~> git diff
diff --git a/dev_env/__init__.py b/dev_env/__init__.py
index e7a8889..b3ddbc4 100644
--- a/dev_env/__init__.py
+++ b/dev_env/__init__.py
@@ -1 +1 @@
-__version__ = '0.5.20'
+__version__ = '1.1.1'
~>
```

# Testing

## [run-unit-tests.sh](run-unit-tests.sh)

* using [nose](https://nose.readthedocs.io/en/latest/) run all unit tests
* ```run-unit-tests.sh``` assumes a ```.coveragerc``` exists in the repo's root directory - below is an example of ```.coveragerc``` from [this repo](https://github.com/simonsdave/dev-env-testing)

```ini
[run]
branch = True
include =
    ./dev_env_testing/*
omit =
    *tests*
    *__init__*

[html]
directory = coverage_report
```

* running unit tests generate coverage data which can be found in ```.coverage``` in the repo's root directory
as well as an HTML coverage report in the directory defined in ```.coveragerc```

# Working with ```CHANGELOG.md```

## [add-new-changelog-dot-md-release.py](add-new-changelog-dot-md-release.py)

* every repo should have a ```CHANGELOG.md``` in the root directory
* ```CHANGELOG.md``` has the same format with the head of the file illustrated below

```
# Change Log
All notable changes to this project will be documented in this file.
Format of this file follows [these](http://keepachangelog.com/) guidelines.
This project adheres to [Semantic Versioning](http://semver.org/).

## [1.2.3] - [2019-03-11]

### Added
.
.
.
```

* ```add-new-changelog-dot-md-release.py``` updates ```CHANGELOG.md``` with a new
release template so the head of the file looks something like the file
illustrated below

```bash
# Change Log
All notable changes to this project will be documented in this file.
Format of this file follows [these](http://keepachangelog.com/) guidelines.
This project adheres to [Semantic Versioning](http://semver.org/).

## [%RELEASE_VERSION%] - [%RELEASE_DATE%]

### Added

* Nothing

### Changed

* Nothing

### Removed

* Nothing

## [1.2.3] - [2019-03-11]

### Added
.
.
.
```

* ```CHANGELOG.md``` will be updated in place.
* expected usage

```bash
~> add_new_changelog_dot_md_release.py./CHANGELOG.md
~>
```


## [changelog-dot-md-release-comments.py](changelog-dot-md-release-comments.py)

* every repo should have a ```CHANGELOG.md``` in the root directory
* ```CHANGELOG.md``` describes, at a high-level, all the changes that have
been made for a  release
* in ```CHANGELOG.md``` each release typically has has a section that looks like

```
## [0.5.14] - [2019-02-03]

### Added

- added ```python-version.sh``` which is used to extract a python project's version number

### Changed

- flake8 3.7.4 -> 3.7.7
- twine 1.12.1 -> 1.13.0
- fixed bug in ```run_shellcheck.sh``` where docker containers weren't being removed are they had exited

### Removed

- Nothing
```

* given a release version, this script extracts the section of ```CHANGELOG.md``` corresponding to the release version
* ```CHANGELOG.md``` is updated in place
* expected usage

```bash
~> changelog_dot_md_release_comments.py '0.5.14' ./CHANGELOG.md
.
.
.
~>
```

## [cut-changelog-dot-md.py](cut-changelog-dot-md.py)

* every repo should have a CHANGELOG.md in the root directory
* this file will have the same format with the head of the file looking like

```
# Change Log
All notable changes to this project will be documented in this file.
Format of this file follows [these](http://keepachangelog.com/) guidelines.
This project adheres to [Semantic Versioning](http://semver.org/).

## [%RELEASE_VERSION%] - [%RELEASE_DATE%]

### Added
.
.
.
```

* when cutting a release ```%RELEASE_VERSION%``` and ```%RELEASE_DATE%``` need to be
replaced with an actual release number and release date which is
what ```cut_changelog_dot_md.py``` does
* ```CHANGELOG.md``` is updated in place
* expected usage

```bash
~> cut_changelog_dot_md.py '1.2.3' '4-Jan-1936' ./CHANGELOG.md
~>
```

## [build-readme-dot-rst.sh](build-readme-dot-rst.sh)

* run [pandoc](https://pandoc.org/) to create ```README.rst``` in the project's root directory
from ```README.md``` in the same root directory

# Python Packages

## [build-python-package.sh](build-python-package.sh)

* create a [source distribution](https://docs.python.org/2/distutils/sourcedist.html)
and [built distribution](https://docs.python.org/2/distutils/builtdist.html) per the
example below

```bash
~> build-python-package.sh
running bdist_wheel
running build
running build_py
creating build
creating build/lib.linux-x86_64-2.7
creating build/lib.linux-x86_64-2.7/dev_env
.
.
.
hard linking dev_env.egg-info/SOURCES.txt -> dev_env-0.5.16/dev_env.egg-info
hard linking dev_env.egg-info/dependency_links.txt -> dev_env-0.5.16/dev_env.egg-info
hard linking dev_env.egg-info/top_level.txt -> dev_env-0.5.16/dev_env.egg-info
copying setup.cfg -> dev_env-0.5.16
Writing dev_env-0.5.16/setup.cfg
Creating tar archive
removing 'dev_env-0.5.16' (and everything under it)
~>
```

```bash
~> ls -la dist
total 80
drwxr-xr-x   4 simonsdave  staff    128  3 May 07:06 .
drwxr-xr-x  25 simonsdave  staff    800  3 May 07:06 ..
-rw-r--r--   1 simonsdave  staff  26443  3 May 07:06 dev_env-0.5.16-py2-none-any.whl
-rw-r--r--   1 simonsdave  staff  11668  3 May 07:06 dev_env-0.5.16.tar.gz
~>
```

## [run-pip-check.sh](run-pip-check.sh)

* run [```pip check```](https://pip.pypa.io/en/stable/reference/pip_check/) on a repo

## [upload-dist-to-pypi.sh](upload-dist-to-pypi.sh)

* publish Python packages on pypi using [twine](https://pypi.org/project/twine/)
* usage

```bash
~> ./upload-dist-to-pypi.sh
usage: upload-dist-to-pypi.sh <repo>
~>
```

* expects Python packages to have already been built (probably by [build-python-package.sh](#build-python-packagesh)) and available in the ```dist``` subdirectory of the directory identified by [repo-root-dir.sh](#repo-root-dirsh)
* expects ```"$HOME:/pypirc``` to exist and be of the format illustrated below

```ini
[distutils]
index-servers =
  pypi
  testpypi

[pypi]
repository=https://upload.pypi.org/legacy/
username=simonsdave
password=supersecret

[testpypi]
repository=https://test.pypi.org/legacy/
username=simonsdave
password=secret
```

* requires a single command line parameter which is the repo to which the packages
should be uploaded - from the above ```.pypirc``` this would be either ```pypi``` or ```testpypi```

# Cutting a Release

## [cut-release.sh](cut-release.sh)

* ```cut-release.sh``` automates the process of cutting a release
* assumptions
    * all development is done on the ```master``` branch
    * [Semantic Versioning](http://semver.org/) is used
    * for each release a new branch is created from master called ```release-<version>```
    * ```CHANGELOG.md``` exits in the project's root directory and follows [these](https://keepachangelog.com/en/1.0.0/) formatting guidelines
    * a [personal access token](https://github.blog/2013-05-16-personal-api-tokens/)
    as been created (see [this](https://github.com/settings/tokens/new) and note that only
    "repo" access is required for this token) and has been saved using ```git config --global github.token TOKEN```
* ```cut-release.sh``` does the following
    * get release version by executing ```.cut-release-version.sh``` in the root directory of the repo
    * generate a release date using ```date "+%Y-%m-%d"```
    * confirm there's a ```CHANGELOG.md``` in the project's root directory
    * use [```cut-changelog-dot-md.py```](#cut-changelog-dot-mdpy) to replace ```%RELEASE_VERSION%``` and ```%RELEASE_DATE%``` in ```CHANGELOG.md```
    * ```git commit``` the ```CHANGELOG.md``` changes on the master branch and save the commit ID - let's call this the "master release commit id"
    * prep master branch for development of next release
        * use [```add-new-changelog-dot-md-release.py```](#add-new-changelog-dot-md-releasepy) to add a new release template to ```CHANGELOG.md```
        * find and execute all files in the repo called ```.cut-release-master-branch-changes.sh```
            * typically this is used to increment the project's version number
            * there are no guarantees on the order in which the various ```.cut-release-master-branch-changes.sh``` scripts are executed
            * see [this](#-cut-release-versionsh) for more details on ```.cut-release-master-branch-changes.sh```
        * ```git commit``` the ```CHANGELOG.md``` changes and ```.cut-release-master-branch-changes.sh``` changes on the master branch
    * create the release branch
        * create a new git branch called ```release-<VERSION>``` based on the "master release commit id" and let's call this the "release branch"
        * ```git checkout``` the release branch
        * find and execute all files in the repo called ```.cut-release-release-branch-changes.sh```
            * these scripts do things like rewrite URLs in markdown docs to point at release branches instead of the master branch
            * there are no guarantees on the order in which the various ```.cut-release-release-branch-changes.sh``` scripts are executed
            * see [this](#cut-release-release-branch-changessh) for more details on ```.cut-release-release-branch-changes.sh```
        * ```git commit``` all release branch changes
    * push all changes on master and release branches to github
    * use [create-github-release.sh](#create-github-releasesh) to create a [github release](https://help.github.com/en/articles/about-releases)

### ``` .cut-release-version.sh```

```bash
#!/usr/bin/env bash

set -e

if [ $# != 0 ]; then
    echo "usage: $(basename "$0")" >&2
    exit 1
fi

python-version.sh

exit 0
```

### ```.cut-release-master-branch-changes.sh```

* these scripts are used to prep the master branch for development of the next release
* typically this is used to increment the project's version number

```bash
#!/usr/bin/env bash

set -e

if [ $# != 0 ]; then
    echo "usage: $(basename "$0")" >&2
    exit 1
fi

python-increment-version.sh -m

exit 0
```

### ```.cut-release-release-branch-changes.sh```

* these scripts do things like rewrite URLs in markdown docs to point at release branches instead of the master branch
* in the extreme, every directory in the repo could have its own ```.cut-release-release-branch-changes.sh```
* below is an example of typical ```.cut-release-release-branch-changes.sh``` that you would find in the root directory of a repo

```bash
#!/usr/bin/env bash

set -e

SCRIPT_DIR_NAME="$( cd "$( dirname "$0" )" && pwd )"

if [ $# != 1 ]; then
    echo "usage: $(basename "$0") <release-branch>" >&2
    exit 1
fi

RELEASE_BRANCH=${1:-}

pushd "${SCRIPT_DIR_NAME}"

sed -i "" \
    -e "s|tree/master|tree/${RELEASE_BRANCH}|g" \
    "${SCRIPT_DIR_NAME}/README.md"

rm -f "${SCRIPT_DIR_NAME}/README.rst"
build-readme-dot-rst.sh

rm -rf "${SCRIPT_DIR_NAME}/dist"
build-python-package.sh

popd

exit 0
```

## [create-github-release.sh](create-github-release.sh)

* expecting ```create-github-release.sh``` to be used only by [cut-release.sh](#cut-releasesh)
ie. it implements a private "API" so use at your own peril
* ```create-github-release.sh``` creates [github release](https://help.github.com/en/articles/about-releases)
* assumptions
    * need a [personal access token](https://github.blog/2013-05-16-personal-api-tokens/)
    to [authenticate to the github API](https://developer.github.com/v3/auth/#basic-authentication)
    * create a new token [here](https://github.com/settings/tokens/new)
    * note the token only needs "repo" access
    * save the token using ```git config --global github.token TOKEN```

# Working with CircleCI

## [run-circleci.sh](run-circleci.sh)

* ```run-circleci.sh``` runs the [CircleCI](https://circleci.com) [CLI](https://circleci.com/docs/2.0/local-cli/)
* all command line args are passed directly to ```circleci``` which is run inside the dev env container
* for example, to see the CLI version

```bash
~> run-circleci.sh version
0.1.5607+f705856
~>
```

* suspect this will mostly be used to validate ```.circleci/config.yml``` per below

```bash
~> run-circleci.sh config validate
Config file at .circleci/config.yml is valid.
~>
```

## [check-consistent-dev-env-version.sh](check-consistent-dev-env-version.sh)

* following ```dev-env``` patterns and practices, a repo is expected to contain a
file ```$(repo-root-dir.sh)/dev_env/dev-env-version.txt``` which looks something like

```text
0.5.15
```

* the idea behind ```dev-env-version.txt``` was to have the
project's ```dev-env``` version defined in a single location
* projects which use ```dev-env``` and CircleCI will have a
file ```$(repo-root-dir.sh)/.circleci/config.yml```
that typically starts out something like

```yaml
version: 2.1

executors:
  dev-env:
    environment:
      DOCKER_TEMP_IMAGE: simonsdave/cloudfeaster-xenial-dev-env:bindle
    docker:
      - image: simonsdave/xenial-dev-env:v0.5.15

jobs:
  build_test_and_deploy:
...
```

* the challenge with CircleCI and ```dev-env-version.txt```
is that there are two places defining the ```dev-env``` version
* don't know how to fix this problem so let's at least automate detection of the problem by
inserting ```check-consistent-dev-env-version.sh``` into the CircleCI pipeline

```yaml
jobs:
  build_test_and_deploy:
    working_directory: ~/repo
    executor: dev-env
    steps:
      - checkout
      - run: check-consistent-dev-env-version.sh
      - restore_cache:
          keys:
```

* ```check-consistent-dev-env-version.sh``` has a zero exit code if the
two versions are the same and non-zero if the two versions are different
* usage for ```check-consistent-dev-env-version.sh```

```bash
~> ./check-consistent-dev-env-version.sh --help
usage: check-consistent-dev-env-version.sh [--verbose]
~>
```

* the ```--verbose``` command line option can be useful after ```check-consistent-dev-env-version.sh```
is inserted into the CircleCI pipeline and it returns a non-zero exit code but a visual
inspection of ```dev-env-version.txt``` and ```config.yml``` don't reveal where there's a version
mismatch - adding ```--verbose``` to the pipeline should generate enough information to
debug the problem

## [create-dummy-docker-container.sh](create-dummy-docker-container.sh)

* expecting ```create-dummy-docker-container.sh``` to be used only by other shell scripts in this directory
ie. it implements a private "API" so use at your own peril
* for context read [CircleCI's doc](https://circleci.com/docs/2.0/building-docker-images/#mounting-folders)
on "mounting a folder from your job space into a container in Remote Docker"
* ```create-dummy-docker-container.sh``` implements the "create a dummy container" pattern
described in [here](https://circleci.com/docs/2.0/building-docker-images/#mounting-folders)

# Working with Docker

## [kill-and-rm-all-docker-containers.sh](kill-and-rm-all-docker-containers.sh)

* this is super destructive - use with caution
* great for "resetting" your development environment
* ```docker container kill``` and ```docker container rm``` all docker containers

## [rm-dangling-docker-images.sh](rm-dangling-docker-images.sh)

* removes all "dangling docker images"
* see [this](https://docs.docker.com/engine/reference/commandline/images/#filtering)
for a description of "dangling docker images"

# [Static Analysis](https://en.wikipedia.org/wiki/Static_program_analysis)

## [run-flake8.sh](run-flake8.sh)

* thin wrapper around [flake8](http://flake8.pycqa.org/en/latest/)
* runs [flake8](http://flake8.pycqa.org/en/latest/) against all files in the repo with a ```py``` extension

## [run-shellcheck.sh](run-shellcheck.sh)

* thin wrapper around [shellcheck](https://github.com/koalaman/shellcheck)
* runs [shellcheck](https://github.com/koalaman/shellcheck) against all files
in the repo with a ```sh``` extension
* files are scanned in alphabetical order
* create a file called ```.shellcheckignore```
in the same directory as ```example.sh``` that looks like the one below
to avoid running [shellcheck](https://github.com/koalaman/shellcheck)
on the file ```example.sh```

```
example.sh
```

## [run-yamllint.sh](run-yamllint.sh)

* thin wrapper around [yamllint](https://yamllint.readthedocs.io/en/stable/index.html)
* runs [yamllint](https://yamllint.readthedocs.io/en/stable/index.html) against all files in the repo with a ```yaml``` or ```yml``` extension

# Security Assessment

## [run-repo-security-scanner.sh](run-repo-security-scanner.sh)

* runs [UKHomeOffice/repo-security-scanner](https://github.com/UKHomeOffice/repo-security-scanner)
* CLI tool that finds secrets accidentally committed to a git repo, eg passwords, private keys

## [run-snyk.sh](run-snyk.sh)

* runs [snyk](https://snyk.io/) vulnerability assessor on the repo

## [run-bandit.sh](run-bandit.sh)

* runs [PyCQA/bandit](https://github.com/PyCQA/bandit)
* Bandit is a tool designed to find common security issues in Python code.
