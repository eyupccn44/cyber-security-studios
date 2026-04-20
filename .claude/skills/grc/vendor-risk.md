# /vendor-risk — Third-Party Vendor Risk Assessment

```
Use agent: risk-analyst
Coordinate with: grc-lead, compliance-analyst
```

## Purpose

Conduct a structured third-party vendor risk assessment to evaluate the security posture of suppliers, partners, and service providers — identifying risks they may introduce to the organization through data sharing, system integrations, or supply chain dependencies.

## Pre-Execution Check

- [ ] Vendor name and category identified
- [ ] Services/data types shared with vendor documented
- [ ] Vendor contact for security questionnaire obtained
- [ ] Assessment scope defined (SOC 2, ISO 27001, questionnaire, technical)

## Assessment Framework

### Step 1: Vendor Classification

```markdown
## Vendor Risk Tier Classification

**Tier 1 — Critical** (Annual comprehensive assessment)
- Processes or stores sensitive personal data (PII, PHI, financial)
- Provides core business services (systems down = business stops)
- Has direct network connectivity to internal systems
- Examples: Core banking platform, ERP provider, cloud provider

**Tier 2 — High** (Annual questionnaire + periodic review)
- Processes business-sensitive data
- Provides important but replaceable services
- Examples: Marketing analytics, HR platform, CRM

**Tier 3 — Medium** (Biennial questionnaire)
- Processes non-sensitive data
- Provides commodity services
- Examples: Office supplies portal, travel booking

**Tier 4 — Low** (Registration only)
- No data processing, no system integration
- Examples: Training vendors, event organizers
```

### Step 2: Security Questionnaire

```markdown
## Vendor Security Questionnaire

**Vendor Name**: [Name]
**Services Provided**: [Description]
**Data Shared**: [PII / Financial / IP / None]
**Integration Method**: [API / VPN / Data transfer / None]
**Assessment Date**: YYYY-MM-DD
**Vendor Contact**: [Name, email]

### A. Governance & Compliance
| # | Question | Vendor Response | Evidence | Status |
|---|----------|-----------------|----------|--------|
| A1 | Do you hold ISO 27001 certification? | | | [ ] |
| A2 | Have you completed SOC 2 Type II audit? | | | [ ] |
| A3 | Do you have a formal Information Security Policy? | | | [ ] |
| A4 | Do you conduct annual security risk assessments? | | | [ ] |
| A5 | Do you have a data protection/privacy officer? | | | [ ] |

### B. Access Control
| # | Question | Vendor Response | Status |
|---|----------|-----------------|--------|
| B1 | Is MFA enforced for all systems handling our data? | | [ ] |
| B2 | Do you apply least-privilege access controls? | | [ ] |
| B3 | How often are access reviews conducted? | | [ ] |
| B4 | Is privileged access management (PAM) in place? | | [ ] |

### C. Data Security
| # | Question | Vendor Response | Status |
|---|----------|-----------------|--------|
| C1 | Is our data encrypted at rest (AES-256 or equivalent)? | | [ ] |
| C2 | Is our data encrypted in transit (TLS 1.2+)? | | [ ] |
| C3 | Where is our data stored (geographic region)? | | [ ] |
| C4 | Is data segregated from other customers? | | [ ] |
| C5 | What is your data retention and deletion policy? | | [ ] |
| C6 | Do you conduct data classification? | | [ ] |

### D. Incident Response
| # | Question | Vendor Response | Status |
|---|----------|-----------------|--------|
| D1 | Do you have a documented incident response plan? | | [ ] |
| D2 | What is your breach notification timeline? | | [ ] |
| D3 | Have you experienced a data breach in last 2 years? | | [ ] |
| D4 | Do you perform post-incident reviews? | | [ ] |

### E. Business Continuity
| # | Question | Vendor Response | Status |
|---|----------|-----------------|--------|
| E1 | What is your target RTO/RPO? | | [ ] |
| E2 | Do you test your disaster recovery plan annually? | | [ ] |
| E3 | What is your SLA for system availability? | | [ ] |
| E4 | Do you have geographic redundancy? | | [ ] |

### F. Sub-processors & Third Parties
| # | Question | Vendor Response | Status |
|---|----------|-----------------|--------|
| F1 | Do you share our data with sub-processors? | | [ ] |
| F2 | Do you assess your own third-party vendors? | | [ ] |
| F3 | Can you provide a list of sub-processors handling our data? | | [ ] |
```

### Step 3: Passive Technical Assessment

```bash
# Assess vendor's external security posture without active scanning

# Check SSL/TLS configuration
testssl.sh vendor-domain.com --json --outputFile reports/vendor-ssl.json

# Security headers
curl -sI https://vendor-domain.com/ | grep -iE \
  "strict-transport|x-frame|content-security|x-content-type|referrer-policy"

# Check for known data breaches (OSINT)
# HaveIBeenPwned API for domain
curl -s "https://haveibeenpwned.com/api/v3/breaches?domain=vendor.com" \
  -H "hibp-api-key: $HIBP_KEY" | jq '.[].Name'

# Shodan exposure
shodan search "org:\"Vendor Name\"" 2>/dev/null | head -20

# Check CVEs for vendor products
# NVD API:
curl -s "https://services.nvd.nist.gov/rest/json/cves/2.0?keywordSearch=VendorProduct&resultsPerPage=10" | \
  jq '.vulnerabilities[].cve | {id:.id, description:.descriptions[0].value, score:.metrics.cvssMetricV31[0].cvssData.baseScore}'
```

### Step 4: Risk Scoring

```markdown
## Vendor Risk Score

| Category | Weight | Score (0-10) | Weighted Score |
|----------|--------|-------------|----------------|
| Governance & Compliance | 20% | [X] | [X × 0.20] |
| Access Control | 20% | [X] | [X × 0.20] |
| Data Security | 25% | [X] | [X × 0.25] |
| Incident Response | 15% | [X] | [X × 0.15] |
| Business Continuity | 10% | [X] | [X × 0.10] |
| Technical Posture | 10% | [X] | [X × 0.10] |

**Overall Score**: [X.X / 10]

| Score | Risk Level | Decision |
|-------|------------|---------|
| 8.0–10.0 | Low Risk | Approve |
| 6.0–7.9 | Medium Risk | Approve with conditions |
| 4.0–5.9 | High Risk | Require remediation |
| 0–3.9 | Critical Risk | Do not engage / Terminate |
```

### Step 5: Contractual Requirements

```markdown
## Required Contract Clauses (for Tier 1 & 2 vendors)

- [ ] Data Processing Agreement (DPA) / Data Processing Addendum
- [ ] Right to audit clause
- [ ] Breach notification within 72 hours
- [ ] Data deletion upon contract termination (within 30 days)
- [ ] Sub-processor approval requirement
- [ ] Minimum security controls specification
- [ ] Liability and indemnification for data breaches
- [ ] Business continuity obligations
- [ ] GDPR/KVKK compliance (if applicable to jurisdiction)
```

## Output

```
grc/vendor-assessments/
└── [vendor-name]-[YYYY-MM]/
    ├── questionnaire-completed.md
    ├── technical-assessment.md
    ├── risk-score.md
    └── assessment-decision.md     ← Approve/Conditional/Reject
```

Feed risk findings to `risk-analyst` for organizational risk register. Critical vendors → CISO review.
