<p align="center">
  <img src="Assets/logo.svg">
</p>

# Swift on Balena

<p>
    <img src="https://img.shields.io/badge/Swift-4 | 5-orange.svg" />
    <img src="https://img.shields.io/badge/architectures-ARMv6 | ARMv7 | ARMv8-lightgray.svg" />
    <a href="https://twitter.com/wlisac"><img src="https://img.shields.io/badge/twitter-@wlisac-blue.svg" /></a>
    <a href="https://launchpass.com/swift-arm"><img src="https://img.shields.io/badge/slack-swift--arm-purple.svg" /></a>
</p>

Welcome to **Swift on Balena** – a set of Docker images for Swift on Raspberry Pi and other ARM devices. These images are based on [balena's IoT focused Docker images](https://www.balena.io/docs/reference/base-images/base-images/) and make it easy to build and run Swift apps on ARM. 

## Getting Started

Use this [sample project](https://github.com/wlisac/balena-swift-hello-world) to get started with Swift and Docker on your Raspberry Pi.


## Latest Releases

### Device Based Images
Device based images are a great way to get started with Swift on a specific device type.

| Device                           | Architecture | Swift | Docker Image                                                                                             |
|----------------------------------|--------------|-------|----------------------------------------------------------------------------------------------------------|
| Raspberry Pi (v1 or Zero)        | armv6        | 5.1   | [`wlisac/raspberry-pi-swift:5.1-build`](https://hub.docker.com/r/wlisac/raspberry-pi-swift/tags)         |
| Raspberry Pi 2                   | armv7hf      | 5.1   | [`wlisac/raspberry-pi2-swift:5.1-build`](https://hub.docker.com/r/wlisac/raspberry-pi2-swift/tags)       |
| Raspberry Pi 3                   | armv7hf      | 5.1   | [`wlisac/raspberrypi3-swift:5.1-build`](https://hub.docker.com/r/wlisac/raspberrypi3-swift/tags)         |
| Raspberry Pi 3 (using 64 bit OS) | aarch64      | 5.5.1 | [`wlisac/raspberrypi3-64-swift:5.5.1-build`](https://hub.docker.com/r/wlisac/raspberrypi3-64-swift/tags)   |
| Raspberry Pi 4 (using 64 bit OS) | aarch64      | 5.5.1 | [`wlisac/raspberrypi4-64-swift:5.5.1-build`](https://hub.docker.com/r/wlisac/raspberrypi4-64-swift/tags)   |
| Generic ARMv7-a HF               | armv7hf      | 5.1   | [`wlisac/generic-armv7ahf-swift:5.1-build`](https://hub.docker.com/r/wlisac/generic-armv7ahf-swift/tags) |
| Generic AARCH64 (ARMv8)          | aarch64      | 5.5.1 | [`wlisac/generic-aarch64-swift:5.5.1-build`](https://hub.docker.com/r/wlisac/generic-aarch64-swift/tags)   |

### Architecture Based Images
Architecture based images are useful when building an image for multiple device types with a common architecture.

| Device                                                                                          | Architecture | Swift | Docker Image                                                                           |
|-------------------------------------------------------------------------------------------------|--------------|-------|----------------------------------------------------------------------------------------|
| Raspberry Pi (v1 or Zero)                                                                       | armv6        | 5.1   | [`wlisac/rpi-swift:5.1-build`](https://hub.docker.com/r/wlisac/rpi-swift/tags)         |
| Raspberry Pi 2<br>Raspberry Pi 3<br>Generic ARMv7-a HF                                          | armv7hf      | 5.1   | [`wlisac/armv7hf-swift:5.1-build`](https://hub.docker.com/r/wlisac/armv7hf-swift/tags) |
| Raspberry Pi 3 (using 64 bit OS)<br>Raspberry Pi 4 (using 64 bit OS)<br>Generic AARCH64 (ARMv8) | aarch64      | 5.5.1 | [`wlisac/aarch64-swift:5.5.1-build`](https://hub.docker.com/r/wlisac/aarch64-swift/tags) |

## Image Variants

There are several image variants available depending on hardware, Linux distribution, and Swift version.

- Devices
    - Raspberry Pi (v1 or Zero)
    - Raspberry Pi 2
    - Raspberry Pi 3
    - Raspberry Pi 3 (using 64 bit OS)
    - Raspberry Pi 4 (using 64 bit OS)
    - Generic ARMv7-a HF
    - Generic AARCH64 (ARMv8)
- Linux Distributions
    - Debian: Stretch
    - Ubuntu: Bionic and Xenial
- Swift Versions
    - Swift 4 (`4.2.3`)
    - Swift 5 (`5.5.1`, `5.1`, `5.0.1`, `5.0`)
- `build` and `run` image variants for [multi-stage builds](https://docs.docker.com/develop/develop-images/multistage-build/)

### Image Naming Scheme

The image naming scheme for Swift on Balena supports a subset of [balena's image naming scheme](https://www.balena.io/docs/reference/base-images/base-images/#how-the-image-naming-scheme-works) and follows the pattern below.

```plain
wlisac/<hardware>-<distro>-swift:<swift_version>-<distro_version>-(build|run)
```

#### Image Names

- `<hardware>` is either the device type or architecture and is required. See the [device list](Documentation/Device%20List.md) for available device names and architecture names.
- `<distro>` is the Linux distribution. This is optional and will usually default to Debian, but may fall-back to Ubuntu if a Debian variant is not available.

#### Image Tags

- `<swift_version>` is the version of Swift and is required.
- `<distro_version>` is the version of the Linux distribution and is required if a distribution is specified in the image name.
- `(build|run)` specifies either the `build` or `run` image variant and is required. The `build` variant includes the Swift compiler, Swift Package Manager, and other tools needed to build and run a Swift app from source. The `run` variant is much lighter-weight, does not include the Swift compiler, and is designed to run an already built Swift app. The `build` and `run` image variants can be used together in a [multi-stage Dockerfile](https://github.com/wlisac/balena-swift-hello-world/blob/b439fddbbda93019ed8747d249efc9fc8bb4c4c7/Dockerfile.raspberrypi3) to produce a smaller image that's ready for deployment.

#### Examples

`wlisac/raspberrypi3-swift:5.1-build`

- `<hardware>`: raspberrypi3 – the Raspberry Pi 3 device type
- `<distro>`: omitted – defaulted to Debian
- `<swift_version>`: 5.1 – specifies Swift version 5.1
- `<distro_version>`: omitted – defaulted to Stretch
- `(build|run)`: build – specifies the `build` variant for building a Swift app from source

`wlisac/raspberrypi3-ubuntu-swift:4.2.3-bionic-run`

- `<hardware>`: raspberrypi3 – the Raspberry Pi 3 device type
- `<distro>`: ubuntu
- `<swift_version>`: 4.2.3 – specifies Swift version 4.2.3
- `<distro_version>`: bionic – Ubuntu 18.04
- `(build|run)`: run – specifies the `run` variant for running an already built Swift app

`wlisac/armv7hf-swift:5.1-build`

- `<hardware>`: armv7hf – the armv7hf architecture type
- `<distro>`: omitted – defaulted to Debian
- `<swift_version>`: 5.1 – specifies Swift version 5.1
- `<distro_version>`: omitted – defaulted to Stretch
- `(build|run)`: build – specifies the `build` variant for building a Swift app from source

## Acknowledgments

Swift on Balena is possible because of the amazing work done by the Swift on ARM community and the projects below.

- [uraimo/buildSwiftOnARM](https://github.com/uraimo/buildSwiftOnARM)
- [futurejones/swift-arm64](https://github.com/futurejones/swift-arm64)
- [helje5/dockSwiftOnARM](https://github.com/helje5/dockSwiftOnARM)

Join the community in the [swift-arm](https://launchpass.com/swift-arm) Slack channel.