# /evidence-preserve — Digital Evidence Preservation & Chain of Custody

```
Use agent: forensics-analyst
Coordinate with: incident-response-lead, dfir-analyst
```

## Purpose

Establish legally defensible digital evidence collection with complete chain of custody documentation — ensuring all forensic artifacts are preserved in a forensically sound manner that maintains admissibility and integrity for legal proceedings, insurance claims, or internal investigations.

## Pre-Execution Check

- [ ] Legal counsel notified (if law enforcement involvement likely)
- [ ] Evidence preservation scope defined (systems, timeframe)
- [ ] Forensic storage media prepared (write-blocked, validated)
- [ ] Chain of custody forms ready
- [ ] Live system vs. powered-off procedure decision made

## Evidence Collection Framework

### Step 1: Order of Volatility (Collect Most Volatile First)

```
1. CPU registers & CPU cache (milliseconds)
2. Network connections & routing tables (seconds)
3. Running processes & memory (minutes)
4. Disk cache (minutes)
5. Temporary file system / swap (hours)
6. Hard disk / SSDs (days)
7. Remote logging / SIEM (weeks)
8. Backup media (months)
9. Paper / printouts (years)
```

### Step 2: Live System Evidence (Volatile Data)

```bash
# CRITICAL: Timestamp each collection immediately
TIMESTAMP=$(date -u +%Y%m%dT%H%M%SZ)
CASE_ID="IR-2025-001"
mkdir -p evidence/${CASE_ID}/{volatile,disk,network,memory}

# Network state — capture before anything changes
echo "[$TIMESTAMP] Collecting network state..." | tee -a evidence/${CASE_ID}/collection.log

netstat -anop > evidence/${CASE_ID}/volatile/netstat-${TIMESTAMP}.txt
ss -anp > evidence/${CASE_ID}/volatile/ss-connections-${TIMESTAMP}.txt
ip route show > evidence/${CASE_ID}/volatile/routes-${TIMESTAMP}.txt
arp -a > evidence/${CASE_ID}/volatile/arp-cache-${TIMESTAMP}.txt
cat /proc/net/tcp > evidence/${CASE_ID}/volatile/tcp-connections-${TIMESTAMP}.txt

# Running processes
ps auxf > evidence/${CASE_ID}/volatile/processes-${TIMESTAMP}.txt
ls -la /proc/*/exe 2>/dev/null > evidence/${CASE_ID}/volatile/process-binaries-${TIMESTAMP}.txt

# Open files
lsof > evidence/${CASE_ID}/volatile/open-files-${TIMESTAMP}.txt

# Logged-in users
who > evidence/${CASE_ID}/volatile/logged-users-${TIMESTAMP}.txt
last -F > evidence/${CASE_ID}/volatile/last-logins-${TIMESTAMP}.txt
w > evidence/${CASE_ID}/volatile/w-output-${TIMESTAMP}.txt

# Command history
cp /root/.bash_history evidence/${CASE_ID}/volatile/bash-history-root-${TIMESTAMP}.txt
for user in $(ls /home); do
  cp /home/$user/.bash_history evidence/${CASE_ID}/volatile/bash-history-${user}-${TIMESTAMP}.txt 2>/dev/null
done

# System information
uname -a > evidence/${CASE_ID}/volatile/system-info-${TIMESTAMP}.txt
uptime >> evidence/${CASE_ID}/volatile/system-info-${TIMESTAMP}.txt
date -u >> evidence/${CASE_ID}/volatile/system-info-${TIMESTAMP}.txt
```

### Step 3: Memory Acquisition (RAM Dump)

```bash
# Linux memory dump using avml
avml evidence/${CASE_ID}/memory/ram-dump-${TIMESTAMP}.lime

# Or using LiME kernel module
insmod lime.ko "path=/evidence/${CASE_ID}/memory/ram-dump-${TIMESTAMP}.lime format=lime"

# Hash memory dump for integrity
sha256sum evidence/${CASE_ID}/memory/ram-dump-${TIMESTAMP}.lime \
  > evidence/${CASE_ID}/memory/ram-dump-${TIMESTAMP}.lime.sha256

# Windows memory dump (from live system)
# winpmem_mini.exe -o memory-dump.raw
# Or: ProcDump, NotMyFault for kernel dump

# Analyze memory dump
volatility3 -f evidence/${CASE_ID}/memory/ram-dump.lime \
  windows.pslist.PsList > evidence/${CASE_ID}/memory/memory-processes.txt
volatility3 -f evidence/${CASE_ID}/memory/ram-dump.lime \
  windows.netstat.NetStat > evidence/${CASE_ID}/memory/memory-netstat.txt
```

### Step 4: Disk Imaging (Forensic Copy)

```bash
# ALWAYS use write blocker for original disk

# Create forensic image with FTK Imager (Windows) or dc3dd (Linux)
dc3dd if=/dev/sdb \
      hof=evidence/${CASE_ID}/disk/disk-image-${TIMESTAMP}.dd \
      hash=sha256 \
      log=evidence/${CASE_ID}/disk/imaging-log-${TIMESTAMP}.txt \
      verb=on

# Or using dd with hash verification
dd if=/dev/sdb bs=512 | tee evidence/${CASE_ID}/disk/disk-image.dd | \
  sha256sum > evidence/${CASE_ID}/disk/disk-image.sha256

# Verify image integrity
sha256sum -c evidence/${CASE_ID}/disk/disk-image.sha256

# Create E01 format (preferred for legal proceedings)
ewfacquire /dev/sdb \
  -t evidence/${CASE_ID}/disk/disk-evidence \
  -S 2GiB -c fast -C "${CASE_ID}" \
  -e "Analyst Name" -D "Incident: $CASE_ID"
```

### Step 5: Log Preservation

```bash
# Copy all relevant logs before rotation
LOG_SOURCES=(
  "/var/log/auth.log"
  "/var/log/syslog"
  "/var/log/kern.log"
  "/var/log/apache2/"
  "/var/log/nginx/"
  "/var/log/audit/"
)

for src in "${LOG_SOURCES[@]}"; do
  cp -r "$src" evidence/${CASE_ID}/logs/ 2>/dev/null
done

# Windows: Export Event Logs
# wevtutil epl Security evidence/${CASE_ID}/logs/Security.evtx
# wevtutil epl System evidence/${CASE_ID}/logs/System.evtx
# wevtutil epl Application evidence/${CASE_ID}/logs/Application.evtx

# Hash all collected logs
find evidence/${CASE_ID}/logs/ -type f | \
  xargs sha256sum > evidence/${CASE_ID}/logs/LOG-HASHES.txt
```

### Step 6: Chain of Custody Documentation

```markdown
## CHAIN OF CUSTODY FORM

**Case Number**: IR-YYYY-NNN
**Date/Time of Collection**: YYYY-MM-DD HH:MM:SS UTC
**Location**: [Physical/System location]
**Collected By**: [Name, Role]
**Witnessed By**: [Name, Role]

### Evidence Items

| Item # | Description | Storage Medium | SHA-256 Hash | Collected By | Date/Time |
|--------|-------------|----------------|-------------|--------------|-----------|
| E-001 | RAM dump — Server01 | USB Drive SN:ABC | abc123... | [Name] | 2025-01-15T14:23:00Z |
| E-002 | Disk image — /dev/sdb | External HDD SN:XYZ | def456... | [Name] | 2025-01-15T14:45:00Z |
| E-003 | Log bundle — /var/log | Same HDD | ghi789... | [Name] | 2025-01-15T15:01:00Z |

### Custody Transfer Log

| Date/Time | From | To | Reason | Signature |
|-----------|------|----|--------|-----------|
| 2025-01-15 | [Analyst] | [Lead IR] | Analysis handoff | ______ |
| 2025-01-16 | [Lead IR] | [Legal] | Legal hold | ______ |

### Integrity Verification

All items verified with SHA-256 hash at time of collection.
Re-verification performed at: [Date] — All hashes match: [Yes/No]
```

## Output

```
evidence/[CASE-ID]/
├── volatile/          ← Network state, processes, users
├── memory/            ← RAM dumps + hashes
├── disk/              ← Disk images + hashes
├── logs/              ← System and application logs
├── chain-of-custody.md ← Legal documentation
└── collection.log     ← Timestamped collection audit trail
```

Hand off to `forensics-analyst` for analysis. Submit to legal team per `/ir-initiate` instructions.
