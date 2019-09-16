FROM golang:1-stretch
MAINTAINER Johan Lundberg <lundberg@sunet.se>
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN /bin/sed -i s/deb.debian.org/ftp.se.debian.org/g /etc/apt/sources.list
RUN apt-get -q update
RUN apt-get -y upgrade
RUN apt-get install -y locales git-core wget sloccount default-jdk-headless
RUN apt-get clean
RUN adduser --disabled-password --disabled-login --gecos jenkins jenkins
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
COPY run.sh /run.sh
