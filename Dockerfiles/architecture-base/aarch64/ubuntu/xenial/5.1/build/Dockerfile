# wlisac/aarch64-ubuntu-swift:5.1-xenial-build

ARG BASE_IMAGE=balenalib/aarch64-ubuntu:xenial-build

# Download and decompress the tarball into an intermediate container
# to improve cache accross different base image variations

FROM balenalib/aarch64-ubuntu:xenial as downloader

LABEL Description="Swift Downloader"

ARG TARBALL_URL=https://github.com/futurejones/swift-arm64/releases/download/v5.1-RELEASE/swift-5.1-aarch64-RELEASE-Ubuntu-16.04_2019-09-24.tar.gz
ARG TARBALL_FILE=swift.tgz

WORKDIR /swift

RUN curl -L -o $TARBALL_FILE $TARBALL_URL \
    && tar -xvzf $TARBALL_FILE -C /swift \
    && rm $TARBALL_FILE

# Create base image

FROM "$BASE_IMAGE"

LABEL maintainer "Will Lisac <will@lisac.org>"
LABEL Description="Docker Container for Swift on Balena"

# Dependencies from official Swift Dockerfile for Swift 5.1 on Ubuntu 16.04
# https://github.com/apple/swift-docker/blob/fd1691a1f73b68fb8c8ef6072e716892be54a3d2/5.1/ubuntu/16.04/Dockerfile

RUN install_packages \
    libatomic1 \
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
    pkg-config

# Copy files from downloader to root
COPY --from=downloader /swift /

RUN swift --version
