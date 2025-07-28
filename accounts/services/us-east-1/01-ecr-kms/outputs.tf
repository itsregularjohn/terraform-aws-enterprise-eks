output "kms_key_id" {
  description = "The KMS key ID for ECR encryption"
  value       = module.ecr_kms.kms_key_id
}

output "kms_key_arn" {
  description = "The KMS key ARN for ECR encryption"
  value       = module.ecr_kms.kms_key_arn
}

output "kms_alias_name" {
  description = "The KMS key alias name"
  value       = module.ecr_kms.kms_alias_name
}

output "kms_alias_arn" {
  description = "The KMS key alias ARN"
  value       = module.ecr_kms.kms_alias_arn
}
