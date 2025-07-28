output "password_policy" {
  description = "IAM account password policy configuration"
  value       = module.iam_security.password_policy
}

output "groups_created" {
  description = "IAM groups created"
  value       = module.iam_security.groups
}

output "policies_created" {
  description = "Custom IAM policies created"
  value       = module.iam_security.policies
}

output "roles_created" {
  description = "IAM roles created"
  value       = module.iam_security.roles
}

output "mfa_enforcement_policy_arn" {
  description = "ARN of the MFA enforcement policy"
  value       = module.iam_security.mfa_enforcement_policy_arn
}

output "security_compliance_status" {
  description = "Security compliance status summary"
  value       = module.iam_security.security_compliance
}

output "group_membership_summary" {
  description = "Summary of group memberships"
  value = {
    for group_name, users in local.group_memberships : group_name => {
      user_count = length(users)
      users      = users
    }
  }
}
