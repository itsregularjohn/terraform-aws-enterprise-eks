locals {
  development_account_id = data.terraform_remote_state.organizations.outputs.account_ids["development"]
  services_account_id    = data.terraform_remote_state.organizations.outputs.account_ids["services"]
  
  service_name = "hello"
  app_name     = "hello"
  environment  = "development"
}
