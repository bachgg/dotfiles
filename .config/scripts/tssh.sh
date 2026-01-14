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

# Local binaries to copy
local_binaries=("/sbin/fzf" "/sbin/rg")

# Remote paths
remote_base="/tmp/bach"
remote_bin_dir="$remote_base/bin"
remote_tmux_conf="$remote_base/.tmux.conf"
remote_tmux_dir="$remote_base/.config/tmux"
remote_nvim_dir="$remote_base/.config/nvim"

# Neovim download details
nvim_url="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz"
remote_nvim_extract_dir="$remote_base/nvim-linux-x86_64" # Extracted folder name

# Prepare SSH command prefix for reuse
ssh_cmd=(ssh)
if [ "${#ssh_extra_args[@]}" -gt 0 ]; then
  ssh_cmd+=("${ssh_extra_args[@]}")
fi
ssh_cmd+=("$host")

# --- 1) Check Existence & Provision ---

# Check if remote bin directory exists
if "${ssh_cmd[@]}" "[ -d '$remote_bin_dir' ]"; then
  echo "Remote directory $remote_bin_dir exists. Skipping provisioning (copying/downloading)."
else
  echo "Provisioning remote environment on $host..."

  # A) Create directory structure
  mkdir_cmd="mkdir -p '$remote_tmux_dir' '$remote_nvim_dir' '$remote_bin_dir'"
  "${ssh_cmd[@]}" "$mkdir_cmd" || exit 1

  # B) Rsync Configs & Utilities
  #    We copy tmux config, nvim config, and static binaries (fzf, rg)
  rsync_opts=(-avzq)
  if [ "${#ssh_extra_args[@]}" -gt 0 ]; then
    rsync_opts+=(-e "ssh ${ssh_extra_args[*]}")
  fi

  echo " -> Copying configs and utils (fzf, rg)..."
  rsync "${rsync_opts[@]}" "$local_tmux_conf" "${host}:${remote_tmux_conf}" || exit 1
  rsync "${rsync_opts[@]}" "$local_tmux_dir/" "${host}:${remote_tmux_dir}/" || exit 1
  rsync "${rsync_opts[@]}" "$local_nvim_dir/" "${host}:${remote_nvim_dir}/" || exit 1
  rsync "${rsync_opts[@]}" "${local_binaries[@]}" "${host}:${remote_bin_dir}/" || exit 1

  # C) Download and Install Neovim
  echo " -> Downloading and extracting Neovim..."
  # Steps: cd base -> download tar -> extract -> remove tar
  install_nvim_cmd="cd '$remote_base' && curl -LO '$nvim_url' && tar -xzf nvim-linux-x86_64.tar.gz && rm nvim-linux-x86_64.tar.gz"
  "${ssh_cmd[@]}" "$install_nvim_cmd" || exit 1
fi

# --- 2) Run Remote Session ---

# Command run inside the root shell:
# 1. Export CONFIG_BASE_DIR
# 2. Add /tmp/bach/bin (fzf, rg) AND /tmp/bach/nvim.../bin (nvim) to PATH
# 3. Export XDG_CONFIG_HOME so nvim finds the config in /tmp/bach/.config/nvim
remote_inner_cmd="export CONFIG_BASE_DIR=$remote_base;"
remote_inner_cmd="$remote_inner_cmd export PATH=$remote_bin_dir:$remote_nvim_extract_dir/bin:\$PATH;"
remote_inner_cmd="$remote_inner_cmd export XDG_CONFIG_HOME=$remote_base/.config;"

# Launch tmux (attach if exists, else new)
remote_inner_cmd="$remote_inner_cmd tmux -f $remote_tmux_conf attach -t bach/$host 2>/dev/null || tmux -f $remote_tmux_conf new -s bach/$host"

# Wrap in sudo su -
remote_cmd="sudo su - -c '$remote_inner_cmd'"

# --- 3) Spawn Alacritty ---
if [ "${#ssh_extra_args[@]}" -gt 0 ]; then
  alacritty --command ssh -t "${ssh_extra_args[@]}" "$host" "$remote_cmd"
else
  alacritty --command ssh -t "$host" "$remote_cmd"
fi
