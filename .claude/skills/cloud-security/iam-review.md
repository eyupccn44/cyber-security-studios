# /iam-review — Cloud IAM Privilege Analysis

```
Use agent: cloud-security-lead
```

## Purpose

Review cloud IAM configurations to identify over-privileged accounts, privilege escalation paths, and violations of least privilege.

## AWS IAM Review

```bash
# List all users and their policies
aws iam generate-credential-report
aws iam get-credential-report --query 'Content' --output text | base64 -d

# Users with admin access
aws iam list-users | jq -r '.Users[].UserName' | while read u; do
  aws iam list-attached-user-policies --user-name $u | \
    jq --arg u "$u" '.AttachedPolicies[] | select(.PolicyName | contains("Admin")) | $u + ": " + .PolicyName'
done

# Root account usage (should be 0)
aws iam get-account-summary | jq '.SummaryMap.AccountAccessKeysPresent'

# MFA status
aws iam get-account-summary | jq '.SummaryMap.AccountMFAEnabled'

# Users without MFA
aws iam generate-credential-report && sleep 5
aws iam get-credential-report --query 'Content' --output text | base64 -d | \
  awk -F, '$4 == "false" && $8 == "false" {print $1 " — No MFA"}'

# Access keys > 90 days old
aws iam list-users | jq -r '.Users[].UserName' | while read u; do
  aws iam list-access-keys --user-name $u | \
    jq --arg u "$u" '.AccessKeyMetadata[] | select(.Status=="Active") | {user: $u, key: .AccessKeyId, created: .CreateDate}'
done
```

## Azure IAM Review

```bash
# List all role assignments
az role assignment list --all --output table

# Find users with Owner/Contributor at subscription level
az role assignment list --all | jq '.[] | select(.roleDefinitionName == "Owner")'

# Check for guest users with high privilege
az ad user list --filter "userType eq 'Guest'" | jq '.[].userPrincipalName'

# Service principals with excessive permissions
az ad sp list --all | jq '.[].appId' | while read spid; do
  az role assignment list --assignee $spid | jq --arg sp "$spid" \
    '.[] | select(.roleDefinitionName | test("Contributor|Owner")) | $sp + ": " + .roleDefinitionName'
done
```

## IAM Finding Categories

| Risk | Finding | Remediation |
|------|---------|-------------|
| Critical | Root account access keys exist | Delete root access keys immediately |
| Critical | No MFA on privileged accounts | Enforce MFA via SCP / Conditional Access |
| High | Users with AdministratorAccess | Apply least privilege, use roles |
| High | Access keys > 90 days | Rotate access keys, implement key rotation |
| High | Wildcard (*) in resource ARNs | Scope to specific resources |
| Medium | Unused accounts (> 90 days) | Disable or delete inactive accounts |
| Medium | Over-broad IAM policies | Scope permissions per use case |

## Privilege Escalation Paths (AWS)

```python
# Common escalation paths to check:
ESCALATION_PATHS = [
    "iam:CreatePolicyVersion",        # Create new policy version with admin
    "iam:SetDefaultPolicyVersion",    # Set existing version with more perms
    "iam:AttachUserPolicy",           # Attach admin policy to self
    "iam:CreateAccessKey",            # Create key for privileged user
    "lambda:CreateFunction + iam:PassRole",  # Execute as privileged role
    "iam:UpdateAssumeRolePolicy",     # Assume any role
    "ec2:RunInstances + iam:PassRole", # Launch EC2 with privileged role
]
```

## Output

`reports/iam-review-[CLOUD]-[DATE].md` with:
- Over-privileged accounts list
- Privilege escalation paths found
- Access key age violations
- MFA gaps
- Prioritized remediation steps
