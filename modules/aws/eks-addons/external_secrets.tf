# https://external-secrets.io/latest/
# https://external-secrets.io/latest/provider/aws-secrets-manager/

# Custom IAM policy for External Secrets read-only access
data "aws_iam_policy_document" "external_secrets_policy" {
  count = var.enable_external_secrets ? 1 : 0

  # Secrets Manager permissions (read-only)
  statement {
    effect = "Allow"
    actions = [
      "secretsmanager:ListSecrets",
      "secretsmanager:BatchGetSecretValue"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "secretsmanager:ListSecretVersionIds"
    ]
    resources = ["arn:aws:secretsmanager:${var.region}:*:secret:*"]
  }

  # Parameter Store permissions (read-only)
  statement {
    effect = "Allow"
    actions = [
      "ssm:GetParameter",
      "ssm:GetParameters",
      "ssm:GetParametersByPath",
      "ssm:DescribeParameters"
    ]
    resources = ["arn:aws:ssm:${var.region}:*:parameter/*"]
  }
}

resource "aws_iam_policy" "external_secrets_policy" {
  count = var.enable_external_secrets ? 1 : 0

  name_prefix = "${var.cluster_name}-external-secrets-"
  policy      = data.aws_iam_policy_document.external_secrets_policy[0].json
}

module "external_secrets_irsa_role" {
  count = var.enable_external_secrets ? 1 : 0

  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name = "${var.cluster_name}-external-secrets"

  # Use our custom read-only policy
  role_policy_arns = {
    external_secrets = aws_iam_policy.external_secrets_policy[0].arn
  }

  oidc_providers = {
    main = {
      provider_arn               = var.eks_oidc_provider_arn
      namespace_service_accounts = ["external-secrets:external-secrets", "external-secrets:external-secrets-webhook", "external-secrets:external-secrets-cert-controller"]
    }
  }
}

# https://charts.external-secrets.io/
resource "helm_release" "external_secrets" {
  count = var.enable_external_secrets ? 1 : 0

  chart      = "external-secrets"
  namespace  = "external-secrets"
  name       = "external-secrets"
  repository = "https://charts.external-secrets.io"
  version    = "0.9.11"

  create_namespace = true

  set {
    name  = "installCRDs"
    value = "true"
  }

  # Service account annotations for IRSA
  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.external_secrets_irsa_role[0].iam_role_arn
  }

  # High availability configuration
  set {
    name  = "replicaCount"
    value = "2"
  }

  # Resource allocation
  set {
    name  = "resources.requests.cpu"
    value = "100m"
  }

  set {
    name  = "resources.requests.memory"
    value = "128Mi"
  }

  set {
    name  = "resources.limits.cpu"
    value = "500m"
  }

  set {
    name  = "resources.limits.memory"
    value = "512Mi"
  }

  # Enable Prometheus metrics
  set {
    name  = "metrics.service.enabled"
    value = "true"
  }

  set {
    name  = "serviceMonitor.enabled"
    value = "true"
  }

  # Pod Disruption Budget
  set {
    name  = "podDisruptionBudget.enabled"
    value = "true"
  }

  set {
    name  = "podDisruptionBudget.minAvailable"
    value = "1"
  }

  # Security context
  set {
    name  = "securityContext.allowPrivilegeEscalation"
    value = "false"
  }

  set {
    name  = "securityContext.readOnlyRootFilesystem"
    value = "true"
  }

  set {
    name  = "securityContext.runAsNonRoot"
    value = "true"
  }

  set {
    name  = "securityContext.runAsUser"
    value = "65534"
  }

  # Webhook configuration
  set {
    name  = "webhook.replicaCount"
    value = "2"
  }

  set {
    name  = "webhook.resources.requests.cpu"
    value = "100m"
  }

  set {
    name  = "webhook.resources.requests.memory"
    value = "128Mi"
  }

  set {
    name  = "webhook.resources.limits.cpu"
    value = "500m"
  }

  set {
    name  = "webhook.resources.limits.memory"
    value = "512Mi"
  }

  # Cert controller configuration
  set {
    name  = "certController.replicaCount"
    value = "2"
  }

  set {
    name  = "certController.resources.requests.cpu"
    value = "100m"
  }

  set {
    name  = "certController.resources.requests.memory"
    value = "128Mi"
  }

  set {
    name  = "certController.resources.limits.cpu"
    value = "500m"
  }

  set {
    name  = "certController.resources.limits.memory"
    value = "512Mi"
  }
}

# Example ClusterSecretStore for AWS Secrets Manager
resource "kubernetes_manifest" "cluster_secret_store_aws" {
  count = var.enable_external_secrets ? 1 : 0

  depends_on = [helm_release.external_secrets]

  manifest = {
    "apiVersion" = "external-secrets.io/v1beta1"
    "kind"       = "ClusterSecretStore"
    "metadata" = {
      "name" = "aws-secrets-manager"
    }
    "spec" = {
      "provider" = {
        "aws" = {
          "service" = "SecretsManager"
          "region"  = var.region
          "auth" = {
            "jwt" = {
              "serviceAccountRef" = {
                "name"      = "external-secrets"
                "namespace" = "external-secrets"
              }
            }
          }
        }
      }
    }
  }
}

# Example ClusterSecretStore for AWS Parameter Store
resource "kubernetes_manifest" "cluster_secret_store_parameter_store" {
  count = var.enable_external_secrets ? 1 : 0

  depends_on = [helm_release.external_secrets]

  manifest = {
    "apiVersion" = "external-secrets.io/v1beta1"
    "kind"       = "ClusterSecretStore"
    "metadata" = {
      "name" = "aws-parameter-store"
    }
    "spec" = {
      "provider" = {
        "aws" = {
          "service" = "ParameterStore"
          "region"  = var.region
          "auth" = {
            "jwt" = {
              "serviceAccountRef" = {
                "name"      = "external-secrets"
                "namespace" = "external-secrets"
              }
            }
          }
        }
      }
    }
  }
}
