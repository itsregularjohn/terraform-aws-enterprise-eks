output "organization_id" {
  description = "ID of the AWS Organization"
  value       = data.aws_organizations_organization.main.id
}

output "organization_arn" {
  description = "ARN of the AWS Organization"
  value       = data.aws_organizations_organization.main.arn
}

output "management_account_id" {
  description = "Management account ID"
  value       = data.aws_organizations_organization.main.master_account_id
}

output "security_ou_id" {
  description = "ID of the Security OU"
  value       = aws_organizations_organizational_unit.security.id
}

output "infrastructure_ou_id" {
  description = "ID of the Infrastructure OU"
  value       = aws_organizations_organizational_unit.infrastructure.id
}

output "workloads_ou_id" {
  description = "ID of the Workloads OU"
  value       = aws_organizations_organizational_unit.workloads.id
}

output "sandbox_ou_id" {
  description = "ID of the Sandbox OU"
  value       = aws_organizations_organizational_unit.sandbox.id
}

output "exceptions_ou_id" {
  description = "ID of the Exceptions OU"
  value       = aws_organizations_organizational_unit.exceptions.id
}

output "transitional_ou_id" {
  description = "ID of the Transitional OU"
  value       = aws_organizations_organizational_unit.transitional.id
}

output "policy_staging_ou_id" {
  description = "ID of the Policy Staging OU"
  value       = aws_organizations_organizational_unit.policy_staging.id
}

output "suspended_ou_id" {
  description = "ID of the Suspended OU"
  value       = aws_organizations_organizational_unit.suspended.id
}

output "individual_business_users_ou_id" {
  description = "ID of the Individual Business Users OU"
  value       = aws_organizations_organizational_unit.individual_business_users.id
}

output "deployments_ou_id" {
  description = "ID of the Deployments OU"
  value       = aws_organizations_organizational_unit.deployments.id
}

output "business_continuity_ou_id" {
  description = "ID of the Business Continuity OU"
  value       = aws_organizations_organizational_unit.business_continuity.id
}

output "production_account_id" {
  description = "Production account ID"
  value       = aws_organizations_account.production.id
}

output "sandbox_account_id" {
  description = "Sandbox account ID"
  value       = aws_organizations_account.sandbox.id
}

output "log_archive_account_id" {
  description = "Log Archive account ID (if enabled)"
  value       = local.enable_log_archive_account ? aws_organizations_account.log_archive[0].id : null
}

output "audit_account_id" {
  description = "Audit (Security Tooling) account ID (if enabled)"
  value       = local.enable_audit_account ? aws_organizations_account.audit[0].id : null
}

output "monitoring_account_id" {
  description = "Monitoring account ID (if enabled)"
  value       = local.enable_monitoring_account ? aws_organizations_account.monitoring[0].id : null
}

output "networking_account_id" {
  description = "Networking account ID (if enabled)"
  value       = local.enable_networking_account ? aws_organizations_account.networking[0].id : null
}

output "backup_account_id" {
  description = "Backup account ID (if enabled)"
  value       = local.enable_backup_account ? aws_organizations_account.backup[0].id : null
}

output "development_account_id" {
  description = "Development account ID (if enabled)"
  value       = local.enable_development_account ? aws_organizations_account.development[0].id : null
}

output "staging_account_id" {
  description = "Staging account ID (if enabled)"
  value       = local.enable_staging_account ? aws_organizations_account.staging[0].id : null
}

output "services_account_id" {
  description = "Services account ID (if enabled)"
  value       = local.enable_services_account ? aws_organizations_account.services[0].id : null
}

output "account_ids" {
  description = "Map of all enabled account IDs"
  value = merge(
    {
      management = data.aws_organizations_organization.main.master_account_id
      production = aws_organizations_account.production.id
      sandbox    = aws_organizations_account.sandbox.id
    },
    local.enable_log_archive_account ? { log_archive = aws_organizations_account.log_archive[0].id } : {},
    local.enable_audit_account ? { audit = aws_organizations_account.audit[0].id } : {},
    local.enable_monitoring_account ? { monitoring = aws_organizations_account.monitoring[0].id } : {},
    local.enable_networking_account ? { networking = aws_organizations_account.networking[0].id } : {},
    local.enable_backup_account ? { backup = aws_organizations_account.backup[0].id } : {},
    local.enable_development_account ? { development = aws_organizations_account.development[0].id } : {},
    local.enable_staging_account ? { staging = aws_organizations_account.staging[0].id } : {},
    local.enable_services_account ? { services = aws_organizations_account.services[0].id } : {}
  )
}
