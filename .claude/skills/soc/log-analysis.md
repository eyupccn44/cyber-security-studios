# /log-analysis — Security Log Analysis & Investigation

```
Use agent: soc-analyst
Coordinate with: soc-lead, siem-engineer, threat-hunter
```

## Purpose

Perform structured, hypothesis-driven security log analysis to identify malicious activity, reconstruct attack timelines, correlate events across multiple sources, and produce actionable intelligence from raw log data — across Windows Event Logs, Linux syslogs, web access logs, firewall logs, and cloud audit trails.

## Pre-Execution Check

- [ ] Log sources identified and accessible
- [ ] Log retention period confirmed (sufficient for investigation timeframe)
- [ ] SIEM access or raw log files available
- [ ] Investigation scope defined (timeframe, assets, users)

## Analysis Framework

### Step 1: Log Source Inventory

| Log Source | Location | Retention | Coverage |
|------------|----------|-----------|----------|
| Windows Security Events | Windows Event Log | 90 days | Auth, process, account |
| Sysmon | Windows Event Log | 90 days | Process, network, file |
| Linux auth.log | /var/log/auth.log | 30 days | SSH, sudo, PAM |
| Web Access Logs | /var/log/nginx/ | 30 days | HTTP requests |
| Firewall Logs | SIEM | 180 days | Network flows |
| DNS Logs | SIEM | 90 days | Query patterns |
| Cloud Audit | CloudTrail/Azure Monitor | 90 days | API calls |

### Step 2: Authentication Log Analysis

```bash
# Linux — Failed SSH login attempts
grep "Failed password" /var/log/auth.log | \
  awk '{print $11}' | sort | uniq -c | sort -rn | head -20

# Linux — Successful logins
grep "Accepted password\|Accepted publickey" /var/log/auth.log | \
  awk '{print $1,$2,$3,$9,$11}' > auth/successful-logins.txt

# Linux — Sudo usage
grep "sudo:" /var/log/auth.log | grep "COMMAND" | \
  awk '{print $1,$2,$3,$5,$8,$9,$NF}' > auth/sudo-commands.txt

# Windows PowerShell — Event ID 4625 (Failed logon)
# KQL (Sentinel):
SecurityEvent
| where EventID == 4625
| summarize FailedAttempts = count() by Account, IpAddress, bin(TimeGenerated, 1h)
| where FailedAttempts > 10
| order by FailedAttempts desc

# Windows — Successful logon (Event ID 4624)
# Watch for LogonType 3 (Network) and 10 (RemoteInteractive/RDP)
```

### Step 3: Process Execution Analysis

```bash
# Sysmon Event ID 1 — Process creation
# Hunt for suspicious parent-child relationships
# KQL:
Event
| where Source == "Microsoft-Windows-Sysmon"
| where EventID == 1
| extend parsed = parse_xml(EventData)
| where ParentImage endswith "winword.exe" and
        (Image endswith "cmd.exe" or Image endswith "powershell.exe")
| project TimeGenerated, Computer, Image, CommandLine, ParentImage

# Hunt for encoded PowerShell (Base64)
grep -i "encodedcommand\|-enc\|-e " windows-events.log | \
  grep "powershell"

# Linux — Unusual process spawning
ausearch -m execve -ts recent | grep -v "^----" | \
  awk '/proctitle=/{print}' | head -50

# Check crontab modifications
grep "CRON" /var/log/syslog | grep -v "CMD" | tail -100
```

### Step 4: Network Log Analysis

```bash
# Web access log — identify scanning activity
awk '{print $1}' /var/log/nginx/access.log | sort | uniq -c | sort -rn | head -20

# Find 404 storms (directory scanning)
awk '$9 == 404' /var/log/nginx/access.log | \
  awk '{print $1}' | sort | uniq -c | sort -rn | head -20

# Large data transfers (potential exfiltration)
awk '{print $1, $10}' /var/log/nginx/access.log | \
  awk '{ip=$1; bytes+=$2} END {for (ip in bytes) print bytes[ip], ip}' | \
  sort -rn | head -20

# DNS analysis — identify C2 communication patterns
# High frequency queries to same domain = beaconing
# Long domain names = DNS tunneling
awk '{print $5}' /var/log/dns.log | sort | uniq -c | sort -rn | head -50

# Detect DNS tunneling (unusually long queries)
awk 'length($5) > 60 {print $5}' /var/log/dns.log | sort -u

# Firewall — identify port scanning
awk '{print $9, $1}' firewall.log | sort | uniq -c | sort -rn | head -20
```

### Step 5: Cloud Audit Log Analysis

```bash
# AWS CloudTrail — suspicious API calls
# High-value events to watch:
# - ConsoleLogin (especially from new IP)
# - CreateUser, AttachUserPolicy (privilege escalation)
# - GetSecretValue (secrets access)
# - StopLogging (CloudTrail tampering)

aws logs filter-log-events \
  --log-group-name "CloudTrail/DefaultLogGroup" \
  --filter-pattern "{ $.eventName = \"ConsoleLogin\" && $.responseElements.ConsoleLogin = \"Failure\" }"

# Azure Monitor — suspicious sign-ins
# KQL (Log Analytics):
SigninLogs
| where ResultType != 0  // Failed sign-ins
| summarize FailedAttempts = count() by UserPrincipalName, IPAddress, bin(TimeGenerated, 1h)
| where FailedAttempts > 10
```

### Step 6: Log Correlation & Timeline

```bash
# Build unified timeline from multiple sources
# Merge and sort by timestamp
cat auth/successful-logins.txt network/connections.txt process/executions.txt | \
  sort -k1,3 > investigation/unified-timeline.txt

# Tag events by severity
python3 - << 'EOF'
import re
with open('investigation/unified-timeline.txt') as f:
    for line in f:
        if any(kw in line.lower() for kw in ['admin', 'sudo', 'root', 'secret']):
            print(f"[HIGH] {line.strip()}")
        elif any(kw in line.lower() for kw in ['failed', 'denied', 'blocked']):
            print(f"[MEDIUM] {line.strip()}")
        else:
            print(f"[INFO] {line.strip()}")
EOF
```

## Output

```
investigations/[incident-id]/logs/
├── auth/
│   ├── failed-logins.txt
│   └── successful-logins.txt
├── process/
│   └── suspicious-executions.txt
├── network/
│   └── suspicious-connections.txt
└── timeline/
    └── unified-timeline.txt     ← Feed to /timeline-build
```

Escalate confirmed threats to `/ir-initiate`. Convert detection patterns to `/siem-rule-create`.
