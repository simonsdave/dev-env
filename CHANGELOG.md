# Change Log

All notable changes to this project will be documented in this file.
Format of this file follows [these](http://keepachangelog.com/) guidelines.
This project adheres to [Semantic Versioning](http://semver.org/).

## [%RELEASE_VERSION%] - [%RELEASE_DATE%]

### Added

- Nothing

### Changed

- Nothing

### Removed

- Nothing

## [0.5.4] - [2018-04-24]

### Added

- Nothing

### Changed

- per [this bug](https://bugs.launchpad.net/cloud-images/+bug/1569237) pinning Xenial to a box version that fixes the bug

### Removed

- Nothing

## [0.5.3] - [2018-04-23]

### Added

- now supporting Ubuntu 16.04 (Xenial) as well as 14.04 (Trusty)

### Changed

- twine 1.10.0 -> 1.11.0

### Removed

- Nothing

## [0.5.2] - [2018-02-10]

### Added

- [memcached](http://memcached.org) is now installed as part of standard provisioning

### Changed

- default value for ```--nginx``` command line option of ```create_dev_env.sh``` 
is now zero which means by default the VM's port 8085 is not exposed to the host
which means nginx won't be exposed to the host by default
- changes to enable ```dev_env_nosetests.py``` to work when ```dev-env```
installed as a site package
- ndg-httpsclient 0.4.3 -> 0.4.4

### Removed

- Nothing

## [0.5.1] - [2017-11-18]

### Added

- Nothing

### Changed

- fixed bug in ```ubuntu/trusty/.prep-for-release-branch-changes.sh``` which
meant ```ubuntu/trusty/.prep-for-release-branch-changes.sh``` wasn't installing
the right version of various shell scripts.
- fix bug in ```.prep-for-release-release-branch-changes.sh```
to support running ```bin/prep-for-release-python.sh```
and ```bin/prep-for-release.sh``` from any directory

### Removed

- Nothing

## [0.5.0] - [2017-11-14]

### Added

- ```dev_env_nosetests.py``` and ```dev_env/nose_plugins.FileCapture```
for the basis for supporting integration testing

### Changed

- Nothing

### Removed

- Nothing

## [0.4.0] - [2017-10-25]

### Added

- ```create_dev_env.sh``` now has a ```--memory``` command line option
allowing customization of amount of RAM is provisioned for a VM
- by default nginx is installed on a VM and exposed to the host
on port 8085 - ```create_dev_env.sh``` now has an ```--nginx``` command
line option allowing customization of the port
- ```create_dev_env.sh``` now has a ```--timezone``` command line option
allowing customization of the provisioned VM's timezone - the value
of the timezone argument comes from ```timedatectl list-timezones```

### Changed

- ```prep-for-release.sh``` now executes  ```.prep-for-release-release-branch-changes.sh```
instead of ```.prep-for-release-branch-changes.sh```
- ```provision.sh``` now installs latest CE version of docker

### Removed

- ```ubuntu/trusty/provision.sh``` no longer installs ```raml2md```

## [0.3.0] - [2017-09-21]

### Added

- Nothing

### Changed

- ```prep-for-release.sh``` now fails if there are outstanding commits
on the master branch
- ```provision.sh``` now installs [yq](https://yq.readthedocs.io/en/latest/)
- ```provision.sh``` installs ```prep-for-release.sh```
- update ```prep-for-release.sh``` with support for repo specific release
branch change scripts so ```prep-for-release.sh``` can be used in more than
just this repo
- ```provision.sh``` now installs a basic python dev env (since it's used so often)

### Removed

- Nothing

## [0.2.0] - [2017-09-15]

### Added

- Nothing

### Changed

- improved create_dev_env.sh command line arg checking
- no longer need to pass provision.sh to create_dev_env.sh

### Removed

- Nothing

## [0.1.0] - [2017-08-20]

### Added

- Initial Release - still a WIP
