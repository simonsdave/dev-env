# Development Environment

To increase predicability, it is recommended
that ```dev-env``` development be done on a [Vagrant](http://www.vagrantup.com/) provisioned
[VirtualBox](https://www.virtualbox.org/)
VM running [Ubuntu 16.04](http://releases.ubuntu.com/16.04/).
Below are the instructions for spinning up such a VM.

Spin up a VM using [create_dev_env.sh](create_dev_env.sh)
(instead of using ```vagrant up``` - this is the only step
that standard vagrant commands aren't used - after provisioning
the VM you will use ```vagrant ssh```, ```vagrant halt```,
```vagrant up```, ```vagrant status```, etc).

```bash
> ./create_dev_env.sh simonsdave simonsdave@gmail.com ~/.ssh/id_rsa.pub ~/.ssh/id_rsa
Bringing machine 'default' up with 'virtualbox' provider...
==> default: Importing base box 'trusty'...
.
.
.
```

SSH into the VM.

```bash
> vagrant ssh
Welcome to Ubuntu 16.04.4 LTS (GNU/Linux 4.4.0-119-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  Get cloud support with Ubuntu Advantage Cloud Guest:
    http://www.ubuntu.com/business/services/cloud

90 packages can be updated.
40 updates are security updates.

New release '18.04.1 LTS' available.
Run 'do-release-upgrade' to upgrade to it.


~>
```

Start the ssh-agent in the background.

```bash
~> eval "$(ssh-agent -s)"
Agent pid 25657
~>
```

Add SSH private key for github to the ssh-agent

```bash
~> ssh-add ~/.ssh/id_rsa_github
Enter passphrase for /home/vagrant/.ssh/id_rsa_github:
Identity added: /home/vagrant/.ssh/id_rsa_github (/home/vagrant/.ssh/id_rsa_github)
~>
```

Clone the repo.

```bash
~/> git clone git@github.com:simonsdave/dev-env.git
Cloning into 'dev-env'...
remote: Counting objects: 697, done.
remote: Compressing objects: 100% (45/45), done.
remote: Total 697 (delta 22), reused 52 (delta 14), pack-reused 632
Receiving objects: 100% (697/697), 87.96 KiB | 0 bytes/s, done.
Resolving deltas: 100% (368/368), done.
Checking connectivity... done.
~>
```

Configure the dev environment

```bash
~> cd dev-env/
~/dev-env> source cfg4dev
New python executable in /home/vagrant/dev-env/env/bin/python
Installing setuptools, pip, wheel...done.
.
.
.
(env) ~/dev-env>
```

Run unit tests

```bash
(env) ~/dev-env> nosetests --with-coverage --cover-branches --cover-erase --cover-package dev_env

Name                  Stmts   Miss Branch BrPart  Cover
-------------------------------------------------------
dev_env/__init__.py       1      0      0      0   100%
----------------------------------------------------------------------
Ran 0 tests in 0.003s

OK
(env) ~/dev-env>
```
