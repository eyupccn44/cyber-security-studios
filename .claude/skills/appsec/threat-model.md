# /threat-model — Conduct Threat Modeling Session

```
Use agent: appsec-engineer
Coordinate with: appsec-lead, development team
```

## Purpose

Systematically identify security threats in a system design before implementation to catch issues early when they're cheapest to fix.

## STRIDE Threat Modeling

### Step 1: Define the Scope
- What system/feature are we modeling?
- What are the system boundaries?
- Who are the users and external systems?

### Step 2: Create Data Flow Diagram (DFD)

```
[User Browser] --HTTPS--> [Load Balancer] --HTTP--> [App Server]
                                                          |
                                                    [Database]
                                                    [Cache/Redis]
                                                    [Message Queue]
```

Document:
- All data stores (databases, file systems, caches)
- All data flows (what data moves where)
- All trust boundaries (where authentication is required)
- All external entities (users, third-party APIs, services)

### Step 3: Apply STRIDE per Component

For each component and data flow, ask:

| Threat | Question | Example Finding |
|--------|----------|-----------------|
| **S**poofing | Can an attacker impersonate a user/service? | JWT can be forged if using weak key |
| **T**ampering | Can data be modified in transit or at rest? | API parameters not validated server-side |
| **R**epudiation | Can actions be denied? | No audit logging on admin operations |
| **I**nformation Disclosure | Can sensitive data leak? | Error messages expose stack traces |
| **D**enial of Service | Can service be disrupted? | No rate limiting on auth endpoints |
| **E**levation of Privilege | Can users gain higher permissions? | IDOR allows accessing other users' data |

### Step 4: Rate and Prioritize Threats

Use DREAD scoring:
```
D = Damage potential    (0-10)
R = Reproducibility     (0-10)
E = Exploitability      (0-10)
A = Affected users      (0-10)
D = Discoverability     (0-10)

DREAD Score = Average of above
8-10 = Critical | 5-7 = High | 3-4 = Medium | 1-2 = Low
```

### Step 5: Define Mitigations

For each identified threat:
```
Threat: [STRIDE category + description]
Component: [Which component is affected]
Risk Score: [DREAD]
Mitigation: [Specific control to implement]
Verification: [How to test the mitigation works]
Owner: [Developer/team responsible]
```

## Threat Model Document Output

```markdown
# Threat Model: [System/Feature Name]

**Date**: [date]
**Participants**: [names]
**Scope**: [what was modeled]

## System Overview
[DFD diagram or description]

## Trust Boundaries
[List of trust boundaries and auth requirements]

## Identified Threats

### THREAT-001 — [Name]
- **Category**: STRIDE category
- **Description**: [What could happen]
- **Impact**: [Business/technical impact]
- **DREAD Score**: [N]
- **Mitigation**: [Control to implement]
- **Status**: Open / In Progress / Mitigated

## Security Requirements Generated
[List of security requirements for development team]
```

## Output

`engagements/[NAME]/threat-model-[SYSTEM]-[DATE].md`
