locals {
  identity_store_id = tolist(data.aws_ssoadmin_instances.main.identity_store_ids)[0]
  instance_arn      = tolist(data.aws_ssoadmin_instances.main.arns)[0]
  
  accounts = data.terraform_remote_state.organizations.outputs.account_ids

  core_accounts = [
    local.accounts["management"],
    local.accounts["production"],
    local.accounts["log_archive"]
  ]

  infrastructure_accounts = [
    local.accounts["monitoring"],
    local.accounts["networking"],
    local.accounts["backup"],
    local.accounts["services"]
  ]

  development_accounts = [
    local.accounts["development"],
    local.accounts["staging"],
    local.accounts["sandbox"]
  ]

  all_accounts = values(local.accounts)
}
