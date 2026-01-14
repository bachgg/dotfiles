#!/usr/bin/env -S zsh
EDITOR="$(which nvim)" && export "EDITOR"
export VISUAL="$EDITOR"
export ZVM_VI_EDITOR="$EDITOR"

if which starship 2>&1 1>&/dev/null; then
  export STARSHIP_CONFIG=~/.config/starship/starship.toml
  eval "$(starship init zsh)"
fi

export XDG_CONFIG_HOME="$HOME/.config"
export MANPAGER="sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat -p -lman'"

if which op 2>&1 1>&/dev/null && [ -f ~/.config/op/plugins.sh ]; then source "$HOME/.config/op/plugins.sh"; fi

# https://github.com/jeffreytse/zsh-vi-mode#execute-extra-commands
zvm_after_init_commands+=('source <(fzf --zsh)')
# eval "$(op completion zsh)"
# compdef _op op

export ZVM_SYSTEM_CLIPBOARD_ENABLED=false

# https://github.com/ohmyzsh/ohmyzsh/discussions/9849
# git_prompt_info() {}
PROMPT="%y %{${fg_bold[red]}%}:: %{${fg[green]}%}%3~%(0?. . %{${fg[red]}%}%? )%{${fg[blue]}%}»%{${reset_color}%} "

# gardenctl session
[ -n "$GCTL_SESSION_ID" ] || [ -n "$TERM_SESSION_ID" ] || export GCTL_SESSION_ID=$(uuidgen)

# [ -e ~/.kube ] || mkdir ~/.kube
# [ -e ~/.garden/gardenctl-v2.yaml ] || ([ -e ~/.kube/kubeconfig-garden-codesphere.yaml ] && gardenctl config set-garden codesphere --kubeconfig ~/.kube/kubeconfig-garden-codesphere.yaml)
# KUBECONFIG=$(ls -1 ~/.kube/kubeconfig-garden* | tr '\n' ':') kubectl config view --merge --flatten > ~/.kube/config

export N_PREFIX=~/.local/
zsh_plugin_source() {
  if [ -f "$1" ]; then
    source "$1"
  fi
}

zsh_plugin_source /usr/share/zsh/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh
zsh_plugin_source /opt/homebrew/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
zsh_plugin_source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
zsh_plugin_source /opt/homebrew/opt/zsh-fast-syntax-highlighting/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

tssh() {
  if [ "$#" -lt 1 ]; then
    echo "Usage: tssh <host> [ssh-args...]" >&2
    return 1
  fi

  local host="$1"
  shift
  # Any extra args after host will be passed to ssh (e.g. -p 2222)
  local ssh_extra_args=("$@")

  # Local paths for config
  local local_tmux_conf="$HOME/.config/tmux/tmux.conf"
  local local_tmux_dir="$HOME/.config/tmux"

  # Remote paths
  local remote_base="/tmp/bach"
  local remote_tmux_conf="$remote_base/.tmux.conf"
  local remote_tmux_dir="$remote_base/.config/tmux"

  # 0) Ensure /tmp/bach exists on remote before rsync
  if [ "${#ssh_extra_args[@]}" -gt 0 ]; then
    ssh "${ssh_extra_args[@]}" "$host" "mkdir -p '$remote_tmux_dir'" || return 1
  else
    ssh "$host" "mkdir -p '$remote_tmux_dir'" || return 1
  fi

  # 1) rsync tmux config to remote:
  #    - Copy ~/.config/tmux/tmux.conf -> /tmp/bach/.tmux.conf
  #    - Copy whole ~/.config/tmux/ -> /tmp/bach/.config/tmux/
  if [ "${#ssh_extra_args[@]}" -gt 0 ]; then
    rsync -avzq -e "ssh ${ssh_extra_args[*]}" \
      "$local_tmux_conf" "${host}:${remote_tmux_conf}" || return 1

    rsync -avzq -e "ssh ${ssh_extra_args[*]}" \
      "$local_tmux_dir/" "${host}:${remote_tmux_dir}/" || return 1
  else
    rsync -avzq \
      "$local_tmux_conf" "${host}:${remote_tmux_conf}" || return 1

    rsync -avzq \
      "$local_tmux_dir/" "${host}:${remote_tmux_dir}/" || return 1
  fi

  # 2) Remote tmux command:
  #    - Use the /tmp/bach/.tmux.conf
  #    - Use a distinct session name
  local remote_cmd
  remote_cmd="export CONFIG_BASE_DIR=$remote_base; tmux -f $remote_tmux_conf attach -t $host 2>/dev/null || tmux -f $remote_tmux_conf new -s $host"
  # echo remote cmd: "ssh -t ${ssh_extra_args[*]} '$host' '$remote_cmd'"

  # 3) Spawn a new Alacritty window running ssh + remote tmux
  if [ "${#ssh_extra_args[@]}" -gt 0 ]; then
    alacritty \
      --command zsh -lc "ssh -t ${ssh_extra_args[*]} '$host' '$remote_cmd'"
  else
    alacritty \
      --command zsh -lc "ssh -t '$host' '$remote_cmd'"
  fi
}
