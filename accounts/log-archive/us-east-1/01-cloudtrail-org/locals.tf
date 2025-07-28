locals {
  environment_prefix = "organization"
  
  organization_id       = data.terraform_remote_state.organizations.outputs.organization_id
  management_account_id = data.terraform_remote_state.organizations.outputs.management_account_id
  audit_account_id      = data.terraform_remote_state.organizations.outputs.account_ids["audit"]
  external_id           = "cloudtrail-security-access-2024"
}
