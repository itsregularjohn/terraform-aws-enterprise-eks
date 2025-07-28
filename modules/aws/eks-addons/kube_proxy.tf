# kube-proxy
# https://docs.aws.amazon.com/eks/latest/userguide/managing-kube-proxy.html
# https://kubernetes.io/docs/reference/command-line-tools-reference/kube-proxy/
# https://gallery.ecr.aws/eks-distro-build-tooling/eks-distro-minimal-base-iptables
# https://github.com/kubernetes/kube-proxy

# kube-proxy is a core Kubernetes networking component that typically runs as a DaemonSet
# For EKS, it uses specific ECR images and versions aligned with the cluster version
# No IRSA needed - uses node-level permissions

# Using Kubernetes manifests since there's no standard Helm chart for kube-proxy
# and it's typically managed by the cluster itself

resource "kubernetes_config_map" "kube_proxy_config" {
  count = var.enable_kube_proxy ? 1 : 0

  metadata {
    name      = "kube-proxy-config"
    namespace = "kube-system"
    labels = {
      app = "kube-proxy"
    }
  }

  data = {
    "config.conf" = yamlencode({
      apiVersion  = "kubeproxy.config.k8s.io/v1alpha1"
      kind        = "KubeProxyConfiguration"
      bindAddress = "0.0.0.0"
      clusterCIDR = "10.100.0.0/16" # Default EKS pod CIDR, should be configurable
      mode        = "iptables"
      clientConnection = {
        kubeconfig = "/var/lib/kube-proxy/kubeconfig.conf"
      }
      metricsBindAddress = "0.0.0.0:10249"
      healthzBindAddress = "0.0.0.0:10256"
    })
  }
}

resource "kubernetes_daemonset" "kube_proxy" {
  count = var.enable_kube_proxy ? 1 : 0

  metadata {
    name      = "kube-proxy"
    namespace = "kube-system"
    labels = {
      app = "kube-proxy"
    }
  }

  spec {
    selector {
      match_labels = {
        app = "kube-proxy"
      }
    }

    template {
      metadata {
        labels = {
          app = "kube-proxy"
        }
      }

      spec {
        priority_class_name = "system-node-critical"

        toleration {
          operator = "Exists"
        }

        node_selector = {
          "kubernetes.io/os" = "linux"
        }

        host_network = true

        container {
          name = "kube-proxy"
          # EKS kube-proxy version for Kubernetes 1.33: v1.33.0-eksbuild.2
          image = "602401143452.dkr.ecr.${var.region}.amazonaws.com/eks/kube-proxy:v1.33.0-eksbuild.2"

          command = [
            "/usr/local/bin/kube-proxy",
            "--config=/var/lib/kube-proxy/config.conf",
            "--hostname-override=$(NODE_NAME)"
          ]

          env {
            name = "NODE_NAME"
            value_from {
              field_ref {
                field_path = "spec.nodeName"
              }
            }
          }

          security_context {
            privileged = true
          }

          volume_mount {
            name       = "kube-proxy-config"
            mount_path = "/var/lib/kube-proxy"
          }

          volume_mount {
            name       = "xtables-lock"
            mount_path = "/run/xtables.lock"
          }

          volume_mount {
            name       = "lib-modules"
            mount_path = "/lib/modules"
            read_only  = true
          }

          liveness_probe {
            http_get {
              host = "127.0.0.1"
              path = "/healthz"
              port = 10256
            }
            initial_delay_seconds = 15
            timeout_seconds       = 15
          }
        }

        volume {
          name = "kube-proxy-config"
          config_map {
            name = kubernetes_config_map.kube_proxy_config[0].metadata[0].name
          }
        }

        volume {
          name = "xtables-lock"
          host_path {
            path = "/run/xtables.lock"
            type = "FileOrCreate"
          }
        }

        volume {
          name = "lib-modules"
          host_path {
            path = "/lib/modules"
          }
        }

        service_account_name = "kube-proxy"
      }
    }
  }

  depends_on = [kubernetes_config_map.kube_proxy_config]
}

# Service Account for kube-proxy
resource "kubernetes_service_account" "kube_proxy" {
  count = var.enable_kube_proxy ? 1 : 0

  metadata {
    name      = "kube-proxy"
    namespace = "kube-system"
  }
}

# ClusterRoleBinding for kube-proxy
resource "kubernetes_cluster_role_binding" "kube_proxy" {
  count = var.enable_kube_proxy ? 1 : 0

  metadata {
    name = "kube-proxy"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "system:node-proxier"
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.kube_proxy[0].metadata[0].name
    namespace = "kube-system"
  }
}
