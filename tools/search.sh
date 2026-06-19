#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/_lib.sh"

args=$(cat)
type=$(json_val "type" "$args"); type="${type:-repos}"
query=$(json_val "query" "$args")
[ -z "$query" ] && { echo '{"error":"query is required"}'; exit 1; }
limit=$(json_val "limit" "$args"); limit="${limit:-20}"

case "$type" in
  repos)
    gh search repos "$query" --limit "$limit" --json fullName,description,stargazersCount
    ;;
  code)
    gh search code "$query" --limit "$limit" --json path,repository,textMatches
    ;;
  issues)
    gh search issues "$query" --limit "$limit" --json number,title,repository,state
    ;;
  *)
    echo "{\"error\":\"unknown type: $type (use: repos, code, issues)\"}"
    exit 1
    ;;
esac
