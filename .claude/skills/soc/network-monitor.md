# /network-monitor — Network Security Monitoring & Anomaly Detection

```
Use agent: soc-analyst
Coordinate with: soc-lead, siem-engineer, threat-hunter
```

## Purpose

Establish structured network security monitoring using traffic analysis, baseline deviation detection, protocol anomaly identification, and behavioral analytics to detect threats that bypass signature-based controls.

## Pre-Execution Check

- [ ] Network monitoring infrastructure in place (TAP, SPAN port, or inline)
- [ ] Baseline traffic profile available or monitoring period defined
- [ ] Alerting thresholds calibrated for environment
- [ ] SIEM/NSM platform accessible (Zeek, Suricata, Arkime)

## Monitoring Framework

### Step 1: Traffic Capture & Baseline

```bash
# Capture network traffic (with authorization)
tcpdump -i eth0 -w capture/traffic-$(date +%Y%m%d-%H%M%S).pcap \
  -G 3600 -z gzip &  # Rotate hourly, compress

# Zeek — structured network logging
zeek -C -i eth0 local.zeek
# Generates: conn.log, dns.log, http.log, ssl.log, files.log, etc.

# Establish baseline: normal traffic per hour
cat zeek-logs/conn.log | zeek-cut orig_bytes | \
  awk '{sum+=$1} END {print "Average hourly bytes:", sum/NR}'

# Identify top talkers (baseline)
cat zeek-logs/conn.log | zeek-cut id.orig_h | \
  sort | uniq -c | sort -rn | head -20
```

### Step 2: Beaconing Detection (C2 Communication)

```bash
# Detect regular interval connections (C2 beaconing)
# Pattern: same src→dst every N seconds with low jitter

# Zeek conn.log analysis
cat zeek-logs/conn.log | zeek-cut ts id.orig_h id.resp_h id.resp_p duration | \
  awk '{print $2,$3,$4}' | sort | uniq -c | sort -rn | \
  awk '$1 > 50' > alerts/high-freq-connections.txt

# Python beaconing detector
python3 - << 'EOF'
import json
from collections import defaultdict
import statistics

connections = defaultdict(list)
with open('zeek-logs/conn.log') as f:
    for line in f:
        if line.startswith('#'): continue
        fields = line.split('\t')
        if len(fields) > 5:
            key = f"{fields[2]}:{fields[4]}:{fields[5]}"  # src:dst:port
            connections[key].append(float(fields[0]))  # timestamp

for key, timestamps in connections.items():
    if len(timestamps) > 20:
        intervals = [timestamps[i+1]-timestamps[i] for i in range(len(timestamps)-1)]
        if intervals:
            mean = statistics.mean(intervals)
            stdev = statistics.stdev(intervals) if len(intervals) > 1 else 0
            jitter = (stdev/mean*100) if mean > 0 else 0
            if jitter < 10 and mean < 300:  # Low jitter, short interval
                print(f"[BEACON] {key} | Interval: {mean:.0f}s | Jitter: {jitter:.1f}%")
EOF
```

### Step 3: Data Exfiltration Detection

```bash
# Large outbound data transfers
cat zeek-logs/conn.log | zeek-cut ts id.orig_h id.resp_h orig_bytes | \
  awk '$4 > 10000000 {print}' | sort -k4 -rn > alerts/large-transfers.txt

# DNS exfiltration detection (long subdomain queries)
cat zeek-logs/dns.log | zeek-cut ts id.orig_h query | \
  awk 'length($3) > 50 {print}' > alerts/dns-long-queries.txt

# HTTPS to unusual destinations
cat zeek-logs/ssl.log | zeek-cut ts id.orig_h server_name | \
  grep -vE "google|microsoft|amazon|apple|cloudflare|akamai" | \
  awk '{print $3}' | sort | uniq -c | sort -rn > alerts/unusual-ssl-destinations.txt

# Upload ratio analysis
cat zeek-logs/conn.log | zeek-cut id.orig_h orig_bytes resp_bytes | \
  awk '{upload[$1]+=$2; download[$1]+=$3} END {
    for (ip in upload) {
      if (upload[ip] > 0 && download[ip] > 0) {
        ratio = upload[ip]/download[ip]
        if (ratio > 2) printf "HIGH-UPLOAD %s | Up: %.0f | Down: %.0f | Ratio: %.2f\n", ip, upload[ip], download[ip], ratio
      }
    }
  }' | sort -k2 -rn | head -20
```

### Step 4: Lateral Movement Detection

```bash
# SMB connections between internal hosts
cat zeek-logs/conn.log | zeek-cut ts id.orig_h id.resp_h id.resp_p | \
  awk '$4 == 445 && $2 ~ /^192\.168/ && $3 ~ /^192\.168/ {print}' | \
  sort | uniq -c | sort -rn > alerts/internal-smb.txt

# New internal connections (not seen in baseline)
# Compare current conn.log against baseline pairs

# Port scan detection (1 source → many destinations)
cat zeek-logs/conn.log | zeek-cut id.orig_h id.resp_h id.resp_p | \
  awk '{src=$1; if (!seen[src"_"$3]++) ports[src]++} END {
    for (src in ports) if (ports[src] > 50) print src, ports[src], "distinct ports"
  }' | sort -k2 -rn | head -20
```

### Step 5: Suricata Rule-Based Detection

```bash
# Run Suricata IDS on captured traffic
suricata -c /etc/suricata/suricata.yaml -r capture/traffic.pcap \
  -l logs/suricata/ --runmode single

# Review alerts
cat logs/suricata/fast.log | grep -iE "severity: [1-2]" | head -50
cat logs/suricata/eve.json | jq -r 'select(.event_type=="alert") | 
  "\(.timestamp) [\(.alert.severity)] \(.alert.signature) \(.src_ip)->\(.dest_ip)"'
```

### Step 6: Alerting & Escalation

```markdown
## Network Alert Classification

| Alert Type | Indicator | Severity | Action |
|------------|-----------|----------|--------|
| C2 Beaconing | Regular interval, low jitter | HIGH | → /threat-hunt |
| Mass outbound transfer | >1GB to single external IP | HIGH | → /ir-initiate |
| DNS tunneling | Queries > 60 chars | HIGH | → /alert-triage |
| Internal port scan | >50 ports from single host | MEDIUM | → SOC triage |
| New external connection | First-seen destination | LOW | → Monitor |
| Protocol anomaly | Non-standard port usage | MEDIUM | → Investigate |
```

## Output

```
monitoring/network/
├── baselines/
│   └── traffic-baseline-[DATE].json
├── alerts/
│   ├── beaconing-detected.txt
│   ├── large-transfers.txt
│   └── lateral-movement.txt
└── daily-summary/
    └── network-summary-[DATE].md
```

Confirmed threats → `/ir-initiate`. Detection patterns → `/siem-rule-create`. Anomalies → `/threat-hunt`.
