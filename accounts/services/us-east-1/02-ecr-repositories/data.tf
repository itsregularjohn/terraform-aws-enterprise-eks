data "terraform_remote_state" "organizations" {
  backend = "s3"
  config = {
    bucket  = "jp-terraform-showcase-terraform"
    key     = "management/global/organizations/terraform.tfstate"
    region  = "us-east-1"
    profile = "terraform-showcase"
  }
}

data "terraform_remote_state" "ecr_kms" {
  backend = "s3"
  config = {
    bucket  = "jp-terraform-showcase-terraform"
    key     = "services/us-east-1/ecr-kms/terraform.tfstate"
    region  = "us-east-1"
    profile = "terraform-showcase"
  }
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_iam_policy_document" "cross_account_ecr_access" {
  statement {
    effect = "Allow"
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetAuthorizationToken",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages",
      "ecr:BatchGetImage",
    ]
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${local.production_account_id}:root",
        "arn:aws:iam::${local.development_account_id}:root",
        "arn:aws:iam::${local.staging_account_id}:root"
      ]
    }
  }

  statement {
    sid    = "LambdaECRImageCrossAccountRetrievalPolicy"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = [
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer"
    ]
    condition {
      test     = "StringLike"
      variable = "aws:ResourceOrgID"
      values   = [data.terraform_remote_state.organizations.outputs.organization_id]
    }
  }
}
