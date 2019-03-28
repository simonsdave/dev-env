FROM ubuntu:16.04

LABEL maintainer="Dave Simons" 

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y

#
# some of the dev env shell scripts depend on in container
# shell scripts which we'll want to access in /usr/local/bin
#
COPY in_container_sh_scripts.tar.gz /tmp/.
RUN ls -la /tmp/in_container_sh_scripts.tar.gz
RUN cd /usr/local/bin && tar xvf /tmp/in_container_sh_scripts.tar.gz

#
# python development
#
RUN apt-get install -y python
RUN apt-get install -y python-dev
RUN apt-get install -y python-pip
RUN pip install --upgrade pip

COPY requirements.txt /tmp/requirements.txt
RUN cd /tmp && pip install --requirement "/tmp/requirements.txt"

#
# pandoc
#
# Common scenario:
#   -- projects have a README.md
#   -- setup.py creates long description by reading README.rst
#   -- README.rst is created by pypandoc reading README.md
#
RUN apt-get install -y pandoc

#
# cURL
#
RUN apt-get install -y curl

#
# git
#
RUN apt-get install -y git

#
# Install docker CE per instructions at
#
#   -- https://docs.docker.com/install/linux/docker-ce/ubuntu/
#
RUN apt-get update -y

RUN apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

RUN add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

RUN apt-get update -y

RUN apt-get install -y docker-ce

#
# repo-security-scanner
#
# -- https://github.com/UKHomeOffice/repo-security-scanner
# -- git log -p | scanrepo
# -- git log -p | docker run -i --rm simonsdave/xenial-dev-env:bindle scanrepo
#
RUN cd /tmp && \
    curl -s -L -o scanrepo.tar.gz https://github.com/UKHomeOffice/repo-security-scanner/releases/download/0.4.0/scanrepo-0.4.0-linux-386.tar.gz && \
    tar xvf scanrepo.tar.gz && \
    mv scanrepo /usr/bin/scanrepo && \
    chown root.root /usr/bin/scanrepo && \
    chmod a+wrx /usr/bin/scanrepo

#
# shellcheck
# -- install instructions from https://github.com/koalaman/shellcheck/issues/704
#
RUN cd /tmp && \
    curl -s -o ./shellcheck.tar.xz https://storage.googleapis.com/shellcheck/shellcheck-latest.linux.x86_64.tar.xz && \
    tar xvf shellcheck.tar.xz && \
    cp shellcheck-latest/shellcheck /usr/local/bin/. && \
    rm -rf shellcheck-latest shellcheck.tar.xz

#
# jq is just so generally useful for parsing json docs
#
RUN curl -s -L -o "/usr/local/bin/jq" "https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64" && \
    chmod a+x "/usr/local/bin/jq"

#
# nvm with node and npm
# -- see https://stackoverflow.com/questions/25899912/install-nvm-in-docker
# -- nvm = Node Version Manager = tool that allows managemnt of multiple versions of node.js same machine
# -- npm = is a package manager for Node.js
#
RUN mkdir /root/.nvm
ENV NVM_DIR /root/.nvm
ENV NODE_VERSION 8.9.4

RUN curl -s https://raw.githubusercontent.com/creationix/nvm/v0.33.9/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

#
# markdown Lint
# -- https://github.com/igorshubovych/markdownlint-cli
#
RUN npm install -g markdownlint-cli

#
# snyk
# -- https://snyk.io/
#
RUN npm install -g snyk

ENV DEBIAN_FRONTEND newt
