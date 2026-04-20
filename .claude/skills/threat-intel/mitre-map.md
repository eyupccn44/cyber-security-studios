# /mitre-map — Map TTPs to MITRE ATT&CK

```
Use agent: threat-intel-lead
Input from: pentest findings, malware analysis, threat intel
```

## Purpose

Map observed or discovered Tactics, Techniques, and Procedures (TTPs) to the MITRE ATT&CK framework to provide structured context for findings and improve detection coverage.

## When to Use This Skill

- After a penetration test (map attack techniques used)
- During malware analysis (map malware capabilities)
- After a threat hunt (map observed threat actor behavior)
- During threat intelligence production (profile threat actor TTPs)
- For purple team planning (select techniques to test)

## ATT&CK Mapping Process

### Step 1: Collect Behaviors

Document observed behaviors in plain language:
```
Examples:
- "Attacker used spearphishing email with malicious attachment"
- "PowerShell was used to download and execute payload"
- "Mimikatz was run to dump LSASS credentials"  
- "Attacker moved laterally using PsExec"
- "Data was compressed using WinRAR before exfiltration"
```

### Step 2: Map to ATT&CK

| Observed Behavior | Tactic | Technique | Sub-Technique |
|------------------|--------|-----------|---------------|
| Spearphishing with attachment | Initial Access | T1566 | T1566.001 |
| PowerShell download/execute | Execution | T1059 | T1059.001 |
| LSASS memory dump (Mimikatz) | Credential Access | T1003 | T1003.001 |
| PsExec lateral movement | Lateral Movement | T1021 | T1021.002 |
| WinRAR data compression | Collection | T1560 | T1560.001 |

### Step 3: ATT&CK Navigator Visualization

Generate layer file for ATT&CK Navigator:
```json
{
  "name": "Engagement TTPs",
  "versions": {"attack": "14", "navigator": "4.9"},
  "domain": "enterprise-attack",
  "techniques": [
    {"techniqueID": "T1566.001", "score": 1, "color": "#ff6666"},
    {"techniqueID": "T1059.001", "score": 1, "color": "#ff6666"},
    {"techniqueID": "T1003.001", "score": 1, "color": "#ff6666"}
  ]
}
```
→ Import at: https://mitre-attack.github.io/attack-navigator/

### Step 4: Detection Gap Analysis

For each mapped technique, check:
- Do we have a detection rule for this?
- Did our existing rule fire during the engagement?
- If no → add to detection backlog for siem-engineer

## Output

`intelligence/mitre-maps/[ENGAGEMENT]-attack-map.json`

Includes:
- ATT&CK Navigator layer file
- Technique descriptions and context
- Current detection coverage per technique
- Detection gap recommendations
