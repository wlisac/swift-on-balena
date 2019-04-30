# wlisac/raspberry-pi2-ubuntu-swift:5.0-bionic

FROM balenalib/raspberry-pi2-ubuntu:bionic

LABEL maintainer "Will Lisac <will@lisac.org>"
LABEL Description="Docker Container for Swift on Raspberry Pi"

# Dependencies from official Swift Dockerfile for Swift 5.0 on Ubuntu 18.04
# https://github.com/apple/swift-docker/blob/6812f217b405a5101ea3e8fce4d1cf09e3c8727b/5.0/ubuntu/18.04/Dockerfile

# Needed to add clang
# https://github.com/uraimo/buildSwiftOnARM/blob/1be3c13d709724b48b418c6511a38c8f323378ec/README.md#dependencies

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
    clang \
    && rm -r /var/lib/apt/lists/*

ARG TARBALL_URL=https://github.com/uraimo/buildSwiftOnARM/releases/download/5.0/swift-5.0-threads_hotfix-RPi23-Ubuntu1804.tgz
ARG TARBALL_FILE=swift.tgz

RUN curl -L -o $TARBALL_FILE $TARBALL_URL \
    && tar -xvzf $TARBALL_FILE -C / \
    && rm $TARBALL_FILE

RUN swift --version
