# Skills Map

> Last audited: YYYY-MM-DD ｜ Backup: `~/skills-backup-YYYY-MM-DD.tar.gz`
> Rule of the house: canonical copies live in the library; everything else is a symlink.

## Layout

| Location | Role | Count | State |
|---|---|---|---|
| `~/.skillshub/` | **Central library** (canonical copies) | NN | source of truth |
| `~/.claude/skills/` | Claude Code, user level | NN | all symlinks ✅ / exceptions below |
| `~/.codex/skills/` | Codex CLI | NN | NN symlinks + NN tool-exclusive |
| `~/.cursor/skills/` | Cursor | NN | all symlinks ✅ |
| `<repo>/.claude/skills/` | Project level (only active inside the repo) | NN | path-coupled, leave in place |
| Plugins | Managed by plugin system | NN | do not touch |

## Declared exceptions

Tool-exclusive skills that intentionally stay outside the library:

- `<tool>`: skill-a, skill-b (reason: only this tool uses them)

## Known divergences / to resolve

- (none) — or list: skill name, where the copies are, which is ahead, decision needed

## Third-party skills and their upstreams

| Skill | Upstream | How to update |
|---|---|---|
| example-skill | github.com/owner/repo | re-run `npx skills add owner/repo@example-skill` |

## Maintenance rules

1. New skill → create in the library, then symlink into each tool that needs it.
2. Before any bulk move: `tar -czf ~/skills-backup-$(date +%Y-%m-%d).tar.gz <dirs>`.
3. Moved a canonical copy? Rebuild every symlink pointing at it, same sitting.
4. Re-run the audit script after any change; update this map when counts change.
