terraform {
  backend "s3" {
    bucket     = "jp-terraform-showcase-terraform"
    key        = "management/global/billing-alarms/terraform.tfstate"
    region     = "us-east-1"
    encrypt    = true
    kms_key_id = "alias/terraform-state"
    profile    = "terraform-showcase"
  }
}
