# /ci-security — CI/CD Pipeline Security Hardening

```
Use agent: devsecops-engineer
Coordinate with: devsecops-lead, appsec-engineer
```

## Purpose

Assess and harden CI/CD pipeline security — covering source control security, build environment integrity, secrets management, dependency security gates, artifact signing, and deployment pipeline controls across GitHub Actions, GitLab CI, Jenkins, and other platforms.

## Pre-Execution Check

- [ ] CI/CD platform identified (GitHub Actions / GitLab / Jenkins / Azure DevOps)
- [ ] Pipeline configuration files accessible
- [ ] Secrets inventory requested from dev teams
- [ ] Access to build logs for historical analysis

## Security Assessment Framework

### Phase 1: Source Control Security

```bash
# Check branch protection rules (GitHub)
gh api repos/ORG/REPO/branches/main/protection

# Verify required reviews before merge
# Required: minimum 1 review, dismiss stale reviews, require code owner review

# Scan for secrets in git history
# TruffleHog — comprehensive secrets scanner
trufflehog git https://github.com/org/repo --only-verified

# Gitleaks
gitleaks detect --source . --verbose --report-format json \
  --report-path gitleaks-results.json

# Check for sensitive files committed
git log --all --full-history -- "**/.env" "**/*.pem" "**/id_rsa" "**/*.key"

# SAST on pull request changes
# Verify: PR checks fail on security findings
gh api repos/ORG/REPO/statuses/$(git rev-parse HEAD)
```

### Phase 2: Pipeline Configuration Audit

```yaml
# GitHub Actions — Security review checklist:
# Review .github/workflows/*.yml

# BAD: Using mutable action references
- uses: actions/checkout@main  # INSECURE — branch can be changed

# GOOD: Pin to full commit SHA
- uses: actions/checkout@b4ffde65f46336ab88eb53be808477a3936bae11  # v4.1.1

# BAD: Dangerous permissions
permissions: write-all  # INSECURE — gives all permissions

# GOOD: Minimal permissions
permissions:
  contents: read
  pull-requests: write

# BAD: Printing secrets
- run: echo "API Key is ${{ secrets.API_KEY }}"  # INSECURE

# BAD: Running user-controlled content
- run: ${{ github.event.issue.body }}  # INJECTION RISK

# Check: Is GITHUB_TOKEN scoped to job level?
# Check: Are third-party actions from trusted organizations?
# Check: Is workflow approved for external PRs?
```

```groovy
// Jenkins — Security review
// Check Jenkinsfile for:
// - Credentials stored in pipeline (should use credentials() binding)
// - Script Security approval for Groovy
// - Agent labels restricting where builds run
// - No sh "curl | bash" patterns

// BAD: Hardcoded credential
sh "docker login -u admin -p supersecret registry.example.com"

// GOOD: Using credentials binding
withCredentials([usernamePassword(
  credentialsId: 'registry-creds',
  usernameVariable: 'REGISTRY_USER',
  passwordVariable: 'REGISTRY_PASS'
)]) {
  sh "docker login -u $REGISTRY_USER -p $REGISTRY_PASS registry.example.com"
}
```

### Phase 3: Secrets Management

```bash
# Inventory all secrets used in pipelines
# GitHub Actions — list repository secrets
gh secret list
gh secret list --env production

# Check for secrets in environment variables (vs proper secret injection)
grep -rn "env:" .github/workflows/ | grep -iE "password|secret|key|token" | \
  grep -v "\${{ secrets\."  # Should use secrets, not hardcoded values

# Check .env files not in .gitignore
cat .gitignore | grep -E "\.env|\.secret|credentials"

# Verify secrets rotation policy
# Ask: When were pipeline secrets last rotated?
# Recommended: Quarterly rotation for high-sensitivity secrets

# Detect overly broad secret access
# Jenkins Credentials — which jobs can access which credentials?
# Review: Jenkins → Manage Credentials → Credential Usage
```

### Phase 4: Dependency Security Gates

```yaml
# Add security gates to pipeline configuration

# Example: GitHub Actions with Trivy + fail on HIGH/CRITICAL
- name: Run Trivy vulnerability scanner
  uses: aquasecurity/trivy-action@master
  with:
    scan-type: 'fs'
    security-checks: 'vuln,config,secret'
    severity: 'CRITICAL,HIGH'
    exit-code: '1'  # Fail build on findings

# SAST gate (Semgrep)
- name: SAST Scan
  run: |
    semgrep --config "p/security-audit" \
            --config "p/owasp-top-ten" \
            --error \  # Exit non-zero on findings
            ./src/

# License compliance gate
- name: License Check
  run: |
    license-checker --onlyAllow "MIT;Apache-2.0;BSD-2-Clause;BSD-3-Clause" \
      --failOnUnlicensed

# Dependency audit
- name: Dependency Security Audit
  run: |
    npm audit --audit-level=high  # Fail on HIGH+ findings
    # OR
    pip-audit --requirement requirements.txt
```

### Phase 5: Build Environment Security

```bash
# Verify build agents are ephemeral (not persistent/shared)
# GitHub Actions: ubuntu-latest = ephemeral ✓
# Self-hosted: Review cleanup between builds

# Check for build artifact tampering
# Verify: Checksums generated and verified
sha256sum dist/app.tar.gz > dist/app.tar.gz.sha256
# Deployment: verify checksum before deploying

# Docker build security
# Review Dockerfile for secrets in build args
grep -n "ARG\|--build-arg" Dockerfile | grep -iE "password|secret|key|token"
# Build args appear in image history = FINDING

# Artifact signing (critical for supply chain)
# Sigstore/cosign for container images
cosign sign --key cosign.key registry.example.com/myapp:latest
# Verify signature in deployment pipeline
cosign verify --key cosign.pub registry.example.com/myapp:latest
```

### Phase 6: Deployment Pipeline Controls

```bash
# Check deployment separation of duties
# Dev should not be able to deploy directly to production
# Review: Who can approve production deployments?

# Environment-specific secrets
# Verify: Prod secrets only accessible to prod deployment

# Deployment audit logging
# Verify: All deployments logged with deployer identity, timestamp, version

# Infrastructure as Code security scan
terraform plan -out=tfplan
tfsec . --format json > reports/tfsec-results.json
checkov -f main.tf --output json > reports/checkov-results.json

# Kubernetes admission control
# Verify: OPA/Gatekeeper policies enforce security policies
kubectl get constrainttemplate
kubectl get constraints
```

## CI/CD Security Checklist

| Control | Status | Priority |
|---------|--------|----------|
| Branch protection enabled | [ ] | Critical |
| Actions pinned to SHA | [ ] | High |
| No secrets in pipeline code | [ ] | Critical |
| SAST gate in CI | [ ] | High |
| Dependency scan gate in CI | [ ] | High |
| Secret scanning enabled | [ ] | High |
| Artifact signing implemented | [ ] | Medium |
| Ephemeral build agents | [ ] | Medium |
| Deployment approval gates | [ ] | High |
| IaC scanning in pipeline | [ ] | Medium |

## Output

```
engagements/[id]/devsecops/ci-pipeline/
├── pipeline-audit.md          ← Findings per pipeline
├── secrets-inventory.md
├── security-gates-status.md
└── remediation-guide.md       ← Priority-ordered fixes
```

Critical findings → immediate notification to `devsecops-lead`. All findings → `/pipeline-secure` for remediation roadmap.
