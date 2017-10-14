# Change Log

All notable changes to this project will be documented in this file.
Format of this file follows [these](http://keepachangelog.com/) guidelines.
This project adheres to [Semantic Versioning](http://semver.org/).

## [%RELEASE_VERSION%] - [%RELEASE_DATE%]

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
