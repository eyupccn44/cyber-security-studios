# /team-blue — Assemble Blue Team for Defensive Operations

```
Use agent: blue-team-director
Mobilize: soc-lead + relevant specialists
```

## Purpose

Activate the defensive team for monitoring, detection, and response operations.

## Team Assembly by Mission Type

**Active Monitoring (Steady State SOC):**
```
blue-team-director
└── soc-lead
    ├── soc-analyst × N (shift coverage)
    ├── siem-engineer (rule tuning)
    └── ioc-analyst (threat feed management)
```

**Active Incident Response:**
```
blue-team-director
└── incident-response-lead (incident command)
    ├── forensics-analyst (evidence)
    ├── malware-analyst (if malware involved)
    ├── threat-hunter (hunt for related activity)
    └── ioc-analyst (IOC extraction)
```

**Threat Hunting Campaign:**
```
blue-team-director
└── soc-lead
    ├── threat-hunter (primary)
    ├── siem-engineer (query support)
    └── threat-intel-lead (intelligence-driven hypotheses)
```

**Detection Improvement Sprint:**
```
blue-team-director
└── soc-lead
    ├── siem-engineer (rule writing)
    ├── threat-hunter (validation testing)
    └── threat-intel-lead (TTP selection)
```

## Blue Team Activation Checklist

- [ ] Confirm SIEM is operational and ingesting all critical log sources
- [ ] Verify EDR coverage across all endpoints
- [ ] Confirm alerting channels are functional (email, Slack, PagerDuty)
- [ ] Review active threat intelligence feed status
- [ ] Confirm IR runbooks are accessible and current
- [ ] Ensure all analysts know escalation procedures

## Steady-State Monitoring Priorities

| Priority | Activity | Frequency |
|----------|----------|-----------|
| P1 | Critical/High alert triage | Real-time |
| P2 | Threat hunt hypothesis execution | Weekly |
| P3 | Detection rule review and tuning | Monthly |
| P4 | Threat intelligence consumption | Daily |
| P5 | Incident lessons learned review | Post-incident |

## Key Performance Indicators

Track and report to blue-team-director:
- Alerts processed (daily)
- True positive rate (weekly)
- MTTD and MTTR (monthly)
- ATT&CK detection coverage percentage (monthly)
- Open incidents and age (daily)
