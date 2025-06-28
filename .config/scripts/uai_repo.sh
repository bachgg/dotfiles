#!/bin/sh

PATH=$PATH:/opt/homebrew/bin:~/.fzf/bin
[ -d ~/workspace ] || mkdir ~/workspace
[ -d ~/uai/workspace ] || mkdir -p ~/uai/workspace
DIR_PATH=$(ls -d $HOME/uai/workspace/*/ $HOME/workspace/*/ $HOME/dotfiles | fzf)
[ -z $DIR_PATH ] && exit
DIR_PATH=$(realpath $DIR_PATH)
DIR_NAME=$(basename $DIR_PATH)
if [ "${DIR_PATH#*uai}" != "$DIR_PATH" ]; then
  SESSION="uai/$DIR_NAME"
else
  SESSION="bach/$DIR_NAME"
fi
(tmux has-session -t "$SESSION" &> /dev/null || tmux new-session -d -c $DIR_PATH -s "$SESSION" "nvim $DIR_PATH" \; new-window -t $SESSION: -c $DIR_PATH) && tmux switch-client -t "$SESSION"

