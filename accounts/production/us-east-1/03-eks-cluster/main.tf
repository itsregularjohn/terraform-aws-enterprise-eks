module "eks_cluster" {
  source = "../../../../modules/aws/eks"

  cluster_name    = local.cluster_name
  cluster_version = local.cluster_version

  vpc_id          = data.terraform_remote_state.networking.outputs.vpc_id
  private_subnets = data.terraform_remote_state.networking.outputs.private_subnets

  cluster_endpoint_public_access           = true
  enable_cluster_creator_admin_permissions = true

  cloudwatch_log_group_retention_in_days = 1827

  kms_key_arn               = data.terraform_remote_state.eks_encryption.outputs.eks_kms_key_arn
  enable_secrets_encryption = true

  sso_terraform_role_arn = local.sso_terraform_role_arn
}
