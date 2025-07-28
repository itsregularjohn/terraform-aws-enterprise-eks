resource "aws_sns_topic" "this" {
  name = "${var.account_name}-billing-alarm"
}

resource "aws_sns_topic_subscription" "this" {
  topic_arn = aws_sns_topic.this.arn
  protocol  = "email"
  endpoint  = var.alarm_email
}

# CloudWatch Billing Alarm - $5 USD threshold
resource "aws_cloudwatch_metric_alarm" "this" {
  alarm_name          = "${var.account_name}-billing-alarm-5-USD"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "EstimatedCharges"
  namespace           = "AWS/Billing"
  period              = 86400 # 24 hours
  statistic           = "Maximum"
  threshold           = 5.00
  alarm_description   = "This alarm monitors estimated charges for AWS account ${var.account_name} - triggers at $5 USD"
  alarm_actions       = [aws_sns_topic.this.arn]
  treat_missing_data  = "notBreaching"

  dimensions = {
    Currency = "USD"
  }
}
