# graphify
- **graphify** (`~/.claude/skills/graphify/SKILL.md`) - any input to knowledge graph. Trigger: `/graphify`
When the user types `/graphify`, use the installed graphify skill or instructions before doing anything else.

# money-leak-audit
- **money-leak-audit** (`~/.claude/skills/money-leak-audit/SKILL.md`) - audit a project for hosting-bill, accessibility, database RLS, messaging-consent and compute-cap problems. Trigger: `/money-leak-audit`
Run it (or offer to) on every project before it goes live and when starting a new one; keep the output minimal.

# web-security-audit
- **web-security-audit** (`~/.claude/skills/web-security-audit/SKILL.md`) - checklist from my Web Security Guide: passwords, sessions, CSRF, roles and ownership, 2FA, passkeys, tokens, headers, rate limits. Trigger: `/web-security-audit`
Run it (or offer to) on every project that has login, user data or an API, before it goes live and when starting one; keep the output minimal.

# claude-automation-recommender
- **claude-automation-recommender** (`~/.claude/skills/claude-automation-recommender/SKILL.md`) - Anthropic's Claude Code Setup: reads a codebase and recommends hooks, subagents, skills, plugins and MCP servers (read-only). Trigger: `/claude-automation-recommender`

# task-observer
- **task-observer** (`~/.claude/skills/task-observer/SKILL.md`) - watches work sessions and turns corrections and repeated friction into proposed skill improvements (you approve each one). Trigger: `/task-observer`
Keep its observation log in `~/.claude/skill-observations/`.

# Angular development guidelines (always read and follow)

## Constraints
- Scope: work only inside the project folder I name (for example `sacos`). Do not modify any file outside it.
- Git: do not commit, push, or run any Git operation that changes the repository history or remote branches, unless I ask.
- Angular version: use Angular 22 and its latest stable features and recommended practices.
- Signals: prefer Angular Signals (`signal`, `computed`, `effect`, `input`, `output`, etc.) for reactive state. Avoid RxJS where Signals are simpler.
- Code quality: clean, simple, readable, maintainable, well-structured code.
- Architecture: follow modern Angular architecture and the project's existing conventions. Keep components focused, with clearly separated responsibilities.
- Performance: efficient change detection, optimized rendering, and Angular's latest control flow and template features.
- Reusability: reuse existing components, services, utilities and models. Avoid duplication and unnecessary abstractions.
- Do not put comments in the code.
- Keep replies short.
- Use understandable, logical names for functions and methods.

## Senior developer expectations
- Analyze the existing code before making changes.
- Choose the simplest maintainable solution; avoid overengineering and redundant code.
- Follow consistent naming conventions and coding standards.
- Remove unused code and imports introduced by your changes or mine.
- Make sure the change integrates with the existing application.
- Preserve all existing functionality and avoid unrelated modifications.
