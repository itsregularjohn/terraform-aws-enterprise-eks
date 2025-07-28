terraform {
  backend "s3" {
    bucket     = "jp-terraform-showcase-terraform"
    key        = "management/global/organizations/terraform.tfstate"
    region     = "us-east-1"
    profile    = "terraform-showcase"
    encrypt    = true
    kms_key_id = "alias/terraform-state"
  }
}