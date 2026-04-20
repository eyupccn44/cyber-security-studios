# /audit-prep — Prepare for External Security Audit

```
Use agent: compliance-analyst
Coordinate with: grc-lead, all department leads
```

## Purpose

Prepare the organization for an external security audit (ISO 27001, SOC 2, PCI-DSS, etc.) by organizing evidence, conducting pre-audits, and coaching control owners.

## Audit Preparation Timeline

```
T-90 days: Gap assessment + remediation planning
T-60 days: Evidence collection begins
T-30 days: Internal pre-audit (dry run)
T-14 days: Evidence finalization and organization
T-7  days: Auditor logistics confirmed, key contacts briefed
T-0:       Audit begins
```

## Evidence Collection Checklist

### Governance & Policy Evidence
- [ ] Information Security Policy (signed, current)
- [ ] All topic-specific policies (current, approved)
- [ ] ISMS/security committee meeting minutes (last 12 months)
- [ ] Risk register (current, reviewed)
- [ ] Security awareness training records (completion %)

### Technical Control Evidence
- [ ] Vulnerability scan reports (last 3-6 months)
- [ ] Penetration test report (last 12 months)
- [ ] Patch management records (demonstrating SLA compliance)
- [ ] Access review records (last quarterly review)
- [ ] Incident log (last 12 months — even if zero incidents)
- [ ] Change management records (sample of approved changes)
- [ ] Backup test records (demonstrating successful restore)

### HR Controls Evidence
- [ ] Background check policy and sample records
- [ ] Onboarding security checklist (signed by new hires)
- [ ] Offboarding checklist (account termination within SLA)
- [ ] Acceptable use policy (signed by all staff)

### Vendor/Third-Party Evidence
- [ ] Vendor inventory/register
- [ ] Vendor security assessments (critical vendors)
- [ ] Data processing agreements (GDPR/KVKK)
- [ ] Vendor security clauses in contracts

## Internal Pre-Audit Process

```
1. SIMULATE auditor questions for each control:
   - "Show me your access review process" → demonstrate with evidence
   - "Show me a terminated user account was disabled within SLA" → find example
   - "Show me how you handle a critical vulnerability patch" → trace an example

2. IDENTIFY evidence gaps:
   - Evidence exists but not organized → organize now
   - Evidence partially exists → complete and backfill where appropriate
   - Evidence doesn't exist → escalate to grc-lead (remediation or risk acceptance)

3. BRIEF control owners:
   - Explain what auditors will ask
   - Ensure they can answer without notes
   - Prepare simple demos where needed
```

## Evidence Organization Structure

```
audit-[FRAMEWORK]-[YEAR]/
├── 00-overview/
│   ├── audit-schedule.md
│   ├── scope-statement.md
│   └── key-contacts.md
├── 01-governance/
│   ├── information-security-policy.pdf
│   └── risk-register.xlsx
├── 02-access-control/
│   ├── access-review-Q1.pdf
│   └── account-termination-log.xlsx
├── 03-incident-response/
│   └── incident-log-2024.xlsx
├── 04-vulnerability-management/
│   ├── pentest-report-2024.pdf
│   └── vuln-scan-Q4-2024.pdf
└── 05-vendor-management/
    ├── vendor-register.xlsx
    └── vendor-assessments/
```

## Output

`docs/audit-prep/[FRAMEWORK]-[YEAR]-readiness.md`
