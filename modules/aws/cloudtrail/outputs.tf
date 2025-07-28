output "cloudtrail_arn" {
  description = "ARN of the CloudTrail"
  value       = aws_cloudtrail.this.arn
}

output "cloudtrail_name" {
  description = "Name of the CloudTrail"
  value       = aws_cloudtrail.this.name
}

output "s3_bucket_name" {
  description = "Name of the CloudTrail S3 bucket"
  value       = aws_s3_bucket.this.id
}

output "s3_bucket_arn" {
  description = "ARN of the CloudTrail S3 bucket"
  value       = aws_s3_bucket.this.arn
}

output "kms_key_id" {
  description = "ID of the CloudTrail KMS key"
  value       = aws_kms_key.this.key_id
}

output "kms_key_arn" {
  description = "ARN of the CloudTrail KMS key"
  value       = aws_kms_key.this.arn
}

output "cloudwatch_log_group_name" {
  description = "Name of the CloudWatch log group"
  value       = aws_cloudwatch_log_group.this.name
}

output "cloudwatch_log_group_arn" {
  description = "ARN of the CloudWatch log group"
  value       = aws_cloudwatch_log_group.this.arn
}

output "sns_topic_arn" {
  description = "ARN of the security alerts SNS topic"
  value       = var.enable_security_monitoring ? aws_sns_topic.security_alerts[0].arn : null
}

output "audit_access_role_arn" {
  description = "ARN of the audit account access role"
  value       = var.enable_cross_account_access && var.audit_account_id != null ? aws_iam_role.audit_account_access[0].arn : null
}
