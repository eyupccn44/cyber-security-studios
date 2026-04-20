# /cspm-check — Cloud Security Posture Management Check

```
Use agent: cloud-security-lead
```

## Purpose

Continuously assess cloud environment security posture and track improvement over time using CSPM tooling.

## Automated CSPM Scans

### AWS — Prowler (Comprehensive)

```bash
# Full AWS CSPM scan
prowler aws --profile $AWS_PROFILE \
    --output-formats json,html,csv \
    --output-directory reports/cspm/

# Score-based summary
prowler aws --profile $AWS_PROFILE \
    --output-formats json | \
    jq '.[] | {check: .CheckID, status: .Status, severity: .Severity}' | \
    head -50

# Critical checks only
prowler aws -S --severity critical high

# CIS AWS Foundations Benchmark
prowler aws --compliance cis_aws_foundations_benchmark_3.0
```

### Azure — Prowler + Defender

```bash
# Prowler for Azure
prowler azure --az-cli-auth \
    --subscription-ids $SUB_ID \
    --output-formats json,html

# Microsoft Secure Score (via CLI)
az security secure-score-controls list \
    --output table \
    --query '[].{Name:displayName, Score:score.current, Max:score.max}'
```

### GCP — Prowler + Security Command Center

```bash
# Prowler for GCP  
prowler gcp --project-ids $PROJECT_ID \
    --output-formats json,html

# Security Command Center findings
gcloud scc findings list $ORGANIZATION_ID \
    --filter="state=ACTIVE" \
    --format="table(name,category,severity,eventTime)"
```

## CSPM Metrics Dashboard

Track these key metrics over time:

| Metric | Current | Last Month | Trend |
|--------|---------|-----------|-------|
| Overall Compliance Score | N% | N% | ↑/↓ |
| Critical Misconfigs | N | N | ↑/↓ |
| High Misconfigs | N | N | ↑/↓ |
| Public S3 Buckets | N | N | ↑/↓ |
| IAM Users without MFA | N | N | ↑/↓ |
| Unencrypted Resources | N | N | ↑/↓ |
| Open Security Groups (0.0.0.0/0) | N | N | ↑/↓ |

## Top Misconfigurations to Check

```bash
# AWS — Most commonly missed
prowler aws -c check116  # S3 public ACLs
prowler aws -c check122  # CloudTrail not enabled
prowler aws -c check142  # Root MFA
prowler aws -c check182  # SG allows 0.0.0.0/0 SSH
prowler aws -c check146  # Access keys > 90 days
prowler aws -c check44   # No VPC flow logs
prowler aws -c check21   # EBS encryption not default
prowler aws -c check75   # RDS not encrypted
```

## Remediation Tracking

```markdown
## CSPM Remediation Tracker — [Month YYYY]

| Finding | Severity | First Seen | Owner | Status | Target Date |
|---------|----------|-----------|-------|--------|-------------|
| Public S3: data-bucket | Critical | YYYY-MM-DD | DevOps | In Progress | YYYY-MM-DD |
| Root MFA disabled | Critical | YYYY-MM-DD | CloudOps | Complete | — |
```

## Output

`reports/cspm-[CLOUD]-[DATE].md` with:
- Compliance score (current vs. last assessment)
- New findings since last scan
- Remediated findings (progress tracking)
- Priority remediation list with owner assignments
