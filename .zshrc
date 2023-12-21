# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000000
SAVEHIST=1000
bindkey -v
bindkey "^R" history-incremental-search-backward

# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/bach/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

source ~/.config/alias/alias
