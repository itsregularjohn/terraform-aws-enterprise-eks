output "kms_key_id" {
  description = "KMS key ID for Terraform state encryption"
  value       = aws_kms_key.this.key_id
}

output "kms_key_arn" {
  description = "KMS key ARN for Terraform state encryption"
  value       = aws_kms_key.this.arn
}

output "bucket_name" {
  description = "Terraform state bucket name"
  value       = data.aws_s3_bucket.this.id
}

output "sns_topic_arn" {
  description = "SNS topic ARN for Terraform state change notifications"
  value       = aws_sns_topic.state_changes.arn
}