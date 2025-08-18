#!/bin/sh

if [ $(uname) = "Darwin" ]; then PATH=${PATH}:/opt/homebrew/bin:~/.fzf/bin; fi
DIR_PATH=$(find ~/ ~/workspace ~/workspace/codesphere-monorepo ~/workspace/codesphere-monorepo/helm -maxdepth 1 -type d | fzf)
[ -z ${DIR_PATH} ] && exit
SESSION=$(echo ${DIR_PATH} | sed "s_${HOME}/__g" | sed "s/\./_/g")
(tmux has-session -t "${SESSION}" &> /dev/null || tmux new-session -d -c ${DIR_PATH} -s "${SESSION}" "nvim ${DIR_PATH}" \; new-window -t ${SESSION}: -c ${DIR_PATH}) && tmux switch-client -t "${SESSION}"

