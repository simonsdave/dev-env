This directory contains a collection of scripts which simplify working with your development environment.
For example, it should be easy to figure out the root directory of the git repo in which you're working
regardless of whether you're trying to do that on the host machine, in the ```dev_env``` or in a CI/CD pipeline.
Not only should it be easy but it should also be consistent. So, for example, the task of determining
the root directory of your git repo is accomplished by calling ```repo-root-dir.sh```.

# Repo Info

## [repo.sh](repo.sh)

## [repo-root-dir.sh](repo-root-dir.sh)

## [python-version.sh](python-version.sh)

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

## [run-pip-check.sh](run-pip-check.sh)

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

## [prep-for-release-python.sh](prep-for-release-python.sh)

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

## [get-dev-env-version-from-circleci-config.sh](get-dev-env-version-from-circleci-config.sh)

* historically each repo would contain a
file ```$(repo-root-dir.sh)/dev_env/dev-env-version.txt```
which looked something like

```text
latest
```

* the idea behind ```dev-env-version.txt``` was to have the
project's ```dev-env``` version in a single location
* projects which use ```dev-env``` and CircleCI will have a
file ```$(repo-root-dir.sh)/.circleci/config.yml```
that typically starts out something like

```yaml
version: 2

_defaults: &defaults
  working_directory: ~/repo
  docker:
  - image: simonsdave/xenial-dev-env:latest
  environment:
    DOCKER_TEMP_IMAGE: simonsdave/cloudfeaster-xenial-dev-env:bindle

jobs:
  build_test_deploy:
.
.
.
```

* the challenge once CircleCI started to be used was that
there were two places for the ```dev-env``` version
* to solve this problem ```get-dev-env-version-from-circleci-config.sh```
extracts the ```dev-env``` version from ```$(repo-root-dir.sh)/.circleci/config.yml```
and removes ```$(repo-root-dir.sh)/dev_env/dev-env-version.txt```

# Working with Docker

## [kill-and-rm-all-docker-containers.sh](kill-and-rm-all-docker-containers.sh)

## [rm-dangling-docker-images.sh](rm-dangling-docker-images.sh)

## [create-dummy-docker-container.sh](create-dummy-docker-container.sh)

# [Static Analysis](https://en.wikipedia.org/wiki/Static_program_analysis)

## [run-flake8.sh](run-flake8.sh)

## [run-shellcheck.sh](run-shellcheck.sh)

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
