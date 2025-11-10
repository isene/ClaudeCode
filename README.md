# ClaudeCode

<img src="logo.svg" align="center" width="500">

<p align="center">
  <em>Custom skills and configurations for Claude Code CLI</em>
</p>

---

## Overview

This repository contains curated custom skills, hooks, and configuration examples for [Claude Code](https://claude.com/claude-code) - Anthropic's official CLI for Claude.

Skills extend Claude's capabilities with specialized knowledge, workflows, and domain expertise. Each skill provides context and instructions that activate automatically based on user needs.

## Included Skills

### [HyperList](skills/hyperlist/)
Expert knowledge of HyperList format (.hl files) - hierarchical lists with rich markup syntax. Covers syntax, coloring, conversion to PDF/HTML, and the complete HyperList 2.6 specification.

### [XRPN](skills/xrpn/)
Stack-based programming language expert. HP-41 FOCAL compatibility, command syntax, testing framework, and HP-41 RAW file format handling.

### [Amar RPG](skills/amar/)
Campaign world mythology for the Amar tabletop RPG. Kingdom lore, personalities, 3-tier game system, adventure creation, and NPC generation.

### [rcurses](skills/rcurses/)
Ruby TUI library specialist. Terminal pane management, user input handling, text formatting, cursor control, and common pitfalls in terminal UI development.

### [Lovdata](skills/lovdata/)
Norwegian legal database expertise. Navigation, search strategies, citation formats, and understanding Norwegian law structure.

### [Music Composer](skills/music-composer/)
Music theory, composition techniques, arrangement, orchestration, and creative music production workflows.

## Usage

### Installing Skills

Copy desired skills to your Claude Code skills directory:

```bash
# Copy individual skill
cp -r skills/hyperlist ~/.claude/skills/

# Or symlink for live updates
ln -s $(pwd)/skills/hyperlist ~/.claude/skills/
```

### Activating Skills

Skills activate automatically based on context. You can also invoke them explicitly:

```bash
# In Claude Code CLI
/hyperlist

# Or via natural language
"Help me create a HyperList"
```

### Configuration Examples

See [CLAUDE.md](CLAUDE.md) for example global configuration including:
- Terminal compatibility settings
- Development workflow templates
- Code standards
- Security protocols
- Deployment rules

## Creating Your Own Skills

Each skill is a directory containing:
- `SKILL.md` - Main skill definition with YAML frontmatter
- Supporting files (documentation, examples, scripts)

Example structure:
```
skills/myskill/
├── SKILL.md           # Core skill definition
├── reference.md       # Extended documentation
└── examples/          # Usage examples
```

See the [skill-creator skill](https://github.com/anthropics/claude-code) for detailed guidance.

## Hooks

Custom hooks for Claude Code events:
- Pre-commit validation
- Secret detection
- Code quality checks

Place hooks in `~/.claude/hooks/` and make executable.

## Contributing

Skills in this repository are personal configurations shared for reference. Feel free to:
- Fork and adapt for your needs
- Submit PRs for corrections or improvements
- Share your own skills

## License

Individual skills may have different licenses. Check each skill's directory for specifics.

Most content: MIT License - see individual skill directories.

## Resources

- [Claude Code Documentation](https://docs.claude.com/en/docs/claude-code)
- [Creating Skills Guide](https://docs.claude.com/en/docs/claude-code/skills)
- [HyperList Official](https://isene.com/hyperlist/)
- [XRPN Project](https://isene.com/xrpn/)

---

<p align="center">
  <sub>Built with Claude Code | <a href="https://isene.com">isene.com</a></sub>
</p>
