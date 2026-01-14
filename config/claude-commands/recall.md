---
description: Search Qdrant memory
argument-hint: What to search for (optional: type:decision, type:error, etc.)
---

Search Qdrant memory using `mcp__qdrant__qdrant-find`.

**If arguments provided**:
- Check for type filter: `type:decision`, `type:error-resolution`, `type:architecture`, `type:session-summary`, `type:note`
- Search for: $ARGUMENTS (excluding the type filter from search query)

**If no arguments**: Search for recent entries related to current project/directory.

**Present results:**
- Show date, type, and project for each result
- Display most relevant content
- If nothing found, suggest alternative search terms or broader queries

**After showing results**: Suggest related searches based on what was found (e.g., "You might also search for: <related terms>").
