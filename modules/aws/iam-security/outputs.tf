output "password_policy" {
  description = "IAM account password policy details"
  value = var.enable_password_policy ? {
    minimum_password_length      = aws_iam_account_password_policy.this[0].minimum_password_length
    max_password_age            = aws_iam_account_password_policy.this[0].max_password_age
    password_reuse_prevention   = aws_iam_account_password_policy.this[0].password_reuse_prevention
    require_lowercase_characters = aws_iam_account_password_policy.this[0].require_lowercase_characters
    require_numbers             = aws_iam_account_password_policy.this[0].require_numbers
    require_uppercase_characters = aws_iam_account_password_policy.this[0].require_uppercase_characters
    require_symbols            = aws_iam_account_password_policy.this[0].require_symbols
    allow_users_to_change_password = aws_iam_account_password_policy.this[0].allow_users_to_change_password
  } : null
}

output "groups" {
  description = "Map of IAM groups created"
  value = {
    for name, group in aws_iam_group.this : name => {
      name = group.name
      arn  = group.arn
      path = group.path
    }
  }
}

output "policies" {
  description = "Map of custom IAM policies created"
  value = {
    for name, policy in aws_iam_policy.this : name => {
      name = policy.name
      arn  = policy.arn
      path = policy.path
    }
  }
}

output "roles" {
  description = "Map of IAM roles created"
  value = {
    for name, role in aws_iam_role.this : name => {
      name = role.name
      arn  = role.arn
      path = role.path
    }
  }
}

output "mfa_enforcement_policy_arn" {
  description = "ARN of the MFA enforcement policy"
  value       = var.enable_mfa_enforcement ? aws_iam_policy.mfa_enforcement[0].arn : null
}

output "security_compliance" {
  description = "Security compliance status"
  value = {
    password_policy_enabled    = var.enable_password_policy
    mfa_enforcement_enabled   = var.enable_mfa_enforcement
    minimum_password_length   = var.minimum_password_length
    password_reuse_prevention = var.password_reuse_prevention
    groups_created           = length(aws_iam_group.this)
    policies_created         = length(aws_iam_policy.this)
    roles_created           = length(aws_iam_role.this)
  }
}
