# Bug Bounty Report Template
## HackerOne / Bugcrowd Format

---

## Vulnerability Title

[Short, clear title — e.g. "IDOR on /api/v1/users/{id} exposes PII of any user"]

---

## Severity

- [ ] Critical
- [ ] High
- [ ] Medium
- [ ] Low
- [ ] Informational

**CVSS v3.1 Score**: X.X
**CVSS Vector**: `CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:H`

---

## Summary

[2-3 sentences. What is the vulnerability, where is it, and what can an attacker do with it?]

Example:
> An Insecure Direct Object Reference (IDOR) vulnerability exists on the `/api/v1/users/{id}` endpoint. An authenticated attacker can access any user's profile data by incrementing the `id` parameter, bypassing authorization checks. This exposes full name, email address, phone number, and address of all users.

---

## Affected Asset

| Field | Value |
|-------|-------|
| **URL** | `https://target.com/api/v1/users/12345` |
| **Parameter** | `id` (path parameter) |
| **Method** | GET |
| **Authentication** | Required (any authenticated user) |

---

## Steps to Reproduce

**Prerequisites**: Valid account on target.com

1. Log in to `https://target.com` with your account
2. Navigate to your profile: `https://target.com/api/v1/users/YOUR_ID`
3. Capture the request in Burp Suite
4. Change `YOUR_ID` to another user's ID (e.g. `12344`)
5. Forward the request
6. Observe: Full profile data of another user is returned

**Request**:
```http
GET /api/v1/users/12344 HTTP/1.1
Host: target.com
Authorization: Bearer YOUR_TOKEN
```

**Response**:
```json
{
  "id": 12344,
  "name": "Victim User",
  "email": "victim@email.com",
  "phone": "+1234567890",
  "address": "123 Victim St"
}
```

---

## Proof of Concept

[Screenshot or video demonstrating the vulnerability]

```bash
# One-liner PoC (if applicable)
curl -H "Authorization: Bearer YOUR_TOKEN" \
  https://target.com/api/v1/users/12344
```

---

## Impact

**Who is affected**: All registered users (~X users based on public data)

**What can an attacker do**:
- Access PII (name, email, phone, address) of any user
- Enumerate all user IDs to harvest bulk PII
- Use harvested data for phishing, social engineering, or identity theft

**Business impact**:
- GDPR / CCPA violation risk
- Regulatory fines
- Reputational damage

---

## Root Cause

The backend does not verify that the requesting user owns the resource at `id`. Only authentication (valid JWT) is checked, not authorization (ownership).

---

## Remediation

```python
# Insecure (current)
def get_user(user_id):
    return db.query(User).filter(User.id == user_id).first()

# Secure (fix)
def get_user(user_id, requesting_user_id):
    if user_id != requesting_user_id and not is_admin(requesting_user_id):
        raise AuthorizationError("Access denied")
    return db.query(User).filter(User.id == user_id).first()
```

**Recommended fix**: Enforce server-side authorization — verify the authenticated user's ID matches the requested resource ID (or has admin privileges).

---

## References

- [OWASP IDOR](https://owasp.org/www-project-web-security-testing-guide/v42/4-Web_Application_Security_Testing/05-Authorization_Testing/04-Testing_for_Insecure_Direct_Object_References)
- [CWE-639: Authorization Bypass Through User-Controlled Key](https://cwe.mitre.org/data/definitions/639.html)
- [PortSwigger IDOR Guide](https://portswigger.net/web-security/access-control/idor)

---

## Researcher Notes

- [ ] Duplicate check completed (`/duplicate-check`)
- [ ] Scope verified (domain + vuln type in scope)
- [ ] Tested on production with minimal footprint
- [ ] No automated scanning used (if policy prohibits)
- [ ] PII accessed only to demonstrate impact (not stored/shared)
