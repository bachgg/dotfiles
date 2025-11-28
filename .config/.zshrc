# https://scottspence.com/posts/speeding-up-my-zsh-shell#fixing-the-completion-system-3076--10
# zmodload zsh/zprof

# https://www.reddit.com/r/zsh/comments/jncp79/paste_bracketing_causes_slow_pastes/
DISABLE_MAGIC_FUNCTIONS="true"

HISTFILE=~/.histfile
HISTSIZE=10000000
SAVEHIST=1000
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=()
source $ZSH/oh-my-zsh.sh
source $HOME/.config/shell/alias.zsh
source $HOME/.config/shell/export.zsh

# zprof
