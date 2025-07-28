data "terraform_remote_state" "organizations" {
  backend = "s3"
  config = {
    bucket  = "jp-terraform-showcase-terraform"
    key     = "management/global/organizations/terraform.tfstate"
    region  = "us-east-1"
    profile = "terraform-showcase"
  }
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}
