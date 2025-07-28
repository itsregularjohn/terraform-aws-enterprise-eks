# https://docs.aws.amazon.com/eks/latest/userguide/ebs-csi.html
# https://github.com/kubernetes-sigs/aws-ebs-csi-driver
# https://registry.terraform.io/modules/terraform-aws-modules/iam/aws/latest/submodules/iam-role-for-service-accounts-eks

module "ebs_csi_irsa_role" {
  count = var.enable_ebs_csi_driver ? 1 : 0

  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name = "${var.cluster_name}-ebs-csi-controller"

  # https://docs.aws.amazon.com/eks/latest/userguide/csi-iam-role.html
  # https://github.com/kubernetes-sigs/aws-ebs-csi-driver/blob/master/docs/example-iam-policy.json 
  attach_ebs_csi_policy = true

  oidc_providers = {
    main = {
      provider_arn               = var.eks_oidc_provider_arn
      namespace_service_accounts = ["kube-system:ebs-csi-controller-sa"]
    }
  }
}

# https://github.com/kubernetes-sigs/aws-ebs-csi-driver/blob/master/charts/aws-ebs-csi-driver/values.yaml
resource "helm_release" "aws_ebs_csi_driver" {
  count = var.enable_ebs_csi_driver ? 1 : 0

  chart      = "aws-ebs-csi-driver"
  namespace  = "kube-system"
  name       = "aws-ebs-csi-driver"
  repository = "https://kubernetes-sigs.github.io/aws-ebs-csi-driver"
  version    = "2.22.0"

  set {
    name  = "controller.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.ebs_csi_irsa_role[0].iam_role_arn
  }

  set {
    name  = "node.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.ebs_csi_irsa_role[0].iam_role_arn
  }

  set {
    name  = "controller.region"
    value = var.region
  }

  # https://docs.aws.amazon.com/eks/latest/userguide/add-ons-images.html
  set {
    name  = "image.repository"
    value = "602401143452.dkr.ecr.${var.region}.amazonaws.com/eks/aws-ebs-csi-driver"
  }
}
