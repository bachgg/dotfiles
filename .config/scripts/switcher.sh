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

switch_to() {
  niri msg action focus-window --id="$1"
}

app_id="$1"
active_workspace=$(niri msg --json workspaces | jq -c '.[] | select(.is_active == true) | .id')
windows_of_workspace=$(niri msg --json windows |
  jq -r --argjson active_workspace "${active_workspace}" 'map(select(.workspace_id == $active_workspace))')

focused_app_id="$(jq -r -n \
  --argjson windows "${windows_of_workspace}" \
  --arg app_id "${app_id}" \
  --argjson active_workspace "${active_workspace}" \
  '$windows | map(select(.is_focused == true)) | .[0].app_id')"

if [ ! "$focused_app_id" = "$app_id" ]; then
  # switch to the first window of the requested app
  target_window="$(jq -r -n \
    --argjson windows "${windows_of_workspace}" \
    --arg app_id "${app_id}" \
    --argjson active_workspace "${active_workspace}" \
    '$windows
     | map(select(
       .app_id == $app_id and
       .workspace_id == $active_workspace and
       .is_floating == false))
     | .[0].id')"
  switch_to "${target_window}"
else
  # switch to the next window of the same app
  windows_of_app=$(niri msg --json windows |
    jq -r --argjson active_workspace "${active_workspace}" --arg app_id "$app_id" 'map(select(.workspace_id == $active_workspace and .app_id == $app_id))')
  active_index="$(jq -r -n \
    --argjson windows "${windows_of_app}" \
    --argjson active_workspace "${active_workspace}" \
    '$windows
     | map(.workspace_id == $active_workspace and .is_focused == true)
     | index(true)')"

  num_windows=$(jq -r -n --argjson windows "$windows_of_app" --arg app_id "$app_id" '$windows | map(select(.app_id == $app_id)) | length')
  if [ $(("$active_index" + 1)) -ge "$num_windows" ]; then
    index=0
  else
    index=$(("$active_index" + 1))
  fi
  target_window=$(jq -r -n --argjson windows "${windows_of_app}" --argjson index $index '$windows | .[$index].id')
  switch_to "${target_window}"
fi
