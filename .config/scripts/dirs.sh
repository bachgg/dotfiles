#!/bin/sh

if [ $(uname) = "Darwin" ]; then PATH=${PATH}:/opt/homebrew/bin:~/.fzf/bin; fi
[ -d ~/workspace ] || mkdir -p ~/workspace/z
[ -d ~/uai/workspace ] || mkdir -p ~/uai/workspace/z
DIR_PATH=$(find ~/ ~/workspace ~/uai/workspace -maxdepth 1 -type d | fzf)
[ -z ${DIR_PATH} ] && exit
SESSION=$(echo ${DIR_PATH} | sed -e "s_${HOME}/__g")
(tmux has-session -t "${SESSION}" &> /dev/null || tmux new-session -d -c ${DIR_PATH} -s "${SESSION}" "nvim ${DIR_PATH}" \; new-window -t ${SESSION}: -c ${DIR_PATH}) && tmux switch-client -t "${SESSION}"

