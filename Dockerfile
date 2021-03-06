# Chromium development environment based on Ubuntu 14.04 LTS.
# version 0.0.2

# Start with Ubuntu 14.04 LTS.
FROM ubuntu:trusty

MAINTAINER Brian Prodoehl <bprodoehl@connectify.me>

# Never ask for confirmations
ENV DEBIAN_FRONTEND noninteractive
RUN echo "debconf shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections
RUN echo "debconf shared/accepted-oracle-license-v1-1 seen true" | debconf-set-selections

RUN apt-get update && \
    apt-get -y install software-properties-common python-software-properties \
                       bzip2 unzip git build-essential pkg-config aptitude dpkg

# Add oracle-jdk6 to repositories
RUN add-apt-repository ppa:webupd8team/java

# Update apt
RUN apt-get update

# Install oracle-jdk6
RUN apt-get -y install oracle-java7-installer

RUN echo "deb http://archive.ubuntu.com/ubuntu/ trusty multiverse" >> /etc/apt/sources.list
RUN echo "deb-src http://archive.ubuntu.com/ubuntu/ trusty multiverse" >> /etc/apt/sources.list
RUN echo "deb http://archive.ubuntu.com/ubuntu/ trusty-updates multiverse" >> /etc/apt/sources.list
RUN echo "deb-src http://archive.ubuntu.com/ubuntu/ trusty-updates multiverse" >> /etc/apt/sources.list
RUN echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true" | debconf-set-selections

RUN dpkg --add-architecture i386 && apt-get update

RUN aptitude install -y g++-arm-linux-gnueabihf

RUN cd /usr/local/sbin && git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git .

ENV HOME /root

ADD scripts/fetch-webrtc /usr/local/sbin/fetch-webrtc
ADD scripts/fetch-chromium /usr/local/sbin/fetch-chromium

# Export JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-7-oracle
