FROM ubuntu:18.04

LABEL maintainer="Dave Simons" 

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y

#
# some of the dev env shell scripts depend on in container
# shell scripts which we'll want to access in /usr/local/bin
#
ADD scripts.tar.gz /usr/local/bin

#
# python 3 development
# -- inspired by https://websiteforstudents.com/installing-the-latest-python-3-7-on-ubuntu-16-04-18-04/
# -- python versions @ https://www.python.org/downloads/
# -- pip3 inspired by https://linuxize.com/post/how-to-install-pip-on-ubuntu-18.04/
#
RUN apt-get install -y software-properties-common
RUN add-apt-repository -y ppa:deadsnakes/ppa
RUN apt-get update -y
RUN apt-get install -y python3.7
RUN apt-get install -y python3-dev
RUN apt-get install -y python3-pip

#
# install core python packages
#
COPY requirements.txt /tmp/requirements.txt
RUN python3.7 -m pip install --requirement /tmp/requirements.txt
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
RUN PDVERSION=2.9.1.1; cd /tmp; curl -s -L -o pandoc.tar.gz https://github.com/jgm/pandoc/releases/download/${PDVERSION}/pandoc-${PDVERSION}-linux-amd64.tar.gz; tar xvf pandoc.tar.gz; mv ./pandoc-$PDVERSION/bin/pandoc /usr/bin/.; rm -rf ./pandoc-$PDVERSION

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
    curl -L -s -o ./shellcheck.tar.xz https://github.com/koalaman/shellcheck/releases/download/stable/shellcheck-stable.linux.x86_64.tar.xz
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

RUN curl -s https://raw.githubusercontent.com/creationix/nvm/v0.33.9/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

#
# markdown lint
# -- https://github.com/markdownlint/markdownlint
#
RUN apt install -y ruby-full
RUN gem install mdl

#
# Bandit
#   -- https://github.com/PyCQA/bandit
#   -- bandit --verbose --exclude env -r .
#
RUN python3.7 -m pip install bandit

#
# yamllint
# -- https://yamllint.readthedocs.io/en/stable/quickstart.html#installing-yamllint
# -- start with python3-pkg-resources install as per https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=860075 
#
RUN python3.7 -m pip install yamllint

#
# :TRICKY: the for loop complexity here is to deal with the
# reality that all too often this install seems to fail.
#
# CircleCI CLI
# -- https://circleci.com/docs/2.0/local-cli/
#
RUN for attempt in {1..10}; do curl -fLSs --http1.1 https://circle.ci/cli | bash && if command -v circleci > /dev/null; then break; else echo $attempt && sleep 10; fi; done

#
# AWS CLI
# -- https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-welcome.html
# -- https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html#install-tool-pip
# -- per https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html
#
# set the following in the CircleCI context
#
#   AWS_ACCESS_KEY_ID
#   AWS_SECRET_ACCESS_KEY
#   AWS_DEFAULT_REGION
#   AWS_DEFAULT_OUTPUT=text
#
RUN python3.7 -m pip install awscli

#
# AWS SAM CLI
# -- https://aws.amazon.com/serverless/sam/
#
RUN python3.7 -m pip install aws-sam-cli

#
# truffleHog
# -- https://github.com/dxa4481/truffleHog
#
RUN python3.7 -m pip install truffleHog

#
# codecov
# -- https://codecov.io
# -- https://pypi.org/project/codecov/
#
RUN python3.7 -m pip install codecov

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
