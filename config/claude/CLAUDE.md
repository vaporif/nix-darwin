# Global Claude Code Preferences

## Code Quality
- Keep functions focused and reasonably sized
- Comment only when the "why" isn't obvious from the code itself
- Test edge cases and error paths, not just happy paths

## Before Writing Code
- Look for project-specific docs (CLAUDE.md, README, docs/) before starting
- Check existing code patterns before introducing new approaches
- Look for existing similar implementations before writing from scratch
- Don't assume - verify with tests or by running the code
- Don't make assumptions about requirements - ask
- Search Qdrant with `/recall` for relevant previous context, decisions, or solutions

## During Long Sessions
- Run `/remember` periodically to save important context to Qdrant
- Especially before complex multi-step tasks or when key decisions are made

## After Completing Code
- When a feature or code implementation is complete, run `/cleanup`
- Present suggested improvements and let the user decide what to apply

## Git Commits
- Prefer short, concise commit messages (one line when possible)
- Do not add Co-Authored-By trailers
