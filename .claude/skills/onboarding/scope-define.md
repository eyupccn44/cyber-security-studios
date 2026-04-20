# /scope-define — Define Engagement Scope

Invoke the **ciso** agent with input from **pentest-lead** to formally define and document the engagement scope.

```
Use agent: ciso
```

## Purpose

Before any active security operation, the scope must be formally defined and documented. This skill creates the `production/active-engagement.md` file that all subsequent operations will validate against.

## Scope Definition Process

### Step 1: Engagement Details
The CISO will prompt for:
- **Client/Target Name**
- **Engagement Type**: External Pentest | Internal Pentest | Red Team | Web App | Cloud | Mobile | GRC | IR
- **Start Date / End Date**
- **Primary Contact** (name, email, phone)
- **Emergency Stop Contact** (for halting operations)

### Step 2: In-Scope Assets
Define **exactly** what can be tested:
```
In-Scope Examples:
- IP Ranges: 192.168.1.0/24, 10.0.0.1-10.0.0.50
- Domains: *.target.com (excluding mx.target.com)
- Applications: https://app.target.com, https://api.target.com
- Cloud: AWS Account ID 123456789012 (us-east-1 only)
- Physical: Building A, 123 Main St (business hours only)
```

### Step 3: Explicitly Out-of-Scope
Define what is FORBIDDEN even if reachable:
```
Out-of-Scope Examples:
- Production database servers (IPs listed)
- Third-party SaaS platforms
- Partner network segments
- Any system not explicitly listed above
```

### Step 4: Rules of Engagement
- Permitted testing hours (e.g., Mon-Fri 09:00-17:00 local)
- Destructive testing allowed? (DoS, data deletion)
- Social engineering included?
- Physical security included?
- Evasion required? (stealth vs noisy)
- Backup/recovery procedures contact

### Step 5: Authorization Documentation
- [ ] Signed Statement of Work (SOW) received
- [ ] Rules of Engagement (RoE) document signed
- [ ] Emergency contacts confirmed
- [ ] Notification sent to client IT team (if required)

## Output

Creates/updates `production/active-engagement.md` with all scope details.
This file is validated by `hooks/validate-scope.sh` before every active operation.

---
*⚠️ No active security testing should begin before this skill is completed.*
