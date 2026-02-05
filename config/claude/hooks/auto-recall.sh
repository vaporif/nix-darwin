#!/usr/bin/env bash
# UserPromptSubmit hook: auto-inject relevant Qdrant memories on first prompt per session
# Fails silently if Qdrant is down or no memories found

INPUT=$(cat)
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // empty')
CWD=$(echo "$INPUT" | jq -r '.cwd // empty')

if [[ -z "$SESSION_ID" || -z "$CWD" ]]; then
  exit 0
fi

# Only run once per session
MARKER="/tmp/claude-recall-${SESSION_ID}"
if [[ -f "$MARKER" ]]; then
  exit 0
fi
touch "$MARKER"

PROJECT=$(basename "$CWD")
QDRANT_URL="http://localhost:6333"
COLLECTION="claude-memory"

PAYLOAD=$(jq -n --arg project "$PROJECT" '{
  filter: { must: [{ key: "metadata.project", match: { value: $project } }] },
  limit: 5,
  with_payload: true
}')

RESPONSE=$(curl -sf --max-time 3 -X POST "${QDRANT_URL}/collections/${COLLECTION}/points/scroll" \
  -H 'Content-Type: application/json' \
  -d "$PAYLOAD" 2>/dev/null) || exit 0

POINTS=$(echo "$RESPONSE" | jq -r '.result.points // empty' 2>/dev/null) || exit 0

if [[ -z "$POINTS" || "$POINTS" == "[]" || "$POINTS" == "null" ]]; then
  exit 0
fi

NL=$'\n'
CONTEXT="## Auto-recalled memories for project: ${PROJECT}${NL}"
while IFS= read -r point; do
  DOC=$(echo "$point" | jq -r '.payload.document // empty')
  if [[ -z "$DOC" ]]; then
    continue
  fi

  TYPE=$(echo "$point" | jq -r '.payload.metadata.type // .payload.metadata.topic // "note"')
  DATE=$(echo "$point" | jq -r '.payload.metadata.date // empty')
  NAME=$(echo "$point" | jq -r '.payload.metadata.memory_name // empty')

  LABEL=""
  if [[ -n "$DATE" ]]; then
    LABEL="${DATE} | ${TYPE}"
  elif [[ -n "$NAME" ]]; then
    LABEL="${NAME} | ${TYPE}"
  else
    LABEL="${TYPE}"
  fi

  if [[ ${#DOC} -gt 500 ]]; then
    DOC="${DOC:0:500}..."
  fi

  CONTEXT="${CONTEXT}${NL}### [${LABEL}]${NL}${DOC}${NL}"
done < <(echo "$POINTS" | jq -c '.[]' 2>/dev/null)

if [[ "$CONTEXT" == *"###"* ]]; then
  jq -n --arg ctx "$CONTEXT" '{
    hookSpecificOutput: {
      hookEventName: "UserPromptSubmit",
      additionalContext: $ctx
    }
  }'
fi

exit 0
