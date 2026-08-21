---
name: tidy-skills
description: Audit, de-duplicate, and organize installed AI agent skills across CLI tools (Claude Code, Codex, Cursor, Gemini CLI, etc.) using a central library + symlinks + a markdown map. Use whenever skills are messy, duplicated, out of sync between tools, or broken - dead symlinks, stale copies, "this skill works here but not there" - or when the user wants to consolidate skills into one place, share skills across tools, or generate a skills inventory. Triggers - tidy skills, skill audit, skills out of sync, duplicate skills, dead symlink, consolidate skills, 整理 skill, skill 乱了, 管理 skills, 软链, 死链, 多端不同步.
license: MIT
---

# Tidy Skills

Manage AI agent skills across CLI tools without a manager app: a central
library, symlinks, and a markdown map the agent maintains itself.

**Core rule: one canonical copy, symlinks everywhere.** A copy in two tool
directories is two skills that will silently diverge; a symlink is one skill
seen from two places. Every mess this fixes comes from breaking this rule.

**Tradeoff:** this biases toward safety over speed - backups and asking cost
time. For moving a single skill, use judgment; for anything bulk, follow it.

## 1. Manage only what you own

| Layer | Owner | Action |
|---|---|---|
| **General** (user-installed, cross-tool) | You | Centralize: library + symlinks |
| **Project** (inside a repo, path-coupled) | The repo | Leave in place; record in the map |
| **Tool-exclusive / plugin** (one tool's own skills, marketplace plugins, `*-managed-*` manifests) | The tool / publisher | Never touch; record in the map |

## 2. Audit before touching

Run `scripts/audit.sh` - read-only, scans common skill directories (pass extra
paths as arguments), reports symlinks, real copies, dead links, and duplicate
names. Summarize findings for the user before proposing any change.

No library yet? Create one - `~/.skillshub/` or `~/.agents/skills/`. One,
never two: migrating between libraries is worse than living with either.

## 3. Back up before any move

`tar -czf ~/skills-backup-$(date +%Y-%m-%d).tar.gz <dirs you will touch>`

One command, always, and tell the user where it went. Skipping this is how a
cleanup becomes data loss.

## 4. Consolidate with evidence

For each real directory found in a tool directory:

- **Not in the library** → move it there, symlink back:
  `mv <tool>/<s> <lib>/<s> && ln -s <lib>/<s> <tool>/<s>` (name already taken
  in the library → don't overwrite, report it)
- **Identical to the library copy** (`diff -rq` clean) → replace with a symlink
- **Stale** (the library side is newer AND a superset) → replacing it is an
  upgrade; do it and say so
- **Unique edits on BOTH sides → stop and ask.** Merging is the user's call,
  not yours.
- **Tool-exclusive** → leave it where it is, declare it in the map
- **Dead links** → restoring the canonical copy heals them; delete only links
  whose target is gone for good

## 5. Keep a map, not an app

Maintain a `SKILLS-MAP.md` next to the library: each location, its role and
counts, declared exceptions, upstream sources of third-party skills,
last-audit date. Humans read it, agents load it as context. Update the
existing doc rather than creating a parallel one.

```markdown
| Location | Role | Count | State |
|---|---|---|---|
| ~/.skillshub/ | library (canonical copies) | 42 | source of truth |
| ~/.claude/skills/ | Claude Code | 42 | all symlinks |
| ~/.codex/skills/ | Codex | 39 + 3 exclusive | exceptions declared below |
```

## 6. Verify, then hold the line

Re-run the audit. Goal state: tool directories are all-symlinks plus declared
exceptions, zero dead links. Going forward: new skills are created in the
library first, then linked - never directly in a tool directory; and whenever
a canonical copy moves, rebuild its links in the same sitting.

**Out of scope:** cross-machine sync (put the library under git), web/desktop
app surfaces (they read cloud-uploaded skills, not local files), updating
third-party skills from upstream (the map records where they came from).
