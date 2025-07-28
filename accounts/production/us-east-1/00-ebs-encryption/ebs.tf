# https://aquasecurity.github.io/tfsec/v1.28.13/checks/aws/ebs/enable-volume-encryption/
resource "aws_ebs_encryption_by_default" "this" {
  enabled = true
}

resource "aws_ebs_default_kms_key" "this" {
  key_arn = local.create_custom_kms_key ? aws_kms_key.this[0].arn : data.aws_kms_key.ebs_aws_managed[0].arn

  depends_on = [aws_ebs_encryption_by_default.this]
}
