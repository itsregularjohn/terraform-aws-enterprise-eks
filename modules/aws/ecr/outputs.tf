output "repository_arns" {
  description = "Map of repository names to their ARNs"
  value       = { for name, repo in aws_ecr_repository.this : name => repo.arn }
}

output "repository_urls" {
  description = "Map of repository names to their URLs"
  value       = { for name, repo in aws_ecr_repository.this : name => repo.repository_url }
}

output "repository_registry_ids" {
  description = "Map of repository names to their registry IDs"
  value       = { for name, repo in aws_ecr_repository.this : name => repo.registry_id }
}

output "repository_names" {
  description = "List of repository names created"
  value       = keys(aws_ecr_repository.this)
}

output "image_scanning_enabled" {
  description = "Whether image scanning is enabled for repositories"
  value       = var.enable_image_scanning
}

output "image_tag_mutability" {
  description = "The tag mutability setting for repositories"
  value       = var.image_tag_mutability
}

output "kms_key_id" {
  description = "KMS key ID used for repository encryption"
  value       = var.kms_key_id
}
