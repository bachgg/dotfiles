#!/usr/bin/env bash
# Switch to another window in the same workspace

app_id="$1"
active_workspace=$(niri msg --json workspaces | jq -c '.[] | select(.is_active == true) | .id')
windows=$(niri msg --json windows)
target_window="$(jq -r -n \
  --argjson windows "${windows}" \
  --arg app_id "${app_id}" \
  --argjson active_workspace "${active_workspace}" \
  '$windows | .[] | select(.app_id == $app_id) | select(.workspace_id == $active_workspace) | .id')"
niri msg action focus-window --id="${target_window}"
