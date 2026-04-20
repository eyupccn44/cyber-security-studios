# /exec-summary — Write Executive Summary

```
Use agent: report-writer
Review: ciso (before delivery)
```

## Purpose

Produce a concise, non-technical executive summary that communicates security risk clearly to CISO/CEO/Board-level stakeholders.

## Executive Summary Principles

1. **Lead with business impact** — not technical details
2. **Maximum 2 pages** — executives won't read more
3. **Traffic light risk rating** — immediate visual risk communication
4. **Quantify where possible** — "$X risk exposure" beats "high risk"
5. **3 clear recommendations** — focused, actionable, prioritized

## Template

```markdown
# Executive Summary
## [Client Name] — [Assessment Type]
**Date**: [date] | **Classification**: CONFIDENTIAL

---

## Overall Security Posture

> 🔴 HIGH RISK — Immediate action required

[Alternative ratings:]
> 🟠 ELEVATED RISK — Priority remediation needed within 30 days
> 🟡 MODERATE RISK — Planned improvement required
> 🟢 ACCEPTABLE RISK — Minor improvements recommended

---

## Assessment Overview

[Organization name] engaged [Studio] to conduct a [assessment type] 
between [dates]. The assessment [brief scope description].

---

## Key Findings

### Most Critical Finding
**[Finding Title]** — [One sentence business impact]

> An attacker could [specific impact, e.g., "access the payment 
> database and exfiltrate all customer credit card records"] by 
> [brief how, e.g., "exploiting an unauthenticated SQL injection 
> vulnerability in the customer portal"].

**Business Risk**: [Revenue impact / regulatory exposure / reputational damage]

---

## Risk Summary

| | Critical | High | Medium | Low |
|--|---------|------|--------|-----|
| **Findings** | N | N | N | N |

[2-3 sentences interpreting what these numbers mean for the business — 
not just a count but what it means: "The N critical findings represent 
immediate risk of data breach or system compromise if exploited."]

---

## Strategic Recommendations

1. **[Most Urgent]** — [What to do, who owns it, when]
2. **[Second Priority]** — [What to do, who owns it, when]  
3. **[Structural Improvement]** — [Longer-term recommendation]

---

## Positive Observations

[1-3 things the organization does well — important for balanced perspective]
- [Positive 1]
- [Positive 2]

---

## Next Steps

| Action | Owner | Timeline |
|--------|-------|----------|
| Address critical findings | [Engineering Lead] | 7 days |
| Review full technical report | [Security Team] | 3 days |
| Schedule remediation verification | [Security Team] | 30 days |
```

## Writing Quality Checklist

- [ ] No unexplained acronyms or jargon
- [ ] Every finding has a business impact statement
- [ ] Recommendations are specific (who, what, when)
- [ ] Overall risk rating is justified
- [ ] Positive observations included (not only negatives)
- [ ] Reviewed by ciso before delivery
- [ ] Length: 1-2 pages maximum
