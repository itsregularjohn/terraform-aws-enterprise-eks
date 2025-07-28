provider "aws" {
  region  = "us-east-1"
  profile = "terraform-showcase"

  assume_role {
    role_arn     = "arn:aws:iam::${local.services_account_id}:role/TerraformExecutionRole"
    session_name = "terraform-services-ecr-kms"
    external_id  = "terraform-deployment"
  }
}

module "ecr_kms" {
  source = "../../../../modules/aws/ecr-kms"
  
  name        = "shared-services"
  environment = "production"
  
  enable_key_rotation     = true
  deletion_window_in_days = 7
}
