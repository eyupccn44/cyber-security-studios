# SOC Rules — Path-Scoped Rules for SOC Operations
# Applied at all times during SOC mode

## SOC Operating Rules

### Alert Triage Standards
- All alerts must be triaged within SLA (P1: 5min, P2: 15min, P3: 60min, P4: 4hr)
- Never close an alert as FP without documenting the reason
- When uncertain: escalate, don't guess
- All triaged alerts must have verdict AND evidence documented

### Investigation Standards
- Document EVERY step of investigation (who, what, when, why)
- Collect at least 3 independent data points before confirming True Positive
- IOCs must be enriched (VirusTotal, AbuseIPDB) before sharing
- Do not share raw customer data in external enrichment without approval

### Escalation Rules
- P1 Incident: Notify incident-response-lead AND blue-team-director IMMEDIATELY
- P2 Incident: Notify incident-response-lead within 30 minutes
- Any suspected data breach: CISO notification required (regulatory timeline)
- Never contain/isolate a system without incident-response-lead approval

### Evidence Preservation
- Do NOT reboot or modify a suspected compromised system before IR lead approval
- Log all queries run during investigation with timestamps
- Screenshot evidence at time of discovery (logs rotate / systems may be isolated)

### Communication Rules
- All incident communications through official channels (not personal messaging)
- Incident details not discussed outside war room until authorized
- External communications (press, vendors, regulators) via CISO only
