#!/bin/sh
source ~/.config/op/plugins.sh

RED="\\033[31m"
GREEN="\\033[32m"
BLUE="\\033[34m"
CYAN="\\033[36m"
RESET="\\033[0m"

mr=$(glab mr list --per-page 10 --not-label renovate -F json -R $(git remote get-url origin)\
  | jq -c 'map({repo: .references.full, iid, title,web_url, description, author: .author.username, target_branch, source_branch})')

repo=$(git remote get-url origin | sed 's_.*/__; s/\.git$//')

messages=$(jq -r -n --argjson data "$mr" '$data | .[] | "!\(.iid) [\(.title)](\(.web_url)) @cloud-engineering \(.description)"')

fzf_entries=$(jq -r -n --argjson data "$mr" '$data | .[] | "!\(.iid),\(.title),\(.author),(\(.target_branch)) ← (\(.source_branch))"' |
  awk \
    -v red=$RED -v green=$GREEN -v blue=$BLUE -v cyan=$CYAN -v reset=$RESET \
    -F ',' '{
    printf "%-20s " green "%-70s" reset "\n" red "%-20s " blue "%-70s" reset "\\0", $1, $2, $3, $4;
  }')

selected_iid=$(echo $fzf_entries  | fzf --ansi --read0 | sed -n '1p' | sed -E 's/^!([0-9]+).*$/\1/')

jq -r -n --arg repo "$repo" --argjson iid "$selected_iid" --argjson data "$mr" '$data | .[] | select(.iid == $iid) | "`\($repo)` [\(.title)](\(.web_url)) @cloud-engineering\n\(.description)"' | pbcopy
