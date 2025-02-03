#!/bin/sh
source ~/.config/op/plugins.sh

RED="\\033[31m"
GREEN="\\033[32m"
BLUE="\\033[34m"
CYAN="\\033[36m"
RESET="\\033[0m"

# get 10 latest MRs
MR=$(glab mr list --per-page 10 --not-label renovate -F json -R $(git remote get-url origin))

# magic parsing of the returned json
PARSED=$(echo "$MR" | jq -R '.' | jq -s '.' | jq -r 'join("")')

# repo slug
REPO=$(echo $PARSED | jq -r '.[0] | "\(.references.full)"' | sed -E 's#.*/([^/]+)![0-9]+#\1#')

# get `iid`s of MRs
TITLES=$(echo $PARSED | jq -r '.[] | "!\(.iid) [\(.title)](\(.web_url)) @sre-team \(.description)"' | sed "s/^/\`$REPO\`/")

# fzf entries
FZF_ENTRIES=$(
  echo $PARSED |
  jq -r '.[] | "!\(.iid),\(.title),\(.author.username),(\(.target_branch)) ← (\(.source_branch))"' |
  awk \
    -v red=$RED -v green=$GREEN -v blue=$BLUE -v cyan=$CYAN -v reset=$RESET \
    -F ',' '{
    printf "%-20s " green "%-70s" reset "\n" red "%-20s " blue "%-70s" reset "\\0", $1, $2, $3, $4;
  }'
)

SELECTED=$(echo "$FZF_ENTRIES"  | fzf --ansi --read0 | sed -n '1p')
IID=$(echo "$SELECTED" | sed -E 's/^(![0-9]+).*$/\1/')
echo $TITLES | grep $IID | sed -E 's/^(.+)(![0-9]+)(.*)(@sre-team)(.*)$/\1\3\4\n\5/' | pbcopy

