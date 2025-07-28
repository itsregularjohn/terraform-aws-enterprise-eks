resource "aws_identitystore_group" "administrators" {
  display_name      = "Administrators"
  description       = "Full administrative access to all accounts"
  identity_store_id = local.identity_store_id
}

resource "aws_identitystore_group" "developers" {
  display_name      = "Developers"
  description       = "Development access to non-production accounts"
  identity_store_id = local.identity_store_id
}

resource "aws_identitystore_group" "production_admins" {
  display_name      = "Production-Admins"
  description       = "Administrative access to production account only"
  identity_store_id = local.identity_store_id
}

resource "aws_identitystore_group" "readonly" {
  display_name      = "ReadOnly"
  description       = "Read-only access for auditing and monitoring"
  identity_store_id = local.identity_store_id
}

resource "aws_identitystore_group" "infrastructure_admins" {
  display_name      = "Infrastructure-Admins"
  description       = "Administrative access to infrastructure accounts"
  identity_store_id = local.identity_store_id
}

resource "aws_identitystore_group" "security_admins" {
  display_name      = "Security-Admins"
  description       = "Administrative access to security accounts (logs, audit)"
  identity_store_id = local.identity_store_id
}
