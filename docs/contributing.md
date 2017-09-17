# Contributing

## Branch Management and Versioning Strategy

* all development is done on the ```master``` branch
* we use [Semantic Versioning](http://semver.org/)
* for each release a new branch is created from master called ```release-<version>```

## How To Cut a Release

* the shell script [prep-for-release.sh](../bin/prep-for-release.sh) automates much of
the release prep

```bash
~/dev-env/bin> ./prep-for-release.sh 0.2.0
Already on 'master'
Your branch is up-to-date with 'origin/master'.
diff --git a/CHANGELOG.md b/CHANGELOG.md
index ec85c3e..1966619 100644
--- a/CHANGELOG.md
+++ b/CHANGELOG.md
@@ -4,7 +4,7 @@ All notable changes to this project will be documented in this file.
 Format of this file follows [these](http://keepachangelog.com/) guidelines.
 This project adheres to [Semantic Versioning](http://semver.org/).

-## [%RELEASE_VERSION%] - [%RELEASE_DATE%]
+## [0.2.0] - [2017-09-15]

 ### Added

These changes to master look ok? (y/n)> y
[master 2cb9cf7] 0.2.0 pre-release prep
 1 file changed, 1 insertion(+), 1 deletion(-)
diff --git a/CHANGELOG.md b/CHANGELOG.md
index 1966619..d6b870f 100644
--- a/CHANGELOG.md
+++ b/CHANGELOG.md
@@ -4,6 +4,20 @@ All notable changes to this project will be documented in this file.
 Format of this file follows [these](http://keepachangelog.com/) guidelines.
 This project adheres to [Semantic Versioning](http://semver.org/).

+## [%RELEASE_VERSION%] - [%RELEASE_DATE%]
+
+### Added
+
+- Nothing
+
+### Changed
+
+- Nothing
+
+### Removed
+
+- Nothing
+
 ## [0.2.0] - [2017-09-15]

 ### Added
These changes to master look ok? (y/n)> y
[master eebb28a] Prep CHANGELOG.md for next release
 1 file changed, 14 insertions(+)
Counting objects: 10, done.
Compressing objects: 100% (6/6), done.
Writing objects: 100% (6/6), 635 bytes | 0 bytes/s, done.
Total 6 (delta 4), reused 0 (delta 0)
remote: Resolving deltas: 100% (4/4), completed with 2 local objects.
To git@github.com:simonsdave/dev-env.git
   067e4ed..eebb28a  master -> master
Switched to branch 'release-0.2.0'
diff --git a/README.md b/README.md
index a07a870..563256c 100644
--- a/README.md
+++ b/README.md
@@ -2,7 +2,7 @@

 ![Maintained](https://img.shields.io/maintenance/yes/2017.svg?style=flat)
 [![MIT license](http://img.shields.io/badge/license-MIT-brightgreen.svg)](http://opensource.org/licenses/MIT)
-[![Build Status](https://travis-ci.org/simonsdave/dev-env.svg?branch=master)](https://travis-ci.org/simonsdave/dev-env)
+[![Build Status](https://travis-ci.org/simonsdave/dev-env.svg?branch=release-0.2.0)](https://travis-ci.org/simonsdave/dev-env)

 To increase predicability and simplify onboarding of new
 collaborators, a common pattern for many of
These changes to release-0.2.0 look ok? (y/n)> y
[release-0.2.0 c06720f] 0.2.0 release prep
 1 file changed, 1 insertion(+), 1 deletion(-)
Counting objects: 8, done.
Compressing objects: 100% (3/3), done.
Writing objects: 100% (3/3), 302 bytes | 0 bytes/s, done.
Total 3 (delta 2), reused 0 (delta 0)
remote: Resolving deltas: 100% (2/2), completed with 2 local objects.
To git@github.com:simonsdave/dev-env.git
 * [new branch]      release-0.2.0 -> release-0.2.0
M    ubuntu/trusty/Vagrantfile
M    ubuntu/trusty/create_dev_env.sh
Switched to branch 'master'
Your branch is up-to-date with 'origin/master'.
```

* after running [prep-for-release.sh](../bin/prep-for-release.sh) follow the standard
process of [creating a github release](https://help.github.com/articles/creating-releases/)
in [this UI](https://github.com/simonsdave/dev-env/releases/new)

## What Next

* start contributing!
