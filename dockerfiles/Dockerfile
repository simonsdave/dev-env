FROM ubuntu:20.04

LABEL maintainer="Dave Simons" 

ENV DEBIAN_FRONTEND noninteractive

#
# some of the dev env shell scripts depend on in container
# shell scripts which we'll want to access in /usr/local/bin
#
ADD scripts.tar.gz /usr/local/bin

#
#
#
RUN apt-get update -y

#
# https://gnupg.org/
#
RUN apt-get install -y gnupg

#
# python 3 development
# -- inspired by https://websiteforstudents.com/installing-the-latest-python-3-7-on-ubuntu-16-04-18-04/
# -- python versions @ https://www.python.org/downloads/
# -- pip3 inspired by https://linuxize.com/post/how-to-install-pip-on-ubuntu-18.04/
#
# python versions @ https://www.python.org/doc/versions/
#
ENV PYTHON_VERSION 3.9
RUN apt-get install -y tzdata
RUN apt-get install -y software-properties-common
RUN add-apt-repository -y ppa:deadsnakes/ppa
RUN apt-get update -y
RUN apt-get install -y python$PYTHON_VERSION
RUN apt-get install -y python3-dev
RUN apt-get install -y python3-pip
RUN python$PYTHON_VERSION -m pip install --upgrade pip

#
# install core python packages
#
COPY requirements.txt /tmp/requirements.txt
RUN python$PYTHON_VERSION -m pip install --requirement /tmp/requirements.txt
RUN rm -r /tmp/requirements.txt

#
# cURL
#
RUN apt-get install -y curl

#
# git
#
RUN apt-get install -y git

#
# pandoc
#
# Common scenario:
#   -- projects have a README.md
#   -- setup.py creates long description by reading README.rst
#   -- README.rst is created by pypandoc reading README.md
#
# :TRICKY: "apt-get install -y pandoc" installed a very old
# version (1.19.2.4) of pandoc so using the massive mess below
#
RUN PDVERSION=2.16.2; cd /tmp; curl -s -L -o pandoc.tar.gz https://github.com/jgm/pandoc/releases/download/${PDVERSION}/pandoc-${PDVERSION}-linux-amd64.tar.gz; tar xvf pandoc.tar.gz; mv ./pandoc-$PDVERSION/bin/pandoc /usr/bin/.; rm -rf ./pandoc-$PDVERSION

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
# Codecov per https://docs.codecov.com/docs/codecov-uploader
#
ENV CODECOV_UPLOADER /usr/local/bin/codecov
RUN curl -s -o $CODECOV_UPLOADER https://uploader.codecov.io/latest/linux/codecov
RUN chmod a+x $CODECOV_UPLOADER

#
# repo-security-scanner
#
# -- https://github.com/UKHomeOffice/repo-security-scanner
# -- git log -p | scanrepo
# -- git log -p | docker run -i --rm simonsdave/bionic-dev-env:bindle scanrepo
#
RUN cd /tmp && \
    curl -s -L -o scanrepo.tar.gz https://github.com/UKHomeOffice/repo-security-scanner/releases/download/0.4.0/scanrepo-0.4.0-linux-386.tar.gz && \
    tar xvf scanrepo.tar.gz && \
    rm scanrepo.tar.gz && \
    mv scanrepo /usr/bin/scanrepo && \
    chown root.root /usr/bin/scanrepo && \
    chmod a+wrx /usr/bin/scanrepo

#
# shellcheck
# -- install instructions from https://github.com/koalaman/shellcheck/issues/1871
#
RUN cd /tmp && \
    curl -L -s -o ./shellcheck.tar.xz https://github.com/koalaman/shellcheck/releases/download/stable/shellcheck-stable.linux.x86_64.tar.xz && \
    tar xvf shellcheck.tar.xz && \
    cp shellcheck-stable/shellcheck /usr/local/bin/. && \
    rm -rf shellcheck-stable shellcheck.tar.xz

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
ENV NVM_VERSION v0.39.1

RUN curl -s https://raw.githubusercontent.com/creationix/nvm/$NVM_VERSION/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

#
# Ruby
# -- https://www.ruby-lang.org/en/
#
RUN apt install -y ruby-full

#
# markdown lint
# -- https://github.com/markdownlint/markdownlint
# -- don't like the chef-utils version hard coding (actually don't even like
# having to list it here) however it's the recommended solution to addressing
# the error below - really should have solved the problem by installing a
# later version of ruby but the process of getting rvm installed was just
# too painful.
#
#   ERROR:  Error installing mdl:
#   	The last version of chef-utils (>= 0) to support your Ruby & RubyGems was 16.6.14. Try installing it with `gem install chef-utils -v 16.6.14` and then running the current command again
#   	chef-utils requires Ruby version >= 2.6.0. The current ruby version is 2.5.0.
#
RUN gem install chef-utils -v 16.6.14
RUN gem install mdl

#
# Jekyll and Bundler
# -- https://jekyllrb.com/
# -- https://jekyllrb.com/tutorials/using-jekyll-with-bundler
#
RUN gem install jekyll bundler

#
# :TRICKY: the for loop complexity here is to deal with the
# reality that all too often this install seems to fail.
#
# CircleCI CLI
# -- https://circleci.com/docs/2.0/local-cli/
# -- the circleci update was added after noticing the
#    install process didn't always install the latest
#    rev of the CLI
#
RUN for attempt in {1..10}; do curl -fLSs --http1.1 https://circle.ci/cli | bash && if command -v circleci > /dev/null; then break; else echo $attempt && sleep 10; fi; done
RUN circleci update install

#
# if you look @ most of the host scripts in dev-env
# you'll notice that many of them mount /app in the
# dev-env container to the project's root directory.
#
# under the assumption that the projects's executables
# in in the bin subdirectory we'll add /app/bin to
# the dev-env docker image's path.
# 
# same kind of logic about re /app/bin applies to
# python projects and PYTHONPATH.
#
ENV PATH "/app/bin:${PATH}"
ENV PYTHONPATH /app
WORKDIR /app

ENV DEBIAN_FRONTEND newt
