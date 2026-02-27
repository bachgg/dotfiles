#!/bin/bash

command="${1:-ssh}"

# SSH config files to parse
CONFIG_FILES=(
  "$HOME/.ssh/config"
  "$HOME/.ssh/tl.config"
  "$HOME/.ssh/cs.config"
  "$HOME/.ssh/private.config"
)

# Extract all Host entries (excluding wildcards like *)
get_hosts() {
  for config in "${CONFIG_FILES[@]}"; do
    if [[ -f "$config" ]]; then
      grep -i "^Host " "$config" 2>/dev/null | awk '{print $2}' | grep -v '[*?]'
    fi
  done | sort -u
}

# Get list of hosts
hosts=$(get_hosts)

if [[ -z "$hosts" ]]; then
  echo "No SSH hosts found in config files."
  exit 1
fi

# Use fzf to select a host
selected_host=$(echo "$hosts" | fzf --prompt="SSH to: ")

# If a host was selected, SSH into it
if [[ -n "$selected_host" ]]; then
  echo "Connecting to $selected_host..."
  "$command" "$selected_host"
fi
