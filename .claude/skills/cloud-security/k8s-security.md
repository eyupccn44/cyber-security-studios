# /k8s-security — Kubernetes Security Assessment

```
Use agent: cloud-security-lead
Coordinate with: container-security
```

## Purpose

Assess Kubernetes cluster security against CIS Kubernetes Benchmark and identify misconfigurations, RBAC issues, and exposed attack surfaces.

## Cluster Assessment Commands

```bash
# CIS Benchmark scan
kube-bench run --targets node,master,etcd,policies

# Kubernetes vulnerability scanning
kube-hunter --remote $CLUSTER_IP
# Or for internal scan:
kube-hunter --pod  # Run as pod inside cluster

# RBAC analysis with rbac-police
kubectl auth can-i --list --namespace=default
kubectl auth can-i --list --as=system:serviceaccount:default:default

# Find overpermissive ClusterRoleBindings
kubectl get clusterrolebindings -o json | jq '.items[] | 
  select(.roleRef.name == "cluster-admin") | 
  {name: .metadata.name, subjects: .subjects}'
```

## Key Security Checks

### API Server Exposure
```bash
# Is API server publicly accessible?
curl -k https://$CLUSTER_IP:6443/version
# Should require valid client cert or token

# Anonymous auth disabled?
kubectl cluster-info dump | grep "anonymous-auth"
```

### RBAC Misconfiguration
```bash
# Wildcard permissions (dangerous)
kubectl get clusterroles -o json | jq '.items[] | 
  select(.rules[].verbs[] == "*") | .metadata.name'

# ServiceAccounts with cluster-admin
kubectl get clusterrolebindings -o json | jq '.items[] | 
  select(.roleRef.name == "cluster-admin") | 
  select(.subjects[].kind == "ServiceAccount") | 
  {binding: .metadata.name, sa: .subjects}'
```

### Pod Security
```bash
# Privileged pods
kubectl get pods --all-namespaces -o json | jq '.items[] | 
  select(.spec.containers[].securityContext.privileged == true) |
  {name: .metadata.name, ns: .metadata.namespace}'

# Pods running as root
kubectl get pods --all-namespaces -o json | jq '.items[] | 
  select(.spec.securityContext.runAsUser == 0 or 
         .spec.containers[].securityContext.runAsUser == 0) |
  {name: .metadata.name, ns: .metadata.namespace}'

# Host network/PID/IPC access
kubectl get pods --all-namespaces -o json | jq '.items[] | 
  select(.spec.hostNetwork == true or .spec.hostPID == true)'
```

### Secrets Security
```bash
# Secrets in environment variables (bad practice)
kubectl get pods --all-namespaces -o json | jq '.items[].spec.containers[].env[]? | 
  select(.name | test("PASSWORD|SECRET|KEY|TOKEN"; "i"))'

# etcd encryption check
kubectl get pod -n kube-system kube-apiserver-* -o yaml | \
  grep encryption-provider-config
```

## Common Kubernetes Vulnerabilities

| Finding | Risk | Remediation |
|---------|------|-------------|
| API server no auth | Critical | Enable authentication |
| cluster-admin to default SA | Critical | Remove binding, use least privilege |
| Privileged containers | High | Remove privileged flag |
| hostNetwork: true | High | Use pod network namespace |
| No Network Policy | High | Implement default-deny + specific allows |
| Secrets as env vars | Medium | Use secretKeyRef or secret volumes |
| No resource limits | Medium | Set CPU/memory limits on all pods |
| No Pod Security Standard | Medium | Apply Restricted PSS |

## Output

`reports/k8s-security-[CLUSTER]-[DATE].md`
