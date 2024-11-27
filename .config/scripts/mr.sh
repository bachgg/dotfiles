#!/bin/sh
source ~/.config/op/plugins.sh
MR=$(glab mr list --per-page 10 --not-label renovate -F json -R $(git remote get-url origin))
REPO=$(echo "$MR" | jq -R '.' | jq -s '.' | jq -r 'join("")' | jq -r '.[0] | "\(.references.full)"' | sed -E 's#.*/([^/]+)![0-9]+#\1#')
TITLES=$(echo "$MR" | jq -R '.' | jq -s '.' | jq -r 'join("")' | jq -r '.[] | "\\033[31;1m[\(.title)]\\033[0m(\(.web_url)) @sre-team"' | sed "s/^/\`$REPO\` /")
echo "$TITLES" | fzf --ansi | pbcopy

