# /ir-initiate — Initiate Security Incident Response

```
Use agent: incident-response-lead
Notify: blue-team-director, ciso (P1/P2)
```

## Purpose

Formally declare a security incident and initiate the Incident Response process. This skill establishes incident command and kicks off structured response operations.

## Immediate Actions (First 15 Minutes)

### Step 1: Incident Declaration
Answer these questions to classify the incident:

```
1. How was the incident detected?
   → Alert, external report, user report, threat hunt

2. What systems are potentially affected?
   → List hostnames, IPs, services

3. What type of incident is this?
   → Ransomware | Data Breach | Unauthorized Access | 
     Malware | Insider Threat | DDoS | Phishing | Other

4. What is the current status?
   → Active attack in progress | Attack completed | Unknown

5. Has any data been exfiltrated?
   → Confirmed | Suspected | Unknown | No
```

### Step 2: Severity Classification

| Level | Criteria | Response |
|-------|----------|----------|
| **P1 - Critical** | Active ransomware, confirmed breach, data exfiltration | War room NOW, CISO + legal immediately |
| **P2 - High** | Confirmed compromise, significant exposure | IR team engaged < 1 hour |
| **P3 - Medium** | Suspected compromise, contained malware | Investigation < 4 hours |
| **P4 - Low** | Security anomaly, policy violation | Next business day |

### Step 3: Notifications

**P1/P2 Notifications (immediate):**
- [ ] Incident Response Lead (you)
- [ ] Blue Team Director
- [ ] CISO
- [ ] Legal Counsel
- [ ] (If data breach) Data Protection Officer / KVKK Officer

### Step 4: Create Incident Record

Creates `engagements/IR-[YYYY-MM-DD]-[INCIDENT-ID]/`:
```
IR-2024-01-15-001/
├── incident-overview.md      # This file (continuously updated)
├── timeline.md               # Attack timeline (minute-by-minute)
├── affected-assets.md        # Systems, users, data involved
├── evidence/                 # Forensic artifacts
├── iocs.md                   # Indicators of Compromise
└── communications/           # Stakeholder updates
```

## Containment Decision Framework

```
Is the threat still active?
├── YES → Immediate isolation required
│         Options: Network isolation | Account disable | System shutdown
│         ⚠️ Consult with ciso BEFORE shutdown (business impact)
└── NO  → Evidence preservation mode
          Do NOT disturb systems until forensics-collect runs
```

## Next Steps After /ir-initiate

1. `/forensics-collect` — Preserve evidence before any changes
2. `/containment-plan` — Develop containment strategy
3. `/timeline-build` — Begin attack timeline construction
4. `/malware-analyze` — If malware is involved
5. `/ioc-extract` — Extract indicators for detection
6. `/post-mortem` — After incident is resolved
