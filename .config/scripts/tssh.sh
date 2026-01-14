#!/bin/bash

if [ "$#" -lt 1 ]; then
  echo "Usage: $(basename "$0") <host> [ssh-args...]" >&2
  exit 1
fi

host="$1"
shift
# Any extra args after host will be passed to ssh (e.g. -p 2222)
ssh_extra_args=("$@")

# --- Configuration ---

# Local paths
local_tmux_conf="$HOME/.config/tmux/tmux.conf"
local_tmux_dir="$HOME/.config/tmux"
local_nvim_dir="$HOME/.config/nvim"

# Remote paths
remote_base="/tmp/bach"
remote_bin_dir="$remote_base/bin"
remote_tmux_conf="$remote_base/.tmux.conf"
remote_tmux_dir="$remote_base/.config/tmux"
remote_nvim_dir="$remote_base/.config/nvim"
remote_nvim_extract_dir="$remote_base/nvim-linux-x86_64"

# URLs
# FZF: Using fixed version 0.67.0 as requested
fzf_url="https://github.com/junegunn/fzf/releases/download/v0.67.0/fzf-0.67.0-linux_amd64.tar.gz"
# Neovim: Latest release
nvim_url="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz"

# Prepare SSH command prefix
ssh_cmd=(ssh)
if [ "${#ssh_extra_args[@]}" -gt 0 ]; then
  ssh_cmd+=("${ssh_extra_args[@]}")
fi
ssh_cmd+=("$host")

# --- 1) Check Existence & Provision ---

if "${ssh_cmd[@]}" "[ -d '$remote_bin_dir' ]"; then
  echo ">>> Remote environment ($remote_bin_dir) exists. Skipping setup."
else
  echo ">>> Remote environment missing. Starting setup on $host..."

  # A) Create directory structure
  mkdir_cmd="mkdir -p '$remote_tmux_dir' '$remote_nvim_dir' '$remote_bin_dir'"
  "${ssh_cmd[@]}" "$mkdir_cmd" || exit 1

  # B) Rsync Configs
  rsync_opts=(-avzq)
  if [ "${#ssh_extra_args[@]}" -gt 0 ]; then
    rsync_opts+=(-e "ssh ${ssh_extra_args[*]}")
  fi

  echo " -> Copying configs (tmux, nvim)..."
  rsync "${rsync_opts[@]}" "$local_tmux_conf" "${host}:${remote_tmux_conf}" || exit 1
  rsync "${rsync_opts[@]}" "$local_tmux_dir/" "${host}:${remote_tmux_dir}/" || exit 1
  rsync "${rsync_opts[@]}" "$local_nvim_dir/" "${host}:${remote_nvim_dir}/" || exit 1

  # C) Download and Install Binaries (Nvim, Fzf, Rg)
  echo " -> Installing Neovim, FZF, and Ripgrep..."

  # We construct a compound command to run on the remote machine
  # Note: escaped \$ vars are evaluated on the remote
  install_script="
    cd '$remote_base' || exit 1

    # 1. Neovim
    echo '   [1/3] Neovim...'
    curl -LO '$nvim_url'
    tar -xzf nvim-linux-x86_64.tar.gz
    rm nvim-linux-x86_64.tar.gz

    # 2. FZF (v0.67.0)
    echo '   [2/3] FZF...'
    curl -L -o fzf.tar.gz '$fzf_url'
    tar -xzf fzf.tar.gz
    # fzf tar usually contains the binary at root
    if [ -f fzf ]; then mv fzf bin/; fi
    rm fzf.tar.gz

    # 3. Ripgrep (Latest Static Musl)
    echo '   [3/3] Ripgrep...'
    # Fetch URL dynamically using Github API
    RG_URL=\$(curl -s https://api.github.com/repos/BurntSushi/ripgrep/releases/latest | grep 'browser_download_url' | grep 'x86_64-unknown-linux-musl.tar.gz' | head -n 1 | cut -d '\"' -f 4)
    
    if [ -n \"\$RG_URL\" ]; then
      curl -L -o rg.tar.gz \"\$RG_URL\"
      tar -xzf rg.tar.gz
      # ripgrep extracts to a subfolder, find 'rg' and move it
      find . -name rg -type f -exec mv {} bin/ \;
      rm rg.tar.gz
      rm -rf ripgrep-* 2>/dev/null
    else
      echo '   Warning: Could not determine Ripgrep URL'
    fi
  "

  "${ssh_cmd[@]}" "$install_script" || exit 1
fi

# --- 2) Run Remote Session ---

# Inner command (evaluated by remote root shell):
# 1. CONFIG_BASE_DIR
# 2. PATH (add custom bins)
# 3. XDG_CONFIG_HOME (for nvim)
# 4. TMUX
remote_inner_cmd="export CONFIG_BASE_DIR=$remote_base;"
remote_inner_cmd="$remote_inner_cmd export PATH=$remote_bin_dir:$remote_nvim_extract_dir/bin:\$PATH;"
remote_inner_cmd="$remote_inner_cmd export XDG_CONFIG_HOME=$remote_base/.config;"
remote_inner_cmd="$remote_inner_cmd tmux -f $remote_tmux_conf attach -t bach/$host 2>/dev/null || tmux -f $remote_tmux_conf new -s bach/$host"

# Outer command (ssh -> sudo)
remote_cmd="sudo su - -c '$remote_inner_cmd'"

# --- 3) Spawn Alacritty ---
if [ "${#ssh_extra_args[@]}" -gt 0 ]; then
  alacritty --command ssh -t "${ssh_extra_args[@]}" "$host" "$remote_cmd"
else
  alacritty --command ssh -t "$host" "$remote_cmd"
fi
