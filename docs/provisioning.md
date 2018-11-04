# Provisioning

To increase predicability and simplify on-boarding of new
collaborators, a common pattern on many of
[my projects on github](https://github.com/simonsdave)
is to create a development environment using a [Vagrant](http://www.vagrantup.com/)
provisioned [VirtualBox](https://www.virtualbox.org/)
VM running [some version of Ubuntu](http://releases.ubuntu.com).
The provisioning scripts for most of these projects have a
ton of commonality and it became obvious that it would make
provisioning script maintenance easier if the scripts were
defined in a single location and hence the motivation for
this project.

Also, [my projects on github](https://github.com/simonsdave) use [Travis](https://travis-ci.com/)
for CI. One challenge with Travis is ensuring tool versions provisioned
by Travis are the same as those provisioned in development environments.
To fix this problem and inspired by [Google's Cloud Build](https://cloud.google.com/cloud-build/),
standard Python development tools ([flake8](https://pypi.org/project/flake8/),
[pip check](https://pypi.org/project/pip/) and [nose](https://nose.readthedocs.io/en/latest/)) are packaged
in ```dev-env``` Docker images and ```dev-env``` shell scripts make it very easy
to use the images.

Below are the (very opinionated) steps for integrating ```dev-env``` into
your repo to provision a development environment.

* [Fundamentals](#fundamentals)
* [Customizations](#customizations)
    * [Memory](#memory)
    * [NGINX Port](#nginx-port)
    * [Timezone](#timezone)
* [What Next](#what-next)

## Fundamentals

```dev-env``` is known to work various combinations of:

* Mac OS X 10.11.6 (El Capitan)
* Vagrant 1.8.5, 1.9.3, 2.0.0
* VirtualBox 5.1.26 r117224 (Qt5.6.2), 5.1.28 r117968 (Qt5.6.2)

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
*.log
```

Create a text file called ```dev-env-version.txt``` which contains the
version number of ```dev-env``` which we'll be using.

```
>cat dev-env-version.txt
v0.5.5
>
```

Create an executable ```create_dev_env.sh```
The example below references the ```master``` branch of [dev-env](https://github.com/simonsdave/dev-env)
which is the active development branch of [dev-env](https://github.com/simonsdave/dev-env).
It probably makes more sense to reference a specific [dev-env release](https://github.com/simonsdave/dev-env/releases)
by changing ```master``` with something like ```v0.2.0```.

```bash
#!/usr/bin/env bash

set -e

SCRIPT_DIR_NAME="$( cd "$( dirname "$0" )" && pwd )"

if [ $# != 4 ]; then
    echo "usage: $(basename "$0") <github username> <github email> <github public key> <github private key>" >&2
    exit 1
fi

DEV_ENV_VERSION=$(cat "$SCRIPT_DIR_NAME/dev-env-version.txt")

curl -s "https://raw.githubusercontent.com/simonsdave/dev-env/$DEV_ENV_VERSION/ubuntu/xenial/create_dev_env.sh" | bash -s -- "$@"

exit 0
```

Create a ```provision.sh``` containing project specific customizations
for the development environment. The file could be empty if there are
no customizations.

```bash
#!/usr/bin/env bash

exit 0
```

You'll notice ```provision.sh``` references ```build-docker-image.sh```
so let's create

```bash
#!/usr/bin/env bash

set -e

SCRIPT_DIR_NAME="$( cd "$( dirname "$0" )" && pwd )"

if [ $# != 0 ]; then
    echo "usage: $(basename "$0")" >&2
    exit 1
fi

CONTEXT_DIR=$(mktemp -d 2> /dev/null || mktemp -d -t DAS)
PROJECT_HOME_DIR="$SCRIPT_DIR_NAME/.."
cp "$PROJECT_HOME_DIR/requirements.txt" "$CONTEXT_DIR/."
cp "$PROJECT_HOME_DIR/setup.py" "$CONTEXT_DIR/."
mkdir "$CONTEXT_DIR/tor_async_util"
cp "$PROJECT_HOME_DIR/tor_async_util/__init__.py" "$CONTEXT_DIR/tor_async_util/."

DEV_ENV_VERSION=$(cat "$SCRIPT_DIR_NAME/dev-env-version.txt")

TEMP_DOCKERFILE=$CONTEXT_DIR/Dockerfile
cp "$SCRIPT_DIR_NAME/Dockerfile.template" "$TEMP_DOCKERFILE"
sed \
    -i \
    -e "s|%DEV_ENV_VERSION%|$DEV_ENV_VERSION|g" \
    "$TEMP_DOCKERFILE"

DOCKER_IMAGE=$(cat "$SCRIPT_DIR_NAME/dev-env-dockerimage.txt")

docker build \
    -t "$DOCKER_IMAGE" \
    --file "$TEMP_DOCKERFILE" \
    "$CONTEXT_DIR"

rm -rf "$CONTEXT_DIR"

exit 0
```

Last file ... let's create ```Dockerfile.template```

```
FROM simonsdave/xenial-dev-env:%DEV_ENV_VERSION%

MAINTAINER Dave Simons

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get install -y build-essential
RUN apt-get install -y libffi-dev
RUN apt-get install -y python-crypto
RUN apt-get install -y libcurl4-openssl-dev
RUN apt-get install -y libssl-dev

COPY requirements.txt /tmp/requirements.txt
COPY setup.py /tmp/setup.py
RUN mkdir /tmp/tor_async_util
COPY tor_async_util/__init__.py /tmp/tor_async_util/__init__.py

RUN cd /tmp && pip install --requirement "/tmp/requirements.txt"

ENV DEBIAN_FRONTEND newt

WORKDIR /app
>
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

:TODO: add something about ```cfg4dev```

```bash
if [ -f "$PWD/requirements.txt" ]; then
    # per guidelines in https://github.com/simonsdave/dev-env
    export DEV_ENV_SOURCE_CODE=$PWD
    export DEV_ENV_DOCKER_IMAGE="simonsdave/tor-async-util-xenial-dev-env:build"
    export DEV_ENV_PACKAGE=tor_async_util
    # if need special security settings to on "docker run" then set DEV_ENV_SECURITY_OPT
    # export DEV_ENV_SECURITY_OPT=seccomp:unconfined

    # :TODO: do we actually need to be using virtualenv anymore?
    if [ -d "$PWD/env" ]; then
        source "$PWD/env/bin/activate"
    else
        virtualenv env
        source "$PWD/env/bin/activate"

        # this is really here so that travis will work
        if ! which run_shellcheck.sh; then
            pip install git+https://github.com/simonsdave/dev-env.git@master
        fi

        "$PWD/dev_env/build-docker-image.sh" "$DEV_ENV_DOCKER_IMAGE"
    fi

    export PATH=$PATH:"$PWD/bin"
    export PYTHONPATH="$PWD"
else
    echo "Must source this script from repo's root directory"
fi
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

[NGINX](https://nginx.org/) is installed on all VMs and listens on port 8085.
By default the VMs 8085 port is not mapped to a host port.
```create_dev_env.sh``` has an ```--nginx``` command
line option allowing specification of the host port to which the VMs port 8085 is mapped.
Setting ```--nginx``` to zero explicitly disables mapping of the VMs port 8085 to any host ports.

```bash
#!/usr/bin/env bash

if [ $# != 4 ]; then
    echo "usage: $(basename "$0") <github username> <github email> <github public key> <github private key>" >&2
    exit 1
fi

curl -s https://raw.githubusercontent.com/simonsdave/dev-env/master/ubuntu/trusty/create_dev_env.sh | bash -s -- --nginx 9000 "$@"
exit $?
```

### Timezone

By default VMs are provisioned with an EST timezone. ```create_dev_env.sh```
has a ```--timezone``` command line option
allowing customization of the provisioned VM's timezone.

```bash
#!/usr/bin/env bash

TIMEZONE=EST

while true
do
    case "${1:-}" in
        --timezone)
            shift
            TIMEZONE=${1:-EST}
            shift
            ;;
        *)
            break
            ;;
    esac
done

if [ $# != 4 ]; then
    echo "usage: $(basename "$0") [--timezone <timezone>] <github username> <github email> <github public key> <github private key>" >&2
    exit 1
fi

curl -s https://raw.githubusercontent.com/simonsdave/dev-env/master/ubuntu/trusty/create_dev_env.sh | bash -s -- --timezone "$TIMEZONE" "$@"
exit $?
```

The value of the timezone argument comes from
the output of ```timedatectl list-timezones```.

```bash
~> timedatectl list-timezones
Africa/Abidjan
Africa/Accra
Africa/Addis_Ababa
Africa/Algiers
Africa/Asmara
Africa/Bamako
Africa/Bangui
Africa/Banjul
.
.
.
~>
```

## What Next

* take a look at [my other projects on github](https://github.com/simonsdave)
for examples of how ```dev-env``` is being used
* as you start to integrate ```dev-env``` into your projects
some feedback would be great - create [issues](../../../issues) and/or
send me an e-mail [simonsdave@gmail.com](mailto:simonsdave@gmail.com) - thanks in advance!
