# https://aquasecurity.github.io/tfsec/v1.28.13/checks/aws/ebs/encryption-customer-key/
resource "aws_kms_key" "this" {
  count = local.create_custom_kms_key ? 1 : 0

  description             = local.kms_key_description
  deletion_window_in_days = local.kms_key_deletion_window
  enable_key_rotation     = local.enable_key_rotation

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "Allow AWS services to use the key for EBS"
        Effect = "Allow"
        Principal = {
          Service = [
            "ec2.amazonaws.com",
            "autoscaling.amazonaws.com",
            "eks.amazonaws.com",
            "ecs.amazonaws.com",
            "rds.amazonaws.com"
          ]
        }
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ]
        Resource = "*"
      },
      {
        Sid    = "Allow AWS services to create grants for EBS"
        Effect = "Allow"
        Principal = {
          Service = [
            "ec2.amazonaws.com",
            "autoscaling.amazonaws.com",
            "eks.amazonaws.com",
            "ecs.amazonaws.com",
            "rds.amazonaws.com"
          ]
        }
        Action = [
          "kms:CreateGrant",
          "kms:ListGrants",
          "kms:RevokeGrant"
        ]
        Resource = "*"
        Condition = {
          Bool = {
            "kms:GrantIsForAWSResource" = "true"
          }
        }
      },
      {
        Sid    = "Allow access through EBS for all principals in the account"
        Effect = "Allow"
        Principal = {
          AWS = "*"
        }
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:CreateGrant",
          "kms:DescribeKey"
        ]
        Resource = "*"
        Condition = {
          StringEquals = {
            "kms:CallerAccount" = "${data.aws_caller_identity.current.account_id}"
            "kms:ViaService"    = "ec2.${data.aws_region.current.name}.amazonaws.com"
          }
        }
      }
    ]
  })
}

resource "aws_kms_alias" "this" {
  count = local.create_custom_kms_key ? 1 : 0

  name          = "alias/ebs-encryption"
  target_key_id = aws_kms_key.this[0].key_id
}
