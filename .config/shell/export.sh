export EDITOR="$(which nvim)"
export VISUAL="$EDITOR"

if which starship 2>&1 1>&/dev/null; then
  export STARSHIP_CONFIG=~/.config/starship/starship.toml
  eval "$(starship init zsh)"
fi

export XDG_CONFIG_HOME="$HOME/.config"
export MANPAGER="sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat -p -lman'"

if which op 2>&1 1>&/dev/null && [ -e ~/.config/op/plugins.sh ]; then
   source ~/.config/op/plugins.sh
fi

# https://github.com/jeffreytse/zsh-vi-mode#execute-extra-commands
zvm_after_init_commands+=('source <(fzf --zsh)')
