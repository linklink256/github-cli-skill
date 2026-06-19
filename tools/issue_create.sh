#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/_lib.sh"

args=$(cat)
title=$(json_val "title" "$args")
[ -z "$title" ] && { echo '{"error":"title is required"}'; exit 1; }
body=$(json_val "body" "$args")
repo=$(json_val "repo" "$args")
[ -z "$repo" ] && { echo '{"error":"repo is required, e.g. owner/name"}'; exit 1; }
labels=$(json_val "labels" "$args")

cmd=(gh issue create -R "$repo" --title "$title" --body "$body")
[ -n "$labels" ] && cmd+=(--label "$labels")

"${cmd[@]}"
