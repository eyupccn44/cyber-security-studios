# /attack-surface-map — Map Complete External Attack Surface

```
Use agent: osint-analyst
Coordinate with: network-pentester, web-pentester
```

## Purpose

Build a comprehensive map of the target's external attack surface by combining OSINT findings into a unified picture of all externally exposed assets.

## Data Sources to Combine

```bash
# 1. Subdomain enumeration
subfinder -d $TARGET -all -o recon/subs-subfinder.txt
amass enum -passive -d $TARGET -o recon/subs-amass.txt
cat recon/subs-*.txt | sort -u > recon/all-subdomains.txt

# 2. DNS resolution (live subdomains only)
dnsx -l recon/all-subdomains.txt -a -resp -o recon/live-subdomains.txt

# 3. HTTP probe (find web services)
httpx -l recon/live-subdomains.txt -title -status-code \
      -tech-detect -follow-redirects -o recon/web-services.txt

# 4. Certificate transparency
curl -s "https://crt.sh/?q=%.$TARGET&output=json" | \
    jq -r '.[].name_value' | sort -u >> recon/all-subdomains.txt

# 5. Shodan for exposed IPs
shodan domain $TARGET > recon/shodan-domain.txt

# 6. Port scanning on resolved IPs
cat recon/live-subdomains.txt | awk '{print $2}' | sort -u > recon/live-ips.txt
nmap -sV --open -p 21,22,23,25,53,80,110,143,443,445,993,995,1433,3306,3389,5432,6379,8080,8443,27017 \
     -iL recon/live-ips.txt -oN recon/ports.txt
```

## Attack Surface Map Sections

### 1. Asset Inventory
| Asset Type | Count | Notable Findings |
|-----------|-------|-----------------|
| Subdomains | N | |
| Live Web Services | N | |
| Exposed IP Ranges | N | |
| Open Ports (non-standard) | N | |
| SSL/TLS Certificates | N | |

### 2. Technology Stack
- Web frameworks detected
- CMS platforms (WordPress, Drupal, etc.)
- Web servers (Apache, Nginx, IIS)
- Cloud providers (AWS, Azure, GCP)
- CDN / WAF detected

### 3. High-Value Targets
Prioritize for testing:
- Admin panels (admin., portal., dashboard.)
- API endpoints (api., graphql., swagger.)
- Dev/staging environments (dev., test., staging.)
- Legacy services (old IP directly, non-HTTPS)
- Exposed management interfaces (VPN, RDP, SSH)

### 4. Attack Path Recommendations
Based on the surface map, prioritize:
1. [Highest-value target with lowest barrier]
2. [Second priority]
3. [Third priority]

## Output

`recon/attack-surface-map.md` — Full surface map with recommendations
Hand off to pentest-lead for test prioritization.
