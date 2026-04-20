<div align="center">

# Claude Code Cyber Security Studios

Turn a single Claude Code session into a full cyber security firm.<br>
52 agents. 80+ skills. One coordinated AI security team.

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](#)
[![Agents](https://img.shields.io/badge/agents-52-blueviolet.svg)](#)
[![Skills](https://img.shields.io/badge/skills-80+-success.svg)](#)
[![Hooks](https://img.shields.io/badge/hooks-6-orange.svg)](#)
[![Rules](https://img.shields.io/badge/rules-5-red.svg)](#)
[![Built For](https://img.shields.io/badge/built%20for-Claude%20Code-grey.svg)](https://docs.anthropic.com/en/docs/agents-and-tools/claude-code/overview)
[![Tools](https://img.shields.io/badge/tools-50+-brightgreen.svg)](#quick-install)

</div>

---

## Quick Install

Before your first session, install all required security tools with one command:

```bash
chmod +x install.sh && ./install.sh
```

This installs nmap, sqlmap, nikto, subfinder, amass, httpx, nuclei, ffuf, gobuster, john, hashcat, volatility3, impacket, and 40+ more tools via Homebrew (macOS) or apt (Linux).

> See [install.sh](install.sh) for the full tool list and requirements.

---

## Why This Exists

Running security operations with AI is powerful — but a single chat session has no structure. No methodology enforcement, no scope validation, no specialist expertise, no quality gates, and no ethical safeguards.

**Claude Code Cyber Security Studios** solves this by giving your AI session the structure of a real cyber security firm. Instead of one general-purpose assistant, you get **52 specialized agents** organized into a professional security hierarchy — a CISO who guards ethical boundaries, department leads who own their domains, and specialists who do hands-on technical work.

The result: AI-augmented security operations with professional methodology, automatic scope validation, and quality-gated deliverables.

---

## Table of Contents

- [Quick Install](#quick-install)
- [Why This Exists](#why-this-exists)
- [What's Included](#whats-included)
- [Studio Hierarchy](#studio-hierarchy)
- [Getting Started](#getting-started)
- [Demo Walkthrough](#demo-walkthrough)
- [Slash Commands — Quick Reference](#slash-commands--quick-reference)
- [How It Works](#how-it-works)
- [Security & Ethics](#security--ethics)
- [Project Structure](#project-structure)
- [Methodologies](#methodologies)
- [Tips for Best Results](#tips-for-best-results)

---

## What's Included

| Component | Count | Description |
|-----------|-------|-------------|
| **Agents** | 52 | Specialized security roles across 3 tiers |
| **Skills** | 80+ | Slash commands for every security workflow |
| **Hooks** | 6 | Lifecycle automation and scope enforcement |
| **Rules** | 5 | Path-scoped behavioral guidelines |
| **Templates** | 5+ | Professional report templates |
| **install.sh** | 1 | One-command installer for 50+ security tools |
| **Demo Walkthrough** | 1 | Step-by-step first engagement guide |

---

## Studio Hierarchy

```
🎖️  TIER 1 — DIRECTORS (Strategic)
├── 🔐 ciso                     Chief Information Security Officer
├── 🔴 red-team-director         Offensive Operations Command
└── 🔵 blue-team-director        Defensive Operations Command

🧑‍💼  TIER 2 — DEPARTMENT LEADS (Tactical)
├── pentest-lead                 Penetration Testing
├── soc-lead                     Security Operations Center
├── threat-intel-lead            Threat Intelligence
├── appsec-lead                  Application Security
├── cloud-security-lead          Cloud Security
├── grc-lead                     Governance, Risk & Compliance
├── incident-response-lead       Incident Response
└── devsecops-lead               DevSecOps

🔧  TIER 3 — SPECIALISTS (Operational)
Red Team: web-pentester, network-pentester, mobile-pentester,
          exploit-developer, reverse-engineer, osint-analyst,
          social-engineer, cloud-pentester, ctf-specialist,
          vuln-researcher, iot-security, api-pentester,
          wireless-pentester, bug-bounty-hunter, red-team-operator,
          phishing-specialist, binary-analyst

Blue Team: malware-analyst, forensics-analyst, soc-analyst,
           threat-hunter, ioc-analyst, siem-engineer,
           dfir-analyst, network-forensics-analyst,
           cloud-forensics-analyst

AppSec: appsec-engineer, code-auditor, sast-sca-engineer,
        crypto-analyst, ai-security-analyst

DevSecOps: devsecops-engineer, container-security

GRC: compliance-analyst, risk-analyst, policy-writer,
     awareness-trainer, report-writer, supply-chain-analyst

Intel: threat-actor-analyst, dark-web-analyst
```

---

## Getting Started

### Step 0: Install security tools (first time only)
```bash
chmod +x install.sh && ./install.sh
```

### Step 1: Open Claude Code in this directory
```bash
cd "Cyber Security Studios"
claude
```

### Step 2: Start the studio
```
/start
```

### Step 3: Define your engagement scope
```
/scope-define
```

### Step 4: Choose your workflow

| Goal | Commands |
|------|---------|
| Run a web pentest | `/osint-gather` → `/web-pentest` → `/pentest-report` |
| Incident response | `/ir-initiate` → `/forensics-collect` → `/post-mortem` |
| Threat hunting | `/hunt-hypothesis` → `/threat-hunt` → `/mitre-map` |
| Code security review | `/code-audit` → `/sast-scan` → `/dependency-check` |
| Cloud audit | `/cloud-audit` → `/iam-review` → `/cspm-check` |
| Compliance check | `/risk-assess` → `/compliance-check` → `/audit-prep` |
| Full red team | `/team-red` → [full operation] → `/pentest-report` |
| Purple team | `/team-red` + `/team-blue` → `/team-purple` |

---

## Demo Walkthrough

New to the studio? Follow the step-by-step guide for your first engagement:

**[docs/demo-walkthrough.md](docs/demo-walkthrough.md)**

The walkthrough covers:

| Step | Command | What Happens |
|------|---------|--------------|
| 1 | `./install.sh` | Install all 50+ security tools |
| 2 | `/start` | Load studio, activate agents |
| 3 | `/scope-define` | Define target scope and get CISO approval |
| 4 | `/osint-gather` | Passive recon — no traffic to target yet |
| 5 | `/subdomain-enum` | Enumerate all subdomains |
| 6 | `/attack-surface-map` | Build full external attack surface map |
| 7 | `/web-pentest` | Active web application testing |
| 8 | `/vuln-scorecard` | Score all findings with CVSS |
| 9 | `/pentest-report` | Generate professional deliverable |
| 10 | `/exec-summary` | Write C-suite executive summary |

Additional scenarios: Incident Response, Code Audit, Threat Hunt, Cloud Audit.

---

## Slash Commands — Quick Reference

Type `/` in Claude Code to access all skills:

| Category | Key Commands |
|----------|-------------|
| **Onboarding** | `/start` `/help` `/scope-define` |
| **Recon** | `/osint-gather` `/network-recon` `/attack-surface-map` |
| **Pentest** | `/web-pentest` `/network-pentest` `/mobile-pentest` `/api-pentest` `/cloud-pentest` |
| **Exploitation** | `/exploit-develop` `/priv-escalate` `/lateral-move` |
| **Malware** | `/malware-analyze` `/reverse-engineer` `/sandbox-report` |
| **Threat Intel** | `/threat-brief` `/ioc-extract` `/mitre-map` `/threat-actor-profile` |
| **SOC** | `/alert-triage` `/siem-rule-create` `/hunt-hypothesis` `/threat-hunt` |
| **Incident Response** | `/ir-initiate` `/containment-plan` `/forensics-collect` `/timeline-build` `/post-mortem` |
| **AppSec** | `/code-audit` `/sast-scan` `/dependency-check` `/threat-model` `/secure-review` |
| **Cloud Security** | `/cloud-audit` `/iam-review` `/k8s-security` `/cspm-check` |
| **GRC** | `/risk-assess` `/compliance-check` `/policy-draft` `/audit-prep` |
| **Reporting** | `/pentest-report` `/exec-summary` `/vuln-scorecard` `/remediation-plan` |
| **DevSecOps** | `/pipeline-secure` `/container-harden` `/secrets-audit` `/sbom-generate` |
| **Team Ops** | `/team-red` `/team-blue` `/team-purple` `/team-ir` `/team-appsec` |

---

## How It Works

### 1. CLAUDE.md is the Foundation
The `CLAUDE.md` file is automatically loaded by Claude Code and sets the studio context. It defines the agent hierarchy, available commands, ethical boundaries, and session lifecycle.

### 2. Agents Are Specialized Personas
Each `.claude/agents/` file defines a specialist with a specific role, model tier, tools, and escalation path. When you invoke an agent via a skill, Claude adopts that specialist's perspective and methodology.

### 3. Skills Are Structured Workflows
Each `.claude/skills/` file provides a step-by-step workflow for a specific security task. Skills invoke the right agents and provide command templates, output structures, and quality checklists.

### 4. Hooks Enforce Safety
- `validate-scope.sh` — Runs before every bash command, blocks dangerous operations
- `ethics-check.sh` — Runs on every prompt, reinforces ethical boundaries
- `session-start.sh` — Loads engagement context at session start
- `pre-compact.sh` — Saves state before context compaction

### 5. Rules Govern Behavior
Path-scoped rules in `.claude/rules/` automatically activate based on which directory you're working in, providing context-appropriate guidance.

---

## Security & Ethics

> ⚠️ **This studio is designed EXCLUSIVELY for legal, authorized security operations.**

- All operations validated against defined engagement scope
- No active testing without explicit written authorization
- Hook scripts block clearly dangerous/prohibited commands
- CISO agent provides ethical oversight and escalation authority
- All session activities logged for audit trail

**Permitted uses:**
- Authorized penetration testing (with signed scope)
- Security research on owned/lab systems
- CTF challenges and intentionally vulnerable systems
- Defensive operations (monitoring, detection, hardening)
- Compliance auditing and GRC work
- Security education and training

---

## Project Structure

```
Cyber Security Studios/
├── CLAUDE.md                          # Master config (auto-loaded)
├── README.md                          # This file
├── install.sh                         # One-command tool installer (50+ tools)
├── .claude/
│   ├── settings.json                  # Permissions + hooks config
│   ├── agents/
│   │   ├── tier1-directors/           # 3 CISO-level agents
│   │   ├── tier2-leads/               # 8 department leads
│   │   └── tier3-specialists/         # 41 specialist agents
│   ├── skills/                        # 80+ slash commands
│   │   ├── onboarding/
│   │   ├── recon/
│   │   ├── pentest/
│   │   ├── exploitation/
│   │   ├── malware/
│   │   ├── threat-intel/
│   │   ├── soc/
│   │   ├── incident-response/
│   │   ├── appsec/
│   │   ├── cloud-security/
│   │   ├── grc/
│   │   ├── reporting/
│   │   ├── devsecops/
│   │   └── team-ops/
│   ├── hooks/                         # Lifecycle automation
│   └── rules/                         # Behavioral guidelines
├── docs/
│   ├── demo-walkthrough.md            # Step-by-step first engagement guide
│   └── templates/                     # Report templates
├── engagements/                       # Active engagement workspaces
├── intelligence/                      # Threat intel database
├── lab/                               # Malware research (ISOLATED)
├── reports/                           # Completed deliverables
└── production/                        # Session state + engagement config
```

---

## Methodologies

This studio operates according to industry standards:

| Framework | Purpose |
|-----------|---------|
| **MITRE ATT&CK** | Tactic/technique mapping |
| **OWASP Top 10 / WSTG / ASVS** | Web security standards |
| **NIST CSF / 800-53** | Cyber Security framework |
| **ISO 27001/27002** | Information security management |
| **PTES** | Penetration testing execution standard |
| **CVSS v3.1** | Vulnerability severity scoring |
| **FAIR Model** | Quantitative risk analysis |
| **TIBER-EU** | Threat intelligence-based red teaming |

---

## Tips for Best Results

1. **Always run `/start` first** — Loads context and validates scope
2. **Define scope before testing** — `/scope-define` protects you legally
3. **Use `/help`** — Full command reference always available
4. **Follow the workflow** — Skills are designed to chain together naturally
5. **Document everything** — All findings go in `engagements/[name]/`
6. **Escalate uncertainties** — If in doubt, ask the CISO agent

---

*Claude Code Cyber Security Studios — Professional Security Operations, AI-Augmented*  
*Inspired by Claude Code Game Studios by Donchitos*
