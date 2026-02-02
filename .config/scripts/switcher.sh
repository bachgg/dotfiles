#!/usr/bin/env bash
# Switch to another window in the same workspace

# Output of `niri msg --json windows`
# [
#   {
#     "id": 241,
#     "title": "Alacritty",
#     "app_id": "Alacritty",
#     "pid": 3206792,
#     "workspace_id": 1,
#     "is_focused": true,
#     "is_floating": false,
#     "is_urgent": false
#   },
#   {
#     "id": 240,
#     "title": "Alacritty",
#     "app_id": "Alacritty",
#     "pid": 2959912,
#     "workspace_id": 1,
#     "is_focused": false,
#     "is_floating": false,
#     "is_urgent": false
#   },
#   {
#     "id": 334,
#     "title": "Meet – cys-owqn-pvv",
#     "app_id": "brave-browser",
#     "pid": 419752,
#     "workspace_id": 1,
#     "is_focused": false,
#     "is_floating": true,
#     "is_urgent": false
#   },
#   {
#     "id": 272,
#     "title": "Microsoft Is A Blackhole Of Talent And Money - YouTube - Brave",
#     "app_id": "brave-browser",
#     "pid": 419752,
#     "workspace_id": 1,
#     "is_focused": false,
#     "is_floating": false,
#     "is_urgent": false
#   }
# ]

set -euo pipefail

if [ -z "${1:-}" ]; then
  echo "Usage: $0 <app_id>" >&2
  exit 1
fi

app_id="$1"
cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/switch_window"
mkdir -p "$cache_dir"

switch_to() {
  niri msg action focus-window --id="$1"
}

save_last_focused() {
  local app="$1" window_id="$2"
  echo "$window_id" >"$cache_dir/$app"
}

get_last_focused() {
  local app="$1"
  if [ -f "$cache_dir/$app" ]; then
    cat "$cache_dir/$app"
  fi
}

active_workspace=$(niri msg --json workspaces | jq -c '.[] | select(.is_active == true) | .id')
all_windows=$(niri msg --json windows)
windows_of_workspace=$(echo "$all_windows" | jq --argjson ws "$active_workspace" 'map(select(.workspace_id == $ws))')

focused_window=$(echo "$windows_of_workspace" | jq -r 'map(select(.is_focused)) | .[0] // empty')
focused_app_id=$(echo "$focused_window" | jq -r '.app_id // empty')
focused_window_id=$(echo "$focused_window" | jq -r '.id // empty')

# Save the currently focused window for its app before switching
if [ -n "$focused_app_id" ] && [ -n "$focused_window_id" ]; then
  save_last_focused "$focused_app_id" "$focused_window_id"
fi

if [ "$focused_app_id" != "$app_id" ]; then
  # Switch to the last focused window of the requested app, or fall back to first non-floating
  last_focused=$(get_last_focused "$app_id")

  # Verify the last focused window still exists in current workspace
  if [ -n "$last_focused" ]; then
    window_exists=$(echo "$windows_of_workspace" | jq -r --argjson id "$last_focused" --arg app "$app_id" '
      map(select(.id == $id and .app_id == $app)) | length > 0')
  fi

  if [ -n "$last_focused" ] && [ "$window_exists" = "true" ]; then
    target_window="$last_focused"
  else
    # Fall back to first non-floating window
    target_window=$(echo "$windows_of_workspace" | jq -r --arg app "$app_id" '
      map(select(.app_id == $app and .is_floating == false)) | .[0].id // empty')
  fi
else
  # Cycle to next window of the same app
  windows_of_app=$(echo "$windows_of_workspace" | jq --arg app "$app_id" 'map(select(.app_id == $app))')
  target_window=$(echo "$windows_of_app" | jq -r '
    (map(.is_focused) | index(true)) as $idx |
    if $idx == null then .[0].id
    else .[(($idx + 1) % length)].id end // empty')
fi

if [ -z "$target_window" ]; then
  echo "No window found for app_id: $app_id" >&2
  exit 1
fi

switch_to "$target_window"
