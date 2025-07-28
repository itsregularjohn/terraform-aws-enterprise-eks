# https://aquasecurity.github.io/tfsec/v1.28.13/checks/aws/cloudtrail/ensure-cloudwatch-integration/
resource "aws_cloudwatch_log_group" "this" {
  name              = local.name
  retention_in_days = 365
}

resource "aws_cloudwatch_log_metric_filter" "root_usage" {
  count = var.enable_security_monitoring ? 1 : 0

  name           = "RootAccountUsage"
  log_group_name = aws_cloudwatch_log_group.this.name
  pattern        = "{ $.userIdentity.type = \"Root\" && $.userIdentity.invokedBy NOT EXISTS && $.eventType != \"AwsServiceEvent\" }"

  metric_transformation {
    name      = "RootAccountUsageCount"
    namespace = "CloudTrailMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "unauthorized_api_calls" {
  count = var.enable_security_monitoring ? 1 : 0

  name           = "UnauthorizedAPICalls"
  log_group_name = aws_cloudwatch_log_group.this.name
  pattern        = "{ ($.errorCode = \"*UnauthorizedOperation\") || ($.errorCode = \"AccessDenied*\") }"

  metric_transformation {
    name      = "UnauthorizedAPICallsCount"
    namespace = "CloudTrailMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "console_without_mfa" {
  count = var.enable_security_monitoring ? 1 : 0

  name           = "ConsoleSigninWithoutMFA"
  log_group_name = aws_cloudwatch_log_group.this.name
  pattern        = "{ ($.eventName = \"ConsoleLogin\") && ($.additionalEventData.MFAUsed != \"Yes\") }"

  metric_transformation {
    name      = "ConsoleSigninWithoutMFACount"
    namespace = "CloudTrailMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "iam_policy_changes" {
  count = var.enable_security_monitoring ? 1 : 0

  name           = "IAMPolicyChanges"
  log_group_name = aws_cloudwatch_log_group.this.name
  pattern        = "{($.eventName=DeleteGroupPolicy)||($.eventName=DeleteRolePolicy)||($.eventName=DeleteUserPolicy)||($.eventName=PutGroupPolicy)||($.eventName=PutRolePolicy)||($.eventName=PutUserPolicy)||($.eventName=CreatePolicy)||($.eventName=DeletePolicy)||($.eventName=CreatePolicyVersion)||($.eventName=DeletePolicyVersion)||($.eventName=AttachRolePolicy)||($.eventName=DetachRolePolicy)||($.eventName=AttachUserPolicy)||($.eventName=DetachUserPolicy)||($.eventName=AttachGroupPolicy)||($.eventName=DetachGroupPolicy)}"

  metric_transformation {
    name      = "IAMPolicyEventCount"
    namespace = "CloudTrailMetrics"
    value     = "1"
  }
}
