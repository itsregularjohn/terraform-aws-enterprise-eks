data "terraform_remote_state" "organizations" {
  backend = "s3"
  config = {
    bucket     = "jp-terraform-showcase-terraform"
    key        = "management/global/organizations/terraform.tfstate"
    region     = "us-east-1"
    profile    = "terraform-showcase"
  }
}

data "terraform_remote_state" "networking" {
  backend = "s3"
  config = {
    bucket  = "jp-terraform-showcase-terraform"
    key     = "production/us-east-1/networking/terraform.tfstate"
    region  = "us-east-1"
    profile = "terraform-showcase"
  }
}

data "terraform_remote_state" "eks_encryption" {
  backend = "s3"
  config = {
    bucket  = "jp-terraform-showcase-terraform"
    key     = "production/us-east-1/eks-secrets-encryption/terraform.tfstate"
    region  = "us-east-1"
    profile = "terraform-showcase"
  }
}

data "aws_caller_identity" "current" {}

data "aws_ssoadmin_instances" "main" {}

data "aws_ssoadmin_permission_set" "terraform_execution" {
  instance_arn = data.aws_ssoadmin_instances.main.arns[0]
  name         = "TerraformExecution"
}
