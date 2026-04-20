# /alert-triage — Triage Security Alert

```
Use agent: soc-analyst
Escalate to: incident-response-lead (if P1/P2 confirmed)
```

## Purpose

Rapidly investigate an incoming security alert to determine if it is a true positive, false positive, or benign true positive — and take appropriate action.

## Triage Decision Flow

```
ALERT RECEIVED
     ↓
1. READ alert details (source, rule name, affected asset, time)
2. CHECK if known false positive (exclusion list, recent change)
     ├── YES → Close as FP, document suppression reason
     └── NO  → Continue investigation
3. GATHER context (5W: Who, What, Where, When, Why)
4. ENRICH IOCs (IPs, domains, hashes)
5. ASSESS severity
6. DECIDE action
```

## Context Gathering (5W Framework)

| Question | Where to Look |
|----------|--------------|
| **WHO** — Which user/account? | AD logs, authentication logs |
| **WHAT** — What happened exactly? | Raw logs, EDR telemetry |
| **WHERE** — Which host/network? | Asset inventory, network topology |
| **WHEN** — Timeline of events | Log timestamps, correlation |
| **WHY** — Is there a legitimate reason? | Change calendar, user activity |

## IOC Enrichment Steps

```bash
# IP Reputation
curl "https://api.abuseipdb.com/api/v2/check?ipAddress=$IP" -H "Key: $API_KEY"
# → Also check: VirusTotal, GreyNoise, Shodan

# Domain reputation
curl "https://www.virustotal.com/api/v3/domains/$DOMAIN" -H "x-apikey: $VT_KEY"

# File hash lookup
curl "https://www.virustotal.com/api/v3/files/$HASH" -H "x-apikey: $VT_KEY"
```

## Common Alert Scenarios

### Malware Alert (EDR)
1. Identify process: name, path, parent process, command line
2. Hash lookup: VirusTotal, MalwareBazaar
3. Check persistence: registry, scheduled tasks, services
4. Check network: outbound connections to C2?
5. Verdict: Isolate host if confirmed malicious

### Brute Force Alert (Auth)
1. Count: How many failures? Over what period?
2. Target: Single account or multiple?
3. Source: Single IP or distributed?
4. Outcome: Any successful logins after failures?
5. Action: Block IP, lock account if needed

### Data Exfiltration Alert (DLP/Proxy)
1. Volume: How much data? Normal baseline?
2. Destination: Known business service or suspicious?
3. User: Normal behavior for this user?
4. Content: What type of data was transferred?
5. Action: Block/quarantine if confirmed sensitive data

## Escalation Triggers

Escalate to incident-response-lead when:
- [ ] Confirmed malware on endpoint
- [ ] Successful authentication after brute force
- [ ] Data exfiltration to suspicious destination
- [ ] Lateral movement indicators
- [ ] Multiple alerts correlated to single attack

## Ticket Documentation

```
Alert: [Alert Name]
Time: [Timestamp]
Asset: [Hostname/IP]
User: [Account]
Verdict: [True Positive / False Positive / Benign TP]
Evidence: [Key log lines, screenshots]
Actions Taken: [Blocked IP / Isolated host / Escalated]
Analyst: [Your ID]
```
