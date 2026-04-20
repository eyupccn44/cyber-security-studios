# /team-purple — Purple Team Exercise

```
Use agent: red-team-director + blue-team-director (joint command)
Full team: pentest-lead, soc-lead, threat-intel-lead
```

## Purpose

Run a collaborative purple team exercise where red and blue teams work together to improve detection and response capabilities in real-time.

## Purple Team Philosophy

> Unlike traditional red team (adversarial), purple team is **collaborative**.
> Red executes a technique → Blue tries to detect it → Both learn → Detection improves.
> The goal is **detection coverage improvement**, not finding who "wins".

## Exercise Format

### Option A: Hands-on-Keyboard (Recommended)
Red and blue work together in real-time:
1. Red announces: "I'm executing technique [T1059.001] in 5 minutes"
2. Blue prepares to detect
3. Red executes technique
4. Blue checks if detection fired
5. If no detection: Blue writes new rule on the spot
6. Repeat with next technique

### Option B: Atomic Test Execution
Use Atomic Red Team library for structured testing:
```bash
# Install Atomic Red Team
Install-Module -Name invoke-atomicredteam

# Execute specific technique
Invoke-AtomicTest T1059.001 -TestNumbers 1
```

### Option C: Attack Scenario Replay
Blue watches while Red executes full attack chain:
- Red documents every action with exact commands/timestamps
- Blue reviews detections vs red team actions
- Gap analysis: What was missed? Why?

## Exercise Structure

```
PRE-EXERCISE (1 hour)
├── Agree on scope (which ATT&CK techniques)
├── Define success metrics
├── Ensure logging is capturing relevant data
└── Document current detection coverage baseline

EXECUTION (4-8 hours)
├── Execute techniques (atomic or scenario-based)
├── Real-time detection checking
├── Immediate rule writing for gaps
└── Document results per technique

POST-EXERCISE (2 hours)
├── Coverage report: What did we detect? What did we miss?
├── Rule quality assessment
├── Priority list for detection improvements
└── Schedule follow-up test for fixed detections
```

## MITRE ATT&CK Coverage Tracking

Track per technique:
| Technique | ID | Executed | Detected | Rule Quality | Action |
|-----------|-----|----------|----------|-------------|--------|
| PowerShell Execution | T1059.001 | ✅ | ✅ | Medium | Tune threshold |
| Credential Dumping | T1003.001 | ✅ | ❌ | None | Write rule |
| Scheduled Task | T1053.005 | ✅ | ✅ | High | No action |

## Deliverable

`reports/purple-team-[DATE]/`
- ATT&CK coverage heatmap (before vs after)
- Detection rules written/improved
- Remaining detection gaps
- Recommended next exercise focus areas
