EDITOR="$(which nvim)" && export "EDITOR"
export VISUAL="$EDITOR"
export ZVM_VI_EDITOR="$EDITOR"

if which starship 2>&1 1>&/dev/null; then
  export STARSHIP_CONFIG=~/.config/starship/starship.toml
  eval "$(starship init zsh)"
fi

export XDG_CONFIG_HOME="$HOME/.config"
export MANPAGER="sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat -p -lman'"

if which op 2>&1 1>&/dev/null && [ -e ~/.config/op/plugins.sh ]; then
  source "$HOME/.config/op/plugins.sh"
fi

# https://github.com/jeffreytse/zsh-vi-mode#execute-extra-commands
zvm_after_init_commands+=('source <(fzf --zsh)')
eval "$(op completion zsh)"
compdef _op op

# https://github.com/ohmyzsh/ohmyzsh/discussions/9849
# git_prompt_info() {}
PROMPT="%y %{${fg_bold[red]}%}:: %{${fg[green]}%}%3~%(0?. . %{${fg[red]}%}%? )%{${fg[blue]}%}»%{${reset_color}%} "

# gardenctl session
[ -n "$GCTL_SESSION_ID" ] || [ -n "$TERM_SESSION_ID" ] || export GCTL_SESSION_ID=$(uuidgen)

# [ -e ~/.kube ] || mkdir ~/.kube
# [ -e ~/.garden/gardenctl-v2.yaml ] || ([ -e ~/.kube/kubeconfig-garden-codesphere.yaml ] && gardenctl config set-garden codesphere --kubeconfig ~/.kube/kubeconfig-garden-codesphere.yaml)
# KUBECONFIG=$(ls -1 ~/.kube/kubeconfig-garden* | tr '\n' ':') kubectl config view --merge --flatten > ~/.kube/config

export N_PREFIX=~/.local/
if [ -d /usr/share/zsh/plugins/zsh-vi-mode ]; then source /usr/share/zsh/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh; fi
