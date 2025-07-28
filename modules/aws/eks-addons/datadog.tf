# https://docs.datadoghq.com/containers/kubernetes/installation/?tab=helm
# https://github.com/DataDog/helm-charts/tree/main/charts/datadog

resource "helm_release" "datadog" {
  count = var.enable_datadog ? 1 : 0

  chart            = "datadog"
  namespace        = "datadog"
  name             = "datadog"
  create_namespace = true
  repository       = "https://helm.datadoghq.com"
  version          = "3.32.0"

  set {
    name  = "datadog.site"
    value = var.datadog_site
  }

  set_sensitive {
    name  = "datadog.apiKey"
    value = var.datadog_api_key
  }

  # https://docs.datadoghq.com/containers/kubernetes/log/?tabs=helm#log-collection
  set {
    name  = "datadog.logs.enabled"
    value = "true"
  }

  set {
    name  = "datadog.logs.containerCollectAll"
    value = "true"
  }

  # https://docs.datadoghq.com/infrastructure/process/?tab=linuxwindows
  set {
    name  = "datadog.processAgent.enabled"
    value = "true"
  }

  # https://docs.datadoghq.com/network_monitoring/performance/setup/?tab=helm
  set {
    name  = "datadog.systemProbe.enabled"
    value = "true"
  }

  set {
    name  = "datadog.networkMonitoring.enabled"
    value = "true"
  }

  # https://docs.datadoghq.com/containers/cluster_agent/?tab=helm
  set {
    name  = "clusterAgent.enabled"
    value = "true"
  }

  set {
    name  = "clusterAgent.replicas"
    value = "2"
  }

  set {
    name  = "clusterAgent.createPodDisruptionBudget"
    value = "true"
  }

  set {
    name  = "targetSystem"
    value = "linux"
  }
}
