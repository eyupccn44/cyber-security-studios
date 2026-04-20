# /sast-scan — Run Automated SAST Scanning

```
Use agent: sast-sca-engineer
Coordinate with: appsec-lead
```

## Purpose

Deploy and execute Static Application Security Testing (SAST) tools against a codebase and triage results.

## Tool Selection by Language

```bash
# Auto-detect language
find . -name "*.py" | head -1 && echo "→ Use: Bandit + Semgrep"
find . -name "*.js" -o -name "*.ts" | head -1 && echo "→ Use: ESLint Security + Semgrep"
find . -name "*.java" | head -1 && echo "→ Use: SpotBugs + Semgrep"
find . -name "*.go" | head -1 && echo "→ Use: Gosec + Semgrep"
```

## Semgrep (Multi-language, Recommended)

```bash
# Install
pip install semgrep

# Run with security-focused rulesets
semgrep --config=p/security-audit \
        --config=p/secrets \
        --config=p/owasp-top-ten \
        --json --output sast/semgrep-results.json .

# Human-readable output
semgrep --config=p/security-audit .

# Run specific rules
semgrep --config=p/python --config=p/flask . --include="*.py"
```

## Language-Specific Scanners

```bash
# Python — Bandit
bandit -r . -f json -o sast/bandit-results.json
bandit -r . -ll -ii  # High severity + confidence only

# JavaScript/Node — ESLint Security
npm install eslint eslint-plugin-security --save-dev
npx eslint --plugin security --rule 'security/detect-sql-injection: error' src/

# Go — Gosec
go install github.com/securego/gosec/v2/cmd/gosec@latest
gosec -fmt=json -out=sast/gosec-results.json ./...

# Java — SpotBugs
mvn spotbugs:check

# PHP — PHPCS Security Audit
phpcs --standard=Security src/
```

## CodeQL (GitHub Advanced Security)

```yaml
# .github/workflows/codeql.yml
name: CodeQL Analysis
on: [push, pull_request]
jobs:
  analyze:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: github/codeql-action/init@v3
        with:
          languages: python  # or: javascript, java, go, cpp
      - uses: github/codeql-action/autobuild@v3
      - uses: github/codeql-action/analyze@v3
```

## Results Triage

```bash
# Count findings by severity
cat sast/semgrep-results.json | jq '[.results[] | .severity] | group_by(.) | map({severity: .[0], count: length})'

# List only ERROR/HIGH findings
cat sast/semgrep-results.json | jq '.results[] | select(.severity == "ERROR") | {file: .path, line: .start.line, rule: .check_id, message: .extra.message}'
```

## Triage Decision Per Finding

```
For each SAST finding:
1. Read the finding (rule, location, code snippet)
2. Is this actually reachable by an attacker? (not dead code)
3. Is user input actually flowing to this sink?
4. Does existing validation/sanitization protect against this?
→ TRUE POSITIVE: Add to findings list
→ FALSE POSITIVE: Suppress with documented reason
→ NEEDS REVIEW: Escalate to code-auditor for manual verification
```

## Output

`sast/[DATE]-sast-findings.md` with:
- Total findings by tool/severity
- Triaged true positives ready for developer action
- False positive suppressions documented
- Recommended suppressions for CI/CD pipeline
