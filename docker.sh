#!/bin/sh

if [ "$1" = "build" ]; then
  docker build -t mearch:latest .
fi

docker run -it \
  -v "$PWD/install.sh:/home/me/install.sh" \
  -v "$PWD:/home/me/dotfiles" \
  mearch:latest
