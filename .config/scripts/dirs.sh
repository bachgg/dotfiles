#!/bin/sh

if [ $(uname) = "Darwin" ]; then PATH=${PATH}:/opt/homebrew/bin:~/.fzf/bin; fi
DIR_PATH=$(find \
  ~/dotfiles \
  ~/workspace \
  -maxdepth 3 -type d | fzf)
[ -z ${DIR_PATH} ] && exit
SESSION=$(echo ${DIR_PATH} | sed "s_${HOME}/__g" | sed "s/\./_/g")

# target-session needs to be prefixed with an equal sign to get matched exactly https://man7.org/linux/man-pages/man1/tmux.1.html#COMMANDS
(tmux has-session -t "=${SESSION}" &> /dev/null || tmux new-session -d -c ${DIR_PATH} -s "${SESSION}" "nvim ${DIR_PATH}" \; new-window -t ${SESSION}: -c ${DIR_PATH}) && tmux switch-client -t "${SESSION}"

