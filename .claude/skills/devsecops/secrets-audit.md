# /secrets-audit — Audit for Exposed Secrets

```
Use agent: devsecops-engineer
Coordinate with: devsecops-lead
```

## Purpose

Scan codebases, repositories, CI/CD configs, and infrastructure for exposed secrets — API keys, passwords, tokens, private keys, and credentials.

## Scanning Approach

### Git Repository Scanning

```bash
# TruffleHog — deep git history scan (recommended)
trufflehog git file://. --only-verified --json > secrets-audit/trufflehog-results.json

# Gitleaks — fast, configurable
gitleaks detect --source . --report-path secrets-audit/gitleaks-report.json \
    --report-format json --verbose

# Scan remote GitHub org
trufflehog github --org=$ORG_NAME --only-verified

# Historical commit scan (finds deleted secrets too!)
trufflehog git file://. --since-commit HEAD~1000
```

### Filesystem Scanning

```bash
# detect-secrets — Python-based
detect-secrets scan --all-files . > secrets-audit/baseline.json
detect-secrets audit secrets-audit/baseline.json

# Semgrep secrets rules
semgrep --config=p/secrets . --json > secrets-audit/semgrep-secrets.json

# Custom grep patterns
grep -rn --include="*.{env,yml,yaml,json,xml,conf,config,properties}" \
    -e "password\s*=" -e "secret\s*=" -e "api_key\s*=" \
    -e "AKIA[0-9A-Z]{16}" -e "ghp_[a-zA-Z0-9]{36}" \
    . > secrets-audit/grep-findings.txt
```

### CI/CD Configuration Scanning

```bash
# GitHub Actions
find .github/workflows -name "*.yml" | xargs grep -l "password\|secret\|key"

# Jenkins pipelines
find . -name "Jenkinsfile" | xargs grep -n "password\|withCredentials" 
```

## Common Secret Patterns

| Secret Type | Pattern Example |
|------------|-----------------|
| AWS Access Key | `AKIA[0-9A-Z]{16}` |
| GitHub Token | `ghp_[a-zA-Z0-9]{36}` |
| Google API Key | `AIza[0-9A-Za-z\-_]{35}` |
| Slack Token | `xox[baprs]-[0-9a-zA-Z]{10,48}` |
| Private Key | `-----BEGIN (RSA\|EC\|DSA) PRIVATE KEY-----` |
| JWT | `eyJ[A-Za-z0-9+/=]{10,}\.eyJ[A-Za-z0-9+/=]{10,}` |
| Connection String | `(mongodb\|redis\|postgres):\/\/[^:]+:[^@]+@` |

## Remediation Process

For each confirmed secret found:

```
1. REVOKE immediately → Don't wait, rotate NOW
2. ASSESS exposure → Was it in public repo? For how long?
3. CHECK audit logs → Was the secret used by anyone else?
4. REPLACE with vault → Store in HashiCorp Vault / AWS Secrets Manager
5. PREVENT recurrence → Add pre-commit hooks + CI gate
6. REPORT → Document finding, exposure window, actions taken
```

## Output

`secrets-audit/`
- `confirmed-secrets.md` — Verified exposed secrets (remediation required)
- `review-required.md` — Potential secrets needing manual review
- `false-positives.md` — Documented FPs for suppression
- `remediation-status.md` — Tracking of revocation and rotation
