terraform {
  backend "s3" {
    bucket  = "jp-terraform-showcase-terraform"
    key     = "development/us-east-1/hello-apprunner/terraform.tfstate"
    region  = "us-east-1"
    profile = "terraform-showcase"
    encrypt = true
  }
}
