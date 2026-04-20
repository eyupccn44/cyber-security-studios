# /secure-review — Security Architecture Review

```
Use agent: appsec-engineer
Coordinate with: appsec-lead
```

## Purpose

Review a system architecture, design document, or technical proposal for security weaknesses before implementation.

## Review Checklist

### Authentication & Identity
- [ ] Authentication mechanism appropriate for sensitivity level?
- [ ] MFA enforced for privileged access?
- [ ] Session tokens generated securely (cryptographically random, sufficient entropy)?
- [ ] Session invalidation on logout and timeout?
- [ ] Password storage using appropriate algorithm (Argon2, bcrypt, PBKDF2)?
- [ ] OAuth2/OIDC flows implemented correctly (PKCE, state parameter)?

### Authorization
- [ ] Authorization checked server-side for every request?
- [ ] Principle of least privilege applied?
- [ ] Resource ownership verified (IDOR prevention)?
- [ ] Horizontal and vertical privilege escalation paths considered?
- [ ] API endpoints authenticated AND authorized?

### Data Protection
- [ ] Sensitive data identified and classified?
- [ ] Encryption at rest for sensitive data (AES-256)?
- [ ] Encryption in transit (TLS 1.2+, strong cipher suites)?
- [ ] PII minimized (collect only what's needed)?
- [ ] Data retention and deletion policies defined?
- [ ] Backup encryption?

### Input Validation
- [ ] All input validated at server-side (not just client)?
- [ ] Input validated against allowlist (not just blocklist)?
- [ ] SQL/NoSQL queries parameterized?
- [ ] Output encoded appropriately per context (HTML, JS, SQL, OS)?
- [ ] File uploads restricted by type, size, content inspection?

### Error Handling & Logging
- [ ] Errors handled gracefully (no stack traces to users)?
- [ ] Security events logged (login, access control failures, admin actions)?
- [ ] Logs don't contain sensitive data (passwords, tokens, PII)?
- [ ] Log integrity protected?
- [ ] Alerts defined for critical security events?

### Third-Party & Supply Chain
- [ ] Third-party dependencies inventoried?
- [ ] Known vulnerable versions avoided?
- [ ] Vendor security assessments completed?
- [ ] Third-party API access scoped to minimum permissions?

### Infrastructure & Configuration
- [ ] Secrets managed via vault (not hardcoded or env vars)?
- [ ] Network segmentation applied (least exposure)?
- [ ] Default credentials changed?
- [ ] Unnecessary services/ports disabled?
- [ ] Security headers configured (CSP, HSTS, X-Frame-Options)?

### Cryptography
- [ ] Approved algorithms only (AES-256, SHA-256+, RSA 2048+, ECDSA P-256)?
- [ ] No hardcoded keys or IVs?
- [ ] Random number generation using CSPRNG?
- [ ] Nonces not reused (especially for GCM)?

## Architecture Review Report

```markdown
## Security Architecture Review: [System Name]

**Review Date**: [date]
**Reviewer**: appsec-engineer
**Version Reviewed**: [doc version/commit]

### Executive Summary
[2-3 sentences: overall security posture assessment]

### Critical Concerns (Must Fix Before Launch)
1. [Issue] — [Risk] — [Recommendation]

### High Risk Concerns (Fix Before Launch)
1. [Issue] — [Risk] — [Recommendation]

### Medium Risk Concerns (Fix in First Release)
1. [Issue] — [Risk] — [Recommendation]

### Security Requirements Generated
1. [Specific requirement for developers]

### Positive Observations
1. [Good security practices noted]
```

## Output

`engagements/[NAME]/secure-review-[SYSTEM]-[DATE].md`
