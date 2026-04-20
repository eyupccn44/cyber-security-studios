# /network-recon — Active Network Reconnaissance

```
Use agent: network-pentester
Pre-req: scope validated via validate-scope.sh
```

## Purpose

Perform active network reconnaissance against in-scope assets to discover live hosts, open ports, running services, and OS/version information.

## ⚠️ Scope Validation

Every target MUST be in `production/active-engagement.md` before scanning.

## Phase 1: Host Discovery

```bash
# Ping sweep (fast host discovery)
nmap -sn -PE -PP -PS80,443,22,3389 $SCOPE_RANGE -oG recon/live-hosts.txt

# ARP scan (internal networks)
arp-scan --interface=eth0 $SCOPE_RANGE

# Extract live IPs
grep "Up" recon/live-hosts.txt | awk '{print $2}' > recon/live-ips.txt
echo "[+] Live hosts: $(wc -l < recon/live-ips.txt)"
```

## Phase 2: Port Scanning

```bash
# Fast full-port scan
nmap -sS -p- --min-rate 1000 -T4 -iL recon/live-ips.txt \
     -oA recon/full-port-scan

# Service version detection on discovered ports
nmap -sV -sC -p $OPEN_PORTS --version-intensity 7 \
     -iL recon/live-ips.txt -oA recon/service-scan
```

## Phase 3: Service-Specific Enumeration

```bash
# SMB enumeration
enum4linux-ng -A $TARGET > recon/smb-enum.txt
crackmapexec smb $SCOPE_RANGE --shares

# SNMP enumeration
snmpwalk -c public -v1 $TARGET

# Web services
httpx -l recon/live-ips.txt -p 80,443,8080,8443 -title -tech-detect \
      -o recon/web-services.txt

# DNS zone transfer attempt
dig axfr @$DNS_SERVER $DOMAIN

# LDAP enumeration (if AD environment)
ldapsearch -x -H ldap://$DC_IP -b "DC=domain,DC=com"
```

## Phase 4: Vulnerability Scanning

```bash
# Nessus / OpenVAS scan (if available)
# OR Nmap NSE vulnerability scripts
nmap --script=vuln -iL recon/live-ips.txt -oA recon/vuln-scan

# Nuclei for network service CVEs
nuclei -l recon/web-services.txt -t technologies/ -t cves/ -o recon/nuclei.txt
```

## Output

```
recon/
├── live-hosts.txt
├── live-ips.txt
├── full-port-scan.{nmap,gnmap,xml}
├── service-scan.{nmap,gnmap,xml}
├── smb-enum.txt
├── web-services.txt
└── network-summary.md      ← Handoff to pentest-lead
```

**network-summary.md** includes:
- Total live hosts
- Interesting open ports and services
- Potential attack paths identified
- Recommended next steps
