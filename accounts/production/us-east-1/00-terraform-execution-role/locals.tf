locals {
  management_account_id = data.terraform_remote_state.organizations.outputs.account_ids["management"]
  production_account_id = data.terraform_remote_state.organizations.outputs.account_ids["production"]
}
