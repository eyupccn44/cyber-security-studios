# /ioc-extract — Extract and Enrich Indicators of Compromise

```
Use agent: ioc-analyst
Coordinate with: threat-intel-lead, soc-lead
```

## Purpose

Extract IOCs from incident data, malware samples, or threat reports, enrich them, and deploy to defensive controls.

## Extraction Commands

```bash
# From text/reports
ioc-finder "$(cat threat-report.txt)"

# From PCAP
tshark -r capture.pcap -T fields -e ip.dst -e dns.qry.name | sort -u

# Manual grep patterns
grep -Eo "([0-9]{1,3}\.){3}[0-9]{1,3}" logs.txt      # IPs
grep -Eo "[a-z0-9.-]+\.[a-z]{2,}" logs.txt             # Domains
grep -Eo "[a-f0-9]{64}" logs.txt                        # SHA256
```

## Enrichment per IOC Type

### IPs → Query: VirusTotal + AbuseIPDB + GreyNoise + Shodan
### Domains → Query: VirusTotal + WHOIS + URLScan.io + Passive DNS
### Hashes → Query: VirusTotal + MalwareBazaar

## IOC Output Format

```yaml
- type: ip
  value: "1.2.3.4"
  confidence: high
  context: "LockBit C2 server"
  action: block

- type: domain
  value: "evil.com"
  confidence: high
  context: "Phishing domain"
  action: block

- type: hash
  value: "sha256:abc123..."
  confidence: high
  context: "LockBit encryptor"
  action: quarantine
```

## Deployment

Push enriched IOCs to: SIEM blocklists, EDR custom IOCs, firewall deny rules, proxy blocklist, MISP platform.

## Output

`intelligence/iocs/[DATE]-[INCIDENT-ID]-iocs.yaml`
