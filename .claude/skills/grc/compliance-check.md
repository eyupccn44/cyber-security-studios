# /compliance-check — Compliance Gap Analysis

```
Use agent: compliance-analyst
Report to: grc-lead
```

## Purpose

Assess current security controls against a selected compliance framework and identify gaps requiring remediation.

## Framework Selection

Choose the relevant framework(s):
- [ ] **ISO 27001:2022** — Information security management
- [ ] **SOC 2 Type II** — Service organization controls (Trust Services Criteria)
- [ ] **PCI-DSS v4.0** — Payment card industry
- [ ] **GDPR / KVKK** — Data protection
- [ ] **NIST CSF 2.0** — Cybersecurity framework
- [ ] **HIPAA** — Healthcare data

## Gap Assessment Process

### Step 1: Control Mapping

For each framework requirement:
```
Requirement ID: [e.g., ISO 27001 A.8.24 / PCI DSS 6.3.3]
Requirement Text: [Exact wording]
Control in Place: [Yes / Partial / No]
Evidence: [What proves compliance?]
Gap Description: [What's missing?]
Risk Rating: [High / Medium / Low]
Remediation Owner: [Team/person]
Target Date: [Completion deadline]
```

### Step 2: ISO 27001 Annex A Quick Scan

Key controls to verify:

| Domain | Key Controls | Status |
|--------|-------------|--------|
| **A.5 Org Controls** | Policies, roles, segregation of duties | |
| **A.6 People** | Screening, training, offboarding | |
| **A.7 Physical** | Access control, clear desk | |
| **A.8 Technical** | Endpoint protection, access management, vulnerability management | |

### Step 3: SOC 2 TSC Quick Scan

| Trust Service Criteria | Key Requirements | Status |
|----------------------|-----------------|--------|
| CC6.1 | Logical access controls implemented | |
| CC6.2 | User access review process | |
| CC7.1 | Vulnerability management program | |
| CC7.2 | Security event monitoring | |
| CC9.2 | Vendor risk management | |

### Step 4: Gap Analysis Output

```
COMPLIANT:     [N] requirements fully met
PARTIAL:       [N] requirements partially met → improvement needed
NON-COMPLIANT: [N] requirements not met → remediation required
NOT APPLICABLE:[N] requirements excluded with justification
```

## Output

`docs/compliance/gap-analysis-[FRAMEWORK]-[DATE].md`

Includes prioritized remediation roadmap with:
- Critical gaps (audit failure risk) — fix within 30 days
- High gaps — fix within 90 days
- Medium gaps — fix within 6 months
