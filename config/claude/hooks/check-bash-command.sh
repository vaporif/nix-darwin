#!/usr/bin/env bash
# PreToolUse hook for Bash commands
# Uses shfmt to parse command AST and extract actual executables,
# then checks against blocklists for destructive/dangerous commands.

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

if [[ -z "$COMMAND" ]]; then
  exit 0
fi

block() {
  jq -n --arg reason "$1" '{ decision: "block", reason: $reason }'
  exit 0
}

# Extract all command names from the bash AST using shfmt
extract_commands() {
  local cmd="$1"
  shfmt --to-json <<< "$cmd" 2>/dev/null | jq -r '
    [
      (.. | objects | select(.Type == "CallExpr") | .Args[0]?.Parts[0]?.Value // empty),
      (.. | objects | select(.Type == "DeclClause") | .Variant.Value)
    ] | unique | .[]' 2>/dev/null
}

COMMANDS=$(extract_commands "$COMMAND")

# Fallback: if shfmt fails, extract words after shell metacharacters
if [[ -z "$COMMANDS" ]]; then
  COMMANDS=$(echo "$COMMAND" | tr '|;&' '\n' | awk '{print $1}' | sort -u)
fi

# --- Blocklist: always block these commands ---
BLOCKED_CMDS="rm rmdir dd mkfs shred wipe srm sudo doas eval"
for cmd in $COMMANDS; do
  cmd_base=$(basename "$cmd")
  for blocked in $BLOCKED_CMDS; do
    if [[ "$cmd_base" == "$blocked" ]]; then
      block "${cmd_base} detected. Confirm with user before proceeding."
    fi
  done
done

# --- Wrapper commands: check what they're actually running ---
# For sudo/env/xargs/nohup, the real command is the next argument
WRAPPER_CMDS="sudo doas env nohup xargs"
for wrapper in $WRAPPER_CMDS; do
  if echo "$COMMANDS" | grep -qx "$wrapper"; then
    # Already blocked above for sudo/doas, but catch env/nohup/xargs
    # wrapping a dangerous command
    INNER=$(echo "$COMMAND" | grep -oP "(?<=\b${wrapper}\b\s)[\w./-]+" | head -1)
    if [[ -n "$INNER" ]]; then
      for blocked in $BLOCKED_CMDS; do
        if [[ "$(basename "$INNER")" == "$blocked" ]]; then
          block "${wrapper} wrapping ${blocked}. Confirm with user."
        fi
      done
    fi
  fi
done

# --- Git destructive operations (check full command text) ---
NORMALIZED=$(echo "$COMMAND" | tr '\n' ';')

if echo "$NORMALIZED" | grep -qiE '\bgit\s+push\b.*(-f\b|--force\b|--delete\b)'; then
  block "Force push or remote branch deletion. Confirm with user."
fi

if echo "$NORMALIZED" | grep -qiE '\bgit\s+push\b.*:'; then
  block "Git push with refspec (could delete remote branch). Confirm with user."
fi

if echo "$NORMALIZED" | grep -qiE '\bgit\s+reset\s+--hard\b'; then
  block "git reset --hard discards all changes. Confirm with user."
fi

if echo "$NORMALIZED" | grep -qiE '\bgit\s+clean\s+-f'; then
  block "git clean -f deletes untracked files. Confirm with user."
fi

if echo "$NORMALIZED" | grep -qiE '\bgit\s+(checkout|restore)\s+\.'; then
  block "Discards all unstaged changes. Confirm with user."
fi

if echo "$NORMALIZED" | grep -qiE '\bgit\s+stash\s+clear\b'; then
  block "git stash clear deletes all stashes. Confirm with user."
fi

if echo "$NORMALIZED" | grep -qiE '\bgit\s+branch\s+-D\b'; then
  block "git branch -D force-deletes a branch. Confirm with user."
fi

if echo "$NORMALIZED" | grep -qiE '\bgit\s+filter-branch\b|\bgit\s+reflog\s+expire\b'; then
  block "Git history rewriting. Confirm with user."
fi

if echo "$NORMALIZED" | grep -qiE '\bgit\s+commit\s+--amend\b'; then
  block "git commit --amend modifies the previous commit. Confirm with user."
fi

if echo "$NORMALIZED" | grep -qiE '\bgit\s+rebase\b'; then
  block "git rebase modifies history. Confirm with user."
fi

if echo "$NORMALIZED" | grep -qiE '\bgit\s+cherry-pick\b'; then
  block "git cherry-pick modifies history. Confirm with user."
fi

# --- Remote code execution ---
if echo "$NORMALIZED" | grep -qiE 'curl\s.*\|\s*(ba)?sh|wget\s.*\|\s*(ba)?sh|curl\s.*\|\s*python|wget\s.*\|\s*python'; then
  block "Piping remote content to shell/interpreter. Confirm with user."
fi

# --- Process/system disruption ---
if echo "$COMMANDS" | grep -qxE 'killall|shutdown|reboot|halt'; then
  block "System disruption command detected. Confirm with user."
fi

if echo "$NORMALIZED" | grep -qiE '\bpkill\b.*-9|\bkill\b.*-9'; then
  block "Force killing processes. Confirm with user."
fi

# --- Permission changes ---
if echo "$NORMALIZED" | grep -qiE '\bchmod\b.*777'; then
  block "chmod 777 makes files world-writable. Confirm with user."
fi

exit 0
