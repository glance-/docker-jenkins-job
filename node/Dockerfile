FROM node:8
MAINTAINER Johan Lundberg <lundberg@sunet.se>
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN /bin/sed -i s/deb.debian.org/ftp.se.debian.org/g /etc/apt/sources.list
RUN apt-get -q update
RUN apt-get -y upgrade
RUN apt-get install -y locales git-core wget sloccount
# Dependencies for headless chrome
RUN apt-get install -y \
    libpangocairo-1.0-0 \
    libx11-xcb1 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxi6 \
    libxtst6 \
    libnss3 \
    libcups2 \
    libxss1 \
    libxrandr2 \
    libgconf2-4\
    libasound2 \
    libatk1.0-0 \
    libgtk-3-0
RUN apt-get clean
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
