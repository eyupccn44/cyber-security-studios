# /pipeline-secure — Secure CI/CD Pipeline

```
Use agent: devsecops-engineer
Coordinate with: devsecops-lead
```

## Purpose

Assess and harden CI/CD pipeline security to prevent supply chain attacks, secrets exposure, and unauthorized code deployment.

## Pipeline Security Assessment

### Step 1: Inventory Pipeline Components
```
Source Control: GitHub / GitLab / Bitbucket / Azure DevOps
CI System: GitHub Actions / Jenkins / CircleCI / GitLab CI
Artifact Registry: ECR / DockerHub / Nexus / Artifactory
Deployment: Kubernetes / ECS / Lambda / VM
Secrets Management: Vault / AWS Secrets Manager / Azure KV
```

### Step 2: Common Pipeline Attack Vectors

| Attack | Description | Mitigation |
|--------|-------------|-----------|
| Secrets in code | Hardcoded creds committed | Pre-commit hooks + gitleaks |
| Dependency confusion | Malicious package substitution | Private registry + pinned versions |
| Build script injection | Malicious PR manipulates CI | Protected branches + PR reviews |
| Artifact tampering | Build output modified | Image signing (Cosign) + SBOM |
| OIDC misconfiguration | Cloud creds over-permissive | Minimal OIDC scope per workflow |
| Runner compromise | Self-hosted runner exploited | Ephemeral runners + least privilege |

### Step 3: GitHub Actions Hardening

```yaml
# Secure workflow template
name: Secure CI Pipeline

on:
  pull_request:
    branches: [main, develop]

# Minimal permissions
permissions:
  contents: read
  security-events: write  # Only for SARIF upload

jobs:
  security-scan:
    runs-on: ubuntu-latest
    
    steps:
    - name: Checkout (pinned SHA, not tag)
      uses: actions/checkout@b4ffde65f46336ab88eb53be808477a3936bae11  # v4.1.1
    
    - name: SAST Scan
      uses: returntocorp/semgrep-action@v1
      with:
        config: p/security-audit
    
    - name: Secrets Detection
      run: |
        pip install gitleaks
        gitleaks detect --source . --exit-code 1
    
    - name: Dependency Scan
      run: |
        pip install safety
        safety check --full-report
    
    - name: Container Scan
      run: trivy image --exit-code 1 --severity CRITICAL $IMAGE
```

### Step 4: Branch Protection Rules

Required settings for `main`/`master`:
- [ ] Require pull request reviews (min 2 reviewers)
- [ ] Require status checks (security scans must pass)
- [ ] Require signed commits
- [ ] No force pushes
- [ ] No direct commits to protected branch
- [ ] Dismiss stale reviews when new commits pushed

### Step 5: OIDC Cloud Authentication (Keyless)

```yaml
# AWS OIDC — no long-lived keys needed
- name: Configure AWS Credentials
  uses: aws-actions/configure-aws-credentials@v4
  with:
    role-to-assume: arn:aws:iam::${{ secrets.AWS_ACCOUNT }}:role/GitHubActionsRole
    aws-region: us-east-1
    # OIDC — no access key/secret needed!
```

## Output

`reports/pipeline-security-[DATE].md` with:
- Current security posture score
- Critical pipeline security gaps
- Hardened workflow templates ready to implement
- Branch protection configuration checklist
