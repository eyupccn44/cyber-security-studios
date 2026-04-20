# /containment-plan — Develop Incident Containment Strategy

```
Use agent: incident-response-lead
Approve: blue-team-director (for major containment actions)
```

## Purpose

Develop and execute a containment strategy that stops active attacker progress while preserving forensic evidence and minimizing business disruption.

## Containment Decision Matrix

| Threat Status | Business Impact Tolerance | Recommended Containment |
|--------------|--------------------------|------------------------|
| Active attack, spreading | Low tolerance | Immediate hard isolation |
| Active attack, contained | Medium | Targeted isolation + monitoring |
| Post-breach, no active threat | Any | Evidence preservation first, then eradication |
| Unknown status | — | Monitor + soft containment |

## Containment Options (Ordered by Disruption)

### Option A: Monitoring Only (Lowest Disruption)
- Enhance logging on affected systems
- Deploy EDR forensic collection
- Monitor for further attacker activity
- **Use when**: Attack appears complete, attribution/scope still unclear

### Option B: Network Isolation (Targeted)
```bash
# Windows — block specific IPs at firewall
netsh advfirewall firewall add rule name="Block C2" dir=out \
    action=block remoteip=C2_IP_HERE

# Linux — iptables block
iptables -A OUTPUT -d $C2_IP -j DROP
iptables -A INPUT -s $C2_IP -j DROP

# Network — VLAN isolation (coordinate with network team)
# Move affected host to quarantine VLAN
```

### Option C: Account Disable (Credential Compromise)
```powershell
# Disable compromised AD account
Disable-ADAccount -Identity $USERNAME

# Reset password and force re-authentication
Set-ADAccountPassword -Identity $USERNAME -Reset \
    -NewPassword (ConvertTo-SecureString "NewStr0ngP@ss!" -AsPlainText -Force)
Revoke-ADAccountTrust -Identity $USERNAME  # Purge Kerberos tickets

# If service account: rotate secret in vault immediately
```

### Option D: Full Network Isolation (Maximum Containment)
```bash
# Physical network disconnect / firewall block all traffic
# This is irreversible until business approves reconnection
# EVIDENCE IS STILL PRESERVED (RAM/disk)
# Document exact time of isolation
```

### Option E: System Shutdown (Last Resort)
> ⚠️ **THIS DESTROYS VOLATILE EVIDENCE**
> Only use if: system is actively spreading ransomware / wiper malware
> Document timestamp and reason before shutdown

## Evidence Preservation Before Containment

Run `/forensics-collect` BEFORE any containment action:
- RAM dump (most volatile — lost on reboot/isolation)
- Network connection snapshot
- Running process list
- File system timestamp snapshot

## Containment Execution Plan

```markdown
## Containment Plan — IR-[ID]

**Decision Made by**: [IR Lead + Blue Team Director]
**Decision Time**: [ISO timestamp]
**Approved by**: [CISO if P1]

### Systems to Contain
| System | Method | Time | Executed By |
|--------|--------|------|-------------|
| HOST-001 | Network isolation | [time] | [analyst] |
| svc-account-x | Account disable | [time] | [analyst] |

### Business Impact
- Services affected: [list]
- Duration estimate: [hours]
- Stakeholders notified: [list]

### Rollback Plan
- Criteria for reconnection: [specific conditions]
- Reconnection approval required from: [CISO / management]
```

## Post-Containment Validation

- [ ] Attacker activity has stopped (no new alerts)
- [ ] Lateral movement paths blocked
- [ ] C2 communication severed (confirmed via proxy/firewall logs)
- [ ] Evidence preserved intact
- [ ] Business stakeholders updated on status
