# Incident Response Report Template

**CONFIDENTIAL**

---

# Security Incident Report
## Incident ID: IR-[YYYY-MM-DD]-[NNN]
## Severity: P[1-4]

| | |
|---|---|
| **Incident Commander** | [Name] |
| **Date Declared** | YYYY-MM-DD HH:MM UTC |
| **Date Resolved** | YYYY-MM-DD HH:MM UTC |
| **Total Duration** | [X hours Y minutes] |
| **Report Date** | YYYY-MM-DD |
| **Classification** | CONFIDENTIAL |

---

## Executive Summary

**Incident Type:** [Ransomware | Data Breach | Unauthorized Access | Malware | DDoS | Other]

[2-3 paragraph summary covering:
- What happened (non-technical)
- What data/systems were affected
- How it was detected and resolved
- Business impact
- Key actions being taken to prevent recurrence]

---

## Impact Assessment

| Impact Category | Details |
|----------------|---------|
| **Systems Affected** | [List] |
| **Users Affected** | [Number / None confirmed] |
| **Data Affected** | [Type, volume / None confirmed] |
| **Service Downtime** | [Duration / None] |
| **Financial Impact** | [Estimate / Under assessment] |
| **Regulatory Notification Required** | Yes / No / TBD |

---

## Incident Timeline

| Timestamp (UTC) | Event | Actor |
|-----------------|-------|-------|
| YYYY-MM-DD HH:MM | Initial indicator (first sign of compromise) | [Attacker/System] |
| YYYY-MM-DD HH:MM | Alert fired in SIEM | [SIEM Rule Name] |
| YYYY-MM-DD HH:MM | Alert triaged and escalated | [Analyst Name] |
| YYYY-MM-DD HH:MM | Incident declared P[X] | [IC Name] |
| YYYY-MM-DD HH:MM | War room established | [Team] |
| YYYY-MM-DD HH:MM | Affected systems identified | [List] |
| YYYY-MM-DD HH:MM | Containment action: [describe] | [Team] |
| YYYY-MM-DD HH:MM | Eradication completed | [Team] |
| YYYY-MM-DD HH:MM | Recovery initiated | [Team] |
| YYYY-MM-DD HH:MM | All-clear declared | [IC] |

---

## Root Cause Analysis

### Primary Root Cause
[Single sentence identifying the fundamental cause]

### 5 Whys Analysis
1. **Why** did the incident occur? → [Answer]
2. **Why** did [answer 1] happen? → [Answer]
3. **Why** did [answer 2] happen? → [Answer]
4. **Why** did [answer 3] happen? → [Answer]
5. **Why** did [answer 4] happen? → **Root Cause: [Root cause]**

### Contributing Factors
- [Factor 1]
- [Factor 2]

---

## Indicators of Compromise

| Type | Indicator | Confidence |
|------|-----------|-----------|
| IP Address | 1.2.3.4 | High |
| Domain | evil.com | High |
| File Hash (SHA256) | abc123... | High |
| Registry Key | HKLM\...\malware | Medium |

---

## Response Actions Taken

| Phase | Action | Outcome |
|-------|--------|---------|
| Containment | Network isolation of [host] | Stopped lateral movement |
| Eradication | Removed [malware] from [systems] | Complete |
| Recovery | Restored from backup dated [date] | Complete |
| Hardening | Patched [CVE-XXXX] | Complete |

---

## Lessons Learned

### What Went Well
- [Positive 1]
- [Positive 2]

### What Could Be Improved
- [Improvement 1]
- [Improvement 2]

---

## Action Items

| # | Action | Owner | Priority | Due Date |
|---|--------|-------|----------|----------|
| 1 | [Action] | [Owner] | High | [Date] |

---

## Response Metrics

| Metric | Actual | Target | Gap |
|--------|--------|--------|-----|
| MTTD | X hours | 1 hour | [±] |
| MTTR | X hours | 4 hours | [±] |
| Data Loss | [None/Amount] | None | — |
