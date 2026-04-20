# /team-ir — Activate Incident Response Team

```
Use agent: incident-response-lead
Notify: blue-team-director, ciso (P1/P2)
```

## Purpose

Rapidly mobilize the incident response team when a security incident is declared or suspected.

## Activation Triggers

Activate immediately for:
- Active malware / ransomware on any system
- Confirmed unauthorized access to systems
- Suspected or confirmed data breach
- Ongoing DDoS attack affecting operations
- Insider threat activity
- Any P1 or P2 security event

## Team Mobilization

```
INCIDENT COMMANDER: incident-response-lead
│
├── TECHNICAL LEAD
│   ├── forensics-analyst   → Evidence preservation, disk/memory forensics
│   └── malware-analyst     → Malware identification and analysis
│
├── INTELLIGENCE LEAD
│   ├── ioc-analyst         → IOC extraction and enrichment
│   └── threat-intel-lead   → Threat actor attribution
│
├── DETECTION/HUNTING
│   ├── threat-hunter       → Find related/persistent attacker activity
│   └── siem-engineer       → Real-time detection rule deployment
│
└── COMMUNICATIONS
    ├── report-writer       → Stakeholder updates, timeline documentation
    └── ciso                → Executive and external communications
```

## IR War Room Setup

```
Communications channel: [Dedicated Slack/Teams channel: #ir-[DATE]-[ID]]
Video bridge: [Link for all-hands calls]
Ticket/case: [IR-YYYY-MM-DD-NNN created in ticketing system]
Document drive: engagements/IR-[DATE]-[ID]/

WAR ROOM GROUND RULES:
- All findings documented in real-time
- No action on affected systems without IC approval
- Evidence preserved before any remediation
- External communications via CISO only
- Regular all-hands every 2 hours (P1), 4 hours (P2)
```

## Immediate Actions Checklist (First 30 Minutes)

- [ ] Incident declared and severity assigned (P1-P4)
- [ ] War room established
- [ ] Incident ticket created
- [ ] Team assembled and roles assigned
- [ ] Affected systems identified
- [ ] Evidence preservation started (`/forensics-collect`)
- [ ] Initial containment decision made
- [ ] CISO notified (P1/P2)
- [ ] Legal notified (data breach suspected)

## Containment Options (IC Decision Required)

| Option | When | Impact |
|--------|------|--------|
| Network isolation | Active lateral movement | High disruption |
| Account disable | Compromised account | Low disruption |
| Process kill | Malware active | Medium disruption |
| System shutdown | Last resort | High disruption + evidence loss |

## Next Skills to Run

```
/forensics-collect   → Preserve evidence before changes
/containment-plan    → Develop and execute containment
/malware-analyze     → If malware involved
/timeline-build      → Reconstruct attack sequence
/post-mortem         → After incident resolved
```
