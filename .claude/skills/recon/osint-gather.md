# /osint-gather — Open Source Intelligence Collection

```
Use agent: osint-analyst
```

## Purpose

Conduct passive OSINT reconnaissance on the target to map the attack surface, discover exposed assets, and build an intelligence picture — without touching target systems.

## Pre-Execution Check

Before running, confirm:
- [ ] Target is defined in `production/active-engagement.md`
- [ ] Passive reconnaissance is within scope
- [ ] Client is aware OSINT will be performed (if required)

> **Tools not installed?** Run `./install.sh` from the studio root, or use the fallbacks below.

## Fallback Commands (no tools required)

If `subfinder`/`amass`/`theHarvester` are not installed, use these web-based alternatives:

```bash
# Certificate Transparency (curl only — always available)
curl -s "https://crt.sh/?q=%.${TARGET}&output=json" | python3 -c \
  "import sys,json; [print(e['name_value']) for e in json.load(sys.stdin)]" | \
  sort -u > recon/ct-subdomains.txt

# DNS records (dig — built into macOS/Linux)
dig +noall +answer $TARGET ANY
dig +noall +answer www.$TARGET A
dig +noall +answer mail.$TARGET MX

# Wayback Machine (curl only)
curl -s "http://web.archive.org/cdx/search/cdx?url=*.${TARGET}&output=text&fl=original&collapse=urlkey" \
  | sort -u > recon/wayback-urls.txt

# Web-based alternatives (open in browser):
# https://crt.sh/?q=%.TARGET         — Certificate transparency
# https://bgp.he.net/dns/TARGET      — ASN, IP ranges
# https://securitytrails.com/        — DNS history (free tier)
# https://haveibeenpwned.com/        — Breach data
# https://www.shodan.io/             — Exposed services
```

## Collection Tasks

### Domain & DNS Intelligence
```bash
# Subdomain enumeration
subfinder -d $TARGET -all -recursive -o recon/subdomains.txt
amass enum -passive -d $TARGET -o recon/amass-subdomains.txt

# DNS records
dnsx -l recon/subdomains.txt -a -cname -mx -txt -o recon/dns-records.txt

# Certificate transparency
curl -s "https://crt.sh/?q=%.$TARGET&output=json" | jq -r '.[].name_value' | sort -u
```

### Infrastructure Intelligence
```bash
# Shodan lookup
shodan domain $TARGET

# Exposed services on known IPs
shodan host $IP

# ASN and IP range discovery
# Query: https://bgp.he.net/dns/$TARGET
```

### Code Repository Leaks
```bash
# GitHub dorking
trufflehog github --org=$TARGET_ORG

# GitLab public repos
# Search: https://gitlab.com/explore/projects?search=$TARGET
```

### Email & Employee Intelligence
```bash
# Email harvesting
theHarvester -d $TARGET -b all -l 500 -f recon/emails.html

# LinkedIn employee discovery (manual)
# LinkedIn search: company:"$TARGET" site:linkedin.com/in
```

### Historical Data
```bash
# Wayback Machine
waybackurls $TARGET | tee recon/wayback-urls.txt

# Historical DNS
# Query: https://securitytrails.com/domain/$TARGET/dns
```

## Output Structure

```
recon/
├── subdomains.txt          # All discovered subdomains
├── dns-records.txt         # DNS record dump
├── emails.txt              # Discovered email addresses
├── infrastructure.md       # IP ranges, ASN, hosting providers
├── employees.md            # Employee names, roles, LinkedIn
├── code-leaks.md           # GitHub/GitLab findings
└── osint-summary.md        # Consolidated intelligence picture
```

## Deliverable

The osint-analyst will produce `recon/osint-summary.md` containing:
- Total discovered assets (subdomains, IPs, domains)
- Interesting findings (exposed credentials, sensitive files, technology stack)
- Recommended attack paths based on OSINT findings
- Handoff notes for network-pentester and web-pentester
