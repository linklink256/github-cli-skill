#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/_lib.sh"

args=$(cat)
repo=$(json_val "repo" "$args"); repo="${repo:-.}"
limit=$(json_val "limit" "$args"); limit="${limit:-10}"
wait_flag=$(json_val "wait" "$args"); wait_flag="${wait_flag:-false}"

list_runs() {
  gh run list -R "$repo" --limit "$limit" \
    --json databaseId,name,status,conclusion,headBranch,createdAt,event
}

if [ "$wait_flag" = "true" ]; then
  while true; do
    result=$(list_runs)
    status=$(echo "$result" | grep -o '"status"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*:[[:space:]]*"//' | sed 's/".*//')
    if [ "$status" != "in_progress" ] && [ "$status" != "queued" ] && [ "$status" != "pending" ]; then
      echo "$result"
      break
    fi
    sleep 15
  done
else
  list_runs
fi
