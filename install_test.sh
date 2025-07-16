#!/bin/sh

time docker run -it --platform linux/amd64 -v $PWD/install.sh:/root/install.sh archlinux /bin/sh -- /root/install.sh
