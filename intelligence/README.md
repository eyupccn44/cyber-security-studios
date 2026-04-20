# Intelligence Directory

This directory stores threat intelligence artifacts.

## Structure

```
intelligence/
├── hunts/          # Threat hunt records
├── briefs/         # Threat intelligence briefs
├── iocs/           # Indicator of Compromise database
├── actors/         # Threat actor profiles
└── mitre-maps/     # ATT&CK mapping layers
```

## Usage

- **Threat hunters** store hunt records in `hunts/`
- **IOC analysts** maintain the IOC database in `iocs/`
- **Threat intel lead** produces briefs in `briefs/`
- **MITRE maps** from `/mitre-map` skill stored in `mitre-maps/`
