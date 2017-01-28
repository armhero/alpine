# Alpine Linux

[![](https://images.microbadger.com/badges/image/armhero/alpine.svg)](https://microbadger.com/images/armhero/alpine "Get your own image badge on microbadger.com") [![](https://images.microbadger.com/badges/version/armhero/alpine.svg)](https://microbadger.com/images/armhero/alpine "Get your own version badge on microbadger.com")

An Alpine Linux Docker base image for the ARM platform.

## Available tags

* **latest**: Latest stable image (e.g. v3.4)
* **edge**: Bleeding edge
* **3.4**: Version 3.4

## CI/Auto-Builds

The image is automatically built by Jenkins CI on a Raspberry Pi Cluster. It will be rebuilt once a week (Bleeding Edge every night).
You can find the job definitions written in Jenkins DSL in the [armhero/jenkins-dsl](https://github.com/armhero/jenkins-dsl) repository.

### Manual Building

To build the image yourself, take a look in the `build.sh` script.

## More information

You can find more information and an overview over all images on [armhero.github.io](https://armhero.github.io).
