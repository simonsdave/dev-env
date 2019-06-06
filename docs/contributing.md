# Contributing

## Key Concepts

### Changelog

* at top of the repo there's a [markdown](https://en.wikipedia.org/wiki/Markdown) file
called [```CHANGELOG.md```](../CHANGELOG.md) which is a hand curated changlelog
* ```CHANGELOG.md``` is intended to be read by humans
ala [this](https://keepachangelog.com/en/1.0.0/) thinking

### Branching

* all development is done on the ```master``` branch
* the ```master``` branch is protected
* [GitHub flow](https://guides.github.com/introduction/flow/) is used to
introduce changes to the ```master``` branch
* before creating a [pull request](https://help.github.com/en/articles/about-pull-requests)
to merge a feature branch back into ```master```,
all changes on the feature branch should be squashed down to a single buildable
commit and then rebased from the up-to-date ```master``` branch -
see [this](https://blog.carbonfive.com/2017/08/28/always-squash-and-rebase-your-git-commits/)
for additional details
* cutting a release involves creating a new branch from ```master```
called ```release-<version>```

### Commit Messaging

* commit messaging follows
the [Conventional Commits specification](https://www.conventionalcommits.org) to
enable automated generation of release version numbers
* more accurately, the single squashed and rebased commit used in a
pull request follows the conventional commits specification

### Versioning

* [semantic versioning](http://semver.org/) is used
* the current release number is stored
in [```dev_env/__init__.py```](../dev_env/__init__.py)
* <<< new release number calculated >>>

## How To Cut a Release

* make sure your ```~/.pypirc``` is setup

```bash
(env) ~> cut-release.sh
Already on 'master'
Your branch is up to date with 'origin/master'.
diff --git a/CHANGELOG.md b/CHANGELOG.md
index ad052f4..b606d21 100644
--- a/CHANGELOG.md
+++ b/CHANGELOG.md
@@ -4,7 +4,7 @@ All notable changes to this project will be documented in this file.
 Format of this file follows [these](http://keepachangelog.com/) guidelines.
 This project adheres to [Semantic Versioning](http://semver.org/).

-## [%RELEASE_VERSION%] - [%RELEASE_DATE%]
+## [0.5.16] - [2019-05-13]

 ### Added

These changes to master for release look ok? (y/n)>
```

```bash
[master dc11a9b] 0.5.16 pre-release prep
 1 file changed, 1 insertion(+), 1 deletion(-)
DEPRECATION: Python 2.7 will reach the end of its life on January 1st, 2020. Please upgrade your Python as Python 2.7 won't be maintained after that date. A future version of pip will drop support for Python 2.7.
diff --git a/CHANGELOG.md b/CHANGELOG.md
index b606d21..8fade40 100644
--- a/CHANGELOG.md
+++ b/CHANGELOG.md
@@ -4,6 +4,20 @@ All notable changes to this project will be documented in this file.
 Format of this file follows [these](http://keepachangelog.com/) guidelines.
 This project adheres to [Semantic Versioning](http://semver.org/).

+## [%RELEASE_VERSION%] - [%RELEASE_DATE%]
+
+### Added
+
+* Nothing
+
+### Changed
+
+* Nothing
+
+### Removed
+
+* Nothing
+
 ## [0.5.16] - [2019-05-13]

 ### Added
diff --git a/dev_env/__init__.py b/dev_env/__init__.py
index fc5d396..ce0149a 100644
--- a/dev_env/__init__.py
+++ b/dev_env/__init__.py
@@ -1 +1 @@
-__version__ = '0.5.16'
+__version__ = '0.5.17'
These changes to master for next release look ok? (y/n)>
```

```bash
[master ae860fc] Prep CHANGELOG.md for next release
 2 files changed, 15 insertions(+), 1 deletion(-)
Switched to branch 'release-0.5.16'
5a6ff6709a7946b4a829175298975f73
running bdist_wheel
running build
running build_py
creating build
creating build/lib.linux-x86_64-2.7
creating build/lib.linux-x86_64-2.7/dev_env
copying dev_env/__init__.py -> build/lib.linux-x86_64-2.7/dev_env
running egg_info
creating dev_env.egg-info
writing dev_env.egg-info/PKG-INFO
writing top-level names to dev_env.egg-info/top_level.txt
writing dependency_links to dev_env.egg-info/dependency_links.txt
writing manifest file 'dev_env.egg-info/SOURCES.txt'
reading manifest file 'dev_env.egg-info/SOURCES.txt'
reading manifest template 'MANIFEST.in'
writing manifest file 'dev_env.egg-info/SOURCES.txt'
running build_scripts
creating build/scripts-2.7
copying and adjusting bin/add-new-changelog-dot-md-release.py -> build/scripts-2.7
copying and adjusting bin/changelog-dot-md-release-comments.py -> build/scripts-2.7
copying and adjusting bin/cut-changelog-dot-md.py -> build/scripts-2.7
copying bin/python-version.sh -> build/scripts-2.7
copying bin/python-increment-version.sh -> build/scripts-2.7
copying bin/cut-release.sh -> build/scripts-2.7
copying bin/create-github-release.sh -> build/scripts-2.7
copying bin/run-flake8.sh -> build/scripts-2.7
copying bin/run-pip-check.sh -> build/scripts-2.7
copying bin/run-shellcheck.sh -> build/scripts-2.7
copying bin/run-unit-tests.sh -> build/scripts-2.7
copying bin/run-repo-security-scanner.sh -> build/scripts-2.7
copying bin/kill-and-rm-all-docker-containers.sh -> build/scripts-2.7
copying bin/build-python-package.sh -> build/scripts-2.7
copying bin/build-readme-dot-rst.sh -> build/scripts-2.7
copying bin/repo.sh -> build/scripts-2.7
copying bin/repo-root-dir.sh -> build/scripts-2.7
copying bin/run-snyk.sh -> build/scripts-2.7
copying bin/rm-dangling-docker-images.sh -> build/scripts-2.7
copying bin/run-markdownlint.sh -> build/scripts-2.7
copying bin/upload-dist-to-pypi.sh -> build/scripts-2.7
copying bin/create-dummy-docker-container.sh -> build/scripts-2.7
copying bin/check-consistent-dev-env-version.sh -> build/scripts-2.7
copying bin/run-yamllint.sh -> build/scripts-2.7
copying bin/run-circleci.sh -> build/scripts-2.7
copying bin/run-bandit.sh -> build/scripts-2.7
changing mode of build/scripts-2.7/add-new-changelog-dot-md-release.py from 644 to 755
changing mode of build/scripts-2.7/changelog-dot-md-release-comments.py from 644 to 755
changing mode of build/scripts-2.7/cut-changelog-dot-md.py from 644 to 755
installing to build/bdist.linux-x86_64/wheel
running install
running install_lib
creating build/bdist.linux-x86_64
creating build/bdist.linux-x86_64/wheel
creating build/bdist.linux-x86_64/wheel/dev_env
copying build/lib.linux-x86_64-2.7/dev_env/__init__.py -> build/bdist.linux-x86_64/wheel/dev_env
running install_egg_info
Copying dev_env.egg-info to build/bdist.linux-x86_64/wheel/dev_env-0.5.16.egg-info
running install_scripts
creating build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data
creating build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts
copying build/scripts-2.7/run-shellcheck.sh -> build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts
copying build/scripts-2.7/build-readme-dot-rst.sh -> build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts
copying build/scripts-2.7/add-new-changelog-dot-md-release.py -> build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts
copying build/scripts-2.7/python-version.sh -> build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts
copying build/scripts-2.7/run-bandit.sh -> build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts
copying build/scripts-2.7/run-flake8.sh -> build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts
copying build/scripts-2.7/create-dummy-docker-container.sh -> build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts
copying build/scripts-2.7/run-markdownlint.sh -> build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts
copying build/scripts-2.7/run-yamllint.sh -> build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts
copying build/scripts-2.7/cut-changelog-dot-md.py -> build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts
copying build/scripts-2.7/run-snyk.sh -> build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts
copying build/scripts-2.7/run-unit-tests.sh -> build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts
copying build/scripts-2.7/run-pip-check.sh -> build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts
copying build/scripts-2.7/python-increment-version.sh -> build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts
copying build/scripts-2.7/repo.sh -> build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts
copying build/scripts-2.7/upload-dist-to-pypi.sh -> build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts
copying build/scripts-2.7/build-python-package.sh -> build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts
copying build/scripts-2.7/create-github-release.sh -> build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts
copying build/scripts-2.7/cut-release.sh -> build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts
copying build/scripts-2.7/repo-root-dir.sh -> build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts
copying build/scripts-2.7/check-consistent-dev-env-version.sh -> build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts
copying build/scripts-2.7/changelog-dot-md-release-comments.py -> build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts
copying build/scripts-2.7/run-circleci.sh -> build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts
copying build/scripts-2.7/rm-dangling-docker-images.sh -> build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts
copying build/scripts-2.7/kill-and-rm-all-docker-containers.sh -> build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts
copying build/scripts-2.7/run-repo-security-scanner.sh -> build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts
changing mode of build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts/run-shellcheck.sh to 755
changing mode of build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts/build-readme-dot-rst.sh to 755
changing mode of build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts/add-new-changelog-dot-md-release.py to 755
changing mode of build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts/python-version.sh to 755
changing mode of build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts/run-bandit.sh to 755
changing mode of build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts/run-flake8.sh to 755
changing mode of build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts/create-dummy-docker-container.sh to 755
changing mode of build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts/run-markdownlint.sh to 755
changing mode of build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts/run-yamllint.sh to 755
changing mode of build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts/cut-changelog-dot-md.py to 755
changing mode of build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts/run-snyk.sh to 755
changing mode of build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts/run-unit-tests.sh to 755
changing mode of build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts/run-pip-check.sh to 755
changing mode of build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts/python-increment-version.sh to 755
changing mode of build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts/repo.sh to 755
changing mode of build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts/upload-dist-to-pypi.sh to 755
changing mode of build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts/build-python-package.sh to 755
changing mode of build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts/create-github-release.sh to 755
changing mode of build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts/cut-release.sh to 755
changing mode of build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts/repo-root-dir.sh to 755
changing mode of build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts/check-consistent-dev-env-version.sh to 755
changing mode of build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts/changelog-dot-md-release-comments.py to 755
changing mode of build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts/run-circleci.sh to 755
changing mode of build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts/rm-dangling-docker-images.sh to 755
changing mode of build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts/kill-and-rm-all-docker-containers.sh to 755
changing mode of build/bdist.linux-x86_64/wheel/dev_env-0.5.16.data/scripts/run-repo-security-scanner.sh to 755
creating build/bdist.linux-x86_64/wheel/dev_env-0.5.16.dist-info/WHEEL
running sdist
running check
creating dev_env-0.5.16
creating dev_env-0.5.16/bin
creating dev_env-0.5.16/dev_env
creating dev_env-0.5.16/dev_env.egg-info
making hard links in dev_env-0.5.16...
hard linking MANIFEST.in -> dev_env-0.5.16
hard linking README.rst -> dev_env-0.5.16
hard linking setup.cfg -> dev_env-0.5.16
hard linking setup.py -> dev_env-0.5.16
hard linking bin/add-new-changelog-dot-md-release.py -> dev_env-0.5.16/bin
hard linking bin/build-python-package.sh -> dev_env-0.5.16/bin
hard linking bin/build-readme-dot-rst.sh -> dev_env-0.5.16/bin
hard linking bin/changelog-dot-md-release-comments.py -> dev_env-0.5.16/bin
hard linking bin/check-consistent-dev-env-version.sh -> dev_env-0.5.16/bin
hard linking bin/create-dummy-docker-container.sh -> dev_env-0.5.16/bin
hard linking bin/create-github-release.sh -> dev_env-0.5.16/bin
hard linking bin/cut-changelog-dot-md.py -> dev_env-0.5.16/bin
hard linking bin/cut-release.sh -> dev_env-0.5.16/bin
hard linking bin/kill-and-rm-all-docker-containers.sh -> dev_env-0.5.16/bin
hard linking bin/python-increment-version.sh -> dev_env-0.5.16/bin
hard linking bin/python-version.sh -> dev_env-0.5.16/bin
hard linking bin/repo-root-dir.sh -> dev_env-0.5.16/bin
hard linking bin/repo.sh -> dev_env-0.5.16/bin
hard linking bin/rm-dangling-docker-images.sh -> dev_env-0.5.16/bin
hard linking bin/run-bandit.sh -> dev_env-0.5.16/bin
hard linking bin/run-circleci.sh -> dev_env-0.5.16/bin
hard linking bin/run-flake8.sh -> dev_env-0.5.16/bin
hard linking bin/run-markdownlint.sh -> dev_env-0.5.16/bin
hard linking bin/run-pip-check.sh -> dev_env-0.5.16/bin
hard linking bin/run-repo-security-scanner.sh -> dev_env-0.5.16/bin
hard linking bin/run-shellcheck.sh -> dev_env-0.5.16/bin
hard linking bin/run-snyk.sh -> dev_env-0.5.16/bin
hard linking bin/run-unit-tests.sh -> dev_env-0.5.16/bin
hard linking bin/run-yamllint.sh -> dev_env-0.5.16/bin
hard linking bin/upload-dist-to-pypi.sh -> dev_env-0.5.16/bin
hard linking dev_env/__init__.py -> dev_env-0.5.16/dev_env
hard linking dev_env.egg-info/PKG-INFO -> dev_env-0.5.16/dev_env.egg-info
hard linking dev_env.egg-info/SOURCES.txt -> dev_env-0.5.16/dev_env.egg-info
hard linking dev_env.egg-info/dependency_links.txt -> dev_env-0.5.16/dev_env.egg-info
hard linking dev_env.egg-info/top_level.txt -> dev_env-0.5.16/dev_env.egg-info
copying setup.cfg -> dev_env-0.5.16
Writing dev_env-0.5.16/setup.cfg
Creating tar archive
removing 'dev_env-0.5.16' (and everything under it)
diff --git a/README.md b/README.md
index a4ef121..7c5966c 100644
--- a/README.md
+++ b/README.md
@@ -61,6 +61,6 @@ are in a sub-directory of the project's root directory called ```dev_env```
 ## What Next

 * take a look at the [shell and python scripts](bin) to assess ```dev-env``` capability
-* [here's](docs/using.md) a description of how to start using ```dev-env```
+* [here's](https://github.com/simonsdave/dev-env/tree/release-0.5.16/docs/using.md) a description of how to start using ```dev-env```
 * take a look at [this](https://github.com/simonsdave/dev-env-testing) github repo which illustrates how to use ```dev-env```
-* if you'd like to help contribute to ```dev-env``` see [this](docs/contributing.md)
+* if you'd like to help contribute to ```dev-env``` see [this](https://github.com/simonsdave/dev-env/tree/release-0.5.16/docs/contributing.md)
These changes to release-0.5.16 look ok? (y/n)>
```

```bash
[release-0.5.16 f4c5f0a] 0.5.16 release prep
 1 file changed, 2 insertions(+), 2 deletions(-)
All changes made locally. Ok to push changes to github? (y/n)>
```

```bash
Switched to branch 'master'
Your branch is ahead of 'origin/master' by 2 commits.
  (use "git push" to publish your local commits)
Counting objects: 8, done.
Delta compression using up to 12 threads.
Compressing objects: 100% (6/6), done.
Writing objects: 100% (8/8), 709 bytes | 709.00 KiB/s, done.
Total 8 (delta 4), reused 0 (delta 0)
remote: Resolving deltas: 100% (4/4), completed with 2 local objects.
To github.com:simonsdave/dev-env.git
   4001ea6..ae860fc  master -> master
Switched to branch 'release-0.5.16'
Counting objects: 3, done.
Delta compression using up to 12 threads.
Compressing objects: 100% (3/3), done.
Writing objects: 100% (3/3), 350 bytes | 350.00 KiB/s, done.
Total 3 (delta 2), reused 0 (delta 0)
remote: Resolving deltas: 100% (2/2), completed with 2 local objects.
remote:
remote: Create a pull request for 'release-0.5.16' on GitHub by visiting:
remote:      https://github.com/simonsdave/dev-env/pull/new/release-0.5.16
remote:
To github.com:simonsdave/dev-env.git
 * [new branch]      release-0.5.16 -> release-0.5.16
Switched to branch 'master'
Your branch is up to date with 'origin/master'.
(env) ~>
```

```bash
(env) ~> upload-dist-to-pypi.sh testpypi
Uploading distributions to https://test.pypi.org/legacy/
Uploading dev_env-0.5.15-py2-none-any.whl
100%|##########| 36.6k/36.6k [00:00<00:00, 370kB/s]
Uploading dev_env-0.5.15.tar.gz
100%|##########| 23.2k/23.2k [00:01<00:00, 21.9kB/s]
(env) ~>
```

Now look on [https://test.pypi.org/project/dev-env/](https://test.pypi.org/project/dev-env/)
to confirm all is ok and if it is upload to the test version of pypi.

```bash
(env) ~> upload-dist-to-pypi.sh pypi
Uploading distributions to https://upload.pypi.org/legacy/
Uploading dev_env-0.5.16-py2-none-any.whl
100%|##########| 36.4k/36.4k [00:02<00:00, 17.7kB/s]
Uploading dev_env-0.5.16.tar.gz
100%|##########| 21.4k/21.4k [00:01<00:00, 15.9kB/s]
(env) ~>
```

Now look on [https://pypi.org/project/dev-env/](https://pypi.org/project/dev-env/)
to confirm all is ok and if it is upload to the live version of pypi.

## What Next

* start contributing!
