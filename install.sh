#!/bin/sh

mkdir -p ~/workspace
git clone git@github.com:ntbdev/dotfiles.git ~/workspace
ln -s ~/workspace/dotfiles/.config ~/testconfig/.config