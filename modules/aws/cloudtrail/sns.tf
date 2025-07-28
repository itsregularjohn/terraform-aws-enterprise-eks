resource "aws_sns_topic" "security_alerts" {
  count = var.enable_security_monitoring ? 1 : 0

  name = "cloudtrail-security-alerts"

  policy = data.aws_iam_policy_document.sns_topic_policy[0].json
}

data "aws_iam_policy_document" "sns_topic_policy" {
  count = var.enable_security_monitoring ? 1 : 0

  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["cloudwatch.amazonaws.com"]
    }
    actions   = ["SNS:Publish"]
    resources = ["arn:aws:sns:*:${data.aws_caller_identity.current.account_id}:cloudtrail-security-alerts"]
  }
}
