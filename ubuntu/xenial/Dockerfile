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

#
# pandoc
#
# Common scenario:
#   -- projects have a README.md
#   -- setup.py creates long description by reading README.rst
#   -- README.rst is created by pypandoc reading README.md
#
RUN apt-get install -y pandoc

ENV DEBIAN_FRONTEND newt
