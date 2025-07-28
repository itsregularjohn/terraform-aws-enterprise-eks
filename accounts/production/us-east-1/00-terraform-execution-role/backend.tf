terraform {
  backend "s3" {
    bucket     = "jp-terraform-showcase-terraform"
    key        = "production/us-east-1/terraform-execution-role/terraform.tfstate"
    region     = "us-east-1"
    encrypt    = true
    profile    = "terraform-showcase"
    kms_key_id = "alias/terraform-state"
  }
}
