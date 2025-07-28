resource "aws_s3_bucket" "this" {
  bucket = local.name

  lifecycle {
    prevent_destroy = true
  }
}

# https://aquasecurity.github.io/tfsec/v1.28.13/checks/aws/cloudtrail/require-bucket-access-logging/
resource "aws_s3_bucket" "logs" {
  bucket = "${local.name}-logs"

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_acl" "this" {
  bucket = aws_s3_bucket.this.id
  acl    = "log-delivery-write"
}

# https://aquasecurity.github.io/tfsec/v1.28.13/checks/aws/cloudtrail/require-bucket-access-logging/
resource "aws_s3_bucket_logging" "this" {
  bucket        = aws_s3_bucket.this.id
  target_bucket = aws_s3_bucket.logs.bucket
  target_prefix = "s3/${local.name}/"
}

# https://aquasecurity.github.io/tfsec/v1.28.13/checks/aws/s3/enable-bucket-encryption/
resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
  }
}

# https://aquasecurity.github.io/tfsec/v1.28.13/checks/aws/s3/enable-bucket-encryption/
resource "aws_s3_bucket_server_side_encryption_configuration" "logs" {
  bucket = aws_s3_bucket.logs.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
  }
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions = [
      "s3:GetBucketAcl",
    ]
    principals {
      identifiers = [
        "cloudtrail.amazonaws.com",
      ]
      type = "Service"
    }
    resources = [
      aws_s3_bucket.this.arn,
    ]
    sid = "CloudTrail ACL Check"

    dynamic "condition" {
      for_each = var.is_organization_trail && var.organization_id != null ? [1] : []
      content {
        test     = "StringEquals"
        variable = "AWS:SourceOrgID"
        values   = [var.organization_id]
      }
    }
  }

  statement {
    actions = [
      "s3:PutObject",
    ]
    condition {
      test = "StringEquals"
      values = [
        "bucket-owner-full-control",
      ]
      variable = "s3:x-amz-acl"
    }
    principals {
      identifiers = [
        "cloudtrail.amazonaws.com",
      ]
      type = "Service"
    }
    resources = [
      "${aws_s3_bucket.this.arn}/*",
    ]
    sid = "CloudTrail Write"

    dynamic "condition" {
      for_each = var.is_organization_trail && var.organization_id != null ? [1] : []
      content {
        test     = "StringEquals"
        variable = "AWS:SourceOrgID"
        values   = [var.organization_id]
      }
    }
  }

  dynamic "statement" {
    for_each = var.is_organization_trail && var.organization_id != null ? [1] : []
    content {
      actions = [
        "s3:GetObject",
        "s3:ListBucket",
      ]
      principals {
        identifiers = ["*"]
        type        = "AWS"
      }
      resources = [
        aws_s3_bucket.this.arn,
        "${aws_s3_bucket.this.arn}/*",
      ]
      condition {
        test     = "StringEquals"
        variable = "aws:PrincipalOrgID"
        values   = [var.organization_id]
      }
      sid = "Allow organization accounts to read logs"
    }
  }

  statement {
    actions = [
      "s3:*",
    ]
    condition {
      test = "Bool"
      values = [
        "false",
      ]
      variable = "aws:SecureTransport"
    }
    effect = "Deny"
    principals {
      identifiers = [
        "*",
      ]
      type = "AWS"
    }
    resources = [
      aws_s3_bucket.this.arn,
      "${aws_s3_bucket.this.arn}/*",
    ]
    sid = "DenyUnsecuredTransport"
  }
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.s3_policy.json
}

# https://aquasecurity.github.io/tfsec/v1.28.13/checks/aws/cloudtrail/no-public-log-access/
# https://aquasecurity.github.io/tfsec/v1.28.13/checks/aws/s3/block-public-acls/
# https://aquasecurity.github.io/tfsec/v1.28.13/checks/aws/s3/block-public-policy/
# https://aquasecurity.github.io/tfsec/v1.28.13/checks/aws/s3/ignore-public-acls/
# https://aquasecurity.github.io/tfsec/v1.28.13/checks/aws/s3/no-public-buckets/
resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# https://aquasecurity.github.io/tfsec/v1.28.13/checks/aws/s3/block-public-acls/
# https://aquasecurity.github.io/tfsec/v1.28.13/checks/aws/s3/block-public-policy/
# https://aquasecurity.github.io/tfsec/v1.28.13/checks/aws/s3/ignore-public-acls/
# https://aquasecurity.github.io/tfsec/v1.28.13/checks/aws/s3/no-public-buckets/
resource "aws_s3_bucket_public_access_block" "logs" {
  bucket                  = aws_s3_bucket.logs.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
