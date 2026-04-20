# /sbom-generate — Generate Software Bill of Materials

```
Use agent: devsecops-engineer
Coordinate with: devsecops-lead
```

## Purpose

Generate a Software Bill of Materials (SBOM) to inventory all software components, versions, and their known vulnerabilities — essential for supply chain security.

## SBOM Generation

### For Container Images
```bash
# Generate SBOM with Syft (CycloneDX format — recommended)
syft $IMAGE_NAME -o cyclonedx-json > sbom/sbom-$IMAGE_NAME-$(date +%Y%m%d).json

# Generate in SPDX format (alternative)
syft $IMAGE_NAME -o spdx-json > sbom/sbom-$IMAGE_NAME-$(date +%Y%m%d).spdx.json

# Human-readable table
syft $IMAGE_NAME -o table
```

### For Source Code / Filesystem
```bash
# Python project
syft dir:. -o cyclonedx-json > sbom/sbom-source-$(date +%Y%m%d).json

# Generate pip requirements-based SBOM
pip-licenses --format=json > sbom/python-licenses.json

# Node.js project
syft dir:. --scope all-layers -o cyclonedx-json > sbom/sbom-node.json

# Java/Maven project
syft dir:. -o cyclonedx-json > sbom/sbom-java.json
```

### Vulnerability Scanning Against SBOM
```bash
# Grype — scan SBOM for vulnerabilities
grype sbom:sbom-image-20240115.json --output table
grype sbom:sbom-image-20240115.json --output json > sbom/vuln-report.json

# Trivy — scan and generate SBOM
trivy image --format cyclonedx --output sbom/trivy-sbom.json $IMAGE_NAME
trivy sbom sbom/trivy-sbom.json  # Scan the SBOM
```

### SBOM in CI/CD Pipeline
```yaml
# GitHub Actions SBOM generation
- name: Generate SBOM
  uses: anchore/sbom-action@v0
  with:
    image: ${{ env.IMAGE_NAME }}
    format: cyclonedx-json
    output-file: sbom.json

- name: Upload SBOM artifact
  uses: actions/upload-artifact@v3
  with:
    name: sbom
    path: sbom.json

- name: Scan SBOM for vulnerabilities
  uses: anchore/scan-action@v3
  with:
    sbom: sbom.json
    fail-build: true
    severity-cutoff: critical
```

## SBOM Output Structure

```
sbom/
├── sbom-[IMAGE]-[DATE].json          # CycloneDX SBOM
├── sbom-[IMAGE]-[DATE].spdx.json    # SPDX SBOM (alternative)
├── vuln-report-[DATE].json           # Vulnerability scan results
└── sbom-summary-[DATE].md            # Human-readable summary
```

## SBOM Summary Template

```markdown
## SBOM Summary — [Image/Project] — [Date]

**Total Components**: N
**Direct Dependencies**: N
**Transitive Dependencies**: N

### Vulnerability Summary
| Severity | Count |
|----------|-------|
| Critical | 0 |
| High | N |
| Medium | N |
| Low | N |

### Top Vulnerable Components
[List components with critical/high vulns + CVEs]

### Recommended Actions
1. Upgrade [component] from [version] to [version] — fixes CVE-XXXX
2. ...
```
