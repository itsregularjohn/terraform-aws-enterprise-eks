output "sns_topic_arn" {
  description = "ARN of the SNS topic for billing alerts"
  value       = module.billing_alarms.sns_topic_arn
}

output "alarm_name" {
  description = "Name of the CloudWatch billing alarm"
  value       = module.billing_alarms.alarm_name
}

output "alarm_email" {
  description = "Email address receiving billing notifications"
  value       = local.alarm_email
  sensitive   = true
}
