# /policy-draft — Draft or Update Security Policy

```
Use agent: policy-writer
Review: grc-lead → legal/HR → CISO approval
```

## Purpose

Draft a new information security policy or update an existing one to address a regulatory requirement, audit finding, or governance gap.

## Policy Types Available

Select the policy type needed:

| Policy | Triggers | Key Requirements |
|--------|----------|-----------------|
| Acceptable Use | New hires, audit gap | Permitted/prohibited system use |
| Access Control | SOC 2 CC6.1, ISO A.8.3 | Provisioning, review, revocation |
| Password / MFA | Audit finding, breach | Length, complexity, MFA mandate |
| Data Classification | GDPR, data breach | Classify, handle, label, dispose |
| Incident Response | ISO A.5.24, SOC 2 CC7.3 | Report, escalate, respond |
| Vendor / Third-Party | SOC 2 CC9.2 | Due diligence, contracts, monitoring |
| Remote Work | Post-COVID, audit | VPN, device, home office security |
| Vulnerability Management | PCI 6.3, NIST | Scan, assess, remediate SLAs |
| Cryptography | ISO A.8.24 | Approved algorithms, key management |
| Mobile Device | BYOD policy gap | MDM enrollment, approved apps |

## Policy Template

```markdown
# [Policy Name]
**Policy ID**: POL-[XXX]
**Version**: 1.0
**Effective Date**: [YYYY-MM-DD]
**Review Date**: [YYYY-MM-DD + 1 year]
**Owner**: [CISO / Department]
**Approved By**: [Executive name, title]
**Classification**: Internal

---

## 1. Purpose
[Why does this policy exist? What risk does it address?]

## 2. Scope
This policy applies to:
- All employees, contractors, and third parties with access to [organization] systems
- All [organization]-owned and managed IT systems and data
- [Any additional scope inclusions/exclusions]

## 3. Roles and Responsibilities
| Role | Responsibility |
|------|---------------|
| CISO | Policy ownership, annual review |
| IT Team | Technical implementation |
| All Staff | Compliance with policy requirements |
| Managers | Enforce within their teams |

## 4. Policy Requirements

### 4.1 [Requirement Area]
**4.1.1** [Specific, measurable requirement]
**4.1.2** [Specific, measurable requirement]

### 4.2 [Requirement Area]
**4.2.1** [Requirement]

## 5. Exceptions Process
Any exception to this policy must be:
1. Submitted in writing to the CISO
2. Approved by the CISO (and legal if required)
3. Time-limited (maximum 90 days)
4. Logged in the exceptions register

## 6. Enforcement
Violations of this policy may result in disciplinary action up to and including termination of employment or contract. Serious violations may be reported to law enforcement.

## 7. Related Documents
- [Related policy/procedure 1]
- [Related standard/guideline]
- [Regulatory reference]

## 8. Revision History
| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | [date] | [author] | Initial release |
```

## Output

`docs/policies/[POLICY-NAME]-v[X.X]-[DATE].md`
Then route for legal/HR review → CISO approval → publication
