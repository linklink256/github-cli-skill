#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/_lib.sh"

args=$(cat)
repo=$(json_val "repo" "$args"); repo="${repo:-.}"
limit=$(json_val "limit" "$args"); limit="${limit:-10}"

gh run list -R "$repo" --limit "$limit" \
  --json databaseId,name,status,conclusion,headBranch,createdAt,event
