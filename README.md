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

# Usage

Below are the (very opinionated) steps for integrating ```dev-env``` into
your repo.

In the root directory of your project create a directory called ```dev_env```. The remainder of these instructions are all conducted in
the ```dev_env``` directory.

Create a ```.gitignore```

```
.vagrant
Vagrantfile
```

Create an executable ```create_dev_env.sh```

```bash
#!/usr/bin/env bash

if [ $# != 4 ]; then
    echo "usage: $(basename "$0") <github username> <github email> <github public key> <github private key>" >&2
    exit 1
fi

curl -s https://raw.githubusercontent.com/simonsdave/dev-env/master/ubuntu/trusty/create_dev_env.sh | bash -s -- "$@"
exit $?
```

Create a ```provision.sh``` containing project specific customizations
for the development environment. The file could be empty if there are
no customizations.

```bash
#!/usr/bin/env bash
exit 0
```

Or you could install just enough to do some basic python development.

```bash
#!/usr/bin/env bash
set -e
apt-get install -y python-virtualenv
apt-get install -y python-dev
exit 0
```

Now it's time to spin up our VM. What's below assumes (in fact
requires) you intend to access your github repo using SSH per
the [canonical github instructions](https://help.github.com/articles/connecting-to-github-with-ssh/)
and have already generated you SSH keys and these
keys can be found in ```~/.ssh/id_rsa.pub``` and ```~/.ssh/id_rsa```.

```bash
>./create_dev_env.sh simonsdave simonsdave@gmail.com ~/.ssh/id_rsa.pub ~/.ssh/id_rsa
Bringing machine 'default' up with 'virtualbox' provider...
==> default: Importing base box 'trusty'...
.
.
.
>
```
