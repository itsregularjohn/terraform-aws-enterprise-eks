resource "aws_ssoadmin_account_assignment" "administrators_to_management" {
  instance_arn       = local.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.administrator.arn
  principal_id       = aws_identitystore_group.administrators.group_id
  principal_type     = "GROUP"
  target_id          = local.accounts.management
  target_type        = "AWS_ACCOUNT"
}

resource "aws_ssoadmin_account_assignment" "terraform_to_management" {
  instance_arn       = local.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.terraform_execution.arn
  principal_id       = aws_identitystore_group.administrators.group_id
  principal_type     = "GROUP"
  target_id          = local.accounts.management
  target_type        = "AWS_ACCOUNT"
}

resource "aws_ssoadmin_account_assignment" "administrators_to_production" {
  instance_arn       = local.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.administrator.arn
  principal_id       = aws_identitystore_group.administrators.group_id
  principal_type     = "GROUP"
  target_id          = local.accounts.production
  target_type        = "AWS_ACCOUNT"
}

resource "aws_ssoadmin_account_assignment" "production_admins_to_production" {
  instance_arn       = local.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.administrator.arn
  principal_id       = aws_identitystore_group.production_admins.group_id
  principal_type     = "GROUP"
  target_id          = local.accounts.production
  target_type        = "AWS_ACCOUNT"
}

resource "aws_ssoadmin_account_assignment" "developers_to_production" {
  instance_arn       = local.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.developer.arn
  principal_id       = aws_identitystore_group.developers.group_id
  principal_type     = "GROUP"
  target_id          = local.accounts.production
  target_type        = "AWS_ACCOUNT"
}

resource "aws_ssoadmin_account_assignment" "readonly_to_production" {
  instance_arn       = local.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.readonly.arn
  principal_id       = aws_identitystore_group.readonly.group_id
  principal_type     = "GROUP"
  target_id          = local.accounts.production
  target_type        = "AWS_ACCOUNT"
}

resource "aws_ssoadmin_account_assignment" "eks_cluster_admin_to_production" {
  instance_arn       = local.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.eks_cluster_admin.arn
  principal_id       = aws_identitystore_group.administrators.group_id
  principal_type     = "GROUP"
  target_id          = local.accounts.production
  target_type        = "AWS_ACCOUNT"
}

resource "aws_ssoadmin_account_assignment" "eks_cluster_admin_to_production_admins" {
  instance_arn       = local.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.eks_cluster_admin.arn
  principal_id       = aws_identitystore_group.production_admins.group_id
  principal_type     = "GROUP"
  target_id          = local.accounts.production
  target_type        = "AWS_ACCOUNT"
}

resource "aws_ssoadmin_account_assignment" "eks_developer_to_production" {
  instance_arn       = local.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.eks_developer.arn
  principal_id       = aws_identitystore_group.developers.group_id
  principal_type     = "GROUP"
  target_id          = local.accounts.production
  target_type        = "AWS_ACCOUNT"
}

resource "aws_ssoadmin_account_assignment" "terraform_to_production" {
  instance_arn       = local.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.terraform_execution.arn
  principal_id       = aws_identitystore_group.administrators.group_id
  principal_type     = "GROUP"
  target_id          = local.accounts.production
  target_type        = "AWS_ACCOUNT"
}

resource "aws_ssoadmin_account_assignment" "administrators_to_log_archive" {
  instance_arn       = local.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.administrator.arn
  principal_id       = aws_identitystore_group.administrators.group_id
  principal_type     = "GROUP"
  target_id          = local.accounts.log_archive
  target_type        = "AWS_ACCOUNT"
}

resource "aws_ssoadmin_account_assignment" "security_admins_to_log_archive" {
  instance_arn       = local.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.security_admin.arn
  principal_id       = aws_identitystore_group.security_admins.group_id
  principal_type     = "GROUP"
  target_id          = local.accounts.log_archive
  target_type        = "AWS_ACCOUNT"
}

resource "aws_ssoadmin_account_assignment" "readonly_to_log_archive" {
  instance_arn       = local.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.readonly.arn
  principal_id       = aws_identitystore_group.readonly.group_id
  principal_type     = "GROUP"
  target_id          = local.accounts.log_archive
  target_type        = "AWS_ACCOUNT"
}

resource "aws_ssoadmin_account_assignment" "terraform_to_log_archive" {
  instance_arn       = local.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.terraform_execution.arn
  principal_id       = aws_identitystore_group.administrators.group_id
  principal_type     = "GROUP"
  target_id          = local.accounts.log_archive
  target_type        = "AWS_ACCOUNT"
}

resource "aws_ssoadmin_account_assignment" "administrators_to_development" {
  instance_arn       = local.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.administrator.arn
  principal_id       = aws_identitystore_group.administrators.group_id
  principal_type     = "GROUP"
  target_id          = local.accounts.development
  target_type        = "AWS_ACCOUNT"
}

resource "aws_ssoadmin_account_assignment" "developers_to_development" {
  instance_arn       = local.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.administrator.arn
  principal_id       = aws_identitystore_group.developers.group_id
  principal_type     = "GROUP"
  target_id          = local.accounts.development
  target_type        = "AWS_ACCOUNT"
}

resource "aws_ssoadmin_account_assignment" "readonly_to_development" {
  instance_arn       = local.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.readonly.arn
  principal_id       = aws_identitystore_group.readonly.group_id
  principal_type     = "GROUP"
  target_id          = local.accounts.development
  target_type        = "AWS_ACCOUNT"
}

resource "aws_ssoadmin_account_assignment" "administrators_to_staging" {
  instance_arn       = local.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.administrator.arn
  principal_id       = aws_identitystore_group.administrators.group_id
  principal_type     = "GROUP"
  target_id          = local.accounts.staging
  target_type        = "AWS_ACCOUNT"
}

resource "aws_ssoadmin_account_assignment" "developers_to_staging" {
  instance_arn       = local.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.administrator.arn
  principal_id       = aws_identitystore_group.developers.group_id
  principal_type     = "GROUP"
  target_id          = local.accounts.staging
  target_type        = "AWS_ACCOUNT"
}

resource "aws_ssoadmin_account_assignment" "readonly_to_staging" {
  instance_arn       = local.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.readonly.arn
  principal_id       = aws_identitystore_group.readonly.group_id
  principal_type     = "GROUP"
  target_id          = local.accounts.staging
  target_type        = "AWS_ACCOUNT"
}

resource "aws_ssoadmin_account_assignment" "administrators_to_sandbox" {
  instance_arn       = local.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.administrator.arn
  principal_id       = aws_identitystore_group.administrators.group_id
  principal_type     = "GROUP"
  target_id          = local.accounts.sandbox
  target_type        = "AWS_ACCOUNT"
}

resource "aws_ssoadmin_account_assignment" "developers_to_sandbox" {
  instance_arn       = local.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.administrator.arn
  principal_id       = aws_identitystore_group.developers.group_id
  principal_type     = "GROUP"
  target_id          = local.accounts.sandbox
  target_type        = "AWS_ACCOUNT"
}

resource "aws_ssoadmin_account_assignment" "administrators_to_monitoring" {
  instance_arn       = local.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.administrator.arn
  principal_id       = aws_identitystore_group.administrators.group_id
  principal_type     = "GROUP"
  target_id          = local.accounts.monitoring
  target_type        = "AWS_ACCOUNT"
}

resource "aws_ssoadmin_account_assignment" "infrastructure_admins_to_monitoring" {
  instance_arn       = local.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.infrastructure_admin.arn
  principal_id       = aws_identitystore_group.infrastructure_admins.group_id
  principal_type     = "GROUP"
  target_id          = local.accounts.monitoring
  target_type        = "AWS_ACCOUNT"
}

resource "aws_ssoadmin_account_assignment" "readonly_to_monitoring" {
  instance_arn       = local.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.readonly.arn
  principal_id       = aws_identitystore_group.readonly.group_id
  principal_type     = "GROUP"
  target_id          = local.accounts.monitoring
  target_type        = "AWS_ACCOUNT"
}

resource "aws_ssoadmin_account_assignment" "administrators_to_networking" {
  instance_arn       = local.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.administrator.arn
  principal_id       = aws_identitystore_group.administrators.group_id
  principal_type     = "GROUP"
  target_id          = local.accounts.networking
  target_type        = "AWS_ACCOUNT"
}

resource "aws_ssoadmin_account_assignment" "infrastructure_admins_to_networking" {
  instance_arn       = local.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.infrastructure_admin.arn
  principal_id       = aws_identitystore_group.infrastructure_admins.group_id
  principal_type     = "GROUP"
  target_id          = local.accounts.networking
  target_type        = "AWS_ACCOUNT"
}

resource "aws_ssoadmin_account_assignment" "readonly_to_networking" {
  instance_arn       = local.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.readonly.arn
  principal_id       = aws_identitystore_group.readonly.group_id
  principal_type     = "GROUP"
  target_id          = local.accounts.networking
  target_type        = "AWS_ACCOUNT"
}

resource "aws_ssoadmin_account_assignment" "administrators_to_backup" {
  instance_arn       = local.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.administrator.arn
  principal_id       = aws_identitystore_group.administrators.group_id
  principal_type     = "GROUP"
  target_id          = local.accounts.backup
  target_type        = "AWS_ACCOUNT"
}

resource "aws_ssoadmin_account_assignment" "infrastructure_admins_to_backup" {
  instance_arn       = local.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.infrastructure_admin.arn
  principal_id       = aws_identitystore_group.infrastructure_admins.group_id
  principal_type     = "GROUP"
  target_id          = local.accounts.backup
  target_type        = "AWS_ACCOUNT"
}

resource "aws_ssoadmin_account_assignment" "readonly_to_backup" {
  instance_arn       = local.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.readonly.arn
  principal_id       = aws_identitystore_group.readonly.group_id
  principal_type     = "GROUP"
  target_id          = local.accounts.backup
  target_type        = "AWS_ACCOUNT"
}

resource "aws_ssoadmin_account_assignment" "administrators_to_services" {
  instance_arn       = local.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.administrator.arn
  principal_id       = aws_identitystore_group.administrators.group_id
  principal_type     = "GROUP"
  target_id          = local.accounts.services
  target_type        = "AWS_ACCOUNT"
}

resource "aws_ssoadmin_account_assignment" "infrastructure_admins_to_services" {
  instance_arn       = local.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.infrastructure_admin.arn
  principal_id       = aws_identitystore_group.infrastructure_admins.group_id
  principal_type     = "GROUP"
  target_id          = local.accounts.services
  target_type        = "AWS_ACCOUNT"
}

resource "aws_ssoadmin_account_assignment" "readonly_to_services" {
  instance_arn       = local.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.readonly.arn
  principal_id       = aws_identitystore_group.readonly.group_id
  principal_type     = "GROUP"
  target_id          = local.accounts.services
  target_type        = "AWS_ACCOUNT"
}

resource "aws_ssoadmin_account_assignment" "terraform_to_monitoring" {
  instance_arn       = local.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.terraform_execution.arn
  principal_id       = aws_identitystore_group.administrators.group_id
  principal_type     = "GROUP"
  target_id          = local.accounts.monitoring
  target_type        = "AWS_ACCOUNT"
}

resource "aws_ssoadmin_account_assignment" "terraform_to_networking" {
  instance_arn       = local.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.terraform_execution.arn
  principal_id       = aws_identitystore_group.administrators.group_id
  principal_type     = "GROUP"
  target_id          = local.accounts.networking
  target_type        = "AWS_ACCOUNT"
}

resource "aws_ssoadmin_account_assignment" "terraform_to_backup" {
  instance_arn       = local.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.terraform_execution.arn
  principal_id       = aws_identitystore_group.administrators.group_id
  principal_type     = "GROUP"
  target_id          = local.accounts.backup
  target_type        = "AWS_ACCOUNT"
}

resource "aws_ssoadmin_account_assignment" "terraform_to_services" {
  instance_arn       = local.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.terraform_execution.arn
  principal_id       = aws_identitystore_group.administrators.group_id
  principal_type     = "GROUP"
  target_id          = local.accounts.services
  target_type        = "AWS_ACCOUNT"
}

resource "aws_ssoadmin_account_assignment" "terraform_to_development" {
  instance_arn       = local.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.terraform_execution.arn
  principal_id       = aws_identitystore_group.administrators.group_id
  principal_type     = "GROUP"
  target_id          = local.accounts.development
  target_type        = "AWS_ACCOUNT"
}

resource "aws_ssoadmin_account_assignment" "terraform_to_staging" {
  instance_arn       = local.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.terraform_execution.arn
  principal_id       = aws_identitystore_group.administrators.group_id
  principal_type     = "GROUP"
  target_id          = local.accounts.staging
  target_type        = "AWS_ACCOUNT"
}

resource "aws_ssoadmin_account_assignment" "terraform_to_sandbox" {
  instance_arn       = local.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.terraform_execution.arn
  principal_id       = aws_identitystore_group.administrators.group_id
  principal_type     = "GROUP"
  target_id          = local.accounts.sandbox
  target_type        = "AWS_ACCOUNT"
}
