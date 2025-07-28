output "cloudtrail_arn" {
  description = "ARN of the CloudTrail"
  value       = module.cloudtrail_organization.cloudtrail_arn
}

output "s3_bucket_name" {
  description = "Name of the CloudTrail S3 bucket"
  value       = module.cloudtrail_organization.s3_bucket_name
}

output "s3_bucket_arn" {
  description = "ARN of the CloudTrail S3 bucket"
  value       = module.cloudtrail_organization.s3_bucket_arn
}

output "cloudwatch_log_group_name" {
  description = "Name of the CloudWatch log group"
  value       = module.cloudtrail_organization.cloudwatch_log_group_name
}

output "kms_key_arn" {
  description = "ARN of the CloudTrail KMS key"
  value       = module.cloudtrail_organization.kms_key_arn
}

output "sns_topic_arn" {
  description = "ARN of the security alerts SNS topic"
  value       = module.cloudtrail_organization.sns_topic_arn
}

output "audit_access_role_arn" {
  description = "ARN of the audit account access role"
  value       = module.cloudtrail_organization.audit_access_role_arn
}
