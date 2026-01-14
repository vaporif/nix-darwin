---
description: Store in Qdrant (no args = session summary, with args = store that info)
argument-hint: Optional info to store
---

Store information in Qdrant memory using `mcp__qdrant__qdrant-store`.

**Before storing**: Search Qdrant to check if similar information already exists. If found, skip or update instead of duplicating.

**If arguments provided**: Store "$ARGUMENTS" with metadata:
```json
{
  "type": "<note|decision|error-resolution|architecture>",
  "date": "<today>",
  "project": "<current repo/directory name>"
}
```

Choose type based on content:
- `note` - general information
- `decision` - key decisions made and why
- `error-resolution` - problems solved and solutions
- `architecture` - design patterns, structure choices

**If no arguments**: Summarize this entire conversation and store with metadata:
```json
{
  "type": "session-summary",
  "date": "<today>",
  "project": "<current repo/directory name>",
  "goals": "<what was attempted>",
  "outcome": "<success|partial|blocked>"
}
```

Include: goals, problems solved, solutions, key files modified, commands used.

Confirm what was stored with the type and a brief preview.
