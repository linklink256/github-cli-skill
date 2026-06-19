#!/usr/bin/env bash
# Shared library for github-cli skill tools.
# Sourced by every tool script — sets up PATH, auth, and JSON helpers.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(dirname "$SCRIPT_DIR")"

# 1) Make the bundled gh/git binaries available
export PATH="$SKILL_DIR/bin:$PATH"

# 2) Auth: prefer GH_TOKEN env var; fall back to skill's config dir
if [ -z "${GH_TOKEN:-}" ] && [ -z "${GITHUB_TOKEN:-}" ]; then
  if [ -f "$SKILL_DIR/config/hosts.yml" ]; then
    export GH_CONFIG_DIR="$SKILL_DIR/config"
  fi
fi

# 3) JSON helpers (no jq dependency)
# Extract a value (string or number) for a key from a JSON string.
# Usage:  val=$(json_val "key" "$json")
json_val() {
  local key="$1" json="$2"
  # Try quoted string value first: "key": "value"
  local val
  val=$(echo "$json" | grep -o "\"$key\"[[:space:]]*:[[:space:]]*\"[^\"]*\"" | head -1 \
    | sed 's/.*:[[:space:]]*"//' | sed 's/"[[:space:]]*$//')
  if [ -n "$val" ]; then
    echo "$val"
    return
  fi
  # Fall back to unquoted value (number/bool/null): "key": 123
  val=$(echo "$json" | grep -o "\"$key\"[[:space:]]*:[[:space:]]*[0-9a-zA-Z_-]*" | head -1 \
    | sed 's/.*:[[:space:]]*//')
  echo "$val"
}
