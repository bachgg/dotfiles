#!/bin/bash

command="${1:-ssh}"

MAIN_CONFIG="$HOME/.ssh/config"

# Build CONFIG_FILES from the main config's Include directives
CONFIG_FILES=("$MAIN_CONFIG")

if [[ -f "$MAIN_CONFIG" ]]; then
  while IFS= read -r included; do
    # Expand ~ to $HOME
    included="${included/#\~/$HOME}"
    # If path is relative, resolve it relative to ~/.ssh
    [[ "$included" != /* ]] && included="$HOME/.ssh/$included"
    # Expand globs (Include supports them); only add if file exists
    for f in $included; do
      [[ -f "$f" ]] && CONFIG_FILES+=("$f")
    done
  done < <(grep -iE "^[[:space:]]*Include[[:space:]]+" "$MAIN_CONFIG" | awk '{for (i=2; i<=NF; i++) print $i}')
fi

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
