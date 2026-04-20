# /risk-assess — Conduct Security Risk Assessment

```
Use agent: risk-analyst
Report to: grc-lead, ciso
```

## Purpose

Identify, analyze, and evaluate information security risks to enable informed risk treatment decisions.

## Assessment Types

| Type | When to Use | Output |
|------|------------|--------|
| Rapid (Qualitative) | New asset/project, quick decision | Risk score, treatment recommendation |
| Full (Quantitative) | Annual review, major investment decisions | FAIR model, $ risk exposure |
| Targeted | Specific threat scenario | Scenario-based risk analysis |

## Rapid Risk Assessment Process

### Step 1: Asset Identification
```
Asset: [Name/Description]
Asset Type: Data | System | Process | People | Facility
Business Criticality: Critical | High | Medium | Low
Data Classification: Confidential | Internal | Public
Owner: [Business owner name/department]
```

### Step 2: Threat Identification
For this asset, identify relevant threats:
- External attackers (opportunistic, targeted APT)
- Insider threats (malicious, accidental)
- Third-party/supply chain
- Natural disasters / physical threats
- System failures

### Step 3: Vulnerability Assessment
What weaknesses exist that threats could exploit?
- Missing/inadequate technical controls
- Process gaps
- Human factors
- Third-party dependencies

### Step 4: Risk Scoring (Qualitative)

```
LIKELIHOOD (1-5):
1 = Rare          (< once in 10 years)
2 = Unlikely      (once in 5-10 years)
3 = Possible      (once in 1-5 years)
4 = Likely        (once per year)
5 = Almost Certain (multiple times/year)

IMPACT (1-5):
1 = Negligible    (< $10K, no regulatory)
2 = Minor         ($10K-$100K)
3 = Moderate      ($100K-$1M)
4 = Major         ($1M-$10M, regulatory fine)
5 = Catastrophic  (> $10M, existential)

RISK = LIKELIHOOD × IMPACT

RISK RATING:
1-4   = LOW      → Accept / annual review
5-9   = MEDIUM   → Planned treatment within 90 days
10-16 = HIGH     → Priority treatment within 30 days
17-25 = CRITICAL → Immediate action, CISO escalation
```

### Step 5: Risk Treatment

| Treatment | Description | When |
|-----------|-------------|------|
| **Avoid** | Eliminate the risk source | Risk too high, activity not worth it |
| **Reduce** | Implement controls | Can reduce to acceptable level |
| **Transfer** | Insurance, contracts | Residual risk transferred to third party |
| **Accept** | Document and monitor | Residual risk within appetite |

### Step 6: Risk Register Entry

```yaml
risk_id: R-[YYYY-NNN]
date: [ISO date]
asset: [Asset name]
threat: [Threat description]
vulnerability: [Weakness description]
likelihood: [1-5]
impact: [1-5]
inherent_risk: [score and rating]
current_controls: [existing mitigations]
residual_risk: [score after controls]
treatment: [Avoid|Reduce|Transfer|Accept]
treatment_plan: [Actions, owner, deadline]
review_date: [Next review date]
owner: [Risk owner]
```

## Output

Updated `docs/risk-register.md` and summary report for grc-lead review.
