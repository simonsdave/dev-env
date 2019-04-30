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
