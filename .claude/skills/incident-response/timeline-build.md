# /timeline-build — Build Incident Attack Timeline

```
Use agent: forensics-analyst
Coordinate with: incident-response-lead
```

## Purpose

Reconstruct a chronological attack timeline from forensic artifacts and logs to understand the full scope and sequence of the incident.

## Data Sources for Timeline

| Source | Data | Tool |
|--------|------|------|
| Windows Event Logs | Authentication, process creation, network | Hayabusa, Chainsaw, Evtx_Dump |
| Sysmon logs | Detailed process, network, file events | Hayabusa |
| EDR telemetry | Full execution trace | Platform UI |
| Firewall logs | Network connections | grep/awk |
| Proxy logs | HTTP/HTTPS traffic | grep/awk |
| SIEM | Correlated alerts | Platform UI |
| Memory dump | Running processes at time of capture | Volatility3 |
| File system | Created/modified/accessed timestamps | Plaso, log2timeline |

## Timeline Construction

### Step 1: Normalize All Log Sources
```bash
# Plaso — super timeline (normalize all sources to single timeline)
log2timeline.py --storage-file incident.plaso /path/to/evidence/

# Export to CSV for analysis
psort.py -o l2tcsv -w timeline.csv incident.plaso

# Or use Hayabusa for Windows event logs (faster)
hayabusa csv-timeline -d /path/to/evtx/ -o timeline.csv -p verbose
```

### Step 2: Filter to Relevant Timeframe
```bash
# Filter timeline to incident window
grep "2024-01-15 1[4-9]:\|2024-01-15 2[0-3]:" timeline.csv > incident-window.csv

# Focus on high-value event types
grep -E "4624|4625|4688|4698|4720|4732|7045|1|3|11|17" incident-window.csv
```

### Step 3: Key Event Types to Map

**Windows Event IDs:**
| ID | Event | Significance |
|----|-------|-------------|
| 4624 | Successful logon | Track attacker movement |
| 4625 | Failed logon | Brute force attempts |
| 4648 | Explicit credential logon | PtH/lateral movement |
| 4688 | Process creation | Malware execution |
| 4698 | Scheduled task created | Persistence |
| 4720 | User account created | Backdoor account |
| 4732 | Member added to group | Privilege escalation |
| 7045 | New service installed | Persistence |

**Sysmon Event IDs:**
| ID | Event |
|----|-------|
| 1 | Process creation (with hash) |
| 3 | Network connection |
| 11 | File created |
| 13 | Registry value set |
| 22 | DNS query |

### Step 4: Attack Timeline Document

```markdown
## Incident Timeline: IR-[ID]

**Incident Type**: [Type]
**First Indicator**: [ISO timestamp]
**Last Activity**: [ISO timestamp]
**Total Duration**: [X hours Y minutes]

### Timeline

| Timestamp (UTC) | Source | Event | Significance |
|----------------|--------|-------|-------------|
| 2024-01-15 14:23:01 | Firewall | Inbound connection from 1.2.3.4:443 to web server | First external connection |
| 2024-01-15 14:23:05 | IIS Log | POST /upload.php 200 — 45.2KB | File upload |
| 2024-01-15 14:23:11 | Sysmon:1 | cmd.exe spawned from w3wp.exe | Webshell execution |
| 2024-01-15 14:24:00 | Sysmon:3 | powershell.exe → 5.6.7.8:443 | C2 beacon |
| 2024-01-15 14:35:22 | Event:4624 | Lateral movement to DC01 | Internal spread |
| 2024-01-15 15:01:00 | Sysmon:11 | 45GB file created + Sysmon:3 to cloud | Exfiltration |
```

## Output

`engagements/IR-[ID]/timeline.md` — Complete attack timeline

Used for:
- Post-mortem root cause analysis
- Legal/regulatory reporting
- Client executive briefing
- Lessons learned
