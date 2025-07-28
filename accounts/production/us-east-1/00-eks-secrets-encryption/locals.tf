locals {
  production_account_id = data.terraform_remote_state.organizations.outputs.account_ids["production"]
  
  create_custom_kms_key = true
  kms_key_description = "Custom KMS key for EKS secrets encryption in production account"
  kms_key_deletion_window = 7
  enable_key_rotation = true
  key_usage = "ENCRYPT_DECRYPT"
  
  eks_kms_key_id  = local.create_custom_kms_key ? aws_kms_key.this[0].key_id : data.aws_kms_key.eks_aws_managed[0].key_id
  eks_kms_key_arn = local.create_custom_kms_key ? aws_kms_key.this[0].arn : data.aws_kms_key.eks_aws_managed[0].arn
}
