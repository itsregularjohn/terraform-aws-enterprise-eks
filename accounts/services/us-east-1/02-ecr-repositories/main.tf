provider "aws" {
  region  = "us-east-1"
  profile = "terraform-showcase"

  assume_role {
    role_arn     = "arn:aws:iam::${local.services_account_id}:role/TerraformExecutionRole"
    session_name = "terraform-services-ecr-repositories"
    external_id  = "terraform-deployment"
  }
}

module "ecr_repositories" {
  source = "../../../../modules/aws/ecr"
  
  repository_names = local.repository_names
  kms_key_id      = data.terraform_remote_state.ecr_kms.outputs.kms_key_id
  
  # TODO: https://aquasecurity.github.io/tfsec/v1.28.13/checks/aws/ecr/enforce-immutable-repository/
  image_tag_mutability = "MUTABLE"  # Set to IMMUTABLE for production security
  enable_image_scanning = true
  
  repository_policy = data.aws_iam_policy_document.cross_account_ecr_access.json
  
  enable_lifecycle_policy                   = true
  lifecycle_policy_untagged_image_count    = 5
  lifecycle_policy_tagged_image_count      = 10
  lifecycle_policy_tag_prefixes            = ["v", "latest", "main", "develop", "staging", "prod"]
}
