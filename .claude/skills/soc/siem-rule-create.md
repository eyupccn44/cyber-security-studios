# /siem-rule-create — Create SIEM Detection Rule

```
Use agent: siem-engineer
Coordinate with: soc-lead, threat-hunter (validation)
```

## Purpose

Design, test, and deploy a new SIEM detection rule for a specific threat technique or behavior.

## Rule Development Process

### Step 1: Define the Detection Goal
```
Technique: [MITRE ATT&CK technique, e.g., T1059.001]
Behavior: [What exactly are we detecting?]
Data Source: [Windows Events / Sysmon / EDR / Proxy / DNS]
Expected False Positives: [Known legitimate behavior that might match]
```

### Step 2: Write Sigma Rule (Universal Format)

```yaml
title: [Descriptive Detection Name]
id: [Generate UUID: python3 -c "import uuid; print(uuid.uuid4())"]
status: experimental   # experimental → test → production
description: |
  Detects [specific malicious behavior].
  Attackers use this to [achieve what goal].
author: siem-engineer
date: YYYY/MM/DD
references:
  - https://attack.mitre.org/techniques/TXXXX/
  - [Other reference]
tags:
  - attack.[tactic_name]
  - attack.tXXXX[.XXX]
logsource:
  category: process_creation   # or: network_connection, file_event, etc.
  product: windows
detection:
  selection:
    Image|endswith:
      - '\malicious.exe'
    CommandLine|contains:
      - 'suspicious_string'
  filter_legitimate:
    Image|endswith:
      - '\legitimate_tool.exe'
  condition: selection and not filter_legitimate
falsepositives:
  - [Known false positive scenario 1]
  - [Known false positive scenario 2]
level: high   # informational / low / medium / high / critical
```

### Step 3: Convert to Platform Query

```bash
# Convert Sigma to KQL (Microsoft Sentinel)
sigma convert -t microsoft365defender sigma-rule.yml

# Convert to SPL (Splunk)
sigma convert -t splunk sigma-rule.yml

# Convert to EQL (Elastic)
sigma convert -t eql sigma-rule.yml
```

### Step 4: KQL Example (Microsoft Sentinel)

```kql
// T1059.001 — PowerShell Encoded Command
DeviceProcessEvents
| where FileName =~ "powershell.exe"
| where ProcessCommandLine has_any ("-EncodedCommand", "-enc ", "-e ")
| where not(InitiatingProcessFileName has_any ("sccm.exe", "ccmexec.exe"))
| project Timestamp, DeviceName, AccountName, 
          ProcessCommandLine, InitiatingProcessFileName
| order by Timestamp desc
```

### Step 5: Testing

```bash
# Test against known-good data
# → Run query on last 30 days of logs
# → Count results and review each for FPs

# Test against known-bad data (if available)
# → Run against logs from red team exercise
# → Confirm rule fires on known malicious activity

# Tune thresholds / exclusions based on results
```

### Step 6: Deployment Checklist

- [ ] Rule reviewed by soc-lead
- [ ] False positive rate < 10% tested over 7 days
- [ ] Alert severity appropriate
- [ ] Alert contains enough context for analyst triage
- [ ] Analyst runbook created for this alert
- [ ] Sigma rule saved in `intelligence/sigma-rules/`

## Output

Rule deployed to SIEM + Sigma rule saved to `intelligence/sigma-rules/[DATE]-[rule-name].yml`
