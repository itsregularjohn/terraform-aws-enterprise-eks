# https://github.com/kubernetes-sigs/metrics-server
# https://artifacthub.io/packages/helm/metrics-server/metrics-server
resource "helm_release" "metrics_server" {
  count = var.enable_metrics_server ? 1 : 0

  chart      = "metrics-server"
  namespace  = "kube-system"
  name       = "metrics-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server"

  version = "3.11.0"
}
