# Sets up Claude Code on a new Windows machine: my skills, my global CLAUDE.md, and my plugins.
# Run once from this folder:  powershell -ExecutionPolicy Bypass -File install.ps1
$here = $PSScriptRoot
$dest = Join-Path $env:USERPROFILE ".claude"
New-Item -ItemType Directory -Force (Join-Path $dest "skills") | Out-Null
Copy-Item -Recurse -Force "$here\skills\*" (Join-Path $dest "skills")
if (Test-Path "$dest\CLAUDE.md") { Write-Host "$dest\CLAUDE.md already exists: merge $here\CLAUDE.md into it by hand" } else { Copy-Item "$here\CLAUDE.md" "$dest\CLAUDE.md" }

claude plugin marketplace add anthropics/claude-plugins-official
claude plugin marketplace add DietrichGebert/ponytail
$plugins = "ponytail@ponytail","frontend-design@claude-plugins-official","code-review@claude-plugins-official","42crunch-api-security-testing@claude-plugins-official","ai-plugins@claude-plugins-official","playwright@claude-plugins-official","modern-web-guidance@claude-plugins-official","context7@claude-plugins-official","typescript-lsp@claude-plugins-official","vercel@claude-plugins-official"
foreach ($p in $plugins) { claude plugin install $p; if ($LASTEXITCODE -ne 0) { Write-Host "could not install $p" } }
Write-Host "Done. Restart Claude Code."
