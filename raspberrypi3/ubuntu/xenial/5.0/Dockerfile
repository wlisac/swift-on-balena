# wlisac/raspberrypi3-ubuntu-swift:5.0-xenial

FROM balenalib/raspberrypi3-ubuntu:xenial

LABEL maintainer "Will Lisac <will@lisac.org>"
LABEL Description="Docker Container for Swift on Raspberry Pi"

# Dependencies from official Swift Dockerfile for Swift 5.0 on Ubuntu 16.04
# https://github.com/apple/swift-docker/blob/6812f217b405a5101ea3e8fce4d1cf09e3c8727b/5.0/ubuntu/16.04/Dockerfile

# Needed to add clang (not clang-3.8)
# https://github.com/uraimo/buildSwiftOnARM/blob/1be3c13d709724b48b418c6511a38c8f323378ec/README.md#dependencies

RUN apt-get -q update && \
    apt-get -q install -y \
    libatomic1 \
    libbsd0 \
    libcurl3 \
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

ARG TARBALL_URL=https://github.com/uraimo/buildSwiftOnARM/releases/download/5.0/swift-5.0-threads_hotfix-RPi23-Ubuntu1604.tgz
ARG TARBALL_FILE=swift.tgz

RUN curl -L -o $TARBALL_FILE $TARBALL_URL \
    && tar -xvzf $TARBALL_FILE -C / \
    && rm $TARBALL_FILE

RUN swift --version
