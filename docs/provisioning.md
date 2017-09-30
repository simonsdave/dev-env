# Provisioning

Below are the (very opinionated) steps for integrating ```dev-env``` into
your repo to provision a development environment.

* [The Fundamentals](#the-fundamentals)
* [Customizations](#customizations)
    * [Memory](#memory)
    * [NGINX Port](#nginx-port)
* [What Next](#what-next)

## The Fundamentals

In the root directory of your repo create a file called ```CHANGELOG.md```.

```
# Change Log

All notable changes to this project will be documented in this file.
Format of this file follows [these](http://keepachangelog.com/) guidelines.
This project adheres to [Semantic Versioning](http://semver.org/).

## [%RELEASE_VERSION%] - [%RELEASE_DATE%]

### Added

- ...

### Changed

- ...

### Removed

- ...
```

In the root directory of your repo create a directory called ```dev_env```.
The remainder of these instructions are all conducted in the ```dev_env``` directory.

Create a ```.gitignore```

```
.vagrant
Vagrantfile
```

Create an executable ```create_dev_env.sh```
The example below references the ```master``` branch of [dev-env](https://github.com/simonsdave/dev-env)
which is the active development branch of [dev-env](https://github.com/simonsdave/dev-env).
It probably makes more sense to reference a specific [dev-env release](https://github.com/simonsdave/dev-env/releases)
by changing ```master``` with something like ```v0.2.0```.

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

## Customizations

The above described the basics of using ```create_dev_env.sh```.
To customize the way ```create_dev_env.sh``` operates see notes below.

### Memory

To customize the amount of RAM allocated to a VM using the ```--memory```
command line option for ```create_dev_env.sh```. The example below
demonstrates how to spin up a VM with 512 MB of RAM.

```bash
#!/usr/bin/env bash

if [ $# != 4 ]; then
    echo "usage: $(basename "$0") <github username> <github email> <github public key> <github private key>" >&2
    exit 1
fi

curl -s https://raw.githubusercontent.com/simonsdave/dev-env/master/ubuntu/trusty/create_dev_env.sh | bash -s -- --memory 512 "$@"
exit $?
```

### NGINX Port

By default [NGINX](https://nginx.org/) is installed on a VM and exposed to the host
on port 8085. ```create_dev_env.sh``` has an ```--nginx``` command
line option allowing customization of the port.

```bash
#!/usr/bin/env bash

if [ $# != 4 ]; then
    echo "usage: $(basename "$0") <github username> <github email> <github public key> <github private key>" >&2
    exit 1
fi

curl -s https://raw.githubusercontent.com/simonsdave/dev-env/master/ubuntu/trusty/create_dev_env.sh | bash -s -- --nginx 9000 "$@"
exit $?
```

## What Next

* take a look at [my other projects on github](https://github.com/simonsdave)
for examples of how ```dev-env``` is being used
* as you start to integrate ```dev-env``` into your projects
some feedback would be great - create [issues](../../../issues) and/or
send me an e-mail (```simonsdave@gmail.com```) - thanks in advance!
