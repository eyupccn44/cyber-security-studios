# /team-red — Assemble Red Team for Offensive Operations

```
Use agent: red-team-director
Mobilize: pentest-lead + relevant specialists
```

## Purpose

Spin up a coordinated red team for a full adversarial simulation engagement. This skill assembles the right offensive agents and establishes the operation structure.

## Team Assembly

### Engagement Type → Team Composition

**External Penetration Test:**
```
red-team-director (oversight)
└── pentest-lead (coordination)
    ├── osint-analyst (initial recon)
    ├── network-pentester (infrastructure)
    └── web-pentester (web applications)
```

**Full Red Team Simulation:**
```
red-team-director (operation command)
└── pentest-lead (tactical lead)
    ├── osint-analyst (pre-operation intelligence)
    ├── social-engineer (initial access - if authorized)
    ├── network-pentester (initial foothold, lateral movement)
    ├── web-pentester (web attack paths)
    ├── exploit-developer (custom exploits if needed)
    └── report-writer (documentation)
```

**Assumed Breach Red Team:**
```
red-team-director
└── pentest-lead
    ├── network-pentester (post-breach lateral movement)
    ├── exploit-developer (privilege escalation)
    └── osint-analyst (internal recon)
```

## Operation Kickoff

The red-team-director will conduct:

### Intelligence Brief (15 min)
- Threat actor to simulate (if specified)
- Known TTPs to emulate
- Primary objectives (crown jewels)
- Rules of engagement review

### Operation Plan
```
Phase 1: RECONNAISSANCE (Days 1-3)
  → /osint-gather (passive intel)
  → /attack-surface-map

Phase 2: INITIAL ACCESS (Days 3-7)
  → /web-pentest OR /phishing-sim OR /network-pentest
  → Goal: Establish first foothold

Phase 3: POST-EXPLOITATION (Days 7-14)
  → /priv-escalate
  → /lateral-move
  → Goal: Reach crown jewel systems

Phase 4: OBJECTIVES (Days 14-21)
  → Demonstrate impact (data access, persistence)
  → Document full attack chain

Phase 5: REPORTING (Days 21-25)
  → /pentest-report
  → Attack narrative documentation
```

## OPSEC Requirements

When simulating advanced threats:
- Use dedicated infrastructure (not shared)
- Rotate C2 infrastructure
- Blend with legitimate traffic
- Timestomp artifacts if testing detection
- Maintain detailed operator logs

## Deliverables

1. **Attack Narrative** — Story of the entire operation
2. **Technical Report** — All vulnerabilities and techniques
3. **Detection Opportunities** — Where blue team could have caught you
4. **Purple Team Handoff** — Feed to `/team-purple` for detection improvement
