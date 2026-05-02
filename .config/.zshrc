# https://www.reddit.com/r/zsh/comments/jncp79/paste_bracketing_causes_slow_pastes/
DISABLE_MAGIC_FUNCTIONS="true"

HISTFILE=~/.histfile
HISTSIZE=10000000
SAVEHIST=10000000
setopt HIST_IGNORE_ALL_DUPS
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY

autoload -Uz compinit
compinit

source $HOME/.config/shell/alias.zsh
source $HOME/.config/shell/export.zsh
