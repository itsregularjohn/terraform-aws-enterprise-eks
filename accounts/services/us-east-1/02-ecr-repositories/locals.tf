locals {
  services_account_id    = data.terraform_remote_state.organizations.outputs.account_ids["services"]
  production_account_id  = data.terraform_remote_state.organizations.outputs.account_ids["production"]
  development_account_id = data.terraform_remote_state.organizations.outputs.account_ids["development"]
  staging_account_id     = data.terraform_remote_state.organizations.outputs.account_ids["staging"]

  repository_names = [
    "hello"
  ]
}
