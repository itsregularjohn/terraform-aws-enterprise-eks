provider "aws" {
  region  = "us-east-1"
  profile = "terraform-showcase"

  assume_role {
    role_arn     = "arn:aws:iam::${local.production_account_id}:role/OrganizationAccountAccessRole"
    session_name = "terraform-execution-role-setup"
  }
}
