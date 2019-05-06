# Provisioning

To increase predicability and simplify on-boarding of new
collaborators, a common pattern on many of
[my projects on github](https://github.com/simonsdave)
is to provision a docker image ... :TODO: add more context & motivation

## ```dev_env/dev-env-version.txt```

* defines the ```dev-env``` version used by the repo
* typically an explicit version number (as below) but could also
be ```master``` or ```latest``` referring to the head of the ```dev-env`` ```master``` branch

```
v0.5.15
```

## ```cfg4dev```

```bash
if [ -f "$PWD/requirements.txt" ]; then
    # per guidelines in https://github.com/simonsdave/dev-env
    export DEV_ENV_DOCKER_IMAGE="simonsdave/dev-env-testing-xenial-dev-env:build"

    if [ -d "$PWD/env" ]; then
        source "$PWD/env/bin/activate"
    else
        virtualenv env
        source "$PWD/env/bin/activate"

        DEV_ENV_VERSION=$(cat "$PWD/dev_env/dev-env-version.txt")
        if [ "${DEV_ENV_VERSION:-}" == "latest" ]; then DEV_ENV_VERSION=master; fi
        curl -s -L https://raw.githubusercontent.com/simonsdave/dev-env/${DEV_ENV_VERSION}/bin/install-dev-env.sh | bash -s --
        unset DEV_ENV_VERSION

        "$PWD/dev_env/build-docker-image.sh" "$DEV_ENV_DOCKER_IMAGE"
    fi

    export PATH="$PWD/bin":$PATH
else
    echo "Must source this script from project's root directory" >&2
    return 1
fi
```

## [shell scripts to work with the dev-env docker image](https://github.com/simonsdave/dev-env/tree/master/bin)

* :TODO: fill me in

## What Next

* take a look at [my other projects on github](https://github.com/simonsdave)
for examples of how ```dev-env``` is being used - in particular look at [```dev-env-testing```](https://github.com/simonsdave/dev-env-testing)
which exists specifically to be an example of how to use ```dev-env```
* as you start to integrate ```dev-env``` into your projects
some feedback would be great so don't hesitate to create [issues](../../../issues)
