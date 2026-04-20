# /hunt-hypothesis — Develop Threat Hunt Hypothesis

```
Use agent: threat-hunter
Input from: threat-intel-lead (TTP intelligence)
```

## Purpose

Develop a well-structured, intelligence-driven hypothesis for a proactive threat hunt before executing `/threat-hunt`.

## Hypothesis Template

```
HYPOTHESIS:
"If [threat actor / malware family / vulnerability class] is/was present 
in our environment, we would expect to observe [specific indicator/behavior] 
in [data source] because [reasoning based on known TTPs]."

EXAMPLE:
"If a ransomware operator (e.g., Black Basta) has initial access, we 
would expect to observe PowerShell downloading a Cobalt Strike stager 
from an external host in Windows Event Logs and EDR telemetry, because 
their documented initial access TTPs (T1059.001) involve PowerShell-based 
staged payloads."
```

## Hypothesis Sources

### 1. Threat Intelligence Driven
- Recent threat actor activity in your sector
- Active campaigns from CISA/FBI alerts
- New malware family TTPs
- Partner/ISAC intelligence sharing

### 2. Alert-Driven
- Anomalous alerts that didn't fire a full incident
- Patterns noticed in low-severity alerts
- "Near miss" detections

### 3. Red Team Results
- Techniques red team used that weren't detected
- "Where else could they have gone if we missed them?"

### 4. ATT&CK Coverage Gap
- Review your ATT&CK detection coverage heatmap
- Select an undetected technique you're exposed to
- Build hypothesis around that technique

## Hypothesis Quality Checklist

- [ ] Specific threat actor or technique named
- [ ] Specific observable behavior defined (not vague)
- [ ] Specific data source identified (where to look)
- [ ] Reasoning is sound (why would this behavior appear here?)
- [ ] Time window defined (last 7 days? 30 days? 90 days?)
- [ ] Success/failure criteria defined

## Hypothesis Document Format

```markdown
## Hunt Hypothesis: [Short Name]

**ID**: HUNT-[YYYY-MM-DD]-[NNN]
**Created by**: threat-hunter
**Date**: [date]
**MITRE Technique**: T[XXXX].[XXX]
**Priority**: High / Medium / Low

### Hypothesis Statement
[Full hypothesis statement from template above]

### Data Sources Required
- [ ] [Data source 1] — available / gap
- [ ] [Data source 2] — available / gap

### Hunt Queries (Draft)
[Initial query ideas — refined during /threat-hunt execution]

### Success Criteria
- FOUND: [What constitutes finding a threat]
- NOT FOUND: [What constitutes a clean result]
- DATA GAP: [If data is insufficient to conclude]

### Time Window
[Date range to hunt over]
```

## Output

`intelligence/hunts/HUNT-[DATE]-[NNN]/hypothesis.md`
Then proceed with `/threat-hunt` to execute.
