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

# Testing

## [run-unit-tests.sh](run-unit-tests.sh)

## [dev-env-nosetests.py](dev-env-nosetests.py)

# Working with ```CHANGELOG.md```

## [add-new-changelog-dot-md-release.py](add-new-changelog-dot-md-release.py)

## [changelog-dot-md-release-comments.py](changelog-dot-md-release-comments.py)

## [cut-changelog-dot-md.py](cut-changelog-dot-md.py)

## [build-readme-dot-rst.sh](build-readme-dot-rst.sh)

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
copying dev_env/nose_plugins.py -> build/lib.linux-x86_64-2.7/dev_env
copying dev_env/__init__.py -> build/lib.linux-x86_64-2.7/dev_env
running egg_info
writing dev_env.egg-info/PKG-INFO
writing top-level names to dev_env.egg-info/top_level.txt
writing dependency_links to dev_env.egg-info/dependency_links.txt
reading manifest file 'dev_env.egg-info/SOURCES.txt'
reading manifest template 'MANIFEST.in'
writing manifest file 'dev_env.egg-info/SOURCES.txt'
running build_scripts
creating build/scripts-2.7
copying and adjusting bin/add-new-changelog-dot-md-release.py -> build/scripts-2.7
copying and adjusting bin/changelog-dot-md-release-comments.py -> build/scripts-2.7
copying and adjusting bin/cut-changelog-dot-md.py -> build/scripts-2.7
copying bin/python-version.sh -> build/scripts-2.7
copying and adjusting bin/dev-env-nosetests.py -> build/scripts-2.7
copying bin/prep-for-release-python.sh -> build/scripts-2.7
copying bin/prep-for-release.sh -> build/scripts-2.7
copying bin/run-flake8.sh -> build/scripts-2.7
copying bin/run-pip-check.sh -> build/scripts-2.7
copying bin/run-shellcheck.sh -> build/scripts-2.7
copying bin/run-unit-tests.sh -> build/scripts-2.7
copying bin/run-repo-security-scanner.sh -> build/scripts-2.7
copying bin/kill-and-rm-all-docker-containers.sh -> build/scripts-2.7
copying bin/build-python-package.sh -> build/scripts-2.7
copying bin/build-readme-dot-rst.sh -> build/scripts-2.7
copying bin/repo.sh -> build/scripts-2.7
copying bin/repo-root-dir.sh -> build/scripts-2.7
copying bin/run-snyk.sh -> build/scripts-2.7
copying bin/rm-dangling-docker-images.sh -> build/scripts-2.7
copying bin/run-markdownlint.sh -> build/scripts-2.7
copying bin/upload-dist-to-pypi.sh -> build/scripts-2.7
copying bin/create-dummy-docker-container.sh -> build/scripts-2.7
copying bin/check-consistent-dev-env-version.sh -> build/scripts-2.7
copying bin/run-yamllint.sh -> build/scripts-2.7
copying bin/run-circleci.sh -> build/scripts-2.7
copying bin/run-bandit.sh -> build/scripts-2.7
changing mode of build/scripts-2.7/add-new-changelog-dot-md-release.py from 644 to 755
changing mode of build/scripts-2.7/changelog-dot-md-release-comments.py from 644 to 755
changing mode of build/scripts-2.7/cut-changelog-dot-md.py from 644 to 755
changing mode of build/scripts-2.7/dev-env-nosetests.py from 644 to 755
installing to build/bdist.linux-x86_64/wheel
running install
running install_lib
creating build/bdist.linux-x86_64
creating build/bdist.linux-x86_64/wheel
creating build/bdist.linux-x86_64/wheel/dev_env
copying build/lib.linux-x86_64-2.7/dev_env/nose_plugins.py -> build/bdist.linux-x86_64/wheel/dev_env
copying build/lib.linux-x86_64-2.7/dev_env/__init__.py -> build/bdist.linux-x86_64/wheel/dev_env
running install_egg_info
Copying dev_env.egg-info to build/bdist.linux-x86_64/wheel/dev_env-0.5.16.egg-info
running install_scripts
creating build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data
creating build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts
copying build/scripts-2.7/run-shellcheck.sh -> build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts
copying build/scripts-2.7/prep-for-release-python.sh -> build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts
copying build/scripts-2.7/build-readme-dot-rst.sh -> build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts
copying build/scripts-2.7/add-new-changelog-dot-md-release.py -> build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts
copying build/scripts-2.7/python-version.sh -> build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts
copying build/scripts-2.7/run-bandit.sh -> build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts
copying build/scripts-2.7/run-flake8.sh -> build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts
copying build/scripts-2.7/create-dummy-docker-container.sh -> build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts
copying build/scripts-2.7/run-markdownlint.sh -> build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts
copying build/scripts-2.7/run-yamllint.sh -> build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts
copying build/scripts-2.7/cut-changelog-dot-md.py -> build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts
copying build/scripts-2.7/dev-env-nosetests.py -> build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts
copying build/scripts-2.7/run-snyk.sh -> build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts
copying build/scripts-2.7/run-unit-tests.sh -> build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts
copying build/scripts-2.7/run-pip-check.sh -> build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts
copying build/scripts-2.7/repo.sh -> build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts
copying build/scripts-2.7/upload-dist-to-pypi.sh -> build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts
copying build/scripts-2.7/build-python-package.sh -> build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts
copying build/scripts-2.7/repo-root-dir.sh -> build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts
copying build/scripts-2.7/check-consistent-dev-env-version.sh -> build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts
copying build/scripts-2.7/changelog-dot-md-release-comments.py -> build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts
copying build/scripts-2.7/run-circleci.sh -> build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts
copying build/scripts-2.7/prep-for-release.sh -> build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts
copying build/scripts-2.7/rm-dangling-docker-images.sh -> build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts
copying build/scripts-2.7/kill-and-rm-all-docker-containers.sh -> build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts
copying build/scripts-2.7/run-repo-security-scanner.sh -> build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts
changing mode of build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts/run-shellcheck.sh to 755
changing mode of build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts/prep-for-release-python.sh to 755
changing mode of build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts/build-readme-dot-rst.sh to 755
changing mode of build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts/add-new-changelog-dot-md-release.py to 755
changing mode of build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts/python-version.sh to 755
changing mode of build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts/run-bandit.sh to 755
changing mode of build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts/run-flake8.sh to 755
changing mode of build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts/create-dummy-docker-container.sh to 755
changing mode of build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts/run-markdownlint.sh to 755
changing mode of build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts/run-yamllint.sh to 755
changing mode of build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts/cut-changelog-dot-md.py to 755
changing mode of build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts/dev-env-nosetests.py to 755
changing mode of build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts/run-snyk.sh to 755
changing mode of build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts/run-unit-tests.sh to 755
changing mode of build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts/run-pip-check.sh to 755
changing mode of build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts/repo.sh to 755
changing mode of build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts/upload-dist-to-pypi.sh to 755
changing mode of build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts/build-python-package.sh to 755
changing mode of build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts/repo-root-dir.sh to 755
changing mode of build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts/check-consistent-dev-env-version.sh to 755
changing mode of build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts/changelog-dot-md-release-comments.py to 755
changing mode of build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts/run-circleci.sh to 755
changing mode of build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts/prep-for-release.sh to 755
changing mode of build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts/rm-dangling-docker-images.sh to 755
changing mode of build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts/kill-and-rm-all-docker-containers.sh to 755
changing mode of build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts/run-repo-security-scanner.sh to 755
creating build/bdist.linux-x86_64/wheel/dev_env-0.5.16.dist-info/WHEEL
running sdist
running check
warning: sdist: standard file not found: should have one of README, README.rst, README.txt

creating dev_env-0.5.16
creating dev_env-0.5.16/bin
creating dev_env-0.5.16/dev_env
creating dev_env-0.5.16/dev_env.egg-info
making hard links in dev_env-0.5.16...
hard linking MANIFEST.in -> dev_env-0.5.16
hard linking setup.cfg -> dev_env-0.5.16
hard linking setup.py -> dev_env-0.5.16
hard linking bin/add-new-changelog-dot-md-release.py -> dev_env-0.5.16/bin
hard linking bin/build-python-package.sh -> dev_env-0.5.16/bin
hard linking bin/build-readme-dot-rst.sh -> dev_env-0.5.16/bin
hard linking bin/changelog-dot-md-release-comments.py -> dev_env-0.5.16/bin
hard linking bin/check-consistent-dev-env-version.sh -> dev_env-0.5.16/bin
hard linking bin/create-dummy-docker-container.sh -> dev_env-0.5.16/bin
hard linking bin/cut-changelog-dot-md.py -> dev_env-0.5.16/bin
hard linking bin/dev-env-nosetests.py -> dev_env-0.5.16/bin
hard linking bin/kill-and-rm-all-docker-containers.sh -> dev_env-0.5.16/bin
hard linking bin/prep-for-release-python.sh -> dev_env-0.5.16/bin
hard linking bin/prep-for-release.sh -> dev_env-0.5.16/bin
hard linking bin/python-version.sh -> dev_env-0.5.16/bin
hard linking bin/repo-root-dir.sh -> dev_env-0.5.16/bin
hard linking bin/repo.sh -> dev_env-0.5.16/bin
hard linking bin/rm-dangling-docker-images.sh -> dev_env-0.5.16/bin
hard linking bin/run-bandit.sh -> dev_env-0.5.16/bin
hard linking bin/run-circleci.sh -> dev_env-0.5.16/bin
hard linking bin/run-flake8.sh -> dev_env-0.5.16/bin
hard linking bin/run-markdownlint.sh -> dev_env-0.5.16/bin
hard linking bin/run-pip-check.sh -> dev_env-0.5.16/bin
hard linking bin/run-repo-security-scanner.sh -> dev_env-0.5.16/bin
hard linking bin/run-shellcheck.sh -> dev_env-0.5.16/bin
hard linking bin/run-snyk.sh -> dev_env-0.5.16/bin
hard linking bin/run-unit-tests.sh -> dev_env-0.5.16/bin
hard linking bin/run-yamllint.sh -> dev_env-0.5.16/bin
hard linking bin/upload-dist-to-pypi.sh -> dev_env-0.5.16/bin
hard linking dev_env/__init__.py -> dev_env-0.5.16/dev_env
hard linking dev_env/nose_plugins.py -> dev_env-0.5.16/dev_env
hard linking dev_env.egg-info/PKG-INFO -> dev_env-0.5.16/dev_env.egg-info
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

## [prep-for-release.sh](prep-for-release.sh)

Your repo probably contains a ```README.md``` in the repo's root
directory and there's a link to a build badge like the one below.

```
[![Build Status](https://travis-ci.org/simonsdave/dev-env.svg?branch=master)](https://travis-ci.org/simonsdave/dev-env)
```

This kind of badge should be updated when cutting a release.
This is one of the things that ```prep-for-release.sh``` will do
for you if you create a script called ```.prep-for-release-release-branch-changes.sh```
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

## [prep-for-release-python.sh](prep-for-release-python.sh)

```prep-for-release-python.sh``` is a Python specific wrapper around
the general purpose [prep-for-release.sh](#prep-for-releasesh).
To run ```prep-for-release.sh```
you need a release version. For Python projects this
version number can be extracted from the project's ```__init__.py```.

# Working with CircleCI

## [run-circleci.sh](run-circleci.sh)

* the [CircleCI](https://circleci.com) [CLI](https://circleci.com/docs/2.0/local-cli/) can be helpful
* mostly used thus far to validate ```.circleci/config.yml``` per below

```bash
~> run-circleci.sh config validate
Config file at .circleci/config.yml is valid.
~>
```

* all command line args are passed directly to ```circleci``` which is run inside
the dev env container

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
* don't know how to fix this problem but ```check-consistent-dev-env-version.sh```
inserting ```check-consistent-dev-env-version.sh``` into the CircleCI pipeline
will at least detects if the two version definitions have drifted
* ```check-consistent-dev-env-version.sh``` has a zero exit code if the
two versions are the same and non-zero if the two versions are different

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
* runs [shellcheck](https://github.com/koalaman/shellcheck) against all files in the repo with a ```sh``` extension

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
