# /threat-landscape — Sector Threat Landscape Assessment

```
Use agent: threat-actor-analyst
Coordinate with: threat-intel-lead, risk-analyst
```

## Purpose

Produce a comprehensive, intelligence-driven threat landscape assessment for a specific industry sector or organization — identifying the most relevant threat actors, their TTPs, targeted vulnerabilities, and historical campaign patterns to inform defensive prioritization.

## Pre-Execution Check

- [ ] Target sector and geography defined
- [ ] Time period for assessment defined (e.g., last 12 months)
- [ ] Intelligence sources available (open source + any commercial feeds)
- [ ] Output audience identified (technical team / executive / board)

## Assessment Framework

### Step 1: Sector Profile

```markdown
## Target Sector Analysis

**Industry**: [Finance / Healthcare / Energy / Manufacturing / Government / etc.]
**Geographic Focus**: [Region/Country]
**Assessment Period**: [YYYY-MM-DD to YYYY-MM-DD]
**Organization Size**: [Enterprise / Mid-market / SMB]
**Key Digital Assets**:
- Customer PII database
- Financial systems (SWIFT/ACH)
- Intellectual property
- OT/ICS infrastructure (if applicable)
- Cloud infrastructure
```

### Step 2: Threat Actor Identification

```markdown
## Active Threat Actors — [Sector]

### Nation-State Actors
| Actor | Origin | Motivation | Recent Activity | Targets Our Sector |
|-------|--------|------------|-----------------|-------------------|
| APT28 (Fancy Bear) | Russia | Espionage | 2025: EU Finance targeting | Yes |
| Lazarus Group | DPRK | Financial gain | 2025: Crypto heists | Possibly |
| APT41 | China | IP theft + Revenue | 2025: Healthcare data | Sector-relevant |

### Financially Motivated Groups
| Group | Type | Revenue Model | Active | Notes |
|-------|------|---------------|--------|-------|
| LockBit 3.0 | Ransomware-as-a-Service | Ransom + Data extortion | Yes | Top threat |
| BlackCat/ALPHV | Ransomware | Triple extortion | Yes | Sophisticated |
| Scattered Spider | BEC + Ransomware | Social engineering | Yes | English-speaking |

### Hacktivists
| Group | Motivation | Methods | Relevance |
|-------|------------|---------|-----------|
| Anonymous Sudan | Political/Religious | DDoS, data leaks | Moderate |
| KillNet | Pro-Russia | DDoS | Low-Moderate |
```

### Step 3: TTP Analysis (MITRE ATT&CK)

```markdown
## Most Used TTPs in [Sector] — Last 12 Months

### Initial Access (TA0001)
| Technique | ID | Frequency | Actors |
|-----------|----|-----------|--------|
| Phishing | T1566 | Very High | All groups |
| Valid Accounts | T1078 | High | APT41, Scattered Spider |
| Exploit Public-Facing App | T1190 | High | APT28, ransomware groups |
| Supply Chain Compromise | T1195 | Medium | APT41, APT29 |

### Execution (TA0002)
| Technique | ID | Frequency |
|-----------|----|-----------|
| PowerShell | T1059.001 | Very High |
| Windows Management Instrumentation | T1047 | High |
| Command and Scripting Interpreter | T1059 | Very High |

### Persistence (TA0003)
| Technique | Frequency |
|-----------|-----------|
| Scheduled Task (T1053) | Very High |
| Registry Run Keys (T1547.001) | High |
| Web Shell (T1505.003) | Medium |

### Impact (TA0040)
| Technique | ID | Notes |
|-----------|----|-------|
| Data Encrypted for Impact | T1486 | Ransomware primary |
| Data Exfiltration | T1041 | Pre-encryption |
| Financial Theft | T1657 | BEC campaigns |
```

### Step 4: Vulnerability Intelligence

```markdown
## Most Exploited Vulnerabilities — [Sector] [Year]

| CVE | Product | CVSS | Exploited By | Patch Available | Your Exposure |
|-----|---------|------|--------------|-----------------|---------------|
| CVE-2023-27997 | FortiGate SSL-VPN | 9.8 | APT28, ransomware | Yes | [ ] Check |
| CVE-2023-46805 | Ivanti Connect Secure | 8.2 | UNC5325 | Yes | [ ] Check |
| CVE-2024-3400 | PAN-OS | 10.0 | UTA0218 | Yes | [ ] Check |
| CVE-2021-44228 | Log4j | 10.0 | Multiple | Yes | [ ] Check |
```

### Step 5: Recent Campaigns & Incidents

```markdown
## Notable Campaigns — [Sector] [Last 12 Months]

### Campaign: [Name/Code]
- **Date**: YYYY-MM-DD
- **Attribution**: [Threat Actor]
- **Method**: [Initial access → lateral movement → impact]
- **Affected Organizations**: [Number/type — anonymized if needed]
- **Data Compromised**: [Type]
- **Relevant TTPs**: T1190, T1059, T1486
- **Key Takeaway**: [What defenders should know]
```

### Step 6: Risk Prioritization Matrix

```markdown
## Top 5 Threats — Prioritized for [Organization]

| Rank | Threat | Likelihood | Impact | Risk Level | Primary Mitigation |
|------|--------|------------|--------|------------|-------------------|
| 1 | Business Email Compromise | Very High | High | CRITICAL | MFA, DMARC, user training |
| 2 | Ransomware (RaaS) | High | Very High | CRITICAL | Backup, EDR, patching |
| 3 | Phishing → Credential Theft | Very High | Medium | HIGH | MFA, security awareness |
| 4 | Supply Chain Attack | Medium | Very High | HIGH | Vendor assessment, SCA |
| 5 | Insider Threat | Low | High | MEDIUM | DLP, PAM, monitoring |
```

## Output

```
intelligence/threat-landscape/
└── [sector]-threat-landscape-[YYYY-QN].md
```

Brief to `risk-analyst` for risk register update. Present via `/exec-summary` to executive team. Feed to `siem-engineer` for detection gap analysis.
