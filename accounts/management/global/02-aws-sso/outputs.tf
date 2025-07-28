output "sso_instance_arn" {
  description = "ARN of the AWS SSO instance"
  value       = local.instance_arn
}

output "identity_store_id" {
  description = "Identity Store ID for AWS SSO"
  value       = local.identity_store_id
}

output "administrator_permission_set_arn" {
  description = "ARN of the Administrator permission set"
  value       = aws_ssoadmin_permission_set.administrator.arn
}

output "readonly_permission_set_arn" {
  description = "ARN of the ReadOnly permission set"
  value       = aws_ssoadmin_permission_set.readonly.arn
}

output "developer_permission_set_arn" {
  description = "ARN of the Developer permission set"
  value       = aws_ssoadmin_permission_set.developer.arn
}

output "sso_portal_url" {
  description = "URL for AWS SSO user portal"
  value       = "https://${local.identity_store_id}.awsapps.com/start"
}

output "administrators_group_id" {
  description = "Group ID for Administrators group"
  value       = aws_identitystore_group.administrators.group_id
}

output "developers_group_id" {
  description = "Group ID for Developers group"
  value       = aws_identitystore_group.developers.group_id
}

output "production_admins_group_id" {
  description = "Group ID for Production-Admins group"
  value       = aws_identitystore_group.production_admins.group_id
}

output "readonly_group_id" {
  description = "Group ID for ReadOnly group"
  value       = aws_identitystore_group.readonly.group_id
}

output "eks_cluster_admin_permission_set_arn" {
  description = "ARN of the EKS Cluster Admin permission set"
  value       = aws_ssoadmin_permission_set.eks_cluster_admin.arn
}

output "eks_developer_permission_set_arn" {
  description = "ARN of the EKS Developer permission set"
  value       = aws_ssoadmin_permission_set.eks_developer.arn
}

output "terraform_execution_permission_set_arn" {
  description = "ARN of the Terraform Execution permission set"
  value       = aws_ssoadmin_permission_set.terraform_execution.arn
}
