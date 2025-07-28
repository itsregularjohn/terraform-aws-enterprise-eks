output "repository_arns" {
  description = "Map of repository names to their ARNs"
  value       = module.ecr_repositories.repository_arns
}

output "repository_urls" {
  description = "Map of repository names to their URLs"
  value       = module.ecr_repositories.repository_urls
}

output "repository_names" {
  description = "List of repository names created"
  value       = module.ecr_repositories.repository_names
}

output "kms_key_id" {
  description = "KMS key ID used for repository encryption"
  value       = module.ecr_repositories.kms_key_id
}

output "total_repositories" {
  description = "Total number of repositories created"
  value       = length(module.ecr_repositories.repository_names)
}

output "cross_account_access_enabled" {
  description = "Whether cross-account access is enabled"
  value       = true
}
