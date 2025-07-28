terraform {
  backend "s3" {
    bucket     = "jp-terraform-showcase-terraform"
    key        = "production/us-east-1/ebs-encryption/terraform.tfstate"
    region     = "us-east-1"
    encrypt    = true
    kms_key_id = "alias/terraform-state"
    profile    = "terraform-showcase"
  }
}
