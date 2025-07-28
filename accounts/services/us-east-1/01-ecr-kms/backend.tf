terraform {
  backend "s3" {
    bucket  = "jp-terraform-showcase-terraform"
    key     = "services/us-east-1/ecr-kms/terraform.tfstate"
    region  = "us-east-1"
    profile = "terraform-showcase"
    encrypt = true
  }
}
