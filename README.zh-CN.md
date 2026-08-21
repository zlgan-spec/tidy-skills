# tidy-skills

[English](README.md) · **中文**

一个帮你管好其他 skill 的 agent skill - 用最简单的方式管理多个 CLI 工具里的 skill。

同时用几个 AI 编程 CLI（Claude Code、Codex、Cursor、Gemini CLI……），装的 skill 会慢慢烂掉：副本各改各的、软链失效、同一个 skill 冒出三个版本，分不清哪个是最新。其实不用装管理器，三样小东西就够，而且都能让 agent 自己跑：

1. **一个中央库** - 每个 skill 的真身只放一份，工具目录里全是软链。改一处，处处生效。
2. **一份 md 地图** - `SKILLS-MAP.md` 记清什么在哪，人能看，agent 也能读。用文档当管理器，不装 app。
3. **一个只读体检脚本** - 一条命令查出副本、死链、重名，赶在变成烂摊子之前。

## 安装

把文件夹放进 agent 的 skill 目录：

```bash
git clone https://github.com/zlgan-spec/tidy-skills.git ~/.claude/skills/tidy-skills
```

（也可以按这个 skill 自己教的方法：clone 进中央库，再软链到各个工具。）

## 使用

对 agent 说「整理一下我的 skills」「skill 乱了」「查一下 skill 有没有不同步」就会触发。也可以直接跑脚本：

```bash
bash scripts/audit.sh
```

体检脚本只读不写。所有会动文件的步骤都要先打带日期的备份；一个 skill 两边都有各自的修改时，agent 会停下来问你，不会擅自合并。

## 目录

```
tidy-skills/
├── SKILL.md                          # 方法本体：工作流 + 判断规则
├── scripts/audit.sh                  # 只读体检脚本
├── references/agent-directories.md   # 各家 CLI 的 skill 目录在哪
└── assets/SKILLS-MAP.template.md     # 地图文档模板
```

## License

MIT
