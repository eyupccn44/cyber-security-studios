# /start — Initialize Cybersecurity Studios Session

Invoke the **ciso** agent to begin a structured security session.

```
Use agent: ciso
```

## What This Does

This skill initializes the Cybersecurity Studios environment for a new engagement or work session. The CISO agent will:

1. **Check for active engagement scope** — Is there a `production/active-engagement.md` file?
2. **If scope exists**: Brief you on the current engagement status and available commands
3. **If no scope**: Walk you through defining the engagement scope

## Session Initialization Checklist

- [ ] Review `production/active-engagement.md` (or prompt to create one)
- [ ] Confirm all operations are within authorized scope
- [ ] Display available skills relevant to current engagement type
- [ ] Identify which agents are needed for today's objectives

## Output

The CISO will present:
- Current engagement name and status
- Engagement type (pentest, red team, SOC, GRC audit, etc.)
- Today's recommended workflow
- Available team members (agents) for this engagement
- Key risks or constraints to keep in mind

## Next Steps After `/start`

| Engagement Type | Recommended Next Command |
|----------------|-------------------------|
| Penetration Test | `/scope-define` → `/osint-gather` |
| Red Team | `/scope-define` → `/team-red` |
| Incident Response | `/ir-initiate` |
| Threat Hunt | `/hunt-hypothesis` |
| Code Audit | `/code-audit` |
| Compliance | `/compliance-check` |

---
*Always run `/start` at the beginning of each Claude Code session.*
