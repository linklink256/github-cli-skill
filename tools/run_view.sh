#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/_lib.sh"

args=$(cat)
repo=$(json_val "repo" "$args"); repo="${repo:-.}"
id=$(json_val "id" "$args")
[ -z "$id" ] && { echo '{"error":"id is required (the run databaseId)"}'; exit 1; }

gh run view "$id" -R "$repo" --json status,conclusion,jobs
