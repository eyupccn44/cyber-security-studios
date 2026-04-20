# ⚠️ Lab Directory — MALWARE ANALYSIS ONLY

This directory is designated for malware research and analysis.

## SAFETY RULES

1. **NEVER analyze malware outside an isolated VM**
2. All samples stored as password-protected ZIPs (password: `infected`)
3. Lab network MUST be isolated from production
4. Snapshot VM before introducing ANY sample
5. Review `.claude/rules/malware-lab-rules.md` before working here

## Structure

```
lab/
├── samples/        # Malware samples (encrypted ZIPs only)
├── reports/        # Analysis reports per sample
├── yara-rules/     # Developed YARA signatures
└── tools/          # Lab tooling scripts
```

## Do NOT store here

- Production credentials (even captured ones)
- Weaponized exploits ready for deployment
- Any file that shouldn't be in an isolated environment
