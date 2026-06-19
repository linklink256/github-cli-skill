#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/_lib.sh"

args=$(cat)
limit=$(json_val "limit" "$args"); limit="${limit:-30}"
json=$(json_val "json" "$args"); json="${json:-nameWithOwner,description,updatedAt}"

gh repo list --limit "$limit" --json "$json"
