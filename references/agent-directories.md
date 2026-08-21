# Where agent CLIs look for skills

Common user-level skill directories, for extending the audit script's coverage.
Verify on the actual machine - tools move these paths between versions.

| Tool | User-level skills | Project-level skills | Notes |
|---|---|---|---|
| Claude Code | `~/.claude/skills/` | `<repo>/.claude/skills/` | Plugins live in `~/.claude/plugins/` (namespaced `plugin:skill`, managed by the plugin system - do not touch). |
| Codex CLI | `~/.codex/skills/` | - | Also has its own runtime plugins in `~/.codex/config.toml`, unrelated to file skills. |
| Cursor | `~/.cursor/skills/` | `<repo>/.cursor/skills/` | `~/.cursor/skills-cursor/` is tool-managed (has a `.cursor-managed-skills-manifest.json`) - off-limits. |
| Gemini CLI | `~/.gemini/skills/` | `<repo>/.gemini/skills/` | |
| Open agent-skills convention | `~/.agents/skills/` | `<repo>/.agents/skills/` | Used by skills.sh ecosystem tools as a shared canonical directory. |

## Surfaces that do NOT read local files

Web apps and desktop apps (e.g. claude.ai, Claude Desktop) read skills from the
cloud account, uploaded via their settings UI. Local file cleanup never affects
them, and nothing here syncs to them automatically. Set that expectation with
the user up front.

## Choosing the central library location

Any stable, non-tool-owned directory works. Reasonable choices:

- `~/.skillshub/` - neutral, purpose-made
- `~/.agents/skills/` - the open-ecosystem convention; good if other tools
  already treat it as canonical

Pick whichever the machine already uses most; migrating between two library
directories is worse than living with either one.
