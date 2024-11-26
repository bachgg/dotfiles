#!/bin/sh

PATH=$PATH:/opt/homebrew/bin
DIR_PATH=$(ls -d $HOME/uai/workspace/*/ | fzf)
if [ ! -z $DIR_PATH ]; then 
  DIR_PATH=$(realpath $DIR_PATH)
  DIR_NAME=$(basename $DIR_PATH)
  (tmux has-session -t $DIR_NAME &> /dev/null || tmux new-session -c $DIR_PATH -s $DIR_NAME -d) && tmux switch-client -t $DIR_NAME
fi

