provider "aws" {
  region  = "us-east-1"
  profile = "terraform-showcase"

  assume_role {
    role_arn     = "arn:aws:iam::${local.production_account_id}:role/TerraformExecutionRole"
    session_name = "terraform-production-deployment"
    external_id  = "terraform-deployment"
  }
}
