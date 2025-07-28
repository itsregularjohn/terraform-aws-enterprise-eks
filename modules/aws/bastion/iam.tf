data "aws_iam_policy_document" "kms_access" {
  statement {
    sid = "KMS Key Default"
    principals {
      type        = "AWS"
      identifiers = ["arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    actions = [
      "kms:*",
    ]
    resources = ["*"]
  }

  statement {
    sid = "CloudWatchLogsEncryption"
    principals {
      type        = "Service"
      identifiers = ["logs.${data.aws_region.current.name}.amazonaws.com"]
    }
    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role" "ssm_role" {
  name = "${local.name_prefix}-bastion"
  path = "/"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Effect = "Allow"
        Sid    = ""
      }
    ]
  })
}

data "aws_iam_policy" "AmazonSSMManagedInstanceCore" {
  arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

data "aws_iam_policy_document" "ssm_s3_cwl_access" {
  statement {
    sid = "S3BucketAccessForSessionManager"
    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:PutObjectVersionAcl",
    ]
    resources = [
      aws_s3_bucket.session_logs_bucket.arn,
      "${aws_s3_bucket.session_logs_bucket.arn}/*",
    ]
  }

  statement {
    sid = "S3EncryptionForSessionManager"
    actions = [
      "s3:GetEncryptionConfiguration",
    ]
    resources = [
      aws_s3_bucket.session_logs_bucket.arn
    ]
  }

  statement {
    sid = "CloudWatchLogsAccessForSessionManager"
    actions = [
      "logs:PutLogEvents",
      "logs:CreateLogStream",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
    ]
    resources = ["*"]
  }

  statement {
    sid = "KMSEncryptionForSessionManager"
    actions = [
      "kms:DescribeKey",
      "kms:GenerateDataKey",
      "kms:Decrypt",
      "kms:Encrypt",
    ]
    resources = [aws_kms_key.ssmkey.arn]
  }
}

resource "aws_iam_policy" "ssm_s3_cwl_access" {
  name   = "${var.cluster_name}-ssm_s3_cwl_access-${data.aws_region.current.name}"
  path   = "/"
  policy = data.aws_iam_policy_document.ssm_s3_cwl_access.json
}

resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = data.aws_iam_policy.AmazonSSMManagedInstanceCore.arn
}

resource "aws_iam_role_policy_attachment" "ssm_s3_cwl" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = aws_iam_policy.ssm_s3_cwl_access.arn
}

resource "aws_iam_instance_profile" "ssm_profile" {
  name = "${var.cluster_name}-ssm-bastion"
  role = aws_iam_role.ssm_role.name
}

resource "aws_iam_policy" "eks" {
  name        = "${local.name_prefix}-BastionHostPolicy"
  description = "Bastion Host access policy"
  policy      = file("${path.module}/policy-eks-full-access.json")
}

resource "aws_iam_role_policy_attachment" "eks" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = aws_iam_policy.eks.arn
}
