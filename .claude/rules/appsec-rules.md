# AppSec Rules — Path-Scoped Rules for Application Security Work
# Applied when working in: .claude/agents/tier*appsec*, .claude/skills/appsec/

## Application Security Standards

### Threat Modeling Requirements
Every new feature or system change affecting:
- Authentication or authorization logic
- Sensitive data handling (PII, financial, health)
- External input processing
- Third-party integrations
...MUST have a threat model completed before development begins.

### Code Review Triggers
Mandatory security code review (via code-auditor) for:
- All authentication and session management code
- All cryptographic implementations
- All SQL query construction
- All file operation code with user-controlled paths
- All deserialization of user-supplied data
- Any code processing PII or sensitive data

### SAST Integration Requirements
- SAST scan must pass before any code reaches staging
- Zero critical/high SAST findings allowed to deploy to production
- All SAST suppressions must be documented with justification and security lead approval

### Dependency Management
- All new dependencies must be reviewed before adoption
- SCA scan must run on every PR
- Critical CVEs in dependencies must be remediated within 7 days
- High CVEs within 30 days

### Security Review Handoff
When handing findings to development teams:
- Provide specific file and line number
- Include vulnerable code snippet
- Include fixed code example
- Reference applicable OWASP/CWE
- Provide test case to verify the fix

### Secure Defaults
When recommending or implementing security controls, always default to:
- Allowlist over denylist
- Encrypt by default (data at rest and in transit)
- Least privilege by default
- Fail secure (deny on error, not allow)
- Defense in depth (never rely on a single control)
