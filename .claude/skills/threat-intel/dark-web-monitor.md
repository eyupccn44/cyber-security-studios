# /dark-web-monitor — Dark Web Monitoring & Intelligence Collection

```
Use agent: threat-actor-analyst
Coordinate with: threat-intel-lead, osint-analyst
```

## Purpose

Conduct structured dark web monitoring to identify leaked credentials, stolen data, threat actor discussions, planned attacks, and brand/infrastructure mentions — using legal OSINT methods, automated monitoring tools, and curated intelligence feeds. All activities conducted legally and ethically.

## Pre-Execution Check

- [ ] Authorized scope includes dark web intelligence collection
- [ ] Monitoring targets defined (domain, brand, employee emails, IP ranges)
- [ ] Legal review completed for jurisdiction (Tor access laws vary by country)
- [ ] Operational security measures in place (isolated VM, Tor)
- [ ] Retention policy for collected data established

## Operational Security Setup

```bash
# Use isolated VM with no personal identifiers
# Route all traffic through Tor
# Use fresh Tails OS or Whonix for anonymity

# Verify Tor is running
curl --socks5-hostname localhost:9050 https://check.torproject.org/api/ip

# Test anonymity
torsocks curl ifconfig.me
```

## Monitoring Workflows

### Step 1: Credential Leak Monitoring

```bash
TARGET_DOMAIN="target.com"
TARGET_EMAILS="company.com"

# Check Have I Been Pwned API (legal, authorized)
curl -s "https://haveibeenpwned.com/api/v3/breaches?domain=${TARGET_DOMAIN}" \
  -H "hibp-api-key: $HIBP_API_KEY" | jq '.[] | {Name, BreachDate, DataClasses}'

# Check DeHashed (requires subscription)
curl -s -u "email:api_key" \
  "https://api.dehashed.com/search?query=domain:${TARGET_DOMAIN}&size=100" | \
  jq '.entries[] | {email, password, hashed_password, database_name}'

# Check LeakCheck
curl -s "https://leakcheck.io/api/v2/query/${TARGET_DOMAIN}" \
  -H "X-API-Key: $LEAKCHECK_KEY" | jq '.'

# SpyCloud / Flare / DarkOwl (enterprise tools — if licensed)
# These provide automated dark web monitoring with alerts
```

### Step 2: Paste Site Monitoring

```bash
# Monitor Pastebin, Ghostbin, Rentry for mentions
# Legal: Use their APIs or third-party monitoring

# Automated paste monitoring via IntelligenceX
curl -s "https://2.intelx.io/intelligent/search" \
  -H "x-key: $INTELX_KEY" \
  -H "Content-Type: application/json" \
  -d "{\"term\":\"$TARGET_DOMAIN\",\"maxresults\":100}"

# Manual keyword search on accessible paste sites
# target.com, @target.com, target employees
```

### Step 3: Ransomware Leak Site Monitoring

```bash
# Track known ransomware group leak sites (many are Tor-only)
# Monitor via surface web mirrors and threat intel services

# Ransomwatch — open source ransomware leak tracker
# (Access via: https://ransomwatch.telemetry.ltd)
curl -s "https://ransomwatch.telemetry.ltd/api/groups" | \
  jq '.[] | select(.name | test("lockbit|alphv|blackcat"; "i")) | {name, locations}'

# Check if target appears in ransomware victim lists
# DarkFeed, Flare, Cybersixgill — commercial feeds

# Manual check categories:
# - lockbit3.0 leak site (Tor)
# - BlackCat/ALPHV leak site
# - Clop leak site
# - Play ransomware site
```

### Step 4: Threat Actor Forum Monitoring

```bash
# Surface-accessible forums (legal access)
# - XSS.is (Russian cybercrime forum — has surface mirror)
# - BreachForums mirror discussions
# - Telegram channels (public)

# Telegram monitoring for threat intel
# Monitor public cybercrime channels for target mentions
# Tools: TelegramSearchBot, Telethon for public channels

# Search for target organization in public breach databases
# raid forums, breachforums archives (archived on OSINT sites)
```

### Step 5: Data Classification & Triage

```markdown
## Dark Web Finding Classification

| Category | Priority | Action Required |
|----------|----------|-----------------|
| Active ransomware negotiation | CRITICAL | Immediate IR activation |
| Employee credentials listed | HIGH | Force password reset |
| Database dump available | HIGH | Confirm scope of breach |
| Threat actor targeting plan | HIGH | Notify CISO immediately |
| Old credential mentions (>1yr) | MEDIUM | Verify if rotated |
| Brand mention in forum | LOW | Monitor for escalation |
| Generic industry targeting | LOW | Awareness update |
```

### Step 6: Intelligence Report

```markdown
## Dark Web Intelligence Report — [Date]

**Classification**: TLP:AMBER — Share with client only
**Monitoring Period**: [Start] to [End]
**Target Organization**: [Name]

### Executive Summary
[High-level findings for CISO/executive review]

### Critical Findings
[Immediate action required]

### Active Mentions
| Date | Platform | Type | Status | Action |
|------|----------|------|--------|--------|
| ... | Ransomware leak site | Victim listing | Unconfirmed | Investigating |

### Credential Exposures
| Source | Date | # Records | Data Types | Action Taken |
|--------|------|-----------|------------|--------------|

### Recommendations
1. [Immediate action]
2. [Short-term]
3. [Long-term monitoring]
```

## Output

```
intelligence/dark-web/
├── monitoring-config.md        ← Keywords, platforms, schedule
├── alerts/
│   └── YYYY-MM-DD-finding.md  ← Per-finding documentation
├── credential-dumps/
│   └── (sanitized references only — no actual credentials stored)
└── monthly-report.md
```

Escalate critical findings immediately to `threat-intel-lead` and CISO. Feed to `/ir-initiate` if active breach confirmed.
