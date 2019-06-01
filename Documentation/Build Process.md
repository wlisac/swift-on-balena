# Build Process

The build / test / release process is currently pretty manual and not usable by potential contributors. This is an area of opportunity, to say the least. 😅

Below is an example process to add Swift 5.0.1 for aarch64 devices:

- Create new 5.0.1 folders in `Dockerfiles/architecture-base/aarch64/{osName}/{osVersion}` for each OS variant
- Add Dockerfiles (typically these are based on previous Dockerfiles or from the official swift-docker repo)
- Update Dockerfile comment (`# wlisac/aarch64-ubuntu-swift:5.0.1-xenial`) and tarball URL
- Run `swift run Run build --swiftVersion 5.0.1` to build the architecture base images
- Run `swift run Run test --swiftVersion 5.0.1` to test the architecture base images
- Run `swift run Run generate` to generate the device base image Dockerfiles
- Run `swift run Run build --swiftVersion 5.0.1` to build all of the new images
- If you want to test the new device images, you can run `swift run Run test --swiftVersion 5.0.1` again
- Once all of the images are built and tested, time to push: `swift run Run push --swiftVersion 5.0.1`
- Run `swift run Run tag-default-images --swiftVersion 5.0.1` to tag default images (images without an OS specified)
- Run `swift run Run push-default-images --swiftVersion 5.0.1` to push these default images
- Commit these Dockerfiles and update readme with latest release info

Sometimes the build or test scripts will hang. If docker appears idle, try to stop and re-run the script.
