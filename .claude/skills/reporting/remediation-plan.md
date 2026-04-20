# /remediation-plan — Build Prioritized Remediation Plan

```
Use agent: report-writer
Coordinate with: pentest-lead, ciso
```

## Purpose

Convert penetration test or assessment findings into a clear, prioritized, actionable remediation roadmap for the client's engineering teams.

## Prioritization Framework

### Priority Tiers

| Priority | Criteria | Timeline | Owner |
|----------|----------|----------|-------|
| **P0 — Emergency** | Active exploitation risk, credentials exposed | 24-48 hours | CISO + Engineering Lead |
| **P1 — Critical** | CVSS 9.0+, easily exploitable | 7 days | Engineering Lead |
| **P2 — High** | CVSS 7.0-8.9 | 30 days | Development Team |
| **P3 — Medium** | CVSS 4.0-6.9 | 90 days | Development Team |
| **P4 — Low/Info** | CVSS < 4.0 | 180 days | Development Team |

## Remediation Plan Template

```markdown
# Remediation Plan
## [Client Name] — [Assessment Type]
**Generated**: [date]
**Assessment Period**: [dates]

---

## Executive Dashboard

Total findings requiring remediation: [N]
| Priority | Count | Remediated | Remaining |
|----------|-------|-----------|-----------|
| P0 Emergency | N | 0 | N |
| P1 Critical | N | 0 | N |
| P2 High | N | 0 | N |
| P3 Medium | N | 0 | N |
| P4 Low | N | 0 | N |

---

## P0 — Emergency Remediation (24-48 hours)

### VULN-001: [Title]
**Risk**: [One sentence business impact]
**Action**: [Specific action — not vague]
**Owner**: [Team/person]
**Deadline**: [date]
**Effort**: [Hours estimate]
**Verification**: [How to confirm fix is complete]

---

## P1 — Critical Remediation (7 days)

[Repeat format above for each finding]

---

## Quick Wins (Low effort, high impact)

[Findings that can be fixed rapidly — encourage early momentum]

---

## Long-Term Security Improvements

[Strategic recommendations beyond individual fixes]

---

## Verification Testing

After remediation of P0/P1 findings, request a focused retest:
- Scope: Only previously identified vulnerabilities
- Timeline: Within 30 days of remediation completion
- Output: Retest report confirming fix effectiveness
```

## Remediation Guidance Quality Standards

Each remediation item must be:
- **Specific**: "Parameterize all SQL queries using prepared statements" NOT "fix SQL injection"
- **Actionable**: Developer can start immediately without further clarification
- **Verifiable**: Clear test case to confirm the fix works
- **Contextualized**: References the specific file/function/endpoint

## Code Fix Examples (Include Where Applicable)

```python
# ❌ VULNERABLE (current code)
cursor.execute(f"SELECT * FROM users WHERE id = {user_id}")

# ✅ REMEDIATED (target state)
cursor.execute("SELECT * FROM users WHERE id = %s", (user_id,))
```

## Output

`reports/[CLIENT]-[DATE]-remediation-plan.md`
