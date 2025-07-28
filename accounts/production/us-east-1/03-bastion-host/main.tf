provider "aws" {
  region  = "us-east-1"
  profile = "terraform-showcase"

  assume_role {
    role_arn     = "arn:aws:iam::${local.production_account_id}:role/TerraformExecutionRole"
    session_name = "terraform-production-deployment"
    external_id  = "terraform-deployment"
  }
}

module "bastion_host" {
  source = "../../../../modules/aws/bastion"

  vpc_name        = "production"
  cluster_name    = data.terraform_remote_state.eks.outputs.cluster_name
  vpc_id          = data.terraform_remote_state.networking.outputs.vpc_id
  private_subnets = data.terraform_remote_state.networking.outputs.private_subnets
}
