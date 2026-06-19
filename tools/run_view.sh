#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/_lib.sh"

args=$(cat)
repo=$(json_val "repo" "$args"); repo="${repo:-.}"
id=$(json_val "id" "$args")
wait_flag=$(json_val "wait" "$args"); wait_flag="${wait_flag:-false}"

if [ -z "$id" ]; then
  echo '{"error":"id is required"}'
  exit 1
fi

view_run() {
  gh run view "$id" -R "$repo" --json status,conclusion,jobs,url,headBranch,createdAt,event,name
}

if [ "$wait_flag" = "true" ]; then
  while true; do
    result=$(view_run)
    status=$(echo "$result" | grep -o '"status"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*:[[:space:]]*"//' | sed 's/".*//')
    if [ "$status" != "in_progress" ] && [ "$status" != "queued" ] && [ "$status" != "pending" ]; then
      echo "$result"
      break
    fi
    sleep 15
  done
else
  view_run
fi
