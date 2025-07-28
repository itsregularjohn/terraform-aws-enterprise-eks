# https://cert-manager.io/docs/installation/helm/
# https://cert-manager.io/docs/configuration/acme/dns01/route53/

module "cert_manager_irsa_role" {
  count = var.enable_cert_manager ? 1 : 0

  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name = "${var.cluster_name}-cert-manager"

  attach_cert_manager_policy = true

  oidc_providers = {
    main = {
      provider_arn               = var.eks_oidc_provider_arn
      namespace_service_accounts = ["cert-manager:cert-manager"]
    }
  }
}

# https://artifacthub.io/packages/helm/cert-manager/cert-manager
resource "helm_release" "cert_manager" {
  count = var.enable_cert_manager ? 1 : 0

  chart      = "cert-manager"
  namespace  = "cert-manager"
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  version    = "v1.13.1"

  create_namespace = true

  set {
    name  = "installCRDs"
    value = "true"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.cert_manager_irsa_role[0].iam_role_arn
  }

  set {
    name  = "securityContext.fsGroup"
    value = "1001"
  }
}

# https://cert-manager.io/docs/configuration/acme/
resource "kubernetes_manifest" "clusterissuer_letsencrypt_prod" {
  count = var.enable_cert_manager ? 1 : 0

  depends_on = [helm_release.cert_manager]

  manifest = {
    "apiVersion" = "cert-manager.io/v1"
    "kind"       = "ClusterIssuer"
    "metadata" = {
      "name" = "letsencrypt-prod"
    }
    "spec" = {
      "acme" = {
        "server" = "https://acme-v02.api.letsencrypt.org/directory"
        "email"  = "admin@${var.cluster_name}.example.com"
        "privateKeySecretRef" = {
          "name" = "letsencrypt-prod"
        }
        # https://cert-manager.io/docs/configuration/acme/dns01/route53/
        "solvers" = [
          {
            "dns01" = {
              "route53" = {
                "region" = var.region
              }
            }
          }
        ]
      }
    }
  }
}

# Staging issuer for testing
resource "kubernetes_manifest" "clusterissuer_letsencrypt_staging" {
  count = var.enable_cert_manager ? 1 : 0

  depends_on = [helm_release.cert_manager]

  manifest = {
    "apiVersion" = "cert-manager.io/v1"
    "kind"       = "ClusterIssuer"
    "metadata" = {
      "name" = "letsencrypt-staging"
    }
    "spec" = {
      "acme" = {
        "server" = "https://acme-staging-v02.api.letsencrypt.org/directory"
        "email"  = "admin@${var.cluster_name}.example.com"
        "privateKeySecretRef" = {
          "name" = "letsencrypt-staging"
        }
        "solvers" = [
          {
            "dns01" = {
              "route53" = {
                "region" = var.region
              }
            }
          }
        ]
      }
    }
  }
}
