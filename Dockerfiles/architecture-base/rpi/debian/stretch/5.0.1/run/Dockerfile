# wlisac/rpi-debian-swift:5.0.1-stretch-run

ARG BASE_IMAGE=balenalib/rpi-debian:stretch

# Download and decompress the tarball into an intermediate container
# to improve cache accross different base image variations

FROM balenalib/rpi-debian:stretch as downloader

LABEL Description="Swift Downloader"

ARG TARBALL_URL=https://github.com/uraimo/buildSwiftOnARM/releases/download/5.0.1/swift-5.0.1-RPi0123-RaspbianStretch.tgz
ARG TARBALL_FILE=swift.tgz

WORKDIR /swift

RUN curl -L -o $TARBALL_FILE $TARBALL_URL \
    && tar -xvzf $TARBALL_FILE -C /swift \
    && rm $TARBALL_FILE

# Create base image

FROM $BASE_IMAGE-run

LABEL maintainer "Will Lisac <will@lisac.org>"
LABEL Description="Docker Container for Swift on Balena"

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
