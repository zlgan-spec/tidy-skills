---
name: tidy-skills
description: Audit, de-duplicate, and organize installed AI agent skills across CLI tools (Claude Code, Codex, Cursor, Gemini CLI, etc.) using a central library + symlinks + a markdown map. Use whenever skills are messy, duplicated, out of sync between tools, or broken - dead symlinks, stale copies, "this skill works here but not there" - or when the user wants to consolidate skills into one place, share skills across tools, or generate a skills inventory. Triggers - tidy skills, skill audit, skills out of sync, duplicate skills, dead symlink, consolidate skills, 整理 skill, skill 乱了, 管理 skills, 软链, 死链, 多端不同步.
---

# Tidy Skills

One rule generates everything else here: **one canonical copy, symlinks
everywhere**. A copy in two tool directories is two skills that will silently
diverge; a symlink is one skill seen from two places. So keep the real files
of every general-purpose skill in **one library directory** (e.g.
`~/.skillshub/`), let tool directories hold only symlinks, and create new
skills in the library first - never directly inside a tool directory.

## Manage only what you own

| Layer | Owner | Action |
|---|---|---|
| **General** (user-installed, cross-tool) | You | Centralize: library + symlinks |
| **Project** (inside a repo, path-coupled) | The repo | Leave in place; record in the map |
| **Tool-exclusive / plugin** (one tool's own skills, marketplace plugins, `*-managed-*` manifests) | The tool / publisher | Never touch; record in the map |

## Workflow

1. **Audit (read-only).** Run `scripts/audit.sh` - it scans common agent skill
   directories (pass extra paths as arguments; see
   [references/agent-directories.md](references/agent-directories.md)) and
   reports symlinks, real copies, dead links, and duplicate names without
   changing anything. Summarize findings for the user before proposing changes.

2. **Back up before any move.** One command, always:
   `tar -czf ~/skills-backup-$(date +%Y-%m-%d).tar.gz <dirs you will touch>`
   Tell the user where it is. Skipping this is how a cleanup becomes data loss.

3. **Consolidate.** For each real directory in a tool directory:
   - **Not in the library yet** → move it there, symlink back:
     `mv <tool-dir>/<s> <library>/<s> && ln -s <library>/<s> <tool-dir>/<s>`
     (if the name already exists in the library, don't overwrite - report it)
   - **Identical to the library copy** (`diff -rq` clean) → replace with a symlink.
   - **Diverged** → decide with evidence (mtime + which side is a superset).
     Replacing an older snapshot with a link to the newer canonical version is
     an upgrade; do it and say so. **If both sides have unique edits, stop and
     ask** - merging is the user's call, not yours.
   - **Tool-exclusive** → leave it where it is, note it as a declared exception.
   - **Dead links** → restoring the canonical copy in the library heals them;
     delete only links whose target is gone for good.

4. **Map.** Generate or update a `SKILLS-MAP.md` from
   [assets/SKILLS-MAP.template.md](assets/SKILLS-MAP.template.md): each
   location, its role, counts, declared exceptions, maintenance rules. The map
   replaces a GUI manager - humans read it, agents load it as context. Update
   an existing inventory doc rather than creating a parallel one.

5. **Verify.** Re-run the audit. Goal state: tool directories are all-symlinks
   plus declared exceptions, zero dead links, zero unexplained duplicates.
   Spot-check by reading a few `SKILL.md` files through their links.

## Out of scope

- Cross-machine sync → put the library under git.
- Web/desktop app surfaces → they read cloud-uploaded skills, not local files;
  upload separately.
- Updating third-party skills from upstream → note upstream sources in the map
  so updates stay possible; this skill only makes local state consistent.
