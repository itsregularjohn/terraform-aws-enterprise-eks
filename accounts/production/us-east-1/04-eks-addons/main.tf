module "eks_addons" {
  source = "../../../../modules/aws/eks-addons"

  cluster_name = local.cluster_name
  region       = local.region_name
  vpc_id       = data.terraform_remote_state.networking.outputs.vpc_id

  eks_cluster_arn                        = data.terraform_remote_state.eks_cluster.outputs.cluster_arn
  eks_cluster_endpoint                   = local.cluster_endpoint
  eks_cluster_certificate_authority_data = local.cluster_ca_data
  eks_oidc_provider_arn                  = data.terraform_remote_state.eks_cluster.outputs.oidc_provider_arn

  enable_aws_load_balancer  = true
  enable_cluster_autoscaler = true
  enable_ebs_csi_driver     = true
  enable_cert_manager       = false
  enable_datadog            = false
  enable_ingress_nginx      = true
  enable_metrics_server     = true
  enable_redis              = true
  enable_gp3_storage_class  = true
}
