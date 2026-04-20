# /threat-actor-profile — Profile a Specific Threat Actor

```
Use agent: threat-intel-lead
Input from: ioc-analyst, osint-analyst
```

## Purpose

Build a comprehensive threat actor profile for a specific APT, ransomware group, or criminal actor to support threat-informed defense.

## Profile Template

```markdown
## Threat Actor Profile: [Name]

**Profile ID**: TA-[YYYY-NNN]
**Classification**: Nation-State APT / Cybercriminal / Hacktivist / Insider
**Confidence**: High / Medium / Low
**Last Updated**: [date]
**Analyst**: threat-intel-lead

---

### Identity

| Field | Detail |
|-------|--------|
| **Primary Name** | [Most common name] |
| **Aliases** | [All known names — MITRE, vendor names] |
| **Attribution** | [Country/organization if known] |
| **Attribution Confidence** | High / Medium / Low / Unknown |
| **Active Since** | [Year] |
| **Current Status** | Active / Inactive / Disrupted |

### Motivation

- [ ] Espionage (government, military, IP theft)
- [ ] Financial (ransomware, fraud, theft)
- [ ] Disruption (sabotage, destruction)
- [ ] Hacktivism (ideological)

### Targeting

**Primary Sectors**:
- [Sector 1, e.g., Financial Services]
- [Sector 2]

**Primary Regions**:
- [Region/Country 1]
- [Region/Country 2]

**Typical Victim Profile**:
[Description of typical targets — size, type, characteristics]

---

### Tactics, Techniques, and Procedures (TTPs)

#### MITRE ATT&CK Enterprise Profile

| Tactic | Technique | ID | Notes |
|--------|-----------|-----|-------|
| Initial Access | Spearphishing Attachment | T1566.001 | Office macros |
| Initial Access | Valid Accounts | T1078 | Stolen credentials |
| Execution | PowerShell | T1059.001 | Encoded commands |
| Persistence | Registry Run Keys | T1547.001 | |
| Defense Evasion | Obfuscated Files | T1027 | Base64 encoding |
| Credential Access | LSASS Memory | T1003.001 | Mimikatz |
| Lateral Movement | PsExec | T1021.002 | |
| C2 | Web Protocols | T1071.001 | HTTPS to CDN |
| Exfiltration | Exfil Over C2 | T1041 | |

#### Known Tooling

| Tool | Type | Description |
|------|------|-------------|
| [Tool Name] | RAT/Loader/Framework | [Brief description] |
| Cobalt Strike | Framework | Often used post-compromise |

---

### Infrastructure

**C2 Characteristics**:
- [Protocol, e.g., HTTPS with JA3: abc123]
- [Hosting providers commonly used]
- [Domain registration patterns]

**Network IOCs** (recent, high confidence):
| Type | Value | Confidence | Date |
|------|-------|-----------|------|
| IP | 1.2.3.4 | High | [date] |
| Domain | evil.com | High | [date] |

---

### Malware Families

| Malware | Role | Notes |
|---------|------|-------|
| [Name] | Initial access / Loader / RAT | [Brief behavior] |

---

### Detection Opportunities

| Opportunity | Technique | Detection Method |
|------------|-----------|-----------------|
| Phishing macro delivery | T1566.001 | Email filtering, macro policy |
| PowerShell encoded | T1059.001 | Event 4103/4104, AMSI |
| LSASS access | T1003.001 | Sysmon Event 10 |

---

### Intelligence Sources

- [MITRE ATT&CK Group page URL]
- [Vendor reports]
- [Government advisories]
- [ISACs]
```

## Output

`intelligence/actors/[ACTOR-NAME]-profile-[DATE].md`

Share with:
- soc-lead → update detection rules for actor TTPs
- pentest-lead → use for threat-actor-based red team simulation
- blue-team-director → defensive prioritization
