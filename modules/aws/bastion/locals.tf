locals {
  name_prefix = var.vpc_name
  
  bucket_names = {
    session_logs = "${local.name_prefix}-ssm-session-logs"
    access_logs  = "${local.name_prefix}-ssm-access-logs"
  }
  
  kms_key_alias = "alias/${local.name_prefix}-ssm-key"
  
  ssm_document_name = "${local.name_prefix}-SessionManagerRunShell"
  
  instance_name = "${local.name_prefix}-bastion"
  security_group_name = "${local.name_prefix}-bastion-sg"
  
  compliance_retention_days = 1827 # 5 years
}
