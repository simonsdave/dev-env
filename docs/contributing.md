# Contributing

## Branch Management and Versioning Strategy

* all development is done on the ```master``` branch
* we use [Semantic Versioning](http://semver.org/) 
* for each release a new branch is created from master called ```release-<version>```

## How To Cut a Release

* the shell script [prep-for-release.sh](../bin/prep-for-release.sh) automates much of
the release prep

```bash
```

* after running [prep-for-release.sh](../bin/prep-for-release.sh) follow the standard
process of [creating a github release](https://help.github.com/articles/creating-releases/)
in [this UI](https://github.com/simonsdave/dev-env/releases/new)
