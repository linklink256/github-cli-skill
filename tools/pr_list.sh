#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/_lib.sh"

args=$(cat)
repo=$(json_val "repo" "$args"); repo="${repo:-.}"
limit=$(json_val "limit" "$args"); limit="${limit:-20}"
state=$(json_val "state" "$args"); state="${state:-open}"

gh pr list -R "$repo" --state "$state" --limit "$limit" \
  --json number,title,author,state,headRefName,updatedAt
