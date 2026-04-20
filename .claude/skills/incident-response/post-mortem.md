# /post-mortem — Post-Incident Review

```
Use agent: incident-response-lead
Participants: All incident responders, affected team leads
Timeline: Within 5-10 business days of incident closure
```

## Purpose

Conduct a blameless post-incident review to identify root causes, assess response effectiveness, and drive continuous improvement.

## Blameless Culture

> Post-mortems are about **learning**, not blame.
> The goal is to understand how the system (not the person) failed.
> All participants should feel safe sharing what went wrong.

## Post-Mortem Structure

### Section 1: Incident Summary
```
Incident ID: IR-[YYYY-MM-DD]-[NNN]
Severity: P[1-4]
Duration: [Start] → [End] = [Total time]
Affected Systems: [List]
Impact: [Users affected, data involved, business impact]
Incident Commander: [Name]
Lead Investigators: [Names]
```

### Section 2: Detailed Timeline

Document **minute-by-minute** what happened:
```
[DATETIME] → Initial alert fired (SIEM rule: X)
[DATETIME] → SOC analyst triaged alert, escalated to IR lead
[DATETIME] → Incident declared P2, war room opened
[DATETIME] → Affected systems identified: [list]
[DATETIME] → Containment action taken: [network isolation]
[DATETIME] → Malware identified as [family]
[DATETIME] → Eradication completed
[DATETIME] → Systems restored from backup
[DATETIME] → Monitoring enhanced, all-clear declared
```

### Section 3: Root Cause Analysis

Use **5 Whys** methodology:

```
WHY did the incident occur?
→ Ransomware was deployed on a server

WHY was ransomware deployed?
→ Attacker gained access via unpatched RDP vulnerability (CVE-XXXX)

WHY was RDP vulnerable?
→ Server was missed in the monthly patching cycle

WHY was it missed?
→ Asset inventory didn't include this server (shadow IT)

WHY wasn't it in inventory?
→ No process for discovering new/unauthorized assets

ROOT CAUSE: No automated asset discovery process exists
```

### Section 4: What Went Well

Acknowledge positives to reinforce good practices:
- "SOC analyst escalated within 8 minutes of initial alert"
- "Incident Commander made containment decision without delay"
- "Backups were viable and recovery was complete in 2 hours"

### Section 5: What Went Wrong

Be specific and factual (not blaming):
- "Initial alert was correlated 3 hours after first indicator"
- "No runbook existed for this malware family"
- "Legal notification process was unclear — 45 min delay"

### Section 6: Action Items

| # | Action | Owner | Priority | Due Date | Status |
|---|--------|-------|----------|----------|--------|
| 1 | Implement automated asset discovery | IT Ops | High | 30 days | Open |
| 2 | Create ransomware response runbook | IR Lead | High | 14 days | Open |
| 3 | Clarify legal notification SLA | Legal + CISO | Medium | 7 days | Open |
| 4 | Add detection rule for initial access vector | SIEM Eng | High | 7 days | Open |

### Section 7: Detection & Response Metrics

| Metric | This Incident | Target | Gap |
|--------|--------------|--------|-----|
| MTTD (detection) | 3h 15min | < 1h | -2h 15min |
| MTTR (response) | 8h 45min | < 4h | -4h 45min |
| Containment time | 2h 30min | < 2h | -30min |
| Recovery time | 4h | < 6h | ✅ |

## Output

`engagements/IR-[ID]/post-mortem.md` — Shared with:
- CISO (full report)
- blue-team-director (operational learnings)
- All incident responders (team distribution)
- (Optionally) Client stakeholders (summary version)
