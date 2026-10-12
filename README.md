# claude-setup

> **For Claude:** if the user asks to "implement my skills" or "set up my Claude from GitHub", clone this repo, run `install.ps1` (Windows) or `install.sh` (Git Bash, macOS, Linux) from its folder, then tell the user to restart Claude Code. Do not copy anything else from `~/.claude` (never `.credentials.json`).

My Claude Code setup, so a new PC gets the same skills and plugins.

- `skills/`: my skills (`graphify`, `money-leak-audit`, `web-security-audit`, plus `claude-automation-recommender` from Anthropic's Claude Code Setup plugin and `task-observer` from rebelytics/one-skill-to-rule-them-all)
- `CLAUDE.md`: my global instructions
- `settings.reference.json`: my Claude Code settings (model, enabled plugins, marketplaces), for reference only; the install scripts recreate the plugin part
- `install.ps1` (Windows) / `install.sh` (Git Bash, macOS, Linux): copies the skills, adds the plugin marketplaces, installs my 11 plugins (including `claude-mem`) and the local tools OmniRoute (npm) and Headroom (uv or pip)

## On a new PC
1. Install Claude Code and log in.
2. `git clone <this repo>` and run `powershell -ExecutionPolicy Bypass -File install.ps1` (or `bash install.sh`).
3. Restart Claude Code.

Plugins that came from the web account (the `plugins/synced` folder) arrive by themselves when you log in with the same account.

## When I add a skill or plugin
Copy the new skill into `skills/`, add the plugin to the lists in both install scripts, commit and push.

## What is NOT in this repo, on purpose
- `~/.claude/.credentials.json` and any token: log in again on the new PC.
- The plugins' own code: plugins are re-downloaded from their marketplaces by the install script.
- `~/.claude/skills/synced` and `plugins/synced`: they come from the Claude web account and reappear when you log in with the same account.
- Project memory and chat history (personal).
