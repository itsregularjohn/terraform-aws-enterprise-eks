# CoreDNS
# https://raw.githubusercontent.com/coredns/helm/refs/heads/master/charts/coredns/README.md
# https://github.com/coredns/coredns
# http://github.com/coredns/helm
# Repository: https://github.com/coredns/coredns

# CoreDNS is a cluster-scoped DNS service that doesn't require AWS IAM permissions
# No IRSA needed - this is a pure Kubernetes workload

# https://github.com/coredns/helm/blob/master/charts/coredns/values.yaml
resource "helm_release" "coredns" {
  count = var.enable_coredns ? 1 : 0

  chart      = "coredns"
  namespace  = "kube-system"
  name       = "coredns"
  repository = "https://coredns.github.io/helm"
  version    = "1.43.0"

  # Deploy as cluster DNS service
  set {
    name  = "isClusterService"
    value = "true"
  }

  # Set system priority class for essential DNS service
  set {
    name  = "priorityClassName"
    value = "system-cluster-critical"
  }

  # Let chart create and manage service account
  set {
    name  = "serviceAccount.create"
    value = "true"
  }

  # Enable RBAC (required for cluster service)
  set {
    name  = "rbac.create"
    value = "true"
  }

  # App version: 1.12.2
  set {
    name  = "image.tag"
    value = "1.12.2"
  }

  # Resource configuration for stable DNS service
  set {
    name  = "resources.requests.cpu"
    value = "100m"
  }

  set {
    name  = "resources.requests.memory"
    value = "128Mi"
  }

  set {
    name  = "resources.limits.memory"
    value = "170Mi"
  }

  # Enable cluster-proportional autoscaling for DNS reliability
  set {
    name  = "autoscaler.enabled"
    value = "true"
  }

  set {
    name  = "autoscaler.coresPerReplica"
    value = "256"
  }

  set {
    name  = "autoscaler.nodesPerReplica"
    value = "16"
  }
}
