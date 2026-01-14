---
description: Store in Qdrant (no args = session summary, with args = store that info)
argument-hint: Optional info to store
---

Store information in Qdrant memory using `mcp__qdrant__qdrant-store`.

**If arguments provided**: Store "$ARGUMENTS" with metadata `{"type": "note", "date": "<today>"}`.

**If no arguments**: Summarize this entire conversation (goals, problems solved, solutions, key files/commands) and store with metadata `{"type": "session-summary", "date": "<today>", "project": "<if applicable>"}`.

Confirm what was stored.
