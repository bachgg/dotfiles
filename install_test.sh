#!/bin/sh

docker run -it --platform linux/amd64 -v $PWD/install.sh:/root/install.sh archlinux
