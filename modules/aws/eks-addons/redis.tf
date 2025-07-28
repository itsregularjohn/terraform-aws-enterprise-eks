resource "helm_release" "redis" {
  count = var.enable_redis ? 1 : 0

  depends_on = [
    kubernetes_storage_class.gp3_encrypted
  ]

  chart      = "redis"
  namespace  = "redis"
  name       = "redis"
  repository = "https://charts.bitnami.com/bitnami"
  version    = "18.19.4"

  create_namespace = true

  set {
    name  = "auth.enabled"
    value = "false"
  }

  set {
    name  = "global.storageClass"
    value = "gp3-kms"
  }

  set {
    name  = "master.persistence.enabled"
    value = "true"
  }

  set {
    name  = "replica.persistence.enabled"
    value = "true"
  }

  set {
    name  = "master.persistence.size"
    value = "10Gi"
  }

  set {
    name  = "replica.persistence.size"
    value = "10Gi"
  }
}
