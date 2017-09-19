#!/usr/bin/env bash
#
# this script provisions a basic ubuntu 14.04 development environment
#
#   -- install latest OS updates
#   -- configure timezone & NTP sync
#   -- configure interactive shell prompt
#   -- install and configure git assuming git accessed via SSH
#   -- configure vi
#   -- install jq & yq
#   -- install nginx, apache2-utils
#   -- install nodejs, npm, raml2md & raml2html
#   -- install docker
#   -- install shellcheck (via docker)
#

set -e

apt-get update -y

#
# assumes we're working in EST and enable NTP synchronization.
# :TODO: there should be some way to configure which timezone is used
#
timedatectl set-timezone EST
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
# install and configure nginx which is often used for
# serving the output of raml2html
#
apt-get install -y nginx
API_HTML_NGINX_SITE=/etc/nginx/sites-available/default
API_HTML_PORT=$(grep forwarded_port < /vagrant/Vagrantfile | sed -e 's|.*host:\s*||g' | sed -e 's|\s*||g')
API_HTML_DIR=/usr/share/nginx/raml2html/html
rm "$API_HTML_NGINX_SITE"
{
    echo "server {"
    echo "    listen $API_HTML_PORT;"
    echo "    root $API_HTML_DIR;"
    echo "    index index.html;"
    echo "}"
} >> "$API_HTML_NGINX_SITE"
mkdir -p "$API_HTML_DIR"
chown root:root "$API_HTML_DIR"
service nginx restart

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
# assuming RAML is used to document APIs ...
#
# this install process does not feel right
# look @ .travis.yml for how it uses nvm - that feels correct
# could not get nvm to work here :-(
#
apt-get install -y nodejs
apt-get install -y npm
ln -s /usr/bin/nodejs /usr/bin/node
chmod a+x /usr/bin/nodejs
curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
apt-get install -y nodejs
npm i -g raml2md
npm i -g raml2html

#
# install docker
#
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" | tee /etc/apt/sources.list.d/docker.list
apt-get update
apt-get install -y docker-engine

echo 'waiting for docker0 network to start '
while ! ifconfig | grep docker0 >& /dev/null
do
   echo '.'
   sleep 1
done
echo 'docker0 network started'
sed -i -e 's|#DOCKER_OPTS="--dns 8.8.8.8 --dns 8.8.4.4"|DOCKER_OPTS="-H tcp://172.17.0.1:2375 -H unix:///var/run/docker.sock"|g' /etc/default/docker

usermod -aG docker vagrant
service docker restart

#
# install shell linter shellcheck
#
# installed via docker so it's easy to have same version
# in dev env as well as travis
#
docker pull koalaman/shellcheck:latest

exit 0
