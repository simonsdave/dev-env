# dev-env

![Maintained](https://img.shields.io/maintenance/yes/2017.svg?style=flat)
[![MIT license](http://img.shields.io/badge/license-MIT-brightgreen.svg)](http://opensource.org/licenses/MIT)
[![Build Status](https://travis-ci.org/simonsdave/dev-env.svg?branch=master)](https://travis-ci.org/simonsdave/dev-env)

To increase predicability and simplify onboarding of new
collaborators, a common pattern on many of
[my projects on github](https://github.com/simonsdave)
is to create a development environment using a [Vagrant](http://www.vagrantup.com/)
provisioned [VirtualBox](https://www.virtualbox.org/)
VM running [some version of Ubuntu](http://releases.ubuntu.com).
The provisioning scripts for most of these projects have a
ton of commonality and it became obvious that it would make
provisioning script maintenance easier if the scripts were
defined in a single location.
This observation led to the creation of this project.

## What Next

* [here's](docs/using.md) a description of how to start using ```dev-env```
* if you'd like to help contribute to ```dev-env``` see [this](docs/contributing.md)
