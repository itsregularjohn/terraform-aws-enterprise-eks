output "ebs_encryption_enabled" {
  description = "Whether EBS encryption by default is enabled"
  value       = aws_ebs_encryption_by_default.this.enabled
}

output "ebs_kms_key_id" {
  description = "The KMS key ID used for EBS encryption"
  value       = local.ebs_kms_key_id
}

output "ebs_kms_key_arn" {
  description = "The KMS key ARN used for EBS encryption"
  value       = local.ebs_kms_key_arn
}

output "ebs_kms_alias" {
  description = "The KMS key alias for EBS encryption (if custom key is created)"
  value       = local.create_custom_kms_key ? aws_kms_alias.this[0].name : "alias/aws/ebs"
}

output "custom_key_created" {
  description = "Whether a custom KMS key was created"
  value       = local.create_custom_kms_key
}

output "kms_key_rotation_enabled" {
  description = "Whether key rotation is enabled (only for custom keys)"
  value       = local.create_custom_kms_key ? aws_kms_key.this[0].enable_key_rotation : null
}
