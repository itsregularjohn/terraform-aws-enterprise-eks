provider "aws" {
  region  = "us-east-1"
  profile = "terraform-showcase"
}

module "iam_security" {
  source = "../../../../modules/aws/iam-security"
  
  iam_groups = {
    "billing-admins" = {
      path = "/"
      aws_managed_policies = ["arn:aws:iam::aws:policy/job-function/Billing"]
      custom_policies     = ["billing-full-access", "billing-assume-role"]
    }
    "billing-viewers" = {
      path = "/"
      custom_policies = ["billing-view-access", "billing-view-assume-role"]
    }
    "organization-admins" = {
      path = "/admin/"
      aws_managed_policies = [
        "arn:aws:iam::aws:policy/AWSOrganizationsFullAccess",
        "arn:aws:iam::aws:policy/AWSSSOMasterAccountAdministrator"
      ]
    }
    "security-auditors" = {
      path = "/security/"
      aws_managed_policies = [
        "arn:aws:iam::aws:policy/SecurityAudit",
        "arn:aws:iam::aws:policy/ReadOnlyAccess"
      ]
    }
    "terraform-operators" = {
      path = "/automation/"
      aws_managed_policies = ["arn:aws:iam::aws:policy/PowerUserAccess"]
      custom_policies     = ["terraform-state-access"]
    }
  }
  
  iam_policies = {
    "billing-full-access" = {
      path            = "/"
      description     = "Full access to billing and cost management"
      policy_document = data.aws_iam_policy_document.billing_full_access.json
    }
    "billing-view-access" = {
      path            = "/"
      description     = "Read-only access to billing information"
      policy_document = data.aws_iam_policy_document.billing_view_access.json
    }
    "billing-assume-role" = {
      path            = "/"
      description     = "Allow assuming billing admin role"
      policy_document = data.aws_iam_policy_document.billing_assume_role.json
    }
    "billing-view-assume-role" = {
      path            = "/"
      description     = "Allow assuming billing viewer role"
      policy_document = data.aws_iam_policy_document.billing_view_assume_role.json
    }
    "terraform-state-access" = {
      path            = "/"
      description     = "Access to Terraform state management"
      policy_document = data.aws_iam_policy_document.terraform_state_access.json
    }
  }
  
  iam_roles = {
    "billing-admin-role" = {
      description        = "Role for billing administration"
      assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
      custom_policies   = ["billing-full-access"]
    }
    "billing-viewer-role" = {
      description        = "Role for billing read-only access"
      assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
      custom_policies   = ["billing-view-access"]
    }
  }
  
  group_memberships = local.group_memberships
}
