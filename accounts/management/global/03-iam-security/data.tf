data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = [data.aws_caller_identity.current.account_id]
    }
  }
}

data "aws_iam_policy_document" "billing_full_access" {
  statement {
    sid    = "BillingFullAccessPermissions"
    effect = "Allow"
    actions = [
      "aws-portal:*",
      "budgets:*",
      "ce:*",
      "cur:*",
      "purchase-orders:*",
      "account:*"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "billing_view_access" {
  statement {
    sid    = "BillingViewAccessPermissions"
    effect = "Allow"
    actions = [
      "aws-portal:ViewPaymentMethods",
      "aws-portal:ViewAccount",
      "aws-portal:ViewBilling",
      "aws-portal:ViewUsage",
      "budgets:ViewBudget",
      "budgets:DescribeBudgets",
      "ce:DescribeCostCategoryDefinition",
      "ce:GetCostAndUsage",
      "ce:GetDimensionValues",
      "ce:GetReservationCoverage",
      "ce:GetReservationPurchaseRecommendation",
      "ce:GetReservationUtilization",
      "ce:GetUsageReport",
      "ce:ListCostCategoryDefinitions",
      "cur:DescribeReportDefinitions"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "billing_assume_role" {
  statement {
    actions   = ["sts:AssumeRole"]
    resources = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/billing-admin-role"]
  }
}

data "aws_iam_policy_document" "billing_view_assume_role" {
  statement {
    actions   = ["sts:AssumeRole"]
    resources = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/billing-viewer-role"]
  }
}

data "aws_iam_policy_document" "terraform_state_access" {
  statement {
    sid    = "TerraformStateS3Access"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:ListBucket"
    ]
    resources = [
      "arn:aws:s3:::jp-terraform-showcase-terraform",
      "arn:aws:s3:::jp-terraform-showcase-terraform/*"
    ]
  }
  
  statement {
    sid    = "TerraformStateDynamoDBAccess"
    effect = "Allow"
    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:DeleteItem"
    ]
    resources = ["arn:aws:dynamodb:us-east-1:${data.aws_caller_identity.current.account_id}:table/terraform-state-lock"]
  }
}
