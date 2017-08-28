# dev-env

![Maintained](https://img.shields.io/maintenance/yes/2017.svg?style=flat)
[![MIT license](http://img.shields.io/badge/license-MIT-brightgreen.svg)](http://opensource.org/licenses/MIT)
[![Build Status](https://travis-ci.org/simonsdave/dev-env.svg)](https://travis-ci.org/simonsdave/dev-env)

To increase predicability and simplify onboarding of new
collaborators, a common pattern for many of
[my projects on github](https://github.com/simonsdave)
is to define a [Vagrant](http://www.vagrantup.com/) provisioned
[VirtualBox](https://www.virtualbox.org/)
VM running [Ubuntu 14.04](http://releases.ubuntu.com/14.04/)
that can be used as a development environment.
The provisioning scripts for many of these projects have a
ton of commonality and it became obvious that it would make
provisioning script maintenance easier if the scripts were
defined in a single location.
This observation led to the creation of this project.
