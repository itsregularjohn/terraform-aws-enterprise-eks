locals {
  cluster_name    = "production"
  cluster_version = "1.31"
  
  production_account_id = data.terraform_remote_state.organizations.outputs.account_ids["production"]
  
  permission_set_id = regex("ps-([a-f0-9]+)$", data.aws_ssoadmin_permission_set.terraform_execution.arn)[0]
  sso_terraform_role_arn = "arn:aws:iam::${local.production_account_id}:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_TerraformExecution_${local.permission_set_id}"
}
