[![Build Status](https://travis-ci.org/norrkin/sabnzbd-docker.svg?branch=master)](https://travis-ci.org/norrkin/sabnzbd-docker) [![](https://images.microbadger.com/badges/image/norrkin/sabnzbd.svg)](https://microbadger.com/images/norrkin/sabnzbd "Get your own image badge on microbadger.com")

## SABnzbd-docker

A docker container running SABnzbd built with Debian Stretch.

### Usage

Commands to build & deploy an SABnzbd container using Docker.

*Build image;*

    $ sudo docker build -t sabnzbd .

*Deploy container;*

    $ sudo docker run -tid --name sabnzbd -m 512m -v /path/on/host:/datadir -v /path/on/host:/download -p 8080:8080 -e UID=100 -e GID=100 sabnzbd

### Parameters

Below parameters needed or container will not start.  Map to your host/local user.

* `-e UID=1000`
* `-e GID=1000`

### Mount volumes

Mount the following for configuration files and downloads directory.

* `/datadir`
* `/download`