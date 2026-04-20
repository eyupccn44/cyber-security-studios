# /threat-hunt — Execute Proactive Threat Hunt

```
Use agent: threat-hunter
Coordinate with: soc-lead, siem-engineer
```

## Purpose

Execute a structured, intelligence-driven threat hunting mission to find adversaries that have evaded automated detection.

## Hunt Prerequisites

- [ ] Hunt hypothesis defined (use `/hunt-hypothesis` first)
- [ ] Relevant data sources available and accessible
- [ ] Log retention sufficient for the hunt timeframe
- [ ] Baseline behavior established for anomaly detection

## Hunt Execution Framework

### Step 1: Hypothesis Statement
```
Template:
"[Threat Actor/Technique] uses [Specific Behavior] — 
I expect to find evidence of [Observable Artifact] 
in [Data Source] because [Reasoning]"

Example:
"Ransomware operators use PowerShell for lateral movement — 
I expect to find encoded PowerShell commands with network 
activity in Windows Event Logs and EDR telemetry because 
LockBit 3.0 TTPs show this pattern (MITRE T1059.001)"
```

### Step 2: Data Source Identification

| Hunt Type | Data Sources |
|-----------|-------------|
| Persistence | Windows Event Log 4698/4702 (scheduled tasks), registry autorun |
| C2 | DNS query logs, proxy logs, firewall flows |
| Credential Theft | LSASS access events, Windows Event 4624 type patterns |
| Lateral Movement | Network authentication logs, SMB activity |
| Data Staging | Large file creation/compression events |
| Exfiltration | Outbound flow anomalies, cloud upload events |

### Step 3: Hunt Queries

#### KQL (Microsoft Sentinel/Defender)
```kql
// Hunt: Unusual process spawning Office apps
DeviceProcessEvents
| where InitiatingProcessFileName in~ ("winword.exe", "excel.exe", "outlook.exe")
| where FileName in~ ("cmd.exe", "powershell.exe", "wscript.exe", "mshta.exe")
| where Timestamp > ago(7d)
| project Timestamp, DeviceName, InitiatingProcessFileName, FileName, ProcessCommandLine
| order by Timestamp desc
```

#### SPL (Splunk)
```spl
index=windows EventCode=4688
| where ParentImage LIKE "%office%" AND Image LIKE "%powershell%"
| table _time, ComputerName, ParentImage, Image, CommandLine
| sort -_time
```

### Step 4: Results Analysis

For each anomaly found:
1. **Document**: What was found, where, when
2. **Pivot**: Expand investigation from finding
3. **Assess**: Is this malicious, benign, or unknown?
4. **Escalate**: If malicious → `/ir-initiate`

### Step 5: Hunt Closure

**Outcome A: Threat Found**
→ Escalate to incident-response-lead immediately
→ Document all artifacts as evidence
→ Run `/ir-initiate`

**Outcome B: No Threat Found**
→ Document negative result (valuable intelligence)
→ Hand off hypothesis to siem-engineer as detection rule
→ Record hunt in hunt log

## Hunt Output

```
intelligence/hunts/hunt-[DATE]-[HYPOTHESIS-ID]/
├── hypothesis.md
├── queries.md          # All queries used
├── results.md          # Findings and analysis
├── outcome.md          # Threat found / Not found / Data gap
└── detection-rule.md   # If converting to permanent detection
```
