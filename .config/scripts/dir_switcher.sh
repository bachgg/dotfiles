#!/bin/sh

uai_repo() {
  DIR_PATH=$(realpath $(ls -d $HOME/uai/workspace/*/ | fzf --tmux))
  DIR_NAME=$(basename $DIR_PATH)
  (tmux has-session -t $DIR_NAME &> /dev/null || tmux new-session -c $DIR_PATH -s $DIR_NAME -d) && tmux switch-client -t $DIR_NAME
}
zle     -N            uai_repo
bindkey -M emacs '^U' uai_repo
bindkey -M vicmd '^U' uai_repo
bindkey -M viins '^U' uai_repo
