# claude-setup

My Claude Code setup, so a new PC gets the same skills and plugins.

- `skills/`: my own skills (`graphify`, `money-leak-audit`, `web-security-audit`)
- `CLAUDE.md`: my global instructions
- `install.ps1` (Windows) / `install.sh` (Git Bash, macOS, Linux): copies the skills, adds the two plugin marketplaces and installs my 10 plugins

## On a new PC
1. Install Claude Code and log in.
2. `git clone <this repo>` and run `powershell -ExecutionPolicy Bypass -File install.ps1` (or `bash install.sh`).
3. Restart Claude Code.

Plugins that came from the web account (the `plugins/synced` folder) arrive by themselves when you log in with the same account.

## When I add a skill or plugin
Copy the new skill into `skills/`, add the plugin to the lists in both install scripts, commit and push.
