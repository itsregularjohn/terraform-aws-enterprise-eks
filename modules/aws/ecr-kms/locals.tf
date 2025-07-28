locals {
  name_prefix = var.name
  
  kms_key_name = "${local.name_prefix}-ecr-encryption"
  kms_alias_name = "alias/${local.name_prefix}/ecr"
  kms_key_description = "Customer-managed KMS key for ECR repository encryption in ${var.environment} environment"
}
