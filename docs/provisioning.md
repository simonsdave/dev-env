# Provisioning

To increase predicability and simplify on-boarding of new
collaborators, a common pattern in many of
[my github projects](https://github.com/simonsdave)
is to provision a docker image ... :TODO: add more context & motivation

## ```.circleci/config.yml```

* projects which use ```dev-env``` and CircleCI will have a
  file ```$(repo-root-dir.sh)/.circleci/config.yml```
  that typically starts out something like

```yaml
version: 2.1

executors:
  dev-env:
    environment:
      DOCKER_TEMP_IMAGE: simonsdave/cloudfeaster-bionic-dev-env:bindle
    docker:
      - image: simonsdave/bionic-dev-env:v0.6.0

jobs:
  build_test_and_deploy:
    .
    .
    .
```

## ```cfg4dev```

With ```cfg4dev``` in a project's root directory, simply doing a ```source cfg4dev```
is all that should be required to start working on the project after a ```git clone```
has been run. A typical ```cfg4dev``` is illustrated below.

```bash
pushd "$(git rev-parse --show-toplevel)" > /dev/null

export DEV_ENV_DOCKER_IMAGE=simonsdave/dev-env-testing-bionic-dev-env:build

if [ -d ./env ]; then
    source ./env/bin/activate
else
    python3.7 -m pip install virtualenv

    virtualenv env
    source ./env/bin/activate

    python3.7 -m pip install --upgrade pip

    curl -s -L https://raw.githubusercontent.com/simonsdave/dev-env/master/bin/install-dev-env.sh | bash -s --

    ./dev_env/build-docker-image.sh "${DEV_ENV_DOCKER_IMAGE}"
fi

export PATH="${PWD}/bin":${PATH}

popd
```

## What Next

* take a look at [my other projects on github](https://github.com/simonsdave)
  for examples of how ```dev-env``` is being used - in particular look at [```dev-env-testing```](https://github.com/simonsdave/dev-env-testing)
  which exists specifically to be an example of how to use ```dev-env```
* as you start to integrate ```dev-env``` into your projects
  some feedback would be great so don't hesitate to create [issues](../../../issues)
