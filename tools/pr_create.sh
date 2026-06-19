#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/_lib.sh"

args=$(cat)
title=$(json_val "title" "$args")
[ -z "$title" ] && { echo '{"error":"title is required"}'; exit 1; }
body=$(json_val "body" "$args")
repo=$(json_val "repo" "$args")
base=$(json_val "base" "$args"); base="${base:-main}"
head=$(json_val "head" "$args")

cmd=(gh pr create --title "$title" --body "$body" --base "$base")
[ -n "$repo" ] && cmd+=(-R "$repo")
[ -n "$head" ] && cmd+=(--head "$head")

"${cmd[@]}"
