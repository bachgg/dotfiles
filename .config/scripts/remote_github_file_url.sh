#!/bin/sh

set -e

current_commit=$(git rev-parse HEAD)
repo=$(git remote get-url origin | sed -E 's_git@github.com:(.+).git_\1_g')
repo_root=$(git rev-parse --show-toplevel)
file_path=${1}
relative_file_path=$(echo "${file_path}" | sed "s_${repo_root}/__g")
if which wl-copy; then
  copy_command=$(which wl-copy)
else
  copy_command=$(which pbcopy)
fi

printf "https://github.com/%s/blob/%s/%s" "${repo}" "${current_commit}" "${relative_file_path}" | ${copy_command}
