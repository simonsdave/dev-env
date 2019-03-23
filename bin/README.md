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

## [run_unit_tests.sh](run_unit_tests.sh)

## [dev_env_nosetests.py](dev_env_nosetests.py)

# Working with ```CHANGELOG.md```

## [add_new_changelog_dot_md_release.py](add_new_changelog_dot_md_release.py)

## [changelog_dot_md_release_comments.py](changelog_dot_md_release_comments.py)

## [cut_changelog_dot_md.py](cut_changelog_dot_md.py)

## [build_readme_dot_rst.sh](build_readme_dot_rst.sh)

# Python Packages

## [build_python_package.sh](build_python_package.sh)

## [run_pip_check.sh](run_pip_check.sh)

# Cutting a Release

## [prep-for-release.sh](prep-for-release.sh)

## [prep-for-release-python.sh](prep-for-release-python.sh)

# Working with Docker

## [kill-and-rm-all-docker-containers.sh](kill-and-rm-all-docker-containers.sh)

## [rm-dangling-docker-images.sh](rm-dangling-docker-images.sh)

# [Static Analysis](https://en.wikipedia.org/wiki/Static_program_analysis)

## [run_flake8.sh](run_flake8.sh)

## [run_shellcheck.sh](run_shellcheck.sh)

# Security Assessment

## [run_repo_security_scanner.sh](run_repo_security_scanner.sh)

## [run_snyk.sh](run_snyk.sh) - runs [snyk](https://snyk.io/) vulnerability assessor on the repo
