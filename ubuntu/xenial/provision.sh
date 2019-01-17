#!/usr/bin/env bash
#
# this script provisions a basic ubuntu 16.04 (xenial) development environment
#
#   -- install latest OS updates
#   -- configure timezone & NTP sync
#   -- configure interactive shell prompt
#   -- install and configure git assuming git accessed via SSH
#   -- configure vi
#   -- install basic python dev env
#   -- install jq & yq
#   -- install apache2-utils
#   -- install Docker CE
#   -- install shellcheck (via docker)
#

set -e

#
# parse command line args
#
TIMEZONE=EST

while true
do
    case "${1,,}" in
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

#
# standard os updates
#
apt-get update -y

#
# assumes we're working in EST and enable NTP synchronization.
#
timedatectl set-timezone "$TIMEZONE"
apt-get install -y ntp

#
# configure interactive shell prompt to CWD 
#
su vagrant <<'EOF'
echo 'PS1="\w> "' >> ~/.profile
EOF

#
# install and configure git
#
apt-get install -y git

# https://stackoverflow.com/questions/18880024/start-ssh-agent-on-login/18915067#18915067
# led to seeing the value of using keychain to simplify starting the ssh-agent
# :FUTURE: in the future consider "apt-get install keychain"

su - vagrant -c "git config --global user.name \"${1:-}\""
su - vagrant -c "git config --global user.email \"${2:-}\""

# so we get the "right" editor on git commit 
su vagrant <<'EOF'
echo 'export VISUAL=vim' >> ~/.profile
echo 'export EDITOR="$VISUAL"' >> ~/.profile
EOF

# per https://help.github.com/articles/connecting-to-github-with-ssh/
# config ssh access to github
su - vagrant -c "echo \"${3:-}\" | base64 --decode > ~/.ssh/id_rsa_github.pub"
su - vagrant -c "echo \"${4:-}\" | base64 --decode > ~/.ssh/id_rsa_github"
su - vagrant -c "chmod u=r,og= ~/.ssh/id_rsa_github ~/.ssh/id_rsa_github.pub"

# per https://serverfault.com/questions/132970/can-i-automatically-add-a-new-host-to-known-hosts
# add github.com & associated IP addresses to known ssh hosts
# to avoid being prompted to confirm authenticity like this
#   git clone git@github.com:simonsdave/cloudfeaster-services.git
#   Cloning into 'cloudfeaster-services'...
#   The authenticity of host 'github.com (192.30.253.113)' can't be established.
#   RSA key fingerprint is 16:27:ac:a5:76:28:2d:36:63:1b:56:4d:eb:df:a6:48.
#   Are you sure you want to continue connecting (yes/no)?
su vagrant <<'EOF'
ssh-keyscan -t rsa,dsa github.com 2>&1 > ~/.ssh/known_hosts
for IP in $(getent hosts github.com | awk '{ print $1 }'); do
    ssh-keyscan -t rsa,dsa $IP 2>&1 >> ~/.ssh/known_hosts
done
EOF

#
# customize vim
#
su vagrant <<'EOF'
echo 'set ruler' > ~/.vimrc
echo 'set hlsearch' >> ~/.vimrc
echo 'filetype plugin on' >> ~/.vimrc
echo 'filetype indent on' >> ~/.vimrc
echo 'set ts=4' >> ~/.vimrc
echo 'set sw=4' >> ~/.vimrc
echo 'set expandtab' >> ~/.vimrc
echo 'set encoding=UTF8' >> ~/.vimrc
echo 'colorscheme koehler' >> ~/.vimrc
echo 'syntax on' >> ~/.vimrc

echo 'au BufNewFile,BufRead *.sh set filetype=shell' >> ~/.vimrc
echo 'autocmd Filetype shell setlocal expandtab tabstop=4 shiftwidth=4' >> ~/.vimrc

echo 'au BufNewFile,BufRead *.json set filetype=json' >> ~/.vimrc
echo 'autocmd FileType json setlocal expandtab tabstop=4 shiftwidth=4' >> ~/.vimrc

echo 'au BufNewFile,BufRead *.py set filetype=python' >> ~/.vimrc
echo 'autocmd FileType python setlocal expandtab tabstop=4 shiftwidth=4' >> ~/.vimrc

echo 'au BufNewFile,BufRead *.raml set filetype=raml' >> ~/.vimrc
echo 'autocmd FileType raml setlocal expandtab tabstop=2 shiftwidth=2' >> ~/.vimrc

echo 'au BufNewFile,BufRead *.yaml set filetype=yaml' >> ~/.vimrc
echo 'autocmd FileType yaml setlocal expandtab tabstop=2 shiftwidth=2' >> ~/.vimrc

echo 'au BufNewFile,BufRead *.js set filetype=javascript' >> ~/.vimrc
echo 'autocmd FileType javascript setlocal expandtab tabstop=2 shiftwidth=2' >> ~/.vimrc

# install pathogen
mkdir -p ~/.vim/autoload ~/.vim/bundle
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
sed -i '1s|^|execute pathogen#infect()\n|' ~/.vimrc
EOF

#
# install basic python dev env
#

# per https://www.howtodojo.com/2016/03/install-use-pip-ubuntu-14-04/
apt-get -y install python-pip

# per https://virtualenv.pypa.io/en/stable/installation/ to get latest
# version as per https://virtualenv.pypa.io/en/stable/changes/
pip install virtualenv

# from https://stackoverflow.com/questions/31002091/what-is-python-dev-package-used-for
# "python-dev contains the header files you need to build Python extensions"
# "python-dev is the package that contains the header files for the Python C API"
apt-get install -y python-dev

#
# jq is just so generally useful for parsing json docs
#
JQ_SOURCE=https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64
JQ_BIN=/usr/local/bin/jq
curl -s -L --output "$JQ_BIN" "$JQ_SOURCE"
chown root.root "$JQ_BIN"
chmod a+x "$JQ_BIN"

#
# just like jq, yq is just so generally useful for parsing yaml docs
#
pip install yq

#
# install the dev-env project directly from github as per
# https://pip.pypa.io/en/stable/reference/pip_install/#vcs-support
#
pip install git+https://github.com/simonsdave/dev-env.git@release-0.5.11

#
# install apache2-utils (mostly to get access to htpasswd)
#
apt-get install -y apache2-utils

#
# install pandoc
#
# Common scenario:
#   -- projects have a README.md
#   -- setup.py creates long description by reading README.rst
#   -- README.rst is created by pypandoc reading README.md
#
apt-get install -y pandoc

#
# Install docker CE per instructions at
#
#   -- https://docs.docker.com/install/linux/docker-ce/ubuntu/
#
apt-get update -y

apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

apt-get update -y

apt-get install -y docker-ce

usermod -aG docker vagrant
service docker restart

# wait for docker service to restart
while true
do
    if docker images >& /dev/null; then
        break
    fi
done

#
# install shell linter shellcheck
#
# installed via docker so it's easy to have same version
# in dev env as well as travis
#
docker pull koalaman/shellcheck:latest

exit 0
