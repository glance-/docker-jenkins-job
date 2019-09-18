FROM ubuntu:18.04
MAINTAINER Leif Johansson <leifj@mnt.se>
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN /bin/sed -i s/archive.ubuntu.com/se.archive.ubuntu.com/g /etc/apt/sources.list
RUN apt-get -q update
RUN apt-get install -y software-properties-common
RUN apt-get -y upgrade
RUN apt-get install -y cmake locales python2.7 python3 python3.7 git-core swig libyaml-dev libyaml-dev python-dev python3-dev python3.7-dev build-essential xsltproc libxml2-dev libxslt-dev libz-dev libssl-dev python-virtualenv python3-venv python3.7-venv wget automake libtool autoconf pkgconf sloccount xmlsec1 default-jdk-headless libssl-dev libseccomp-dev libpcsclite-dev
RUN apt-get clean
RUN adduser --disabled-password --disabled-login --gecos jenkins jenkins
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
COPY builders /opt/builders
COPY run.sh /run.sh
