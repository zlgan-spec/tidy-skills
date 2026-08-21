# tidy-skills

**English** · [中文](README.zh-CN.md)

An agent skill that keeps your *other* skills tidy - the simplest way to
manage AI agent skills across multiple CLI tools.

If you use more than one AI coding CLI (Claude Code, Codex, Cursor, Gemini
CLI...), installed skills rot: copies drift apart, symlinks die, the same
skill ends up in three versions. You don't need a manager app. You need three
small things your agent can run itself:

1. **One central library** - the canonical copy of every skill lives in one
   directory; tool directories hold only symlinks.
2. **A markdown map** - a `SKILLS-MAP.md` inventory that humans and agents
   both read. Docs as the manager, not an app.
3. **A read-only audit script** - one command that reports copies, dead links,
   and duplicates before they become a mess.

## Install

Put the folder in your agent's skill directory:

```bash
git clone https://github.com/zlgan-spec/tidy-skills.git ~/.claude/skills/tidy-skills
```

(Or, in the spirit of the skill itself: clone it into your central library and
symlink it into each tool.)

## Use

Say "audit my skills", "my skills are out of sync", "tidy up my skills" - or
run the scanner directly:

```bash
bash scripts/audit.sh
```

The audit script never modifies anything. Every destructive step in the
workflow requires a dated backup first, and when two copies of a skill have
been edited on both sides, the agent stops and asks instead of merging.

## Contents

```
tidy-skills/
├── SKILL.md                          # the method: workflow + judgment rules
├── scripts/audit.sh                  # read-only scanner
├── references/agent-directories.md   # where each CLI keeps skills
└── assets/SKILLS-MAP.template.md     # inventory doc template
```

## License

MIT
