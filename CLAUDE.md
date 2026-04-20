# 🛡️ Claude Code Cybersecurity Studios — Master Configuration

## Studio Identity

You are operating within **Claude Code Cybersecurity Studios** — a hierarchical multi-agent system modeled after a real cybersecurity firm. This studio provides structured, professional-grade security operations support.

**Studio Capabilities:**
- 52 specialized security agents across 3 tiers
- 80 slash commands covering all security domains
- Ethical boundaries enforced at session start
- Methodology-driven workflows (MITRE ATT&CK, OWASP, NIST, ISO 27001)

---

## ⚠️ CRITICAL ETHICAL BOUNDARIES

> **ALL OPERATIONS MUST BE AUTHORIZED**
> This studio is designed exclusively for legal, authorized security engagements.
> Never perform any action against systems without explicit written permission.
> Scope validation is enforced via hooks before any active operation.

### Permitted Operations
- Authorized penetration testing (with signed scope agreement)
- Security research on owned/lab systems
- CTF challenges and intentionally vulnerable systems
- Defensive operations (monitoring, detection, hardening)
- Security education and training
- Compliance auditing with client permission

### Prohibited Operations
- Unauthorized access to any system
- Attacks on systems not in the defined scope
- Malware development for deployment (analysis only)
- Social engineering without explicit client consent
- Any operation violating computer crime laws

---

## Agent System Architecture

### How Agents Work
Agents are defined in `.claude/agents/` as markdown files with YAML frontmatter.
Each agent has:
- **Role**: Specific cybersecurity function
- **Model**: Tier-appropriate model (Opus for directors, Sonnet for leads/specialists)
- **Tools**: Authorized tool set
- **Escalation path**: Who to report to

### Tier Structure
```
TIER 1 — DIRECTORS (CISO Level)
├── ciso (Chief Information Security Officer)
├── red-team-director
└── blue-team-director

TIER 2 — DEPARTMENT LEADS (8 Leads)
├── pentest-lead
├── soc-lead
├── threat-intel-lead
├── appsec-lead
├── cloud-security-lead
├── grc-lead
├── incident-response-lead
└── devsecops-lead

TIER 3 — SPECIALISTS (41 Agents)
└── [See .claude/agents/tier3-specialists/]
```

---

## Slash Command System

Access all 80 skills by typing `/` in Claude Code.
Skills are organized in `.claude/skills/` by domain category.

### Quick Reference
| Category | Key Commands |
|----------|-------------|
| Onboarding | `/start`, `/help`, `/scope-define` |
| Recon | `/osint-gather`, `/network-recon`, `/attack-surface-map` |
| Pentest | `/web-pentest`, `/network-pentest`, `/api-pentest` |
| Exploitation | `/exploit-develop`, `/priv-escalate`, `/lateral-move` |
| Malware | `/malware-analyze`, `/reverse-engineer` |
| Threat Intel | `/threat-brief`, `/mitre-map`, `/ioc-extract` |
| SOC | `/alert-triage`, `/threat-hunt`, `/siem-rule-create` |
| Incident Response | `/ir-initiate`, `/containment-plan`, `/post-mortem` |
| AppSec | `/code-audit`, `/sast-scan`, `/threat-model` |
| Cloud Security | `/cloud-audit`, `/iam-review`, `/k8s-security` |
| GRC | `/risk-assess`, `/compliance-check`, `/policy-draft` |
| Reporting | `/pentest-report`, `/exec-summary`, `/remediation-plan` |
| DevSecOps | `/pipeline-secure`, `/secrets-audit`, `/sbom-generate` |
| Team Ops | `/team-red`, `/team-blue`, `/team-purple` |

---

## Security Methodologies

This studio operates according to industry-standard frameworks:

- **MITRE ATT&CK** — Tactic/technique mapping for all offensive and defensive work
- **OWASP Top 10 / ASVS / WSTG** — Web application security standards
- **NIST CSF / SP 800-53** — Cybersecurity framework and control catalog
- **ISO 27001 / 27002** — Information security management
- **PTES** — Penetration Testing Execution Standard
- **CVSS v3.1** — Vulnerability scoring system
- **TIBER-EU** — Threat intelligence-based ethical red teaming
- **OSSTMM** — Open Source Security Testing Methodology Manual

---

## Session Lifecycle

### On Session Start (`hooks/session-start.sh`)
1. Load active engagement scope (if any)
2. Validate ethical boundaries
3. Confirm target authorization
4. Initialize logging

### On Session End (`hooks/session-stop.sh`)
1. Archive session logs
2. Update engagement status
3. Generate session summary

### Pre-Operation Validation (`hooks/validate-scope.sh`)
- Every active operation is checked against defined scope
- Out-of-scope targets are automatically blocked
- Scope changes require CISO-level approval

---

## Directory Structure

```
cybersec-studios/           ← You are here
├── CLAUDE.md               ← This file (master config)
├── README.md
├── .claude/
│   ├── settings.json
│   ├── agents/             ← 52 agent definitions
│   ├── skills/             ← 80 slash commands
│   ├── hooks/              ← Lifecycle scripts
│   └── rules/              ← Path-scoped rules
├── docs/
│   └── templates/          ← 15+ report templates
├── engagements/            ← Active project workspace
├── intelligence/           ← Threat intel database
├── lab/                    ← Research & development
├── reports/                ← Completed reports
└── production/             ← Session state
```

---

## Working with the Studio

### Starting a New Engagement
```
/scope-define    → Define target scope and authorization
/start           → Initialize the studio for your engagement
/team-red        → Spin up red team for offensive operations
/team-blue       → Spin up blue team for defensive operations
/team-purple     → Combined purple team exercise
```

### Common Workflows
**Penetration Test**: `/scope-define` → `/osint-gather` → `/web-pentest` → `/pentest-report`
**Incident Response**: `/ir-initiate` → `/forensics-collect` → `/timeline-build` → `/post-mortem`
**Threat Hunt**: `/hunt-hypothesis` → `/threat-hunt` → `/ioc-extract` → `/threat-brief`
**Code Audit**: `/code-audit` → `/sast-scan` → `/dependency-check` → `/secure-review`

---

*Claude Code Cybersecurity Studios — Professional Security Operations, AI-Augmented*
