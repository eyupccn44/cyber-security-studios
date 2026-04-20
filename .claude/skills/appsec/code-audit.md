# /code-audit — Manual Source Code Security Review

```
Use agent: code-auditor
Coordinate with: appsec-lead, sast-sca-engineer
```

## Purpose

Perform a deep, manual security review of source code focusing on logic flaws, auth bypass, and chained vulnerabilities that automated tools miss.

## Phase 1: Risk-Ranked Scoping

Prioritize review by attack surface risk:
```
CRITICAL  → Authentication, authorization, payment, crypto
HIGH      → All user input handling, file operations, SQL queries
MEDIUM    → Session management, logging, error handling
LOW       → Configuration files, dead code
```

## Phase 2: Targeted Grep Patterns

```bash
# Hardcoded secrets
grep -rn "password\s*=\s*['\"]" --include="*.py" .
grep -rn "secret_key\|api_key\|private_key" --include="*.env*" .

# SQL injection sinks
grep -rn "execute\|query\|cursor" --include="*.py" . | grep -v "?"
grep -rn f"SELECT\|INSERT\|UPDATE\|DELETE" --include="*.py" .

# Command injection
grep -rn "os\.system\|subprocess\.call.*shell=True\|exec(" --include="*.py" .

# Path traversal
grep -rn "open(.*request\|open(.*param\|open(.*user" --include="*.py" .

# Insecure deserialization
grep -rn "pickle\.loads\|yaml\.load(" --include="*.py" .

# Weak crypto
grep -rn "md5\|sha1\b\|DES\|RC4\|ECB" --include="*.py" .
```

## Phase 3: Authorization Review Pattern

For every route/endpoint, verify:
```
1. Is authentication enforced?  (decorator, middleware, manual check)
2. Is authorization enforced?   (does it check the right user/role?)
3. Is it server-side?           (never trust client-side checks alone)
4. Is the resource ID verified? (IDOR check — user A can't access user B's data)
```

## Phase 4: Common Vulnerability Patterns

### IDOR (Most Common Critical)
```python
# ❌ VULNERABLE — uses user-supplied ID without ownership check
def get_document(doc_id):
    return Document.query.get(doc_id)  # Any user can access any doc!

# ✅ SAFE
def get_document(doc_id, current_user):
    doc = Document.query.get(doc_id)
    if doc.owner_id != current_user.id:
        abort(403)
    return doc
```

### SQL Injection
```python
# ❌ VULNERABLE
query = f"SELECT * FROM users WHERE name = '{name}'"

# ✅ SAFE (parameterized)
cursor.execute("SELECT * FROM users WHERE name = %s", (name,))
```

### Path Traversal
```python
# ❌ VULNERABLE
open(f"/uploads/{filename}")

# ✅ SAFE
safe_path = os.path.realpath(os.path.join("/uploads", filename))
if not safe_path.startswith("/uploads/"):
    abort(400)
```

## Output

`engagements/[NAME]/findings/code-audit-[DATE].md`

Each finding includes: severity, file path, line number, vulnerable code, safe code example, remediation guidance.
