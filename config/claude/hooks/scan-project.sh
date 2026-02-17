#!/usr/bin/env bash
# UserPromptSubmit hook: scan project for security issues on session init
# Checks CLAUDE.md files, custom commands, settings overrides, hooks, and .envrc

INPUT=$(cat)
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // empty')
CWD=$(echo "$INPUT" | jq -r '.cwd // empty')

if [[ -z "$SESSION_ID" || -z "$CWD" ]]; then
  exit 0
fi

# Only run once per session
MARKER="/tmp/claude-scan-${SESSION_ID}"
if [[ -f "$MARKER" ]]; then
  exit 0
fi
touch "$MARKER"

NL=$'\n'
WARNINGS=""

warn() {
  WARNINGS="${WARNINGS}${NL}> **$1**: $2${NL}"
}

# --- Scan markdown files for prompt injection ---
for f in \
  "${CWD}/CLAUDE.md" \
  "${CWD}/.claude/CLAUDE.md" \
  "${CWD}/.claude/commands/"*.md; do
  if [[ -f "$f" ]]; then
    if ! echo "$(cat "$f")" | scan-injection 2>/dev/null; then
      warn "INJECTION" "${f#"${CWD}/"} may contain prompt injection"
    fi
  fi
done

# --- Check for project-level settings that could escalate permissions ---
for settings_file in \
  "${CWD}/.claude/settings.json" \
  "${CWD}/.claude/settings.local.json"; do
  if [[ -f "$settings_file" ]]; then
    # Check for dangerous allow patterns
    ALLOWS=$(jq -r '.permissions.allow[]? // empty' "$settings_file" 2>/dev/null)
    if echo "$ALLOWS" | grep -qiE 'Bash\(rm|Bash\(sudo|Bash\(eval|Bash\(dd |Bash\(curl.*sh'; then
      warn "PERMISSIONS" "${settings_file#"${CWD}/"} contains dangerous allow rules"
    fi
    # Check if it tries to override deny list
    DENIES=$(jq -r '.permissions.deny[]? // empty' "$settings_file" 2>/dev/null)
    if [[ -z "$DENIES" ]] && [[ -n "$ALLOWS" ]]; then
      warn "PERMISSIONS" "${settings_file#"${CWD}/"} adds allow rules with empty deny list"
    fi
  fi
done

# --- Flag project-level hooks (could execute arbitrary code) ---
if [[ -d "${CWD}/.claude/hooks" ]]; then
  for hook in "${CWD}/.claude/hooks/"*; do
    if [[ -f "$hook" ]]; then
      warn "HOOKS" "${hook#"${CWD}/"} is a project-level hook — review before trusting"
    fi
  done
fi

# --- Check .envrc for suspicious commands ---
if [[ -f "${CWD}/.envrc" ]]; then
  ENVRC=$(cat "${CWD}/.envrc")
  if echo "$ENVRC" | grep -qiE 'curl.*\|.*sh|wget.*\|.*sh|eval|exec|sudo|rm\b'; then
    warn "ENVRC" ".envrc contains potentially dangerous commands — review before running direnv allow"
  fi
fi

# --- Check for .serena project configs that could override behavior ---
if [[ -f "${CWD}/.serena/config.json" ]]; then
  if ! echo "$(cat "${CWD}/.serena/config.json")" | scan-injection 2>/dev/null; then
    warn "INJECTION" ".serena/config.json may contain prompt injection"
  fi
fi

# --- Output warnings if any ---
if [[ -n "$WARNINGS" ]]; then
  CONTEXT="## Project Security Scan${NL}${WARNINGS}"
  jq -n --arg ctx "$CONTEXT" '{
    hookSpecificOutput: {
      hookEventName: "UserPromptSubmit",
      additionalContext: $ctx
    }
  }'
fi

exit 0
