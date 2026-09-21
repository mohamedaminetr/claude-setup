#!/usr/bin/env bash
# Sets up Claude Code on a new machine: my skills, my global CLAUDE.md, and my plugins.
# Run once from this folder (Git Bash, macOS or Linux):  bash install.sh
set -e
here="$(cd "$(dirname "$0")" && pwd)"
dest="$HOME/.claude"
mkdir -p "$dest/skills"
cp -r "$here"/skills/* "$dest/skills/"
[ -f "$dest/CLAUDE.md" ] && echo "~/.claude/CLAUDE.md already exists: merge $here/CLAUDE.md into it by hand" || cp "$here/CLAUDE.md" "$dest/CLAUDE.md"

claude plugin marketplace add anthropics/claude-plugins-official || true
claude plugin marketplace add DietrichGebert/ponytail || true
for p in \
  ponytail@ponytail \
  frontend-design@claude-plugins-official \
  code-review@claude-plugins-official \
  42crunch-api-security-testing@claude-plugins-official \
  ai-plugins@claude-plugins-official \
  playwright@claude-plugins-official \
  modern-web-guidance@claude-plugins-official \
  context7@claude-plugins-official \
  typescript-lsp@claude-plugins-official \
  vercel@claude-plugins-official; do
  claude plugin install "$p" || echo "could not install $p"
done
echo "Done. Restart Claude Code."
