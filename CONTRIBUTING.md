# Contributing to Claude Code Cybersecurity Studios

Thank you for your interest in contributing! This project welcomes improvements from the security community.

## Types of Contributions Welcome

- **New agents**: Additional specialist roles not yet covered
- **New skills**: Additional slash command workflows
- **Improved methodology**: Better techniques, updated tool references
- **Bug fixes**: Incorrect commands, broken workflow steps
- **Documentation**: Clearer explanations, additional examples
- **Templates**: More report templates
- **Translations**: Skill files in other languages

## What We Don't Accept

- Actual exploit code or malware samples
- Tools or techniques designed for unauthorized access
- Content that could facilitate illegal activity
- Anything violating the [Code of Conduct](#code-of-conduct)

## How to Contribute

### 1. Fork and Clone
```bash
git clone https://github.com/[your-username]/claude-code-cybersecurity-studios
cd claude-code-cybersecurity-studios
```

### 2. Create a Branch
```bash
git checkout -b feature/new-agent-osint-analyst
# or
git checkout -b fix/web-pentest-tool-reference
```

### 3. Make Your Changes

**Adding a new agent:**
- Place in `.claude/agents/tier[1-3]-[level]/agent-name.md`
- Use the existing agent files as templates
- Include: YAML frontmatter, role overview, responsibilities, escalation protocol

**Adding a new skill:**
- Place in `.claude/skills/[category]/skill-name.md`
- Use existing skills as templates
- Include: agent to use, purpose, step-by-step workflow, output format

### 4. Agent File Standards

```yaml
---
name: agent-name
description: One sentence description for Claude's agent selection. Use agent: [name] when [specific conditions].
model: claude-opus-4-5   # Directors only
# or
model: claude-sonnet-4-5  # Leads and Specialists
tools:
  - Read
  - Write
  - Bash      # Only if needed
  - WebFetch  # Only if needed
---
```

### 5. Skill File Standards

```markdown
# /skill-name — Human Readable Title

```
Use agent: [agent-name]
Coordinate with: [other-agent] (optional)
```

## Purpose
[One paragraph explaining what this skill does and when to use it]

## [Steps/Content]
...

## Output
[What is produced and where it's saved]
```

### 6. Commit and Pull Request

```bash
git add .
git commit -m "feat: add osint-analyst agent for passive reconnaissance"
# or
git commit -m "fix: update web-pentest ffuf command syntax"
git push origin feature/new-agent-osint-analyst
```

Open a Pull Request with:
- Clear title describing the change
- What problem it solves
- Any methodology references (OWASP, MITRE, etc.)

## Code of Conduct

- Be respectful and professional
- Focus on constructive feedback
- No content that facilitates unauthorized system access
- Security research content must reference legal, authorized use

## Questions?

Open a GitHub Discussion for questions about the project or contributions.
