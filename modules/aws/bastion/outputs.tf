output "session_logs_bucket_id" {
  description = "ID of the S3 bucket used for storing SSM session logs"
  value       = aws_s3_bucket.session_logs_bucket.id
}

output "session_manager_cloudwatch_log_group_name" {
  description = "Name of the CloudWatch log group for SSM session logs"
  value       = aws_cloudwatch_log_group.session_manager_log_group.name
}

output "ssm_kms_key_id" {
  description = "ID of the KMS key used for SSM encryption"
  value       = aws_kms_key.ssmkey.id
}

output "ssm_kms_key_arn" {
  description = "ARN of the KMS key used for SSM encryption"
  value       = aws_kms_key.ssmkey.arn
}

output "instance_id" {
  description = "ID of the bastion host EC2 instance"
  value       = aws_instance.this.id
}

output "instance_private_ip" {
  description = "Private IP address of the bastion host"
  value       = aws_instance.this.private_ip
}

output "security_group_id" {
  description = "ID of the security group attached to the bastion host"
  value       = aws_security_group.this.id
}

output "iam_role_arn" {
  description = "ARN of the IAM role attached to the bastion host"
  value       = aws_iam_role.ssm_role.arn
}

output "iam_instance_profile_name" {
  description = "Name of the IAM instance profile attached to the bastion host"
  value       = aws_iam_instance_profile.ssm_profile.name
}
