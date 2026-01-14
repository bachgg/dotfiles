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
  local ssh_extra_args=("$@")

  # Local paths
  local local_tmux_conf="$HOME/.config/tmux/tmux.conf"
  local local_tmux_dir="$HOME/.config/tmux"
  local local_nvim_dir="$HOME/.config/nvim"
  local local_binaries=("/sbin/fzf" "/sbin/rg")

  # Remote paths
  local remote_base="/tmp/bach"
  local remote_bin_dir="$remote_base/bin"
  local remote_tmux_conf="$remote_base/.tmux.conf"
  local remote_tmux_dir="$remote_base/.config/tmux"
  local remote_nvim_config_dir="$remote_base/.config/nvim"
  local remote_nvim_install_dir="$remote_base/nvim-linux-x86_64"

  # Helper for SSH commands
  local ssh_cmd=("ssh")
  if [ "${#ssh_extra_args[@]}" -gt 0 ]; then
    ssh_cmd+=("${ssh_extra_args[@]}")
  fi
  local rsync_ssh_str="${ssh_cmd[*]}"

  # ---------------------------------------------------------
  # 1) Check if setup is needed
  # ---------------------------------------------------------
  # We check if /tmp/bach/bin exists. If it does, we assume
  # the environment is already hydrated and skip the copy/install.
  if "${ssh_cmd[@]}" "$host" "[ -d '$remote_bin_dir' ]"; then
    echo ">>> Remote environment ($remote_bin_dir) exists. Skipping setup/copy."
  else
    echo ">>> Remote environment missing. Starting setup..."

    # A) Prepare Directories
    local prep_cmd="mkdir -p '$remote_tmux_dir' '$remote_bin_dir' '$remote_nvim_config_dir'"
    "${ssh_cmd[@]}" "$host" "$prep_cmd" || return 1

    # B) Sync Configs (Tmux & Nvim)
    echo "   > Syncing configs..."
    rsync -avzq -e "$rsync_ssh_str" "$local_tmux_conf" "${host}:${remote_tmux_conf}" || return 1
    rsync -avzq -e "$rsync_ssh_str" "$local_tmux_dir/" "${host}:${remote_tmux_dir}/" || return 1
    rsync -avzq -e "$rsync_ssh_str" "$local_nvim_dir/" "${host}:${remote_nvim_config_dir}/" || return 1

    # C) Sync Local Binaries (fzf, rg)
    echo "   > Syncing binaries..."
    for bin in "${local_binaries[@]}"; do
      if [ -f "$bin" ]; then
        rsync -avzq -e "$rsync_ssh_str" "$bin" "${host}:${remote_bin_dir}/"
      fi
    done

    # D) Install Neovim (Download & Extract)
    echo "   > Installing Neovim..."
    local nvim_install_cmd="
      curl -L -o /tmp/nvim.tar.gz https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz;
      tar -C '$remote_base' -xzf /tmp/nvim.tar.gz;
      rm /tmp/nvim.tar.gz;
    "
    "${ssh_cmd[@]}" "$host" "$nvim_install_cmd" || return 1
  fi

  # ---------------------------------------------------------
  # 2) Remote Tmux Command as ROOT
  # ---------------------------------------------------------
  local remote_inner_cmd
  # Base env
  remote_inner_cmd="export CONFIG_BASE_DIR=$remote_base;"
  
  # Update PATH to include nvim and custom bin
  remote_inner_cmd="$remote_inner_cmd export PATH=$remote_nvim_install_dir/bin:$remote_bin_dir:\$PATH;"
  
  # IMPORTANT: Set XDG_CONFIG_HOME so nvim finds the config in /tmp/bach/.config/nvim
  remote_inner_cmd="$remote_inner_cmd export XDG_CONFIG_HOME=$remote_base/.config;"
  
  # Run/Attach Tmux
  remote_inner_cmd="$remote_inner_cmd tmux -f $remote_tmux_conf attach -t bach/$host 2>/dev/null || tmux -f $remote_tmux_conf new -s bach/$host"

  local remote_cmd
  remote_cmd="sudo su - -c '$remote_inner_cmd'"

  # ---------------------------------------------------------
  # 3) Spawn Alacritty
  # ---------------------------------------------------------
  if [ "${#ssh_extra_args[@]}" -gt 0 ]; then
    alacritty --command ssh -t "${ssh_extra_args[@]}" "$host" "$remote_cmd"
  else
    alacritty --command ssh -t "$host" "$remote_cmd"
  fi
}
