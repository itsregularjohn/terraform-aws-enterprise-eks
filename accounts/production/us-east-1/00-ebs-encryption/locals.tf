locals {
  production_account_id = data.terraform_remote_state.organizations.outputs.account_ids["production"]
  
  create_custom_kms_key = true
  kms_key_description = "Custom KMS key for EBS encryption in production account"
  kms_key_deletion_window = 7
  enable_key_rotation = true
  
  ebs_kms_key_id  = local.create_custom_kms_key ? aws_kms_key.this[0].key_id : data.aws_kms_key.ebs_aws_managed[0].key_id
  ebs_kms_key_arn = local.create_custom_kms_key ? aws_kms_key.this[0].arn : data.aws_kms_key.ebs_aws_managed[0].arn
}
