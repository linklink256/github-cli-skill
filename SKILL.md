---
name: github-cli
description: GitHub CLI toolkit — interact with repos, pull requests, issues, CI/Actions, and search via gh. Tools are registered as function-calling for direct AI invocation.
---

# GitHub CLI Skill

Bundled `gh` and `git` binaries plus 13 executable tools that wrap common GitHub
operations. When this skill is enabled on an assistant with a workspace bound,
the tools below appear as function-calling tools the AI can call directly.

## 🔐 Authentication

The tools need a GitHub token to work. Two options:

1. **GH_TOKEN env var** — set `GH_TOKEN` (or `GITHUB_TOKEN`) in the workspace
   environment. The scripts pick it up automatically.

2. **gh auth login** — run `gh auth login` in the workspace terminal once.
   Credentials are stored in the workspace's `~/.config/gh`.

> The skill does **not** ship with a hardcoded token. You must authenticate
> yourself before using the tools.

## 📦 Available Tools

| Tool | Description | Write? |
|------|-------------|--------|
| `repo_list` | List your repositories | No |
| `repo_view` | View repo details | No |
| `repo_clone` | Clone a repo into workspace | Yes |
| `pr_list` | List pull requests | No |
| `pr_view` | View PR details + diff stats | No |
| `pr_create` | Create a pull request | Yes |
| `pr_merge` | Merge a pull request | Yes |
| `issue_list` | List issues | No |
| `issue_view` | View issue details + comments | No |
| `issue_create` | Create an issue | Yes |
| `run_list` | List CI/Actions runs | No |
| `run_view` | View a run's job details | No |
| `search` | Search repos / code / issues | No |

Tools marked "Write?" need human approval before execution (unless running
in a subagent, where approval is automatically waived).

## 🛠 How It Works

Each tool maps to a bash script in `tools/`. The AI calls the tool with
JSON parameters; the script:

1. Reads parameters from **stdin** (JSON)
2. Extracts values with a lightweight parser (no `jq` needed)
3. Calls `gh` with those values
4. Returns **stdout** as the tool result

All scripts source `tools/_lib.sh` which sets up `PATH` (to find the bundled
`gh`/`git`) and auth configuration.

## 💡 Notes

- Use `"repo": "."` to refer to the current git repository in the workspace.
- Output is always JSON (via `gh --json`) for easy parsing by the AI.
- Timeout is 30s for most tools; `repo_clone` allows 120s.
- The bundled `gh` is v2.45.0, `git` is v2.43.0.
