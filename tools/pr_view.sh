#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/_lib.sh"

args=$(cat)
repo=$(json_val "repo" "$args"); repo="${repo:-.}"
number=$(json_val "number" "$args")
[ -z "$number" ] && { echo '{"error":"number is required"}'; exit 1; }

gh pr view "$number" -R "$repo" --json number,title,body,state,author,reviewDecision,mergeable,additions,deletions,changedFiles,commits
