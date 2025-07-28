# https://kubernetes.github.io/ingress-nginx/deploy/#aws
# https://docs.nginx.com/nginx-ingress-controller/installation/installation-with-helm/
# https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/

# This provides an alternative approach to AWS Load Balancer Controller if you really want to avoid vendor lock-in

resource "helm_release" "ingress_nginx" {
  count = var.enable_ingress_nginx ? 1 : 0

  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = "ingress-nginx"
  version    = "4.8.3"

  create_namespace = true

  # https://kubernetes.github.io/ingress-nginx/deploy/#aws
  set {
    name  = "controller.service.type"
    value = "LoadBalancer"
  }

  # https://kubernetes.github.io/ingress-nginx/deploy/#network-load-balancer-nlb
  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-type"
    value = "external"
  }

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-backend-protocol"
    value = "tcp"
  }

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-cross-zone-load-balancing-enabled"
    value = "true"
  }

  # https://kubernetes.github.io/ingress-nginx/user-guide/exposing-tcp-udp-services/
  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-connection-idle-timeout"
    value = "60"
  }

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-scheme"
    value = "internet-facing"
  }

  # High availability with multiple replicas
  set {
    name  = "controller.replicaCount"
    value = "2"
  }

  # https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/configmap/
  # Performance optimizations for high-traffic workloads
  set {
    name  = "controller.config.worker-processes"
    value = "auto"
  }

  set {
    name  = "controller.config.worker-connections"
    value = "16384"
  }

  set {
    name  = "controller.config.max-worker-open-files"
    value = "65536"
  }

  set {
    name  = "controller.config.keepalive-requests"
    value = "1000"
  }

  set {
    name  = "controller.config.upstream-keepalive-connections"
    value = "320"
  }

  # SSL/TLS optimization
  set {
    name  = "controller.config.ssl-protocols"
    value = "TLSv1.2 TLSv1.3"
  }

  set {
    name  = "controller.config.ssl-ciphers"
    value = "ECDHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-RSA-AES128-GCM-SHA256"
  }

  # Enable Prometheus metrics
  set {
    name  = "controller.metrics.enabled"
    value = "true"
  }

  set {
    name  = "controller.metrics.serviceMonitor.enabled"
    value = "false"
  }

  # Pod Disruption Budget for high availability
  set {
    name  = "controller.podDisruptionBudget.enabled"
    value = "true"
  }

  set {
    name  = "controller.podDisruptionBudget.minAvailable"
    value = "1"
  }

}


resource "kubernetes_secret" "ingress_nginx_default_ssl" {
  count = var.enable_ingress_nginx && var.default_ssl_certificate_arn != "" ? 1 : 0

  metadata {
    name      = "default-ssl-certificate"
    namespace = "ingress-nginx"
  }

  type = "tls"

  data = {
    "tls.crt" = "" # Certificate from ACM or custom cert
    "tls.key" = "" # Private key
  }

  depends_on = [helm_release.ingress_nginx]
}
