# /executive-brief — Executive Security Briefing

```
Use agent: report-writer
Coordinate with: ciso, risk-analyst
```

## Purpose

Produce a concise, non-technical executive security briefing — communicating current threat landscape, organizational risk posture, recent incidents, and strategic security decisions to C-suite executives and board members in 10 minutes or less.

## Pre-Execution Check

- [ ] Audience level defined (CEO / CFO / Board / Full Executive Team)
- [ ] Time period covered (monthly / quarterly / ad hoc)
- [ ] Key messages from recent engagements identified
- [ ] Metrics and KPIs compiled

## Briefing Structure

### Slide/Section 1: Security Posture Summary (30 seconds)

```markdown
## Security Posture — [Month Year]

Overall Status: 🟡 MODERATE RISK

| Domain | Status | Trend |
|--------|--------|-------|
| Infrastructure Security | 🟡 Moderate | ↑ Improving |
| Application Security | 🔴 Elevated | → Stable |
| Identity & Access | 🟢 Strong | ↑ Improving |
| Third-Party Risk | 🟡 Moderate | ↓ Worsening |
| Incident Response Readiness | 🟢 Strong | → Stable |

**Key Message**: [One sentence summary for executives]
```

### Slide/Section 2: Top 3 Threats This Month (1 minute)

```markdown
## Top Threats Relevant to Our Business

### 1. Ransomware Targeting [Industry Sector]
**What happened**: [Brief — 1 sentence]
**Impact to us**: [Are we exposed? What controls do we have?]
**Action taken/needed**: [What we're doing about it]

### 2. Credential Phishing Campaign
**What happened**: [Brief — 1 sentence]
**Impact to us**: [Specific relevance]
**Action taken/needed**: [Countermeasure]

### 3. Critical Vulnerability in [Product We Use]
**CVE**: [CVE-XXXX-XXXXX] — CVSS 9.8
**Impact to us**: [Exposed? Already patched?]
**Action taken/needed**: [Patch status]
```

### Slide/Section 3: Incidents & Near-Misses (1 minute)

```markdown
## This Period's Incidents

| Date | Incident | Severity | Status | Business Impact |
|------|----------|----------|--------|-----------------|
| MM-DD | Phishing email clicked by 3 users | Medium | Resolved | No data loss |
| MM-DD | Unauthorized login attempt blocked | Low | Resolved | None |

**Key takeaway**: [What this tells us about our risk level]

## Near-Misses (What We Stopped)
- [N] phishing emails blocked before reaching inboxes
- [N] malware downloads blocked by EDR
- [N] suspicious logins blocked by MFA
```

### Slide/Section 4: Metrics Dashboard (1 minute)

```markdown
## Key Security Metrics — [Quarter]

### Vulnerability Management
| Metric | Current | Last Period | Target |
|--------|---------|-------------|--------|
| Critical vulns unpatched > 7 days | 2 | 5 | 0 |
| High vulns unpatched > 30 days | 8 | 12 | < 5 |
| Mean time to patch (critical) | 4.2 days | 6.8 days | < 3 days |

### Threat Detection
| Metric | Current | Last Period | Target |
|--------|---------|-------------|--------|
| Mean time to detect (MTTD) | 47 min | 3.2 hours | < 1 hour |
| Mean time to respond (MTTR) | 2.1 hours | 4.8 hours | < 4 hours |
| False positive rate | 12% | 18% | < 10% |

### Security Awareness
| Metric | Current | Last Period | Target |
|--------|---------|-------------|--------|
| Phishing simulation click rate | 8% | 14% | < 5% |
| Security training completion | 87% | 72% | 95% |
```

### Slide/Section 5: Strategic Decisions Needed (2 minutes)

```markdown
## Decisions Required from Leadership

### Decision 1: [Title] — Deadline: [Date]
**Context**: [Brief background in 2 sentences]
**Options**:
- Option A: [Action] — Cost: $X, Risk reduction: High
- Option B: [Action] — Cost: $Y, Risk reduction: Medium
- Option C: Do nothing — Cost: $0, Risk: High (quantified)
**Recommendation**: Option A
**What happens if we delay**: [Specific consequence]

### Decision 2: [Title]
[Same format]
```

### Slide/Section 6: Budget & Investment Update (1 minute)

```markdown
## Security Investment Summary

| Initiative | Budget | Spent | Status | ROI/Benefit |
|------------|--------|-------|--------|-------------|
| EDR Deployment | $120K | $95K | 80% complete | Estimated 3 incidents prevented |
| Security Awareness Training | $30K | $30K | Complete | Phishing rate -43% |
| Cloud Security Posture (CSPM) | $50K | $12K | In progress | 47 misconfigs identified |
| Penetration Testing (Q1) | $40K | $40K | Complete | 18 findings, 12 remediated |
```

### Slide/Section 7: Next Period Priorities (30 seconds)

```markdown
## Next 90 Days — Focus Areas

1. **Zero Trust Architecture**: Roll out MFA to remaining 200 endpoints
2. **Vendor Security**: Complete Tier-1 vendor assessments (3 remaining)
3. **Incident Response**: Annual tabletop exercise (scheduled MM-DD)
4. **Application Security**: Remediate 2 critical findings from pentest
```

## Delivery Tips

- Lead with business impact, not technical details
- Never use acronyms without defining them first
- Use dollar figures when possible (not "high severity" but "estimated $2M exposure")
- Prepare 3 backup slides with technical details if questions arise
- Keep to time — executives have compressed schedules

## Output

```
reports/executive-briefs/
└── executive-brief-[YYYY-MM].md
```

Present to executive team. Archive alongside board meeting minutes. Full technical details available in `/pentest-report` if requested.
