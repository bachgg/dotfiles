#!/bin/sh
# Changes the wallpaper to a randomly chosen image in a given directory
# at a set interval.

directory=${1:-~/.config/wallpapers/}
interval=${2:-3}

resize="crop" # no, crop, fit, stretch

export SWWW_TRANSITION_FPS="${SWWW_TRANSITION_FPS:-60}"
export SWWW_TRANSITION_STEP="${SWWW_TRANSITION_STEP:-2}"

while true; do
	find "${directory}" -type f \
	| while read -r img; do
		echo "$(</dev/urandom tr -dc a-zA-Z0-9 | head -c 8):${img}"
	done \
	| sort -n | cut -d':' -f2- \
	| while read -r img; do
		swww img --resize="${resize}" "${img}"
		sleep ${interval}
	done
done
