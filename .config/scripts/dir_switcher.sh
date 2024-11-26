switch() {
  tmux split-window -Z $HOME/dotfiles/.config/scripts/uai_repo.sh
}
zle     -N            switch
bindkey -M emacs '^U' switch
bindkey -M vicmd '^U' switch
bindkey -M viins '^U' switch
