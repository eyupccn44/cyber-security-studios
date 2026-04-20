# /dns-enum — DNS Enumeration & Zone Analysis

```
Use agent: osint-analyst
Coordinate with: network-pentester, pentest-lead
```

## Purpose

Perform comprehensive DNS reconnaissance to enumerate records, test for zone transfer vulnerabilities, identify mail infrastructure, discover internal naming conventions, and map DNS-based attack vectors.

## Pre-Execution Check

- [ ] Target domain(s) confirmed in scope
- [ ] Nameserver IPs included in authorized scope (for zone transfer)
- [ ] Rate limits understood

## Enumeration Phases

### Phase 1: Core DNS Record Collection

```bash
TARGET="target.com"

# All record types
for type in A AAAA MX NS TXT SOA CNAME PTR SRV CAA DMARC; do
  echo "=== $type Records ==="
  dig $TARGET $type +short
done

# SPF, DMARC, DKIM records (email security posture)
echo "=== SPF ==="
dig TXT $TARGET +short | grep "spf"

echo "=== DMARC ==="
dig TXT _dmarc.$TARGET +short

echo "=== DKIM (common selectors) ==="
for sel in default google mail k1 s1 s2 selector1 selector2 dkim; do
  result=$(dig TXT ${sel}._domainkey.$TARGET +short 2>/dev/null)
  [ -n "$result" ] && echo "$sel: $result"
done
```

### Phase 2: Zone Transfer Attempt

```bash
# Get nameservers
NS_SERVERS=$(dig NS $TARGET +short)
echo "Nameservers: $NS_SERVERS"

# Attempt zone transfer from each nameserver
for ns in $NS_SERVERS; do
  echo "[*] Attempting AXFR from $ns..."
  dig @$ns $TARGET AXFR
done
# Successful zone transfer = CRITICAL finding
```

### Phase 3: DNS Brute-Force

```bash
# DNSRecon comprehensive scan
dnsrecon -d $TARGET -t brt -D /opt/wordlists/subdomains-top5000.txt \
  -x dnsrecon-output.xml

# Gobuster DNS mode
gobuster dns -d $TARGET \
  -w /opt/wordlists/subdomains-top1million.txt \
  -t 50 \
  -o dns-gobuster.txt

# Fierce — legacy but effective for internal network discovery
fierce --domain $TARGET --subdomains /opt/wordlists/fierce-wordlist.txt
```

### Phase 4: Reverse DNS Lookups

```bash
# Find IP ranges from A records
TARGET_IPS=$(dig A $TARGET +short)
for ip in $TARGET_IPS; do
  RANGE=$(echo $ip | cut -d. -f1-3)
  echo "[*] Scanning reverse DNS for $RANGE.0/24"
  for i in $(seq 1 254); do
    result=$(dig -x $RANGE.$i +short 2>/dev/null)
    [ -n "$result" ] && echo "$RANGE.$i → $result"
  done
done
```

### Phase 5: DNS Security Assessment

```bash
# DNSSEC validation
dig $TARGET DNSKEY +short
dig $TARGET DS +short
# Check if DNSSEC is properly configured

# DNS over HTTPS / TLS support
curl -s "https://dns.google/resolve?name=${TARGET}&type=A"

# Check for DNS cache poisoning indicators
dig $TARGET A @8.8.8.8
dig $TARGET A @1.1.1.1
# Compare results — discrepancies may indicate cache poisoning
```

## Findings Classification

| Record/Test | Finding | Severity |
|-------------|---------|----------|
| Zone Transfer Success | Full DNS zone exposed | Critical |
| No DMARC | Email spoofing possible | High |
| No SPF | Email spoofing possible | High |
| Wildcard DNS | May hide subdomains | Medium |
| No DNSSEC | Cache poisoning risk | Medium |
| Internal IPs in DNS | Network info disclosure | Medium |
| Missing CAA | Cert issuance unrestricted | Low |

## Output

```
recon/[engagement-id]/dns/
├── all-records.txt
├── zone-transfer-attempt.txt     ← CRITICAL if successful
├── brute-force-subdomains.txt
├── reverse-dns.txt
└── dns-security-assessment.md
```

Feed results to `/subdomain-enum` and `/attack-surface-map`.
