# Reporting Rules — Rules for All Security Report Deliverables

## Report Quality Standards

### Every Report Must Have
- [ ] Client name and engagement period on cover page
- [ ] Classification marking (CONFIDENTIAL) on every page
- [ ] Version number and date
- [ ] Author and reviewer names
- [ ] Executive Summary accessible to non-technical readers
- [ ] All technical terms defined or explained

### Finding Quality Gates
Every finding MUST have before entering report:
- [ ] Unique finding ID (e.g., VULN-001)
- [ ] Severity rating (Critical/High/Medium/Low/Info)
- [ ] CVSS v3.1 score AND vector string
- [ ] CWE reference
- [ ] Affected asset(s) fully identified
- [ ] Reproduction steps verified (can someone else reproduce it?)
- [ ] Evidence attached (screenshot, request/response)
- [ ] Business impact described in plain language
- [ ] Remediation guidance is specific (not generic)
- [ ] pentest-lead has reviewed and approved severity

### Language Standards
- Lead with business impact, not technical details
- Avoid unexplained acronyms
- Use active voice: "An attacker can..." not "The system is vulnerable to..."
- Remediation should say WHAT to do, not just WHAT is wrong
- No finding severity inflation or deflation for client satisfaction

### Confidentiality
- Never include actual credentials captured during test
- Mask sensitive data in screenshots (blur/redact PII, passwords)
- Reports transmitted only via encrypted channel (client-approved)
- Store reports in `reports/` directory with restricted access

### Review Process
1. Specialist writes finding → saves to `engagements/[NAME]/findings/`
2. pentest-lead reviews and approves findings
3. report-writer assembles full report
4. pentest-lead reviews complete report
5. ciso reviews executive summary and overall deliverable
6. Deliver to client only after ciso approval
