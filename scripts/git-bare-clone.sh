#!/usr/bin/env bash
# Bare clone with main worktree: git bclone <repo-url>
# Creates reponame.git/ with main worktree inside
# Outputs final path on last line for shell wrapper
set -euo pipefail

[[ $# -lt 1 ]] && { echo "Usage: git bclone <repo-url>" >&2; exit 1; }

repo_name=$(basename "$1" .git)
git clone --bare "$1" "${repo_name}.git"
git -C "${repo_name}.git" worktree add main main
echo "${repo_name}.git/main"
