# wlisac/raspberrypi3-64-ubuntu-swift:5.0-bionic

FROM balenalib/raspberrypi3-64-ubuntu:bionic

LABEL maintainer "Will Lisac <will@lisac.org>"
LABEL Description="Docker Container for Swift on Raspberry Pi"

# Dependencies from official Swift Dockerfile for Swift 5.0 on Ubuntu 18.04
# https://github.com/apple/swift-docker/blob/6812f217b405a5101ea3e8fce4d1cf09e3c8727b/5.0/ubuntu/18.04/Dockerfile

RUN export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true && apt-get -q update && \
    apt-get -q install -y \
    libatomic1 \
    libbsd0 \
    libcurl4 \
    libxml2 \
    libedit2 \
    libsqlite3-0 \
    libc6-dev \
    binutils \
    libgcc-5-dev \
    libstdc++-5-dev \
    libpython2.7 \
    tzdata \
    git \
    pkg-config \
    && rm -r /var/lib/apt/lists/*

ARG TARBALL_URL=https://github.com/futurejones/swift-arm64/releases/download/v5.0-RELEASE/swift-5.0-RELEASE-aarch64-Ubuntu-18.04_2019-03-26.tar.gz
ARG TARBALL_FILE=swift.tgz

RUN curl -L -o $TARBALL_FILE $TARBALL_URL \
    && tar -xvzf $TARBALL_FILE -C / \
    && rm $TARBALL_FILE

RUN swift --version
