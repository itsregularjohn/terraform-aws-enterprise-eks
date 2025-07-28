resource "aws_iam_account_password_policy" "this" {
  count = var.enable_password_policy ? 1 : 0

  minimum_password_length        = var.minimum_password_length
  max_password_age              = var.max_password_age
  password_reuse_prevention     = var.password_reuse_prevention
  require_lowercase_characters  = var.require_lowercase_characters
  require_numbers              = var.require_numbers
  require_uppercase_characters = var.require_uppercase_characters
  require_symbols             = var.require_symbols
  allow_users_to_change_password = var.allow_users_to_change_password
  hard_expiry                 = var.hard_expiry
}

# https://aquasecurity.github.io/tfsec/v1.28.13/checks/aws/iam/enforce-group-mfa/
resource "aws_iam_group" "this" {
  for_each = var.iam_groups

  name = each.key
  path = each.value.path
}

# https://aquasecurity.github.io/tfsec/v1.28.13/checks/aws/iam/no-user-attached-policies/
resource "aws_iam_group_policy_attachment" "aws_managed" {
  for_each = local.group_aws_managed_policies

  group      = aws_iam_group.this[each.value.group].name
  policy_arn = each.value.policy_arn
}

resource "aws_iam_group_policy_attachment" "custom" {
  for_each = local.group_custom_policies

  group      = aws_iam_group.this[each.value.group].name
  policy_arn = aws_iam_policy.this[each.value.policy].arn

  depends_on = [aws_iam_policy.this]
}

resource "aws_iam_policy" "this" {
  for_each = var.iam_policies

  name        = each.key
  path        = each.value.path
  description = each.value.description
  policy      = each.value.policy_document
}

resource "aws_iam_role" "this" {
  for_each = var.iam_roles

  name                 = each.key
  description          = each.value.description
  assume_role_policy   = each.value.assume_role_policy
  path                 = each.value.path
  max_session_duration = each.value.max_session_duration
}

resource "aws_iam_role_policy_attachment" "aws_managed" {
  for_each = local.role_aws_managed_policies

  role       = aws_iam_role.this[each.value.role].name
  policy_arn = each.value.policy_arn
}

resource "aws_iam_role_policy_attachment" "custom" {
  for_each = local.role_custom_policies

  role       = aws_iam_role.this[each.value.role].name
  policy_arn = aws_iam_policy.this[each.value.policy].arn

  depends_on = [aws_iam_policy.this]
}

resource "aws_iam_group_membership" "this" {
  for_each = var.group_memberships

  name  = "${each.key}_membership"
  group = aws_iam_group.this[each.key].name
  users = each.value
}

# https://aquasecurity.github.io/tfsec/v1.28.13/checks/aws/iam/enforce-mfa/
resource "aws_iam_policy" "mfa_enforcement" {
  count = var.enable_mfa_enforcement ? 1 : 0

  name        = "mfa-enforcement-policy"
  path        = "/"
  description = "Enforce MFA for all users"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowViewAccountInfo"
        Effect = "Allow"
        Action = [
          "iam:GetAccountPasswordPolicy",
          "iam:GetAccountSummary",
          "iam:ListVirtualMFADevices"
        ]
        Resource = "*"
      },
      {
        Sid    = "AllowManageOwnPasswords"
        Effect = "Allow"
        Action = [
          "iam:ChangePassword",
          "iam:GetUser"
        ]
        Resource = "arn:aws:iam::*:user/$${aws:username}"
      },
      {
        Sid    = "AllowManageOwnMFA"
        Effect = "Allow"
        Action = [
          "iam:CreateVirtualMFADevice",
          "iam:DeleteVirtualMFADevice",
          "iam:ListMFADevices",
          "iam:EnableMFADevice",
          "iam:ResyncMFADevice"
        ]
        Resource = [
          "arn:aws:iam::*:mfa/*",
          "arn:aws:iam::*:user/$${aws:username}"
        ]
      },
      {
        Sid    = "DenyAllExceptUnlessSignedInWithMFA"
        Effect = "Deny"
        NotAction = [
          "iam:CreateVirtualMFADevice",
          "iam:EnableMFADevice",
          "iam:GetUser",
          "iam:ListMFADevices",
          "iam:ListVirtualMFADevices",
          "iam:ResyncMFADevice",
          "sts:GetSessionToken"
        ]
        Resource = "*"
        Condition = {
          BoolIfExists = {
            "aws:MultiFactorAuthPresent" = "false"
          }
        }
      }
    ]
  })
}

resource "aws_iam_group_policy_attachment" "mfa_enforcement" {
  for_each = var.enable_mfa_enforcement ? var.iam_groups : {}

  group      = aws_iam_group.this[each.key].name
  policy_arn = aws_iam_policy.mfa_enforcement[0].arn
}
