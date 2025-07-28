resource "aws_kms_key" "ssmkey" {
  description             = "SSM Key"
  deletion_window_in_days = var.kms_key_deletion_window
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.kms_access.json
}

resource "aws_kms_alias" "ssmkey" {
  name          = "alias/${var.vpc_name}-ssm"
  target_key_id = aws_kms_key.ssmkey.key_id
}