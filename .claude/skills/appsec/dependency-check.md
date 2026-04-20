# /dependency-check — Audit Third-Party Dependencies

```
Use agent: sast-sca-engineer
Coordinate with: appsec-lead
```

## Purpose

Identify known vulnerabilities in third-party libraries and packages using Software Composition Analysis (SCA).

## Scanning by Package Manager

```bash
# Python (pip)
pip install safety
safety check --full-report --json > sca/safety-report.json
# OR
pip-audit --format=json --output sca/pip-audit.json

# Node.js (npm/yarn)
npm audit --json > sca/npm-audit.json
yarn audit --json > sca/yarn-audit.json

# Java (Maven)
mvn dependency-check:check
# Output: target/dependency-check-report.html

# Go
govulncheck ./... > sca/govulncheck.txt

# Ruby (Bundler)
bundle audit check --update > sca/bundle-audit.txt
```

## Snyk (Multi-Language, Recommended)

```bash
# Install
npm install -g snyk
snyk auth $SNYK_TOKEN

# Test project
snyk test --json > sca/snyk-results.json
snyk test --severity-threshold=high  # Only high/critical

# Monitor (continuous tracking)
snyk monitor

# Container scan
snyk container test $IMAGE_NAME --json > sca/snyk-container.json
```

## Trivy (Container + Filesystem)

```bash
# Filesystem scan
trivy fs --severity HIGH,CRITICAL --format json \
         --output sca/trivy-fs.json .

# Container image scan
trivy image --severity HIGH,CRITICAL --format json \
            --output sca/trivy-image.json $IMAGE_NAME

# Generate SBOM and scan
trivy image --format cyclonedx $IMAGE_NAME > sbom.json
trivy sbom sbom.json
```

## Results Analysis

```bash
# Count critical/high findings
cat sca/snyk-results.json | jq '[.vulnerabilities[] | select(.severity == "critical" or .severity == "high")] | length'

# List vulnerable packages
cat sca/snyk-results.json | jq '.vulnerabilities[] | {pkg: .packageName, version: .version, severity: .severity, cve: .identifiers.CVE[0], fixedIn: .fixedIn[0]}'
```

## Remediation Priority

| Severity | Has Fix? | Action | SLA |
|----------|---------|--------|-----|
| Critical | Yes | Upgrade immediately | 24 hours |
| Critical | No | Mitigate or replace library | 48 hours |
| High | Yes | Upgrade | 7 days |
| High | No | Assess exploitability, plan mitigation | 30 days |
| Medium | Yes | Include in next sprint | 30 days |
| Medium | No | Monitor + assess | 90 days |
| Low | Any | Next release cycle | 90-180 days |

## Output

`sca/[DATE]-dependency-report.md` with:
- Vulnerable packages sorted by severity
- Available upgrades and version targets
- Packages with no fix (requires alternative)
- CI/CD gate recommendations (fail on critical/high)
