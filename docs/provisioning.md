# Provisioning

To increase predicability and simplify on-boarding of new
collaborators, a common pattern on many of
[my projects on github](https://github.com/simonsdave)
is to provision a docker image ... :TODO: add more context & motivation

## ```dev_env/dev-env-version.txt```

* defines the ```dev-env``` version used by the repo
* typically an explicit version number (as below) but could also
  be ```master``` or ```latest``` referring to the head of the ```dev-env`` ```master``` branch

```text
v0.5.15
```

## ```cfg4dev```

```bash
pushd "$(git rev-parse --show-toplevel)" > /dev/null

export DEV_ENV_DOCKER_IMAGE=simonsdave/cloudfeaster-bionic-dev-env:build

if [ -d ./env ]; then
    source ./env/bin/activate
else
    virtualenv env
    source ./env/bin/activate

    python3.7 -m pip install --upgrade pip

    DEV_ENV_VERSION=$(cat ./dev_env/dev-env-version.txt)
    if [ "${DEV_ENV_VERSION}" == "latest" ]; then DEV_ENV_VERSION=master; fi
    python3.7 -m pip install "git+https://github.com/simonsdave/dev-env.git@${DEV_ENV_VERSION}"
    unset DEV_ENV_VERSION

    ./dev_env/build-docker-image.sh "${DEV_ENV_DOCKER_IMAGE}"
fi

export PATH="$PWD/bin":$PATH

popd > /dev/null
```

## [shell scripts to work with the dev-env docker image](https://github.com/simonsdave/dev-env/tree/master/bin)

* :TODO: fill me in

## What Next

* take a look at [my other projects on github](https://github.com/simonsdave)
  for examples of how ```dev-env``` is being used - in particular look at [```dev-env-testing```](https://github.com/simonsdave/dev-env-testing)
  which exists specifically to be an example of how to use ```dev-env```
* as you start to integrate ```dev-env``` into your projects
  some feedback would be great so don't hesitate to create [issues](../../../issues)
