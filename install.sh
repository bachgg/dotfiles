#!/bin/sh

[[ ! -f ~/dotfiles ]] || git clone https://github.com/ntbdev/dotfiles.git ~/dotfiles

PROGRAMS=(
	bspwm
	sxhkd
	alacritty
	starship
	rofi
	nvim
	tmux
)

ln -sf ~/dotfiles/.config/* ~/.config/
