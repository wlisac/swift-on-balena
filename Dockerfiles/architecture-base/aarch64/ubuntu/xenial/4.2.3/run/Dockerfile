# wlisac/aarch64-ubuntu-swift:4.2.3-xenial-run

ARG BASE_IMAGE=balenalib/aarch64-ubuntu:xenial-run

# Download and decompress the tarball into an intermediate container
# to improve cache accross different base image variations

FROM balenalib/aarch64-ubuntu:xenial as downloader

LABEL Description="Swift Downloader"

ARG TARBALL_URL=https://github.com/futurejones/swift-arm64/releases/download/v4.2.3-RELEASE/swift-4.2.3-RELEASE-aarch64-Ubuntu-16.04_2019-03-03.tar.gz
ARG TARBALL_FILE=swift.tgz

WORKDIR /swift

RUN curl -L -o $TARBALL_FILE $TARBALL_URL \
    && tar -xvzf $TARBALL_FILE -C /swift \
    && rm $TARBALL_FILE

# Create base image

FROM "$BASE_IMAGE"

LABEL maintainer "Will Lisac <will@lisac.org>"
LABEL Description="Docker Container for Swift on Balena"

# There isn't an official Swift 4 slim Dockerfile to see dependencies
# Dependencies from official Swift Dockerfile for Swift 5.0 on Ubuntu 16.04
# https://github.com/apple/swift-docker/blob/bdd1aba3f1bc66139e1daff609a4037a7fa8cd8a/5.0/ubuntu/16.04/slim/Dockerfile

RUN install_packages \
    libatomic1 \
    libbsd0 \
    libcurl3 \
    libxml2 \
    tzdata

# Copy files from downloader to root
COPY --from=downloader /swift/usr/lib/swift/linux /usr/lib/swift/linux
