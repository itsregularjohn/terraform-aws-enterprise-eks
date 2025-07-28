output "eks_kms_key_id" {
  description = "The KMS key ID used for EKS secrets encryption"
  value       = local.eks_kms_key_id
}

output "eks_kms_key_arn" {
  description = "The KMS key ARN used for EKS secrets encryption"
  value       = local.eks_kms_key_arn
}

output "eks_kms_alias" {
  description = "The KMS key alias for EKS secrets encryption (if custom key is created)"
  value       = local.create_custom_kms_key ? aws_kms_alias.this[0].name : "alias/aws/eks"
}

output "custom_key_created" {
  description = "Whether a custom KMS key was created"
  value       = local.create_custom_kms_key
}

output "kms_key_rotation_enabled" {
  description = "Whether key rotation is enabled (only for custom keys)"
  value       = local.create_custom_kms_key ? aws_kms_key.this[0].enable_key_rotation : null
}

output "kms_key_deletion_window" {
  description = "KMS key deletion window in days"
  value       = local.create_custom_kms_key ? aws_kms_key.this[0].deletion_window_in_days : null
}
