terraform {
  backend "s3" {
    bucket  = "jp-terraform-showcase-terraform"
    key     = "management/global/iam-security/terraform.tfstate"
    region  = "us-east-1"
    profile = "terraform-showcase"
    encrypt = true
  }
}
