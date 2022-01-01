#!/bin/sh

mkdir -p ~/utility
[[ ! -f ~/utility/dotfiles ]] || git clone https://github.com/ntbdev/dotfiles.git ~/utility

PROGRAMS=(
	bspwm
	sxhkd
	alacritty
	starship
	nvim
	tmux
)

for p in ${PROGRAMS[@]}; do
	echo $p
done
