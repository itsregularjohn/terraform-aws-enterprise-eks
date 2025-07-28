resource "aws_cloudwatch_metric_alarm" "root_usage" {
  count = var.enable_security_monitoring ? 1 : 0

  alarm_name          = "cloudtrail-root-account-usage"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "RootAccountUsageCount"
  namespace           = "CloudTrailMetrics"
  period              = "60"
  statistic           = "Sum"
  threshold           = "1"
  alarm_description   = "Monitoring for root account usage"
  alarm_actions       = [aws_sns_topic.security_alerts[0].arn]
  treat_missing_data  = "notBreaching"
}

resource "aws_cloudwatch_metric_alarm" "unauthorized_api_calls" {
  count = var.enable_security_monitoring ? 1 : 0

  alarm_name          = "cloudtrail-unauthorized-api-calls"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "UnauthorizedAPICallsCount"
  namespace           = "CloudTrailMetrics"
  period              = "300"
  statistic           = "Sum"
  threshold           = "10"
  alarm_description   = "Monitoring for unauthorized API calls"
  alarm_actions       = [aws_sns_topic.security_alerts[0].arn]
  treat_missing_data  = "notBreaching"
}
