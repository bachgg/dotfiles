#!/bin/sh

autorandr --change

# case "${SRANDRD_OUTPUT} ${SRANDRD_EVENT}" in
#   "DP-1-0 connected") xrandr --output DP-1-0 --auto --above eDP1; echo 'DP-1-0';;
#   "DP-1-1 connected") xrandr --output DP-1-1 --auto --above eDP1; echo 'DP-1-1';;
#   "HDMI-1-0 connected") xrandr --output HDMI-1-0 --auto --above eDP1; echo 'HDMI';;
# esac
