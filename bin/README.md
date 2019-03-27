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

# Cutting a Release

## [prep-for-release.sh](prep-for-release.sh)

## [prep-for-release-python.sh](prep-for-release-python.sh)

# Working with Docker

## [kill-and-rm-all-docker-containers.sh](kill-and-rm-all-docker-containers.sh)

## [rm-dangling-docker-images.sh](rm-dangling-docker-images.sh)

# [Static Analysis](https://en.wikipedia.org/wiki/Static_program_analysis)

## [run-flake8.sh](run-flake8.sh)

## [run-shellcheck.sh](run-shellcheck.sh)

# Security Assessment

## [run-repo-security-scanner.sh](run-repo-security-scanner.sh)

## [run-snyk.sh](run-snyk.sh) - runs [snyk](https://snyk.io/) vulnerability assessor on the repo
