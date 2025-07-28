locals {
  organization_admin_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/OrganizationAccountAccessRole"
  create_kms_key              = var.kms_key_arn == null ? true : false
  node_group_name            = "${var.cluster_name}-application"
}
