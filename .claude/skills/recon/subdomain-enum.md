# /subdomain-enum — Subdomain Enumeration & Discovery

```
Use agent: osint-analyst
Coordinate with: pentest-lead, network-pentester
```

## Purpose

Systematically discover all subdomains belonging to a target organization using passive OSINT sources, DNS brute-forcing, certificate transparency logs, and web crawling — to map the full external attack surface before active testing begins.

## Pre-Execution Check

- [ ] Root domain(s) confirmed in scope
- [ ] Wildcard DNS behavior understood (test first)
- [ ] Rate limiting awareness — respect target infrastructure
- [ ] Cloud assets authorized for enumeration

> **Tools not installed?** Run `./install.sh` from the studio root. Fallback commands below work with only `curl`, `dig`, and `python3` (all pre-installed on macOS/Linux).

## Fallback: No-Install Enumeration

```bash
TARGET="target.com"
mkdir -p passive active analysis

# Fallback 1: Certificate Transparency (curl + python3)
curl -s "https://crt.sh/?q=%.${TARGET}&output=json" | \
  python3 -c "import sys,json; data=json.load(sys.stdin); \
  [print(e['name_value'].replace('*.','')) for e in data]" 2>/dev/null | \
  sort -u > passive/ct-logs.txt
echo "[*] CT Logs: $(wc -l < passive/ct-logs.txt) entries"

# Fallback 2: DNS resolution (dig — built-in)
while IFS= read -r sub; do
  result=$(dig +short "$sub" A 2>/dev/null | head -1)
  [ -n "$result" ] && echo "$sub → $result"
done < passive/ct-logs.txt > active/resolved-dig.txt

# Fallback 3: Common subdomains (no wordlist needed)
for sub in www api dev staging test admin mail smtp pop3 imap vpn git gitlab jenkins jira confluence portal dashboard; do
  result=$(dig +short "${sub}.${TARGET}" A 2>/dev/null | head -1)
  [ -n "$result" ] && echo "${sub}.${TARGET} → $result"
done >> active/resolved-dig.txt

echo "[*] Live hosts: $(wc -l < active/resolved-dig.txt)"
```

## Enumeration Phases

### Phase 1: Passive Reconnaissance (No direct target contact)

```bash
TARGET="target.com"

# Certificate Transparency Logs — fastest passive method
curl -s "https://crt.sh/?q=%.${TARGET}&output=json" | \
  jq -r '.[].name_value' | \
  sed 's/\*\.//g' | sort -u > passive/ct-logs.txt

# Subfinder — aggregates 50+ passive sources
subfinder -d $TARGET -o passive/subfinder.txt -all -silent

# Amass passive mode
amass enum -passive -d $TARGET -o passive/amass-passive.txt

# theHarvester — email, subdomain, IP from search engines
theHarvester -d $TARGET -b all -f passive/harvester-output

# Merge and deduplicate
cat passive/*.txt | sort -u > passive/all-passive.txt
echo "[*] Passive: $(wc -l < passive/all-passive.txt) subdomains found"
```

### Phase 2: DNS Brute-Force (Active)

```bash
# Test for wildcard DNS first
dig A "$(openssl rand -hex 8).${TARGET}" +short
# If returns IP → wildcard exists → filter results accordingly

# dnsx — fast DNS resolution
dnsx -l passive/all-passive.txt -o active/resolved.txt -resp -silent

# Brute-force with common wordlist
ffuf -w /opt/wordlists/subdomains-top1million.txt \
     -u https://FUZZ.${TARGET} \
     -mc 200,301,302,401,403 \
     -o active/ffuf-subdomains.json \
     -t 50

# Puredns — accurate mass DNS resolution
puredns bruteforce /opt/wordlists/subdomains-top1million.txt $TARGET \
  --resolvers /opt/resolvers.txt -w active/puredns.txt
```

### Phase 3: Web Crawling & JS Analysis

```bash
# Katana — crawl discovered subdomains for more endpoints
cat active/resolved.txt | katana -jc -o active/katana-endpoints.txt

# Extract additional domains from JavaScript files
cat active/katana-endpoints.txt | grep "\.js$" | \
  xargs -I{} curl -s {} | grep -oE "([a-zA-Z0-9-]+\.${TARGET})" | sort -u
```

### Phase 4: Cloud Asset Discovery

```bash
# Check for S3 buckets, Azure blobs, GCP storage
TARGET_CLEAN=$(echo $TARGET | sed 's/\./\-/g')
for pattern in $TARGET ${TARGET_CLEAN} "${TARGET_CLEAN}-backup" "${TARGET_CLEAN}-dev" "${TARGET_CLEAN}-staging"; do
  # AWS S3
  curl -s "https://${pattern}.s3.amazonaws.com/" | grep -q "NoSuchBucket" || \
    echo "[!] POTENTIAL S3: ${pattern}.s3.amazonaws.com"
  # Azure
  curl -s "https://${pattern}.blob.core.windows.net/" | grep -q "BlobServiceProperties" && \
    echo "[!] POTENTIAL Azure Blob: ${pattern}.blob.core.windows.net"
done
```

### Phase 5: Port Scan on Discovered Subdomains

```bash
# Quick port scan on all resolved subdomains
nmap -iL active/resolved-ips.txt \
     -p 80,443,8080,8443,8000,8888,3000,4000,5000,9000 \
     --open -T4 \
     -oA active/nmap-web-ports
```

## Results Analysis

```bash
# Identify interesting subdomains
grep -iE "dev|staging|test|beta|admin|api|internal|vpn|mail|git|jenkins|jira|confluence" \
  active/resolved.txt > analysis/interesting-subdomains.txt

# Check HTTP status of all resolved hosts
cat active/resolved.txt | httpx -status-code -title -tech-detect \
  -o analysis/httpx-results.txt -silent
```

## Output Structure

```
recon/[engagement-id]/subdomains/
├── passive/
│   ├── ct-logs.txt
│   ├── subfinder.txt
│   └── all-passive.txt
├── active/
│   ├── resolved.txt          ← DNS-confirmed subdomains
│   ├── resolved-ips.txt
│   └── nmap-web-ports.txt
└── analysis/
    ├── interesting-subdomains.txt
    └── httpx-results.txt      ← Technologies, titles, status codes
```

## Handoff

Feed `resolved.txt` into `/attack-surface-map` for full surface mapping, and `interesting-subdomains.txt` to `web-pentester` for prioritized testing.
