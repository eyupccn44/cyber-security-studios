# /shodan-search — Shodan OSINT & Exposed Asset Discovery

```
Use agent: osint-analyst
Coordinate with: pentest-lead, network-pentester
```

## Purpose

Leverage Shodan and complementary internet-wide scanning databases to discover exposed services, misconfigurations, leaked credentials, and attack surface indicators — entirely passively, without touching target systems directly.

## Pre-Execution Check

- [ ] Shodan API key configured (`SHODAN_API_KEY` env var)
- [ ] Target organization name, IP ranges, and domains confirmed
- [ ] Scope includes external exposure assessment

> **No Shodan API key or CLI?** Use the free web UI at [shodan.io](https://www.shodan.io) or the free-tier fallbacks below.

## Fallback: Free-Tier Alternatives (No API Key)

```bash
TARGET_DOMAIN="target.com"
TARGET_IP="$(dig +short $TARGET_DOMAIN A | head -1)"

# Shodan web UI — free manual searches (no CLI needed):
# https://www.shodan.io/search?query=hostname:$TARGET_DOMAIN
# https://www.shodan.io/host/$TARGET_IP

# Censys.io — free 250 queries/month
# https://search.censys.io/?q=$TARGET_DOMAIN

# GreyNoise — see who's scanning the target's IP (free community API)
curl -s "https://api.greynoise.io/v3/community/$TARGET_IP" | python3 -m json.tool 2>/dev/null

# IPinfo.io — free IP intelligence (no key needed)
curl -s "https://ipinfo.io/$TARGET_IP/json" | python3 -m json.tool

# Reverse DNS + ASN lookup (dig + whois — always available)
dig -x $TARGET_IP +short
whois $TARGET_IP 2>/dev/null | grep -E "OrgName|CIDR|NetRange|Country"
```

## Search Phases

### Phase 1: Organization & IP Discovery

```bash
# Shodan CLI searches
TARGET_ORG="Target Organization Name"
TARGET_DOMAIN="target.com"

# Find all IPs belonging to the organization
shodan search --fields ip_str,port,org,os "org:\"$TARGET_ORG\"" > shodan/org-assets.txt

# Search by domain (SSL cert matching)
shodan search --fields ip_str,port,hostnames "ssl.cert.subject.cn:\"$TARGET_DOMAIN\"" >> shodan/ssl-matches.txt
shodan search --fields ip_str,port,hostnames "hostname:\"$TARGET_DOMAIN\"" >> shodan/hostname-matches.txt

# IP range scan (if CIDR in scope)
shodan search --fields ip_str,port,org "net:203.0.113.0/24" > shodan/ip-range.txt
```

### Phase 2: Service & Vulnerability Discovery

```bash
# Find exposed sensitive services
for service in "rdp" "vnc" "telnet" "ftp" "smtp" "mongodb" "elasticsearch" "redis" "cassandra"; do
  shodan search --fields ip_str,port,banner "org:\"$TARGET_ORG\" $service" > shodan/${service}-exposed.txt
  echo "[*] $service: $(wc -l < shodan/${service}-exposed.txt) hosts"
done

# Search for known CVEs in target infrastructure
shodan search "org:\"$TARGET_ORG\" vuln:CVE-2021-44228"  # Log4Shell
shodan search "org:\"$TARGET_ORG\" vuln:CVE-2021-26855"  # Exchange ProxyLogon
shodan search "org:\"$TARGET_ORG\" vuln:CVE-2023-23397"  # Outlook NTLM

# Industrial control systems (if in scope)
shodan search "org:\"$TARGET_ORG\" tag:ics"
```

### Phase 3: Default Credentials & Misconfigurations

```bash
# Admin panels and management interfaces
shodan search "hostname:\"$TARGET_DOMAIN\" http.title:\"Admin\""
shodan search "hostname:\"$TARGET_DOMAIN\" http.title:\"Dashboard\""
shodan search "hostname:\"$TARGET_DOMAIN\" http.title:\"Login\""

# Known exposed panels
shodan search "hostname:\"$TARGET_DOMAIN\" product:\"Apache Tomcat\""
shodan search "hostname:\"$TARGET_DOMAIN\" product:\"Jenkins\""
shodan search "hostname:\"$TARGET_DOMAIN\" product:\"GitLab\""
shodan search "hostname:\"$TARGET_DOMAIN\" product:\"Grafana\""

# Open databases (no authentication)
shodan search "org:\"$TARGET_ORG\" product:\"Elasticsearch\" -authentication"
shodan search "org:\"$TARGET_ORG\" product:\"MongoDB Server\" -authentication"
```

### Phase 4: SSL Certificate Intelligence

```bash
# Find all certs issued for the domain (historical)
# Cross-reference with crt.sh
curl -s "https://crt.sh/?q=%.${TARGET_DOMAIN}&output=json" | \
  jq -r '.[] | "\(.name_value) | \(.issuer_name) | \(.not_before)"' | \
  sort -u > ssl/cert-history.txt

# Find expired or self-signed certs in production
shodan search "hostname:\"$TARGET_DOMAIN\" ssl.cert.expired:true"
shodan search "hostname:\"$TARGET_DOMAIN\" ssl.cert.issuer.cn:\"$TARGET_DOMAIN\""  # Self-signed
```

### Phase 5: Shodan Dorks — High-Value Targets

```bash
# Cameras / Webcams
shodan search "org:\"$TARGET_ORG\" has_screenshot:true"

# Exposed Git repositories
shodan search "hostname:\"$TARGET_DOMAIN\" http.html:\".git\""

# AWS/Cloud metadata endpoints
shodan search "org:\"$TARGET_ORG\" http.html:\"169.254.169.254\""

# API documentation exposed
shodan search "hostname:\"$TARGET_DOMAIN\" http.title:\"Swagger\""
shodan search "hostname:\"$TARGET_DOMAIN\" http.title:\"API Documentation\""
```

### Phase 6: Complementary Databases

```bash
# Censys — alternative to Shodan
# (via web UI or API)
# censys.io/search → "target.com"

# Fofa (Chinese alternative, global data)
# fofa.info → domain="target.com"

# GreyNoise — check if IPs are scanners/benign
# greynoise.io/viz → check IPs found in Shodan

# OSINT Industries / Intelligence X
# intelx.io → search email domains, IPs
```

## Findings Classification

| Discovery | Severity |
|-----------|----------|
| Unauthenticated database exposed | Critical |
| Remote management service (RDP/VNC) exposed | High |
| Known CVE confirmed via Shodan | High |
| Admin panel exposed to internet | High |
| Default credentials login page | High |
| Outdated software versions | Medium |
| Expired SSL certificate | Medium |
| Self-signed certificate in production | Low |

## Output

```
recon/[engagement-id]/shodan/
├── org-assets.txt               ← All discovered IPs
├── vulnerable-services.txt      ← CVE matches
├── exposed-panels.txt           ← Admin/management UIs
├── ssl/cert-history.txt         ← Certificate intelligence
└── shodan-summary.md            ← Analyst summary
```

Feed critical findings directly to `pentest-lead` for priority targeting. All IPs feed into `/network-pentest`.
