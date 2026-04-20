# /serverless-security — Serverless Function Security Assessment

```
Use agent: cloud-security-lead
Coordinate with: appsec-engineer, devsecops-engineer
```

## Purpose

Assess the security posture of serverless computing environments (AWS Lambda, Azure Functions, Google Cloud Functions) — covering function code vulnerabilities, IAM over-permission, event trigger security, secrets management, and serverless-specific attack vectors.

## Pre-Execution Check

- [ ] Cloud provider access credentials with read permissions
- [ ] Function source code access (white-box) or ARNs/names (grey-box)
- [ ] Scope includes serverless infrastructure components
- [ ] Billing alerts enabled (avoid runaway cost from testing)

## Assessment Framework

### Phase 1: Function Discovery & Inventory

```bash
# AWS Lambda — enumerate all functions
aws lambda list-functions --query 'Functions[].{Name:FunctionName,Runtime:Runtime,Role:Role,LastModified:LastModified}' \
  --output table

# Get function configuration and code
aws lambda get-function --function-name my-function
aws lambda get-function-configuration --function-name my-function

# Download function code for review
aws lambda get-function --function-name my-function \
  --query 'Code.Location' --output text | xargs curl -o function.zip
unzip function.zip -d function-code/

# Azure Functions — enumerate
az functionapp list --query '[].{Name:name,Location:location,State:state}' --output table
az functionapp function list --name my-app --resource-group my-rg

# GCP Cloud Functions
gcloud functions list --format="table(NAME,STATUS,TRIGGER,RUNTIME)"
gcloud functions describe my-function --format=json
```

### Phase 2: IAM & Permission Review

```bash
# AWS Lambda — check execution role permissions
ROLE_ARN=$(aws lambda get-function-configuration --function-name my-function \
  --query 'Role' --output text)
ROLE_NAME=$(basename $ROLE_ARN)

# Get attached policies
aws iam list-attached-role-policies --role-name $ROLE_NAME --output table

# Check inline policies
aws iam list-role-policies --role-name $ROLE_NAME --output table

# Get actual permissions (check for over-privilege)
aws iam get-role-policy --role-name $ROLE_NAME --policy-name my-policy | \
  jq '.PolicyDocument.Statement[] | select(.Effect=="Allow") | .Action'

# Flags to look for:
# "*" on any resource = over-privilege
# "s3:*" = full S3 access
# "iam:*" = IAM privilege escalation risk
# "lambda:*" = can create/modify other functions

# Check for admin-equivalent roles
aws iam list-attached-role-policies --role-name $ROLE_NAME | \
  grep -i "AdministratorAccess\|PowerUserAccess"
```

### Phase 3: Function Code Security Review

```python
# Automated review — search for common issues
import os, re

SUSPICIOUS_PATTERNS = {
    'hardcoded_creds': r'(password|secret|api_key|aws_secret)\s*=\s*["\'][^"\']{8,}',
    'sql_injection': r'(cursor\.execute|query)\s*\([^)]*\+',
    'command_injection': r'(os\.system|subprocess\.run|exec)\s*\(',
    'insecure_deserialization': r'pickle\.loads|yaml\.load\b',
    'path_traversal': r'open\s*\(\s*[^)]*\+',
    'hardcoded_endpoint': r'https?://(?!localhost)[a-z0-9.-]+\.(com|net|io)',
    'ssrf_vector': r'(urllib|requests)\.(get|post)\s*\([^)]*input',
}

for root, dirs, files in os.walk('function-code/'):
    for file in files:
        if file.endswith(('.py', '.js', '.ts', '.go', '.java')):
            filepath = os.path.join(root, file)
            with open(filepath, 'r', errors='ignore') as f:
                content = f.read()
                for issue, pattern in SUSPICIOUS_PATTERNS.items():
                    matches = re.findall(pattern, content, re.IGNORECASE)
                    if matches:
                        print(f"[{issue.upper()}] {filepath}: {matches[:2]}")
```

### Phase 4: Event Trigger Security

```bash
# AWS API Gateway trigger — check authentication
aws apigateway get-rest-apis --output table

# Check if API methods require auth
aws apigateway get-method \
  --rest-api-id abc123 \
  --resource-id xyz789 \
  --http-method GET | \
  jq '{AuthorizationType: .authorizationType, ApiKeyRequired: .apiKeyRequired}'
# authorizationType: "NONE" = unauthenticated = POTENTIAL FINDING

# S3 trigger — check bucket permissions
aws lambda list-event-source-mappings --function-name my-function
# Get bucket name, then:
aws s3api get-bucket-acl --bucket trigger-bucket-name
aws s3api get-bucket-policy --bucket trigger-bucket-name

# SQS trigger — check queue policy
aws sqs get-queue-attributes --queue-url https://sqs.../queue \
  --attribute-names Policy | jq '.Attributes.Policy | fromjson'

# SNS trigger — check topic policy
aws sns get-topic-attributes --topic-arn arn:aws:sns:... \
  --query 'Attributes.Policy' | jq 'fromjson'
```

### Phase 5: Secrets & Environment Variables

```bash
# Check environment variables for hardcoded secrets
aws lambda get-function-configuration --function-name my-function \
  --query 'Environment.Variables' | \
  jq 'to_entries[] | select(.key | test("PASSWORD|SECRET|KEY|TOKEN|PASS"; "i"))'

# Check if using proper secrets management
aws lambda get-function-configuration --function-name my-function \
  --query 'Environment.Variables' | \
  jq 'keys[]'
# Should see: DB_SECRET_ARN, not DB_PASSWORD

# Verify Secrets Manager usage in code
grep -rn "secretsmanager\|SSM\|ParameterStore\|get_secret_value" function-code/
# Good: using AWS Secrets Manager
# Bad: hardcoded credentials in env vars

# Check for KMS encryption on env vars
aws lambda get-function-configuration --function-name my-function | \
  jq '.KMSKeyArn'
# null = env vars not encrypted at rest with custom KMS key
```

### Phase 6: Serverless-Specific Attacks

```bash
# Function event injection testing
# (If you have write access to event sources)

# SQS poisoning — inject malicious payload
aws sqs send-message \
  --queue-url https://sqs.../trigger-queue \
  --message-body '{"key": "../../../../etc/passwd"}'

# Test SSRF via function
# If function fetches URLs based on input:
curl -X POST $FUNCTION_URL \
  -d '{"url": "http://169.254.169.254/latest/meta-data/iam/security-credentials/"}'

# Cold start timing attack (for cryptographic operations)
# Measure response time to determine if secrets cached
```

## Serverless Security Checklist

| Check | Status | Severity |
|-------|--------|----------|
| No hardcoded credentials in code/env | [ ] | Critical |
| Execution role follows least privilege | [ ] | High |
| API endpoints require authentication | [ ] | High |
| Env vars encrypted with KMS | [ ] | Medium |
| Function code vulnerability-scanned | [ ] | Medium |
| VPC-isolated (if accessing private resources) | [ ] | Medium |
| Reserved concurrency set (DoS protection) | [ ] | Low |
| Dead letter queue configured | [ ] | Low |
| X-Ray tracing enabled | [ ] | Low |

## Output

```
engagements/[id]/serverless/
├── function-inventory.md
├── iam-review/
│   └── over-privileged-roles.md
├── code-review/
│   └── security-findings.md
└── serverless-findings.md
```

Feed to `cloud-security-lead` and `devsecops-engineer` for remediation. Critical findings → immediate escalation.
