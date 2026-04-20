# /container-harden — Harden Container Configuration

```
Use agent: container-security
Coordinate with: devsecops-lead
```

## Purpose

Apply security hardening to container images and Kubernetes deployments following CIS benchmarks.

## Dockerfile Security Hardening

```dockerfile
# ✅ Hardened Dockerfile Template

# 1. Use specific digest, not mutable tags
FROM python:3.12-alpine@sha256:abc123...

# 2. Set non-root user
RUN adduser -D -s /sbin/nologin -u 10001 appuser

# 3. Set working directory
WORKDIR /app

# 4. Copy only necessary files
COPY --chown=appuser:appuser requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY --chown=appuser:appuser ./src .

# 5. Remove package manager after use (reduce attack surface)
RUN apk del --no-cache gcc musl-dev

# 6. Switch to non-root user
USER 10001

# 7. Use read-only filesystem (enforce in pod spec)
# 8. Expose minimal port
EXPOSE 8080

# 9. No shell in production images where possible
ENTRYPOINT ["/app/server"]
```

## Kubernetes Pod Security Hardening

```yaml
apiVersion: v1
kind: Pod
spec:
  # Pod-level security
  securityContext:
    runAsNonRoot: true
    runAsUser: 10001
    runAsGroup: 10001
    fsGroup: 10001
    seccompProfile:
      type: RuntimeDefault
  
  containers:
  - name: app
    image: myapp:1.0.0@sha256:digest
    
    # Container-level security
    securityContext:
      allowPrivilegeEscalation: false
      readOnlyRootFilesystem: true
      capabilities:
        drop:
          - ALL
        add:
          - NET_BIND_SERVICE  # Only if port < 1024
    
    # Resource limits (also prevents DoS)
    resources:
      limits:
        cpu: "500m"
        memory: "256Mi"
      requests:
        cpu: "100m"
        memory: "128Mi"
    
    # Writable volume mounts for temp data
    volumeMounts:
    - name: tmp
      mountPath: /tmp
    - name: cache
      mountPath: /app/cache
  
  volumes:
  - name: tmp
    emptyDir: {}
  - name: cache
    emptyDir: {}
  
  # Don't automount service account token if not needed
  automountServiceAccountToken: false
```

## Hardening Checklist

**Image Build:**
- [ ] Specific image digest (not latest tag)
- [ ] Non-root user defined in Dockerfile
- [ ] Minimal base image (Alpine/Distroless)
- [ ] No secrets in image layers (check with `docker history`)
- [ ] Unnecessary packages removed
- [ ] Image scanned: `trivy image myapp:1.0 --severity HIGH,CRITICAL`

**Kubernetes Deployment:**
- [ ] `runAsNonRoot: true`
- [ ] `readOnlyRootFilesystem: true`
- [ ] `allowPrivilegeEscalation: false`
- [ ] `capabilities.drop: [ALL]`
- [ ] Resource limits set
- [ ] `automountServiceAccountToken: false`
- [ ] Network policy applied (deny-all default + specific allows)
- [ ] Pod Security Standard: Restricted

**Registry:**
- [ ] Private registry (not public DockerHub)
- [ ] Image scanning in registry pipeline
- [ ] Image signing with Cosign
- [ ] Pull secrets configured

## Verification

```bash
# Scan image
trivy image --severity HIGH,CRITICAL myapp:1.0

# Check running pod security
kubectl auth can-i --list --namespace=prod

# Audit pod security context
kubectl get pods -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.spec.securityContext}{"\n"}{end}'

# CIS benchmark for cluster
kube-bench run --targets node,master
```
