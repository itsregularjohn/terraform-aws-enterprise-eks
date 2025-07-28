locals {
  group_aws_managed_policies = merge([
    for group_name, group_config in var.iam_groups : {
      for policy_arn in group_config.aws_managed_policies : "${group_name}-${replace(policy_arn, "/", "-")}" => {
        group      = group_name
        policy_arn = policy_arn
      }
    }
  ]...)

  group_custom_policies = merge([
    for group_name, group_config in var.iam_groups : {
      for policy_name in group_config.custom_policies : "${group_name}-${policy_name}" => {
        group  = group_name
        policy = policy_name
      }
    }
  ]...)

  role_aws_managed_policies = merge([
    for role_name, role_config in var.iam_roles : {
      for policy_arn in role_config.aws_managed_policies : "${role_name}-${replace(policy_arn, "/", "-")}" => {
        role       = role_name
        policy_arn = policy_arn
      }
    }
  ]...)

  role_custom_policies = merge([
    for role_name, role_config in var.iam_roles : {
      for policy_name in role_config.custom_policies : "${role_name}-${policy_name}" => {
        role   = role_name
        policy = policy_name
      }
    }
  ]...)
}
