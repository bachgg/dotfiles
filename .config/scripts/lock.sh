#!/bin/sh
set -e
grim -l0 - | ffmpeg -y -i - -vf "scale=720:-1,gblur=5:steps=2" -c:a copy /tmp/screensaver.png
swaylock --color=000000 --indicator-radius=100 --image /tmp/screensaver.png
