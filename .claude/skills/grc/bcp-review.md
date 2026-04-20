# /bcp-review — Business Continuity Plan Review & Testing

```
Use agent: risk-analyst
Coordinate with: grc-lead, incident-response-lead
```

## Purpose

Review, assess, and improve an organization's Business Continuity Plan (BCP) and Disaster Recovery Plan (DRP) — evaluating completeness, accuracy, testability, and alignment with business objectives and regulatory requirements (ISO 22301, NIST SP 800-34).

## Pre-Execution Check

- [ ] Current BCP/DRP documents obtained (latest version)
- [ ] Key stakeholders identified for interviews
- [ ] Last test date and results reviewed
- [ ] Regulatory BCP requirements applicable to organization identified

## Review Framework

### Step 1: Business Impact Analysis (BIA) Verification

```markdown
## BIA Completeness Check

| Business Function | RTO Target | RPO Target | In BCP | Tested |
|-------------------|------------|------------|--------|--------|
| Core Banking / Payment Processing | 4h | 1h | [ ] | [ ] |
| Customer Data Access | 8h | 4h | [ ] | [ ] |
| Email/Communications | 24h | 8h | [ ] | [ ] |
| HR Systems | 72h | 24h | [ ] | [ ] |
| Development/Engineering | 72h | 24h | [ ] | [ ] |

**BIA Review Questions:**
- [ ] Is the BIA based on current business processes? (Last updated: ______)
- [ ] Are all critical systems and applications included?
- [ ] Are supply chain dependencies documented?
- [ ] Are financial impact estimates included per hour of downtime?
- [ ] Are regulatory notification requirements mapped to RTOs?
```

### Step 2: Plan Document Review

```markdown
## BCP Document Gap Analysis

### Activation Criteria
- [ ] Clear triggers defined for plan activation
- [ ] Escalation thresholds documented
- [ ] Decision authority matrix defined
- [ ] Communication tree current (phone numbers, alternates)

### Recovery Procedures
- [ ] Step-by-step recovery runbooks for each critical system
- [ ] Manual workaround procedures documented (when systems unavailable)
- [ ] Recovery team roles and responsibilities defined
- [ ] Primary and backup contacts for all roles current

### Technical Recovery
- [ ] Backup strategy documented (3-2-1 rule: 3 copies, 2 media, 1 offsite)
- [ ] Backup restoration procedures tested
- [ ] Failover procedures to DR site documented
- [ ] Network recovery procedures included
- [ ] System rebuild procedures (if catastrophic loss)

### Communication Plan
- [ ] Internal notification procedures (employees, management)
- [ ] External notification procedures (customers, regulators, media)
- [ ] PR/crisis communication templates available
- [ ] Regulatory notification timelines documented

### Vendor/Supplier Dependencies
- [ ] Critical vendor contact information current
- [ ] Vendor recovery obligations documented in contracts
- [ ] Alternative supplier list maintained
```

### Step 3: Recovery Capability Assessment

```bash
# Verify backup integrity and recoverability
# (Coordinate with IT team)

# Test backup restoration time (sample systems)
# Document: Can you restore System X within stated RTO?
time rsync --dry-run -avz backup-server:/backups/system-x/ /restore-test/
# Estimate: actual restore = dry-run time × 1.5 (compression factor)

# Test network failover time
# If failover to secondary DC:
# Document: Time to reroute DNS, time to establish VPN, time for services to come online

# DR environment verification
# - Is DR environment current? (Last sync date)
# - Same software versions as production?
# - Sufficient capacity for critical workloads?
echo "Manual verification required — document findings"

# Backup coverage analysis
# Critical systems with verified backups:
SYSTEMS=(
  "database-primary: Last backup YYYY-MM-DD, Restore tested: YYYY-MM-DD, RTO achieved: Yes/No"
  "app-server-01: Last backup YYYY-MM-DD, Restore tested: YYYY-MM-DD, RTO achieved: Yes/No"
)
```

### Step 4: BCP/DR Test Execution & Review

```markdown
## Test Types

| Test Type | Effort | Disruption | Frequency | Last Done |
|-----------|--------|------------|-----------|-----------|
| **Tabletop Exercise** | Low | None | Quarterly | _________ |
| **Walkthrough Test** | Medium | None | Semi-annual | _________ |
| **Simulation Test** | High | Partial | Annual | _________ |
| **Parallel Test** | High | None | Annual | _________ |
| **Full Cutover Test** | Very High | Yes | Every 2 years | _________ |

## Tabletop Scenario Template

**Scenario**: Ransomware attack — primary data center encrypted Saturday 3 AM
**Duration**: 3 hours
**Participants**: CISO, IT Lead, Operations Lead, Legal, Communications

### Timeline
- T+0h: Detection and initial response
- T+2h: Decision to invoke BCP
- T+4h: Communication to stakeholders
- T+8h: DR site activation
- T+24h: Critical systems restored
- T+72h: Full operations restored

### Discussion Questions
1. Who has authority to invoke BCP at 3 AM Saturday?
2. How do we communicate when email is down?
3. What is the customer notification obligation and timeline?
4. Can we operate from the DR site with current capacity?
5. What's the rollback plan if DR site has issues?
```

### Step 5: Gap Assessment & Recommendations

```markdown
## BCP Maturity Assessment

| Area | Current State | Target State | Gap | Priority |
|------|---------------|--------------|-----|---------|
| Plan Currency | Last updated 18mo ago | < 6 months old | High | High |
| Testing Frequency | Last test 2 years ago | Annual full test | High | Critical |
| DR Site Capacity | 60% of prod capacity | 100% critical workload | High | High |
| Backup Restoration | Never formally tested | Annual test | Critical | Critical |
| Communication Plan | Outdated contacts | Current contacts | Medium | Medium |
| Regulatory Alignment | Not reviewed vs KVKK | Mapped | Medium | High |

## Top 5 Recommendations
1. **Immediate**: Test database backup restoration — risk of unrecoverable backups
2. **30 days**: Update all contact information in communication tree
3. **60 days**: Conduct tabletop exercise for ransomware scenario
4. **90 days**: Upgrade DR site to handle 100% of critical workloads
5. **6 months**: Full DR failover test — validate actual RTO achievement
```

## Output

```
grc/bcp-review/
└── [YYYY-QN]-bcp-review/
    ├── bia-gap-analysis.md
    ├── plan-review-findings.md
    ├── test-results.md            ← If tabletop conducted
    ├── maturity-assessment.md
    └── recommendations.md
```

Share recommendations with `risk-analyst` for risk register. Present critical gaps to CISO via `/exec-summary`.
