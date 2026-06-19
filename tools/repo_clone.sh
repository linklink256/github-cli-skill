#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/_lib.sh"

args=$(cat)
repo=$(json_val "repo" "$args")
[ -z "$repo" ] && { echo '{"error":"repo is required, e.g. owner/name"}'; exit 1; }
dir=$(json_val "dir" "$args")

if [ -n "$dir" ]; then
  gh repo clone "$repo" "$dir"
else
  gh repo clone "$repo"
fi
echo "Cloned $repo successfully."
