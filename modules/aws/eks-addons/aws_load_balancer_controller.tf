# https://docs.aws.amazon.com/eks/latest/userguide/aws-load-balancer-controller.html
# https://docs.aws.amazon.com/eks/latest/userguide/alb-ingress.html
# https://kubernetes-sigs.github.io/aws-load-balancer-controller/

module "aws_load_balancer_controller_role" {
  count = var.enable_aws_load_balancer ? 1 : 0

  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name = "${var.cluster_name}-aws-load-balancer-controller"

  attach_load_balancer_controller_policy = true

  # https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html
  oidc_providers = {
    main = {
      provider_arn               = var.eks_oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }
}

# https://aws.github.io/eks-charts/
resource "helm_release" "aws_load_balancer_controller" {
  count = var.enable_aws_load_balancer ? 1 : 0

  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  version    = "1.6.2"

  set {
    name  = "clusterName"
    value = var.cluster_name
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.aws_load_balancer_controller_role[0].iam_role_arn
  }

  set {
    name  = "region"
    value = var.region
  }

  set {
    name  = "vpcId"
    value = var.vpc_id
  }

  # https://docs.aws.amazon.com/eks/latest/userguide/add-ons-images.html
  set {
    name  = "image.repository"
    value = "602401143452.dkr.ecr.${var.region}.amazonaws.com/amazon/aws-load-balancer-controller"
  }
}
