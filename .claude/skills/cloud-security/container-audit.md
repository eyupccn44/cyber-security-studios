# /container-audit — Container Security Audit

```
Use agent: container-security
Coordinate with: cloud-security-lead, devsecops-engineer
```

## Purpose

Perform a comprehensive security audit of containerized environments — covering Docker image security, container runtime configurations, orchestration platform hardening, network policies, and secrets management within container ecosystems.

## Pre-Execution Check

- [ ] Access to container registry and image layers
- [ ] Docker daemon or Kubernetes cluster access (with appropriate RBAC)
- [ ] Container scanning tools available (Trivy, Grype, Snyk)
- [ ] Authorization to scan production images

## Audit Framework

### Phase 1: Container Image Security

```bash
# Scan images for vulnerabilities
IMAGE="myapp:latest"

# Trivy — comprehensive image scan
trivy image --severity HIGH,CRITICAL $IMAGE \
  --format json -o reports/trivy-image-scan.json
trivy image --severity HIGH,CRITICAL $IMAGE  # Human-readable

# Grype — alternative scanner
grype $IMAGE -o json > reports/grype-scan.json

# Snyk container scan
snyk container test $IMAGE --json > reports/snyk-container.json

# Check for secrets in image layers
trivy image --scanners secret $IMAGE

# Docker Scout (built-in)
docker scout cves $IMAGE --only-severity critical,high

# Inspect image configuration
docker inspect $IMAGE | jq '.[0] | {
  User: .Config.User,
  ExposedPorts: .Config.ExposedPorts,
  Env: .Config.Env,
  Entrypoint: .Config.Entrypoint,
  Volumes: .Config.Volumes
}'

# Check if running as root
docker inspect $IMAGE | jq '.[0].Config.User'
# Empty or "root" = FINDING — run as non-root user
```

### Phase 2: Dockerfile Best Practices

```bash
# Lint Dockerfile for security issues
hadolint Dockerfile

# Manual review checklist:
grep -n "FROM" Dockerfile  # Is base image pinned? (not :latest)
grep -n "USER" Dockerfile  # Is non-root user set?
grep -n "COPY\|ADD" Dockerfile  # Does ADD fetch from URLs? (security risk)
grep -n "RUN.*curl\|RUN.*wget" Dockerfile  # Downloaded content — verify hash?
grep -n "ENV.*PASSWORD\|ENV.*SECRET\|ENV.*KEY" Dockerfile  # Secrets in Dockerfile = CRITICAL
grep -n "EXPOSE" Dockerfile  # Unnecessary ports exposed?

# Multi-stage build check (reduces attack surface)
grep -c "FROM" Dockerfile  # Should be > 1 for production images

# Check for .dockerignore
ls .dockerignore || echo "MISSING: .dockerignore — .git, .env may be copied into image"
```

### Phase 3: Container Runtime Security

```bash
# List running containers and their security config
docker ps --quiet | xargs docker inspect | jq '.[] | {
  Name: .Name,
  Privileged: .HostConfig.Privileged,
  CapAdd: .HostConfig.CapAdd,
  CapDrop: .HostConfig.CapDrop,
  ReadonlyRootfs: .HostConfig.ReadonlyRootfs,
  SecurityOpt: .HostConfig.SecurityOpt,
  NetworkMode: .HostConfig.NetworkMode,
  PidMode: .HostConfig.PidMode,
  UsernsMode: .HostConfig.UsernsMode
}'

# FINDINGS to flag:
# Privileged: true → Container has root on host
# CapAdd: SYS_ADMIN → Dangerous capability
# ReadonlyRootfs: false → Container can write to filesystem
# NetworkMode: host → Container shares host network
# PidMode: host → Container can see all host processes
# SecurityOpt: [] → No seccomp/AppArmor

# Check for mounted sensitive host paths
docker ps --quiet | xargs docker inspect | jq '.[].HostConfig.Binds[]?' | \
  grep -E "(/etc|/var/run/docker.sock|/root|/proc|/sys)"
# /var/run/docker.sock mounted = Container escape risk
```

### Phase 4: Kubernetes Security Audit

```bash
# Check pod security contexts
kubectl get pods --all-namespaces -o json | jq '
  .items[] | select(.spec.securityContext == null or
    .spec.securityContext.runAsNonRoot != true) |
  "\(.metadata.namespace)/\(.metadata.name) — Missing runAsNonRoot"'

# Privileged pods
kubectl get pods --all-namespaces -o json | jq '
  .items[].spec.containers[] |
  select(.securityContext.privileged == true) |
  .name + " — PRIVILEGED CONTAINER"'

# Check RBAC — ClusterAdmin bindings
kubectl get clusterrolebindings -o json | jq '
  .items[] | select(.roleRef.name == "cluster-admin") |
  .subjects[]?.name'

# Network policies
kubectl get networkpolicies --all-namespaces
# No network policies = all pods can communicate = lateral movement risk

# Exposed services
kubectl get services --all-namespaces | grep -E "LoadBalancer|NodePort"

# Secrets in environment variables (bad practice)
kubectl get pods --all-namespaces -o json | jq '
  .items[].spec.containers[].env[]? |
  select(.name | test("PASSWORD|SECRET|KEY|TOKEN"; "i")) |
  "\(.name) — Hardcoded in env"'

# Run kube-bench (CIS Kubernetes Benchmark)
kube-bench --benchmark cis-1.8 --json > reports/kube-bench.json
```

### Phase 5: Container Registry Security

```bash
REGISTRY="registry.target.com"

# Scan all images in registry
trivy registry $REGISTRY --severity HIGH,CRITICAL

# Check registry authentication
docker login $REGISTRY  # Should require credentials
curl -s "https://$REGISTRY/v2/_catalog"  # Unauthenticated catalog = FINDING

# Check image signing
cosign verify $IMAGE --certificate-identity-regexp=".*" \
  --certificate-oidc-issuer-regexp=".*"
# If unsigned → supply chain risk

# Check for unused/old images (attack surface reduction)
docker images | sort -k4  # Sort by date — remove old images
```

## Security Checklist

| Check | Status | Severity if Fail |
|-------|--------|-----------------|
| Images run as non-root | [ ] | High |
| Base images pinned (not :latest) | [ ] | Medium |
| No secrets in Dockerfile/ENV | [ ] | Critical |
| .dockerignore present | [ ] | Medium |
| Privileged containers absent | [ ] | Critical |
| /docker.sock not mounted | [ ] | Critical |
| Network policies defined (K8s) | [ ] | High |
| RBAC least privilege | [ ] | High |
| Images signed (Cosign) | [ ] | Medium |
| Vulnerability scan < 30 days old | [ ] | Medium |

## Output

```
engagements/[id]/container-security/
├── image-scan-results/
│   ├── trivy-results.json
│   └── vulnerability-summary.md
├── runtime-audit.md
├── kubernetes-audit.md         ← If K8s environment
└── container-findings.md
```

Feed vulnerability findings to `devsecops-engineer` for pipeline integration. Critical findings → `cloud-security-lead`.
