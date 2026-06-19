#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/_lib.sh"

args=$(cat)
repo=$(json_val "repo" "$args"); repo="${repo:-.}"

gh repo view "$repo" --json name,description,url,defaultBranchRef,stargazerCount,forkCount,isPrivate,primaryLanguage
