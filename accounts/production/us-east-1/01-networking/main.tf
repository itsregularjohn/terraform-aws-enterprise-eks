provider "aws" {
  region  = "us-east-1"
  profile = "terraform-showcase"

  assume_role {
    role_arn     = "arn:aws:iam::${local.production_account_id}:role/TerraformExecutionRole"
    session_name = "terraform-production-deployment"
    external_id  = "terraform-deployment"
  }
}

module "networking" {
  source = "../../../../modules/aws/networking"

  vpc_name       = "production"
  cidr_start     = "10.0"
  network_suffix = 16

  cluster_name = "production"

  enable_nat_gateway = true
  enable_vpn_gateway = false

  azs = ["us-east-1a", "us-east-1b", "us-east-1c"]

  public_subnets  = ["10.0.0.0/19", "10.0.32.0/19", "10.0.64.0/19"]
  private_subnets = ["10.0.96.0/19", "10.0.128.0/19", "10.0.160.0/19"]
}
