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
