# tidy-skills

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

## 中文简介

多个 AI 编程 CLI 并用时，装的 skill 会慢慢烂掉：副本漂移、软链失效、版本
分不清。不需要装管理器 - 把三样小东西交给 agent 自己执行：**中央真身库 +
全软链**、**一份 md 地图**（人和 AI 都能读）、**一个只读体检脚本**。

对 agent 说「整理一下我的 skills」「skill 乱了 / 不同步」即可触发。所有会
动文件的步骤强制先备份；两边都有独有修改的 skill 一律先问再动。

## License

MIT
