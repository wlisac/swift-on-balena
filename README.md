<p align="center">
  <img src="Assets/logo.svg">
</p>

# Swift on Balena

<p>
    <img src="https://img.shields.io/badge/Swift-4 | 5-f2654a.svg" />
    <img src="https://img.shields.io/badge/architectures-ARMv6 | ARMv7 | ARMv8-lightgray.svg" />
    <a href="https://twitter.com/wlisac"><img src="https://img.shields.io/badge/twitter-@wlisac-blue.svg" /></a>
    <a href="https://launchpass.com/swift-arm"><img src="https://img.shields.io/badge/slack-swift--arm-purple.svg" /></a>
</p>

Swift Docker images for Raspberry Pi and other ARM devices from balena's base images.

<!-- ## Getting Started -->


## Latest Releases

| Device                  | Architecture | Swift | Docker Image                                     |
| ----------------------- | ------------ | ----- | ------------------------------------------------ |
| Raspberry Pi (v1 or Zero)   | armv6      | 5.0   | [`wlisac/raspberry-pi-swift:5.0`](https://hub.docker.com/r/wlisac/raspberry-pi-swift/tags)   |
| Raspberry Pi 2          | armv7hf      | 5.0   | [`wlisac/raspberry-pi2-swift:5.0`](https://hub.docker.com/r/wlisac/raspberry-pi2-swift/tags)   |
| Raspberry Pi 3          | armv7hf      | 5.0   | [`wlisac/raspberrypi3-swift:5.0`](https://hub.docker.com/r/wlisac/raspberrypi3-swift/tags)   |
| Raspberry Pi 3 (using 64 bit OS) | aarch64      | 5.0   | [`wlisac/raspberrypi3-64-swift:5.0`](https://hub.docker.com/r/wlisac/raspberrypi3-64-swift/tags) |
| Generic ARMv7-a HF          | armv7hf      | 5.0   | [`wlisac/generic-armv7ahf-swift:5.0`](https://hub.docker.com/r/wlisac/generic-armv7ahf-swift/tags)   |
| Generic AARCH64 (ARMv8) | aarch64      | 5.0   | [`wlisac/generic-aarch64-swift:5.0`](https://hub.docker.com/r/wlisac/generic-aarch64-swift/tags) |

## Image Variants

There are several image variants available depending on hardware, Linux distribution, and Swift version.

- Devices
    - Raspberry Pi (v1 or Zero)
    - Raspberry Pi 2
    - Raspberry Pi 3
    - Raspberry Pi 3 (using 64 bit OS)
    - Generic ARMv7-a HF
    - Generic AARCH64 (ARMv8)
- Linux Distributions
    - Debian: Stretch
    - Ubuntu: Bionic and Xenial
- Swift Versions
    - Swift 4
    - Swift 5

### Image Naming Scheme

The image naming scheme for Swift on Balena supports a subset of [balena's image naming scheme](https://www.balena.io/docs/reference/base-images/base-images/#how-the-image-naming-scheme-works) and follows the pattern below:

```plain
wlisac/<hardware>-<distro>-swift:<swift_version>-<distro_version>
```

#### Image Names

- `<hardware>` is either the device type or architecture and is required. See the [device list](todo) for available device names and architectures.
- `<distro>` is the Linux distribution. This is optional and will usually default to Debian, but may fall-back to Ubuntu if a Debian variant is not available.

#### Image Tags

- `<swift_version>` is the version of Swift and is required.
- `<distro_version>` is the version of the Linux distribution and is required if a distribution is specified in the image name.

#### Examples

`wlisac/raspberrypi3-swift:5.0`

- `<hardware>`: raspberrypi3 – the Raspberry Pi 3 device type
- `<distro>`: omitted – defaulted to Debian
- `<swift_version>`: 5.0 – specifies Swift version 5.0
- `<distro_version>`: omitted – defaulted to Stretch

`wlisac/raspberrypi3-ubuntu-swift:4.2.3-bionic`

- `<hardware>`: raspberrypi3 – the Raspberry Pi 3 device type
- `<distro>`: ubuntu
- `<swift_version>`: 4.2.3 – specifies Swift version 4.2.3
- `<distro_version>`: bionic – Ubuntu 18.04
