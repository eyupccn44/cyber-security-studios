# /team-appsec — Assemble Application Security Team

```
Use agent: appsec-lead
Mobilize: appsec-engineer, code-auditor, sast-sca-engineer
```

## Purpose

Activate the application security team for a security assessment, SDLC integration, or security architecture review engagement.

## Team Assembly by Mission

**Source Code Security Review:**
```
appsec-lead
├── code-auditor          (manual review lead)
├── sast-sca-engineer     (automated scanning)
└── crypto-analyst        (if cryptographic components involved)
```

**New Feature Threat Modeling:**
```
appsec-lead
└── appsec-engineer       (threat modeling facilitation)
    └── [development team representatives]
```

**AppSec Program Setup:**
```
appsec-lead
├── appsec-engineer       (developer enablement, champions)
├── sast-sca-engineer     (tool deployment in pipeline)
└── devsecops-lead        (pipeline integration)
```

**Full Application Pentest (AppSec + Red Team):**
```
appsec-lead + pentest-lead (co-lead)
├── code-auditor          (whitebox source review)
├── web-pentester         (blackbox/greybox dynamic testing)
└── sast-sca-engineer     (automated baseline)
```

## Engagement Kickoff Checklist

- [ ] Application architecture diagram obtained
- [ ] Tech stack documented (languages, frameworks, DBs)
- [ ] OWASP ASVS level agreed (Level 1/2/3)
- [ ] Source code access granted (whitebox) or confirmed restricted (blackbox)
- [ ] Test accounts provided with relevant permission levels
- [ ] API documentation / Swagger/OpenAPI spec obtained
- [ ] Business-critical functionality identified (payment, auth, admin)
- [ ] Timeline and deliverable format agreed

## AppSec Engagement Timeline

```
Day 1-2:   Architecture review + threat modeling (/threat-model)
Day 2-4:   SAST + SCA automated scanning (/sast-scan + /dependency-check)
Day 3-7:   Manual code review (/code-audit)
Day 5-8:   Dynamic testing (/web-pentest for dynamic validation)
Day 8-10:  Finding consolidation + report writing (/pentest-report)
Day 10:    Findings presentation to development team
```

## Key Deliverables

1. **Threat Model Document** — System threats and mitigations
2. **SAST/SCA Report** — Automated findings (baseline)
3. **Manual Code Review Report** — Logic flaws and complex vulns
4. **Full Security Assessment Report** — Consolidated, prioritized
5. **Remediation Guidance** — Developer-friendly fix guidance with code examples
6. **Security Requirements** — For future development cycles
