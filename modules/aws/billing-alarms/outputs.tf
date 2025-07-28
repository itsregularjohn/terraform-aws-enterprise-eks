output "sns_topic_arn" {
  description = "ARN of the SNS topic for billing alerts"
  value       = aws_sns_topic.this.arn
}

output "alarm_name" {
  description = "Name of the CloudWatch billing alarm"
  value       = aws_cloudwatch_metric_alarm.this.alarm_name
}

output "alarm_arn" {
  description = "ARN of the CloudWatch billing alarm"
  value       = aws_cloudwatch_metric_alarm.this.arn
}
