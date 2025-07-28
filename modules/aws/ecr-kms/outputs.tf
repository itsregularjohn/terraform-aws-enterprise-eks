output "kms_key_id" {
  description = "The KMS key ID for ECR encryption"
  value       = aws_kms_key.this.key_id
}

output "kms_key_arn" {
  description = "The KMS key ARN for ECR encryption"
  value       = aws_kms_key.this.arn
}

output "kms_alias_name" {
  description = "The KMS key alias name"
  value       = aws_kms_alias.this.name
}

output "kms_alias_arn" {
  description = "The KMS key alias ARN"
  value       = aws_kms_alias.this.arn
}

output "key_rotation_enabled" {
  description = "Whether key rotation is enabled"
  value       = aws_kms_key.this.enable_key_rotation
}

output "deletion_window" {
  description = "KMS key deletion window in days"
  value       = aws_kms_key.this.deletion_window_in_days
}
