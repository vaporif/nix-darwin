#!/usr/bin/env bash
# PreToolUse hook for Bash commands
# Checks for destructive or history-modifying commands

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

if [[ -z "$COMMAND" ]]; then
  exit 0
fi

# Destructive commands
if echo "$COMMAND" | grep -qE 'rm -rf|rm -r|git push --force|git push -f|git reset --hard|git clean -f|git checkout \.|git restore \.|git stash clear|git branch -D|git push.*--delete|chmod -R 777|dd |mkfs'; then
  jq -n '{
    decision: "block",
    reason: "Destructive command. Explain why it'\''s necessary and confirm with user before proceeding."
  }'
  exit 0
fi

# Git history modification commands
if echo "$COMMAND" | grep -qE 'git commit --amend|git rebase|git cherry-pick'; then
  jq -n '{
    decision: "block",
    reason: "This command modifies git history. Confirm with user before proceeding."
  }'
  exit 0
fi

exit 0
