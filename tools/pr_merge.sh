#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/_lib.sh"

args=$(cat)
repo=$(json_val "repo" "$args"); repo="${repo:-.}"
number=$(json_val "number" "$args")
[ -z "$number" ] && { echo '{"error":"number is required"}'; exit 1; }
method=$(json_val "method" "$args"); method="${method:-squash}"

gh pr merge "$number" -R "$repo" "--$method" --delete-branch 2>&1 || \
gh pr merge "$number" -R "$repo" "--$method"
