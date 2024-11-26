# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000000
SAVEHIST=1000

source ~/.zprofile
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"
zvm_after_init_commands+=('[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh && source ~/dotfiles/.config/scripts/dir_switcher.sh')
plugins=(zsh-vi-mode)

source $ZSH/oh-my-zsh.sh

export MANPATH="/usr/local/man:$MANPATH"
export USE_GKE_GCLOUD_AUTH_PLUGIN=True
#
# # The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/jimmy/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/jimmy/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# # The next line enables shell command completion for gcloud.
if [ -f '/Users/jimmy/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/jimmy/Downloads/google-cloud-sdk/completion.zsh.inc'; fi
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"

export PATH="/Users/jimmy/.local/bin:$PATH"
source ~/.config/alias/alias
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
alias kar-server='ssh -i id_rsa_bullseye -p 32122 bach@185.228.137.28'

export PYENV_ROOT="$HOME/.pyen"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
source /Users/jimmy/.config/op/plugins.sh

