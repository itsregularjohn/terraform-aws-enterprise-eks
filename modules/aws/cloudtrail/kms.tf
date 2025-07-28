resource "aws_kms_key" "this" {
  description = "CloudTrail KMS key"
  policy      = data.aws_iam_policy_document.cloudtrail_kms.json

  # https://aquasecurity.github.io/tfsec/v1.28.13/checks/aws/kms/auto-rotate-keys/
  enable_key_rotation = true
}

resource "aws_kms_alias" "this" {
  name          = "alias/cloudtrail"
  target_key_id = aws_kms_key.this.key_id
}

data "aws_iam_policy_document" "cloudtrail_kms" {
  statement {
    actions = [
      "kms:*",
    ]
    principals {
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
      ]
      type = "AWS"
    }
    resources = [
      "*"
    ]
    sid = "Enable IAM User Permissions"
  }

  dynamic "statement" {
    for_each = var.is_organization_trail && var.organization_id != null ? [1] : []
    content {
      actions = [
        "kms:Decrypt",
        "kms:DescribeKey",
      ]
      principals {
        identifiers = ["*"]
        type        = "AWS"
      }
      resources = ["*"]
      condition {
        test     = "StringEquals"
        variable = "aws:PrincipalOrgID"
        values   = [var.organization_id]
      }
      sid = "Allow organization accounts to decrypt logs"
    }
  }

  statement {
    actions = [
      "kms:GenerateDataKey*",
    ]
    condition {
      test = "StringLike"
      values = var.is_organization_trail ? [
        "arn:aws:cloudtrail:*:*:trail/*"
        ] : [
        "arn:aws:cloudtrail:*:${data.aws_caller_identity.current.account_id}:trail/*",
      ]
      variable = "kms:EncryptionContext:aws:cloudtrail:arn"
    }
    principals {
      identifiers = [
        "cloudtrail.amazonaws.com",
      ]
      type = "Service"
    }
    resources = [
      "*"
    ]
    sid = "Allow CloudTrail to encrypt logs"
  }

  statement {
    actions = [
      "kms:DescribeKey",
    ]
    principals {
      identifiers = [
        "cloudtrail.amazonaws.com",
      ]
      type = "Service"
    }
    resources = [
      "*"
    ]
    sid = "Allow CloudTrail to describe key"
  }
}
