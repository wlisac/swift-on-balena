# wlisac/raspberry-pi-debian-swift:4.2.3-stretch

FROM balenalib/raspberry-pi-debian:stretch

LABEL maintainer "Will Lisac <will@lisac.org>"
LABEL Description="Docker Container for Swift on Raspberry Pi"

# Dependencies from official Swift Dockerfile for Swift 4.2 on Ubuntu 16.04
# https://github.com/apple/swift-docker/blob/6812f217b405a5101ea3e8fce4d1cf09e3c8727b/4.2/ubuntu/16.04/Dockerfile

# Needed to replace libcurl4-openssl-dev with libcurl4-nss-dev
# https://github.com/uraimo/buildSwiftOnARM/tree/fc3ac47b2ce60b0098f44c7961f8295231698c99#dependencies

RUN apt-get -q update && \
    apt-get -q install -y \
    make \
    libc6-dev \
    clang-3.8 \
    curl \
    libedit-dev \
    libpython2.7 \
    libicu-dev \
    libssl-dev \
    libxml2 \
    tzdata \
    git \
    libcurl4-nss-dev \
    pkg-config \
    && update-alternatives --quiet --install /usr/bin/clang clang /usr/bin/clang-3.8 100 \
    && update-alternatives --quiet --install /usr/bin/clang++ clang++ /usr/bin/clang++-3.8 100 \
    && rm -r /var/lib/apt/lists/*    

ARG TARBALL_URL=https://github.com/uraimo/buildSwiftOnARM/releases/download/4.2.3/swift-4.2.3-RPi01-RaspbianStretch.tgz
ARG TARBALL_FILE=swift.tgz

RUN curl -L -o $TARBALL_FILE $TARBALL_URL \
    && tar -xvzf $TARBALL_FILE -C / \
    && rm $TARBALL_FILE

RUN swift --version
