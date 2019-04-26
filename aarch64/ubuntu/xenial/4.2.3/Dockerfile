# wlisac/aarch64-ubuntu-swift:4.2.3-xenial

FROM balenalib/aarch64-ubuntu:xenial

LABEL maintainer "Will Lisac <will@lisac.org>"
LABEL Description="Docker Container for Swift on Raspberry Pi"

# Dependencies from official Swift Dockerfile for Swift 4.2 on Ubuntu 16.04
# https://github.com/apple/swift-docker/blob/6812f217b405a5101ea3e8fce4d1cf09e3c8727b/4.2/ubuntu/16.04/Dockerfile

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
    libcurl4-openssl-dev \
    pkg-config \
    && update-alternatives --quiet --install /usr/bin/clang clang /usr/bin/clang-3.8 100 \
    && update-alternatives --quiet --install /usr/bin/clang++ clang++ /usr/bin/clang++-3.8 100 \
    && rm -r /var/lib/apt/lists/*    

ARG TARBALL_URL=https://github.com/futurejones/swift-arm64/releases/download/v4.2.3-RELEASE/swift-4.2.3-RELEASE-aarch64-Ubuntu-16.04_2019-03-03.tar.gz
ARG TARBALL_FILE=swift.tgz

RUN curl -L -o $TARBALL_FILE $TARBALL_URL \
    && tar -xvzf $TARBALL_FILE -C / \
    && rm $TARBALL_FILE

RUN swift --version
