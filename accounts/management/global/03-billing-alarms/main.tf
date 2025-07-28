provider "aws" {
  region  = "us-east-1"
  profile = "terraform-showcase"
}

module "billing_alarms" {
  source = "../../../../modules/aws/billing-alarms"

  account_name = "management"
  alarm_email  = local.alarm_email
}
