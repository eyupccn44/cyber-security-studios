# /threat-brief — Produce Threat Intelligence Brief

```
Use agent: threat-intel-lead
Input from: ioc-analyst, osint-analyst
```

## Purpose

Produce an actionable threat intelligence brief for a specific threat scenario, industry sector, threat actor, or time period.

## Brief Types

| Type | Audience | Length | Frequency |
|------|----------|--------|-----------|
| Flash Alert | All staff | 1 page | As needed (critical threats) |
| Weekly Threat Digest | Security team | 2-3 pages | Weekly |
| Monthly Threat Landscape | CISO/Management | 4-6 pages | Monthly |
| Threat Actor Profile | Red/Blue teams | 5-10 pages | Per actor |
| Pre-Engagement Brief | Pentest team | 3-5 pages | Per engagement |

## Flash Alert Template

```markdown
# 🚨 THREAT ALERT — [Threat Name]

**Severity**: CRITICAL / HIGH / MEDIUM
**Date**: [ISO date]
**Analyst**: [Name]

## What is Happening
[2-3 sentences: what threat, who is targeting whom]

## Are We At Risk?
[Yes/No/Unknown — with brief rationale]

## Immediate Actions Required
1. [Most urgent action]
2. [Second action]
3. [Third action]

## Technical Indicators (IOCs)
| Type | Value | Confidence |
|------|-------|-----------|
| IP | 1.2.3.4 | High |
| Domain | malicious.com | High |
| Hash | abc123... | Medium |

## MITRE ATT&CK
- TA0001: Initial Access — T1566.001 (Spearphishing)
- TA0003: Persistence — T1053.005 (Scheduled Task)

## Additional Resources
- [CVE link if applicable]
- [CISA advisory if applicable]
```

## Threat Intelligence Brief Structure (Full)

```
1. EXECUTIVE SUMMARY (non-technical, 1 paragraph)
2. THREAT OVERVIEW (who, what, why)
3. THREAT ACTOR ANALYSIS (if attributed)
4. TARGETED SECTORS / VICTIMOLOGY
5. ATTACK METHODOLOGY (TTPs mapped to ATT&CK)
6. INDICATORS OF COMPROMISE
7. DEFENSIVE RECOMMENDATIONS
8. DETECTION OPPORTUNITIES (SIEM rules, hunt hypotheses)
9. REFERENCES & SOURCES
```

## Output

`intelligence/briefs/[DATE]-[THREAT-NAME]-brief.md`

Push IOCs to ioc-analyst for enrichment and distribution.
Push detection opportunities to soc-lead / siem-engineer.
