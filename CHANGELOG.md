# Change Log

All notable changes to this project will be documented in this file.
Format of this file follows [these](http://keepachangelog.com/) guidelines.
This project adheres to [Semantic Versioning](http://semver.org/).

## [%RELEASE_VERSION%] - [%RELEASE_DATE%]

### Added

* added ```python-semantic-release```

### Changed

* ```flake8``` 3.9.0 -> 3.9.1
* ```run-pip-check.sh``` now runs pip's check command by using python3.7 specifically
* simplified pip install of packages in generated docker image
+ ```python3.7 -m pip install``` codecov rather than ```pip3 install``` in the CircleCI pipeline

### Removed

* removed [AWS SAM CLI](https://aws.amazon.com/serverless/sam/) 
  and [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-welcome.html)
* removed [truffleHog](https://github.com/dxa4481/truffleHog)

## [0.6.14] - [2021-03-21]

### Added

* added ```docker builder prune --force``` to ```docker-destructive-cleanup.sh```

### Changed

* remove explicit requirement for ```pycodestyle``` because ```flake8```
  includes ```pycodestyle``` and that elmininates trying to keep ```pycodestyle```
  and ```flake8``` versions in-sync
* ```twine``` 3.3.0 -> 3.4.1

### Removed

* Nothing

## [0.6.13] - [2020-12-29]

### Added

* Nothing

### Changed

* ```install-dev-env.sh``` execution must now be done within a virtual env

### Removed

* Nothing

## [0.6.12] - [2020-12-27]

### Added

* Nothing

### Changed

* ```codecov``` 2.1.8 -> 2.1.11
* ```flake8``` 3.8.3 -> 3.8.4
* ```mock``` 4.0.2 -> 4.0.3
* per [this](https://discuss.circleci.com/t/old-linux-machine-image-remote-docker-deprecation/37572) article, added
  explicit version to ```setup_remote_docker``` in CircleCI pipeline
* start using venv instead of virtualenv
* ```twine``` 3.2.0 -> 3.3.0
* a ```circleci update``` is now performed during docker install to
  ensure the latest CircleCI CLI is always installed

### Removed

* Nothing

## [0.6.11] - [2020-08-17]

### Added

* add [Jekyl](https://jekyllrb.com/) and [Bundler](https://bundler.io/) to dev-env docker image
* add support for ```.yamllintignore``` so ```run-yamllint.sh``` can ignore specific files

### Changed

* flake8 3.7.9 -> 3.8.3
* pycodestyle 2.5.0 -> 2.6.0
* ```docker-destructive-cleanup.sh``` now uses ```docker container prune```
* codecov 2.0.22 -> 2.1.8
* twine 3.1.1 -> 3.2.0
* fixed markdown syntax error in ```bin/README.md```

### Removed

* Nothing

## [0.6.10] - [2020-04-08]

### Added

* added ```bin/in-container/get-circle-ci-executor.sh```

### Changed

* Nothing

### Removed

* Nothing

## [0.6.9] - [2020-04-07]

### Added

* added ```bin/get-circle-ci-executor.sh```

### Changed

* dramatically simplify use of ```bin/install-dev-env.sh```
* replaced ```bin/check-consistent-dev-env-version.sh```
  with ```bin/get-circle-ci-executor.sh```
* ```shellcheck``` now installed per [these](https://github.com/koalaman/shellcheck/issues/1871)
  instructions

### Removed

* removed ```bin/check-consistent-dev-env-version.sh```

## [0.6.8] - [2020-03-22]

### Added

* [CodeFactor](https://www.codefactor.io) badge to main README.md
* ```in-container/run-markdownlint.sh``` actually works now!!!

### Changed

* mock 4.0.1 -> 4.0.2
* increased reliability of CircleCI CLI install

### Removed

* Nothing

## [0.6.7] - [2020-02-21]

### Added

* Nothing

### Changed

* mock 4.0.0 -> 4.0.1
* ```pip3 install``` -> ```python3.7 -m pip install```
* CircleCI wasn't getting installed because ```curl -fLSs https://circle.ci/cli | bash```
  generated ```curl: (16) Error in the HTTP2 framing layer``` - resolved by getting
  curl to use HTTP 1.1

### Removed

* Nothing

## [0.6.6] - [2020-02-09]

### Added

* add [codecov](https://codecov.io/)

### Changed

* ```.run-yamllint.sh``` will now work even if there is no ```.yamllint```
  in the repo's root directory

### Removed

* Nothing

## [0.6.5] - [2020-02-01]

### Added

* add ```bin/in-container/build-readme-dot-rst.sh``` so CI pipelines
  can build ```README.txt``` and ```README.rst```

### Changed

* a number of the scripts had ```python3 -c "import uuid; print(uuid.uuid4().hex)"```
  to generate a 16 digit random string but that requires python3 to be installed
  on the dev machine so it was replaced with ```openssl rand -hex 16```

### Removed

* Nothing

## [0.6.4] - [2020-01-26]

### Added

* ```run-markdownlint.sh``` now works and is documented

### Changed

* pandoc 1.19.2.4 -> 2.9.1.1
* markdown lint [https://github.com/igorshubovych/markdownlint-cli](https://github.com/igorshubovych/markdownlint-cli) -> [https://github.com/markdownlint/markdownlint](https://github.com/markdownlint/markdownlint)
* ```build-python-package.sh``` now does a ```twine check``` after building
  distributions to ensure an upload to pypi will succeed
* added ```--text``` command line option to ```build-readme-dot-rst.sh```
  to optionally indicate a ```README.txt``` should be created
  from ```README.md``` in addition to ```README.rst```

### Removed

* Nothing

## [0.6.3] - [2019-12-29]

### Added

* add ```bin/docker-destructive-cleanup.sh``` to replace
  both ```bin/kill-and-rm-all-docker-containers.sh```
  and ```bin/rm-dangling-docker-images.sh``` - motivation was (i) both
  removed scripts were always run together anyway (ii) the naming
  scheme didn't scream the destructure nature loudly enough (iii) there
  were no safeguards to protect users who ran the scripts without
  understanding their destructure nature
* add ```bin/run-jsonlint.sh``` and ```bin/in-container/run-jsonlint.sh```

### Changed

* Nothing

### Removed

* remove ```bin/kill-and-rm-all-docker-containers.sh``` and ```bin/rm-dangling-docker-images.sh``` - see
  the notes under "Added" for more details

## [0.6.2] - [2019-12-28]

### Added

* add ```create-dummy-docker-container.sh``` to ```bin/in-container``` and
  ensure ```create-dummy-docker-container.sh``` is always the same as the version
  in ```bin```

### Changed

* Nothing

### Removed

* Nothing

## [0.6.1] - [2019-12-17]

### Added

* Nothing

### Changed

* fixed ```upload-dist-to-pypi.sh``` after upgrade to Python 3.7

### Removed

* Nothing

## [0.6.0] - [2019-12-15]

### Added

* Nothing

### Changed

* *material change* = generated docker images Ubuntu 16.04 (Xenial) -> Ubuntu 18.04 (Bionic) and Python 2.7 -> Python 3.7

### Removed

* Nothing

## [0.5.26] - [2019-10-14]

### Added

* add ```run-codecov.sh```

### Changed

* ```run-shellcheck.sh``` -> ```run-shelllint.sh``` - there's a breaking change in here = need to rename ```.shellcheckignore``` to ```.shelllintignore```
* twine 1.13.0 -> 1.15.0

### Removed

* remove [Snyc](https://snyk.io/) support

## [0.5.25] - [2019-08-05]

### Added

* add [Codecov CLI](https://codecov.io)

### Changed

* Nothing

### Removed

* remove [coveralls CLI](https://pypi.org/project/coveralls/)

## [0.5.24] - [2019-08-04]

### Added

* add [coveralls CLI](https://pypi.org/project/coveralls/)
* add [AWS SAM CLI](https://aws.amazon.com/serverless/sam/)

### Changed

* Nothing

### Removed

* Nothing

## [0.5.23] - [2019-08-03]

### Added

* add [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-welcome.html)
* add [truffleHog](https://github.com/dxa4481/truffleHog) to scan for secrets in git source code repos

### Changed

* Nothing

### Removed

* Nothing

## [0.5.22] - [2019-07-26]

### Added

* Nothing

### Changed

* flake8 3.7.7 -> 3.7.8
* ```bin/in-container/run-bandit.sh``` incorrectly named packages to be tested
  when package name contains a dash

### Removed

* Nothing

## [0.5.21] - [2019-06-23]

### Added

* add ```--dev-env-version``` command line option to ```install-dev-env.sh```

### Changed

* Nothing

### Removed

* Nothing

## [0.5.20] - [2019-06-23]

### Added

* ```cfg4dev``` now installs [increment_version.sh](https://github.com/fmahnke/shell-semver) in the ```bin``` directory
  so that development of ```python-increment-version.sh``` is possible
* add support for ```.shellcheckignore``` so ```run-shellcheck.sh``` can ignore
  specific files

### Changed

* fixed bug in ```run-unit-tests.sh``` which wasn't looking for ```.coveragerc``` in the repo root directory
* ```run-shellcheck.sh``` sorts shell scripts before scanning
* ```python-increment-version.sh``` now accepts command line arguments of ```M```, ```m``` and ```p```
  instead of ```-M```, ```-m``` and ```-p```

### Removed

* Nothing

## [0.5.19] - [2019-05-17]

### Added

* created ```bin/in-container/should-be-the-same.sh``` and called it from the CI pipeline to ensure
  scripts on ```bin``` and ```bin/in-container``` that are supposed to be the same really are the same

### Changed

* ```bin/check-consistent-dev-env-version.sh``` and ```bin/in-container/check-consistent-dev-env-version.sh``` are now the same

### Removed

* Nothing

## [0.5.18] - [2019-05-16]

### Added

* add ```--verbose``` command line option to ```check-consistent-dev-env-version.sh```

### Changed

* Nothing

### Removed

* Nothing

## [0.5.17] - [2019-05-14]

### Added

* Nothing

### Changed

* fixed bug in ```check-consistent-dev-env-version.sh``` when normalizing of version numbers
* mock 2.0.0 -> 3.0.5

### Removed

* ```requirements.txt``` in the repo's root directory since it's no longer used

## [0.5.16] - [2019-05-13]

### Added

* [Bandit (a tool designed to find common security issues in Python code)](https://github.com/PyCQA/bandit)
  is now available in the ```dev-env``` docker image
* added ```check-consistent-dev-env-version.sh``` to detect dev-env version drift
* ```install-dev-env.sh``` is now the recommended way for ```dev-env``` to be installed by a ```cfg4dev``` script
* added ```python-increment-version.sh``` for use in ```.cut-release-master-branch-changes.sh```
* ```cut-release.sh``` now creates a github release

### Changed

* ```bin/in_container``` directory renamed to ```bin/in-container``` - should affect no one
* ```run-unit-tests.sh``` now pulls the html coverage reports from inside
* renamed ```prep-for-release.sh``` -> ```cut-release.sh```

### Removed

* removed ```prep-for-release-python.sh``` and replaced with ```cut-release.sh``` which is a far more generalizable version of ```prep-for-release.sh```
* removed ```dev-env-nosetests.py``` since it no longer seemed to be used

## [0.5.15] - [2019-04-14]

### Added

* added ```current-python-version.sh``` which is used to extract a python project's version number
* added ```changelog-dot-md-release-comments.py``` which is used to extract the notes for a single release from ```CHANGELOG.md```
* added snyk, nvm, node, markdownlint-cli, jq, git, docker-ce and shellcheck to Ubuntu Xenial docker image
* added ```run-snyc.sh``` to simplify running [snyc](https://snyk.io/) CLI against a repo
* added ```-u``` command line option to ```repo.sh``` to convert dashes in repo's name to underscores
* added ```upload-dist-to-pypi.sh``` (both in container and on host) to publish Python packages on pypi using [twine](https://pypi.org/project/twine/)
* added ```get-dev-env-version-from-circleci-config.sh```
* added ```run-yamllint.sh``` to make it easy to run [yamllint](https://yamllint.readthedocs.io)
* added ```run-circleci.sh``` to simplify running the [CircleCI](https://circleci.com) [CLI](https://circleci.com/docs/2.0/local-cli/) inside a dev env container

### Changed

* flake8 3.7.4 -> 3.7.7
* twine 1.12.1 -> 1.13.0
* fixed bug in ```run_shellcheck.sh``` where docker containers weren't being removed are they had exited
* using ```"$(echo "${1:-}" | tr "[:upper:]" "[:lower:]")"``` instead of ```"${1,,}"``` and ```[[:space:]]``` instead of ```\s``` with sed so scripts work on macOS and Ubuntu
* ```prep-for-release.sh``` now uses ```cut-changelog-dot-md.py``` and ```add-new-changelog-dot-md-release.py``` to improve portability across macOS and Ubuntu as well as simplifying ```prep-for-release.sh```

### Removed

* no longer need to set ```DEV_ENV_PACKAGE``` and ```DEV_ENV_SOURCE_CODE```

## [0.5.14] - [2019-02-03]

### Added

* added ```build_python_package.sh```
* added [Travis Client](https://github.com/travis-ci/travis.rb) to Ubuntu 16.04 dev env
* added core python dev packages to docker dev env image so that every project doesn't have to add them

### Changed

* Nothing

### Removed

* Nothing

## [0.5.12] - [2019-01-27]

### Added

* added ```kill-and-rm-all-docker-containers.sh```

### Changed

* Nothing

### Removed

* Nothing

## [0.5.11] - [2019-01-16]

### Added

* Nothing

### Changed

* get ```bin/run_unit_tests.sh``` working again on travis
* moving ```nose==1.3.7``` from ```setup.py``` to ```requirements.txt```

### Removed

* Nothing

## [0.5.10] - [2019-01-13]

### Added

* added ```run_repo_security_scanner.sh```
* cURL added to docker image ```simonsdave/xenial-dev-env```

### Changed

* Nothing

### Removed

* Nothing

## [0.5.9] - [2018-12-05]

### Added

* Nothing

### Changed

* ```run_unit_tests.sh``` no longer chown's ```/app/.coverage```

### Removed

* Nothing

## [0.5.8] - [2018-11-12]

### Added

* added support for customizing ```--security-opt``` command line option
  to ```docker run``` executed by ```run_unit_tests.sh```
  using the ```DEV_ENV_SECURITY_OPT``` environment variable
* ```run_unit_tests.sh``` now allows specification on the command line
  of the directories in which unit tests can be found

### Changed

* Nothing

### Removed

* Nothing

## [0.5.7] - [2018-10-24]

### Added

* Nothing

### Changed

* Nothing

### Removed

* Nothing

## [0.5.6] - [2018-10-21]

### Added

* Nothing

### Changed

* ```.coverage``` files generated by ```run_unit_tests.sh``` was incorrectly
  referencing source code in ```/app``` which mean [coveralls](https://pypi.org/project/coveralls/)
  coverage data upload was failing

### Removed

* Nothing

## [0.5.5] - [2018-09-30]

### Added

* added ```run_flake8.sh```, ```run_pip_check.sh```, ```run_shellcheck.sh``` and ```run_unit_tests.sh```

### Changed

* ndg-httpsclient 0.4.4 -> 0.5.1
* development environment Ubuntu 14.04 -> 16.04
* twine 1.11.0 -> 1.12.1

### Removed

* Nothing

## [0.5.4] - [2018-04-24]

### Added

* Nothing

### Changed

* per [this bug](https://bugs.launchpad.net/cloud-images/+bug/1569237) pinning Xenial to a box version that fixes the bug

### Removed

* Nothing

## [0.5.3] - [2018-04-23]

### Added

* now supporting Ubuntu 16.04 (Xenial) as well as 14.04 (Trusty)

### Changed

* twine 1.10.0 -> 1.11.0

### Removed

* Nothing

## [0.5.2] - [2018-02-10]

### Added

* [memcached](http://memcached.org) is now installed as part of standard provisioning

### Changed

* default value for ```--nginx``` command line option of ```create_dev_env.sh```
  is now zero which means by default the VM's port 8085 is not exposed to the host
  which means nginx won't be exposed to the host by default
* changes to enable ```dev_env_nosetests.py``` to work when ```dev-env```
  installed as a site package
* ndg-httpsclient 0.4.3 -> 0.4.4

### Removed

* Nothing

## [0.5.1] - [2017-11-18]

### Added

* Nothing

### Changed

* fixed bug in ```ubuntu/trusty/.prep-for-release-branch-changes.sh``` which
  meant ```ubuntu/trusty/.prep-for-release-branch-changes.sh``` wasn't installing
  the right version of various shell scripts.
* fix bug in ```.prep-for-release-release-branch-changes.sh```
  to support running ```bin/prep-for-release-python.sh```
  and ```bin/prep-for-release.sh``` from any directory

### Removed

* Nothing

## [0.5.0] - [2017-11-14]

### Added

* ```dev_env_nosetests.py``` and ```dev_env/nose_plugins.FileCapture```
  for the basis for supporting integration testing

### Changed

* Nothing

### Removed

* Nothing

## [0.4.0] - [2017-10-25]

### Added

* ```create_dev_env.sh``` now has a ```--memory``` command line option
  allowing customization of amount of RAM is provisioned for a VM
* by default nginx is installed on a VM and exposed to the host
  on port 8085 - ```create_dev_env.sh``` now has an ```--nginx``` command
  line option allowing customization of the port
* ```create_dev_env.sh``` now has a ```--timezone``` command line option
  allowing customization of the provisioned VM's timezone - the value
  of the timezone argument comes from ```timedatectl list-timezones```

### Changed

* ```prep-for-release.sh``` now executes  ```.prep-for-release-release-branch-changes.sh```
  instead of ```.prep-for-release-branch-changes.sh```
* ```provision.sh``` now installs latest CE version of docker

### Removed

* ```ubuntu/trusty/provision.sh``` no longer installs ```raml2md```

## [0.3.0] - [2017-09-21]

### Added

* Nothing

### Changed

* ```prep-for-release.sh``` now fails if there are outstanding commits
  on the master branch
* ```provision.sh``` now installs [yq](https://yq.readthedocs.io/en/latest/)
* ```provision.sh``` installs ```prep-for-release.sh```
* update ```prep-for-release.sh``` with support for repo specific release
  branch change scripts so ```prep-for-release.sh``` can be used in more than
  just this repo
* ```provision.sh``` now installs a basic python dev env (since it's used so often)

### Removed

* Nothing

## [0.2.0] - [2017-09-15]

### Added

* Nothing

### Changed

* improved create_dev_env.sh command line arg checking
* no longer need to pass provision.sh to create_dev_env.sh

### Removed

* Nothing

## [0.1.0] - [2017-08-20]

### Added

* Initial Release - still a WIP
