FROM ubuntu:16.04

MAINTAINER Dave Simons

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y

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
    curl -L -o scanrepo.tar.gz https://github.com/UKHomeOffice/repo-security-scanner/releases/download/0.4.0/scanrepo-0.4.0-linux-386.tar.gz && \
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
# Markdown Proofer
# -- https://github.com/felicianotech/md-proofer
# -- https://circleci.com/blog/markdown-proofer/
# -- md-proofer lint <files>
#
RUN cd /tmp && \
    curl -s -o md-proofer.tar.gz -L https://github.com/felicianotech/md-proofer/releases/download/v0.1.0/md-proofer-v0.1.0-linux-amd64.tar.gz && \
    tar xvf md-proofer.tar.gz && \
    cp md-proofer /usr/local/bin/. && \
    rm -rf md-proofer md-proofer.tar.gz

ENV DEBIAN_FRONTEND newt
