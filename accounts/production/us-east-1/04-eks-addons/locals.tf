locals {
  profile_name          = "terraform-showcase"
  production_account_id = data.terraform_remote_state.organizations.outputs.account_ids["production"]
  
  cluster_name     = data.terraform_remote_state.eks_cluster.outputs.cluster_name
  cluster_endpoint = data.terraform_remote_state.eks_cluster.outputs.cluster_endpoint
  cluster_ca_data  = data.terraform_remote_state.eks_cluster.outputs.cluster_certificate_authority_data
  region_name      = data.aws_region.current.name
}
