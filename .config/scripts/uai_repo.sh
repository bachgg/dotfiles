#!/bin/sh

PATH=$PATH:/opt/homebrew/bin
DIR_PATH=$(ls -d $HOME/uai/workspace/*/ $HOME/workspace/*/ $HOME/dotfiles | fzf)
if [ ! -z $DIR_PATH ]; then 
  DIR_PATH=$(realpath $DIR_PATH)
  DIR_NAME=$(basename $DIR_PATH)
  if [ "${DIR_PATH#*uai}" != "$DIR_PATH" ]; then
    SESSION="uai/$DIR_NAME"
  else
    SESSION="bach/$DIR_NAME"
  fi
  (tmux has-session -t "$SESSION" &> /dev/null || tmux new-session -c $DIR_PATH -s "$SESSION" -d) && tmux switch-client -t "$SESSION"
fi

