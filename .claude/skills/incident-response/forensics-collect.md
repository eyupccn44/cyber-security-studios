# /forensics-collect — Digital Evidence Collection

```
Use agent: forensics-analyst
Coordinate with: incident-response-lead
```

## ⚠️ Evidence Preservation First

> **CRITICAL**: Do NOT reboot, shut down, or modify any system before imaging.
> RAM data, running processes, and network connections will be LOST on reboot.
> Consult incident-response-lead before taking any action on the affected system.

## Collection Priority Order

```
1. RAM / Memory (most volatile — lost on shutdown)
2. Running processes and network connections (snapshot)
3. Full disk image (before any changes)
4. System logs (Windows Event Logs, /var/log)
5. Browser artifacts
6. Email artifacts
7. Cloud storage / SaaS logs
```

## Memory Acquisition

```bash
# Windows — WinPmem
winpmem_mini_x64.exe memory-dump.raw

# Linux — LiME (load kernel module)
insmod lime.ko "path=/mnt/evidence/memory.lime format=lime"

# macOS — OSXPmem
osxpmem memory.aff4

# ALWAYS hash immediately after acquisition
sha256sum memory.raw > memory.raw.sha256
md5sum memory.raw > memory.raw.md5
```

## Live System Snapshot (Before Imaging)

```powershell
# Windows — capture volatile data first
# Running processes
Get-Process | Export-Csv evidence/processes.csv

# Network connections
netstat -anob > evidence/netstat.txt
Get-NetTCPConnection | Export-Csv evidence/connections.csv

# Logged-in users
query user > evidence/logged-users.txt

# Scheduled tasks
Get-ScheduledTask | Export-Csv evidence/scheduled-tasks.csv

# Services
Get-Service | Export-Csv evidence/services.csv

# Autorun entries
reg export HKLM\Software\Microsoft\Windows\CurrentVersion\Run evidence/autorun.reg
```

## Disk Imaging

```bash
# Full disk image (forensically sound)
# Write-block the drive first!
dc3dd if=/dev/sdb hash=sha256 log=evidence/disk.log \
      of=/mnt/evidence/disk-image.dd

# Verify hash
dc3dd if=disk-image.dd hash=sha256 log=evidence/verify.log

# Mount read-only for analysis
mount -o ro,noatime /dev/sdb /mnt/evidence-ro
```

## Log Collection

```powershell
# Windows Event Logs
wevtutil epl Security evidence/Security.evtx
wevtutil epl System evidence/System.evtx
wevtutil epl Application evidence/Application.evtx
wevtutil epl "Microsoft-Windows-PowerShell/Operational" evidence/PowerShell.evtx
wevtutil epl "Microsoft-Windows-Sysmon/Operational" evidence/Sysmon.evtx

# Linux logs
cp -r /var/log evidence/var-log/
find /home -name ".*history" -exec cp {} evidence/ \;
cp /etc/passwd /etc/shadow evidence/
```

## Chain of Custody

```
Evidence Item: [Description]
Item ID: [Unique identifier]
Collected by: [Analyst name]
Collection Time: [ISO 8601 timestamp]
System: [Hostname, IP, OS]
Hash (SHA256): [Hash value]
Storage Location: [Where stored]
Access Log: [Who accessed when]
```

## Output Structure

```
engagements/IR-[ID]/evidence/
├── chain-of-custody.md
├── memory-dump.raw + .sha256
├── disk-image.dd + .sha256
├── volatile/
│   ├── processes.csv
│   ├── connections.csv
│   └── ...
└── logs/
    ├── Security.evtx
    └── ...
```
