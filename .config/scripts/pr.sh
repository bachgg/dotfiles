#!/bin/bash
set -e

if op --version 1>/dev/null 2>&1; then
  clickup_token="$(op read --account Codesphere "op://Employee/Clickup/token")"
  clickup_api_url="$(op read --account Codesphere "op://Employee/Clickup/sre-tasks")"
fi

if [ -z "$clickup_token" ]; then
  echo Missing ClickUp token && exit 1
fi

clickup_tasks=$(curl -fsSL \
  --request "GET" \
  --url "${clickup_api_url}?assignees[]=93666470&statuses[]=in%20progress" \
  --header "Authorization: $clickup_token" \
  --header "accept: application/json")

my_tasks="$(jq -r -n --argjson tasks "$clickup_tasks" \
  '$tasks.tasks | .[] | [.id,.name] | @tsv')"

task_id="$(echo "$my_tasks" | fzf --ansi | awk '{print $1}')"

EDITOR=$(which nvim) gh pr create -b CU-"$task_id" -e
