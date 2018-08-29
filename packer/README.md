For building Websflyer Release Image, we need to start from a pre-existing Websflyer Continuous Delivery Vagrant Box. You need to create a `base_box` folder or symlink that points to the folder which contains the box.ovf and the vmdk disk image. The `init_basebox.sh` will attempt to use the `baseimage-websflyer-cd` Vagrant Box and symlink it to `base_box`. Make sure you have build and added the `baseimage-websflyer-cd` to Vagrant first.

Vagrant Boxes will be found in `build/` folder after being successfully built.

## Pre-requisites for building vagrant box
> ./init_basebox.sh

You need to copy the `local_build.env.example` file to `local_build.env` and fill in the necessary Environment Variables (except AWS Credentials)

## Pre-requisites for building AWS AMI
You need to fill in the necessary AWS Credentials in `local_build.env`

## Examples

### Building EC2 AMI + Local Vagrant Box
> source local_build.env
> packer build websflyer-release-image.json

## Building Local Vagrant Box only
> source local_build.env
> packer build -only=virtualbox-ovf websflyer-release-image.json

### Building EC2 AMI Box only
> source local_build.env
> packer build -only=amazon-ebs websflyer-release-image.json
