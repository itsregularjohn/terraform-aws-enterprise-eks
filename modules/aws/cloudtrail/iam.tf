data "aws_iam_policy_document" "cloudwatch_assume_role" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      identifiers = [
        "cloudtrail.amazonaws.com",
      ]
      type = "Service"
    }
  }
}

resource "aws_iam_role" "cloudwatch_logs" {
  name               = "CloudTrailRoleForCloudWatchLogs_${local.name}"
  assume_role_policy = data.aws_iam_policy_document.cloudwatch_assume_role.json
}

data "aws_iam_policy_document" "cloudwatch_logs_role" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = [
      "${aws_cloudwatch_log_group.this.arn}:*",
    ]
    sid = "AWSCloudTrailLogging"
  }
}

resource "aws_iam_role_policy" "cloudwatch_logs" {
  name   = "CloudTrailCloudWatchPolicy"
  policy = data.aws_iam_policy_document.cloudwatch_logs_role.json
  role   = aws_iam_role.cloudwatch_logs.id
}

resource "aws_iam_role" "audit_account_access" {
  count = var.enable_cross_account_access && var.audit_account_id != null ? 1 : 0

  name = "CloudTrailAuditAccountAccess"

  assume_role_policy = data.aws_iam_policy_document.audit_account_assume_role[0].json
}

data "aws_iam_policy_document" "audit_account_assume_role" {
  count = var.enable_cross_account_access && var.audit_account_id != null ? 1 : 0

  statement {
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.audit_account_id}:root"]
    }
    actions = ["sts:AssumeRole"]
    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values   = [var.external_id]
    }
  }
}

resource "aws_iam_role_policy" "audit_account_access" {
  count = var.enable_cross_account_access && var.audit_account_id != null ? 1 : 0

  name = "CloudTrailAuditAccess"
  role = aws_iam_role.audit_account_access[0].id

  policy = data.aws_iam_policy_document.audit_account_access[0].json
}

data "aws_iam_policy_document" "audit_account_access" {
  count = var.enable_cross_account_access && var.audit_account_id != null ? 1 : 0

  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:ListBucket",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "logs:GetLogEvents",
      "logs:FilterLogEvents"
    ]
    resources = [
      aws_s3_bucket.this.arn,
      "${aws_s3_bucket.this.arn}/*",
      aws_cloudwatch_log_group.this.arn,
      "${aws_cloudwatch_log_group.this.arn}:*"
    ]
  }
}
