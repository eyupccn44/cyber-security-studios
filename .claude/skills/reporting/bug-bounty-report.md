# /bug-bounty-report — Bug Bounty Report Generator

```
Use agent: bug-bounty-hunter + report-writer
Coordinate with: appsec-lead
```

## Purpose

Generate a professional, platform-ready bug bounty report (HackerOne / Bugcrowd format) from raw findings.

## Pre-Submission Checklist

- [ ] `/duplicate-check` completed
- [ ] Scope verified
- [ ] CVSS score calculated
- [ ] PoC reproducible in clean environment
- [ ] Minimal footprint (no bulk data extraction)

## Report Generation

Use template: `docs/templates/bug-bounty-report-template.md`

Fill in:
1. **Title** — specific, not generic ("IDOR on /api/users" not "Access Control Issue")
2. **Severity** — CVSS v3.1 calculated
3. **Summary** — 2-3 sentences, non-technical impact clear
4. **Steps to Reproduce** — numbered, with exact requests/responses
5. **Impact** — business + technical
6. **Remediation** — specific fix, not "add authorization"

## Severity Calibration

```
Critical: RCE, SQLi+data exfil, auth bypass → ATO, payment data
High:     IDOR (PII), stored XSS, privesc, 2FA bypass
Medium:   Reflected XSS, open redirect, sensitive info disclosure
Low:      Missing headers, verbose errors, self-XSS
```

## Platform Submission Tips

**HackerOne:**
- Title ≤ 100 chars
- Add weakness type (CWE)
- Attach HTTP request/response as text (not screenshot)
- Use markdown formatting

**Bugcrowd:**
- Select correct VRT category
- Include target URL in asset field
- Attach PoC video for complex bugs

## Output

Save final report to: `reports/YYYY-MM-DD-[program]-[vuln-type].md`
