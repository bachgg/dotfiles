#!/bin/bash
set -e

name="$1"
if [ -z "$name" ]; then echo "Repo name missing" && exit 1; fi
cd "$HOME/workspace"
gh repo create "$name" --private --clone
cd "$HOME/workspace/$name"
git remote set-url origin "$(git remote get-url origin | sed 's_https://github.com/_git@github.com:_g')"
