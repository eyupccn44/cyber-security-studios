# /cloud-audit — Cloud Security Configuration Audit

```
Use agent: cloud-security-lead
Specialists: cloud-pentester (if active testing needed)
```

## Purpose

Assess cloud environment security posture against CIS benchmarks and identify critical misconfigurations.

## Multi-Cloud Audit Commands

### AWS Security Audit
```bash
# Prowler — comprehensive AWS security checks
prowler aws --profile $AWS_PROFILE -M json,html \
    --output-directory reports/cloud-audit/

# ScoutSuite — multi-cloud auditing
python3 scout.py aws --profile $AWS_PROFILE \
    --report-dir reports/cloud-audit/scoutsuite/

# Key checks to prioritize:
prowler aws -c check116,check117,check118  # Public S3 buckets
prowler aws -c check122                    # CloudTrail logging
prowler aws -c check142,check143           # MFA enforcement
prowler aws -c check182,check183           # Security groups (0.0.0.0/0)
```

### Azure Security Audit
```bash
# Prowler for Azure
prowler azure --az-cli-auth --subscription-ids $SUB_ID

# Microsoft Defender for Cloud score review
az security secure-score-controls list | jq '.[] | {name: .displayName, score: .score}'
```

### GCP Security Audit
```bash
# Prowler for GCP
prowler gcp --project-ids $PROJECT_ID

# Cloud Asset Inventory
gcloud asset search-all-resources --scope="projects/$PROJECT_ID" \
    --asset-types="storage.googleapis.com/Bucket"
```

## Critical Findings Categories

| Category | Check | Risk |
|----------|-------|------|
| Storage | Public S3/Blob/GCS buckets | Critical |
| IAM | Root account usage | Critical |
| IAM | MFA not enforced | High |
| Network | Security groups allowing 0.0.0.0/0 on SSH/RDP | High |
| Logging | CloudTrail/Activity Log disabled | High |
| Encryption | Unencrypted EBS/RDS volumes | Medium |
| Secrets | Access keys > 90 days old | Medium |
| Monitoring | No alerts on root account usage | Medium |

## IAM Privilege Escalation Check

```bash
# Enumerate all IAM users and their policies
aws iam list-users --query 'Users[*].UserName' --output text | \
while read user; do
    echo "=== $user ==="
    aws iam list-attached-user-policies --user-name $user
done

# Check for admin-equivalent policies
aws iam list-policies --scope Local | \
    jq '.Policies[] | select(.AttachmentCount > 0)'
```

## Output

`reports/cloud-audit-[DATE]/`
- Executive summary with risk rating
- Finding-by-finding details with remediation
- CIS benchmark compliance percentage
- Priority remediation roadmap
