# /vuln-scorecard — Vulnerability Scorecard Report

```
Use agent: report-writer
Coordinate with: pentest-lead, risk-analyst
```

## Purpose

Generate a structured, metrics-driven vulnerability scorecard that communicates the overall security posture to both technical and executive audiences using visual risk ratings, trend data, and prioritized remediation sequencing.

## Pre-Execution Check

- [ ] All findings documented and severity-rated (CVSS v3.1)
- [ ] Retesting results available (if applicable)
- [ ] Previous scorecard available for trend comparison (if repeat engagement)
- [ ] Client remediation SLAs defined

## Scorecard Generation Process

### Step 1: Findings Inventory

Compile all findings into a master register:

```markdown
| ID | Title | Severity | CVSS | Status | Component | Owner |
|----|-------|----------|------|--------|-----------|-------|
| F-001 | SQL Injection — Login | Critical | 9.8 | Open | /api/auth | Backend Team |
| F-002 | Hardcoded API Key | High | 8.2 | Open | mobile-app | Mobile Team |
| F-003 | Missing HSTS Header | Medium | 5.3 | Open | web-app | DevOps |
| F-004 | Verbose Error Pages | Low | 3.1 | Open | web-app | Backend Team |
```

### Step 2: Risk Score Calculation

**Overall Risk Score (0–100):**

```
Score = 100 - (
  (Critical × 15) +
  (High × 8) +
  (Medium × 3) +
  (Low × 1)
)
Minimum score: 0
```

**Risk Rating:**

| Score | Rating | Color |
|-------|--------|-------|
| 90–100 | Excellent | 🟢 Green |
| 75–89 | Good | 🟡 Yellow |
| 50–74 | Moderate | 🟠 Orange |
| 25–49 | Poor | 🔴 Red |
| 0–24 | Critical | ⛔ Dark Red |

### Step 3: Severity Distribution Chart

```markdown
## Vulnerability Distribution

Critical  ████████████ 3  (15%)
High      ████████████████████ 5  (25%)
Medium    ████████████████████████████ 7  (35%)
Low       ████████ 2  (10%)
Info      ████ 1  (5%)
──────────────────────────────────────
Total     18 Findings
```

### Step 4: Category Breakdown

```markdown
| Category | Critical | High | Medium | Low | Total |
|----------|----------|------|--------|-----|-------|
| Injection | 2 | 1 | 0 | 0 | 3 |
| Authentication | 1 | 2 | 1 | 0 | 4 |
| Configuration | 0 | 1 | 3 | 1 | 5 |
| Cryptography | 0 | 1 | 2 | 1 | 4 |
| Authorization | 0 | 0 | 1 | 0 | 1 |
```

### Step 5: Remediation Priority Matrix

```markdown
## Fix Priority (Risk × Effort)

IMMEDIATE (< 24h): Critical findings
├── F-001: SQL Injection — Login endpoint
└── F-002: Hardcoded API Key in mobile binary

SHORT-TERM (< 1 week): High findings
├── F-005: Broken Object Level Authorization
├── F-006: JWT Algorithm Confusion
└── F-007: Stored XSS — Comment Field

MEDIUM-TERM (< 1 month): Medium findings
└── [All Medium severity]

LONG-TERM (Next cycle): Low / Informational
└── [All Low / Info]
```

### Step 6: Trend Comparison (Repeat Engagements)

```markdown
| Metric | Previous | Current | Δ |
|--------|----------|---------|---|
| Total Findings | 24 | 18 | -6 ✅ |
| Critical | 5 | 3 | -2 ✅ |
| High | 8 | 5 | -3 ✅ |
| Risk Score | 42 | 61 | +19 ✅ |
| Remediation Rate | — | 75% | — |
```

## Output

```
reports/[engagement-id]/
└── vuln-scorecard-[DATE].md    ← This document
```

Deliver alongside `/pentest-report` and `/exec-summary` for complete reporting package.
