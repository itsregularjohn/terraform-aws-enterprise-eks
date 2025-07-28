data "aws_ssoadmin_instances" "main" {}

data "terraform_remote_state" "organizations" {
  backend = "s3"
  config = {
    bucket     = "jp-terraform-showcase-terraform"
    key        = "management/global/organizations/terraform.tfstate"
    region     = "us-east-1"
    profile    = "terraform-showcase"
  }
}

data "aws_iam_policy_document" "developer" {
  statement {
    effect = "Allow"
    actions = [
      "ec2:*",
      "s3:*",
      # "rds:*",
      "lambda:*",
      "cloudformation:*",
      "iam:Get*",
      "iam:List*",
      "iam:PassRole",
      "logs:*",
      # "monitoring:*",
      # "events:*"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Deny"
    actions = [
      "iam:Create*",
      "iam:Delete*",
      "iam:Put*",
      "iam:Update*",
      "iam:Attach*",
      "iam:Detach*"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "eks_cluster_admin" {
  statement {
    effect = "Allow"
    actions = [
      "eks:*",
      "ec2:DescribeInstances",
      "ec2:DescribeRouteTables",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSubnets",
      "ec2:DescribeVolumes",
      "ec2:DescribeVpcs",
      "iam:ListRoles",
      "iam:PassRole",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "eks_developer" {
  statement {
    effect = "Allow"
    actions = [
      "eks:DescribeCluster",
      "eks:ListClusters",
      "eks:AccessKubernetesApi"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "ec2:DescribeInstances",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSubnets"
    ]
    resources = ["*"]
  }
}
