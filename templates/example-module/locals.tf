locals {
  name_prefix = var.name
  
  bucket_name = "${local.name_prefix}-${data.aws_caller_identity.current.account_id}"
}
