---
description: Update project documentation after code changes
---

Review recent changes and update all relevant documentation.

**Steps:**

1. Get the diff: `git diff main...HEAD` to see all changes (or review what was done this session)
2. For each category below, check if updates are needed:

**CLAUDE.md** (project root):
- Architecture section: new files, changed structure
- Commands section: new commands, changed workflows
- Key implementation details: new patterns, dependencies

**Serena Memory** (via `mcp__serena__write_memory` / `mcp__serena__edit_memory`):
- Codebase structure changes
- New modules or key abstractions
- Patterns that future sessions should know about

**Auto Memory** (`~/.claude/projects/<project>/memory/MEMORY.md`):
- Common pitfalls discovered
- Patterns that worked or failed
- Project-specific conventions

**Qdrant** (via `mcp__qdrant__qdrant-store`):
- Key decisions made and rationale
- Error resolutions worth remembering
- Architecture choices

3. Present a summary of what needs updating
4. Apply updates after user approval
5. Skip categories where nothing changed
