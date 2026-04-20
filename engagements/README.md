# Engagements Directory

This directory contains active and completed engagement workspaces.

## Structure

Each engagement has its own subdirectory:
```
engagements/
└── [CLIENT-NAME]-[DATE]-[TYPE]/
    ├── scope.md              # Copy of engagement scope
    ├── findings/             # Raw findings from specialists
    ├── evidence/             # Screenshots, logs, artifacts
    ├── recon/                # Reconnaissance output
    └── notes/                # Analyst notes
```

## Creating a New Engagement Workspace

When you run `/scope-define`, the CISO agent will create the workspace structure automatically.

Or create manually:
```bash
mkdir -p engagements/[CLIENT-YYYY-MM-DD-TYPE]/{findings,evidence,recon,notes}
```
