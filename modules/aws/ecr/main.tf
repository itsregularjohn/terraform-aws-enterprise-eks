resource "aws_ecr_repository" "this" {
  for_each = toset(var.repository_names)

  name = each.value

  # https://aquasecurity.github.io/tfsec/v1.28.13/checks/aws/ecr/enforce-immutable-repository/
  image_tag_mutability = var.image_tag_mutability

  image_scanning_configuration {
    # https://aquasecurity.github.io/tfsec/v1.28.13/checks/aws/ecr/enable-image-scans/
    scan_on_push = var.enable_image_scanning
  }

  encryption_configuration {
    encryption_type = "KMS"
    # https://aquasecurity.github.io/tfsec/v1.28.13/checks/aws/ecr/repository-customer-key/
    kms_key = var.kms_key_id
  }

  force_delete = var.force_delete

  lifecycle {
    ignore_changes = [
      encryption_configuration
    ]
  }
}

resource "aws_ecr_lifecycle_policy" "this" {
  for_each = var.enable_lifecycle_policy ? toset(var.repository_names) : []

  repository = aws_ecr_repository.this[each.value].name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last ${var.lifecycle_policy_untagged_image_count} untagged images"
        selection = {
          tagStatus   = "untagged"
          countType   = "imageCountMoreThan"
          countNumber = var.lifecycle_policy_untagged_image_count
        }
        action = {
          type = "expire"
        }
      },
      {
        rulePriority = 2
        description  = "Keep only the last ${var.lifecycle_policy_tagged_image_count} tagged images"
        selection = {
          tagStatus     = "tagged"
          tagPrefixList = var.lifecycle_policy_tag_prefixes
          countType     = "imageCountMoreThan"
          countNumber   = var.lifecycle_policy_tagged_image_count
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}

# https://aquasecurity.github.io/tfsec/v1.28.13/checks/aws/ecr/no-public-access/
resource "aws_ecr_repository_policy" "this" {
  for_each = var.repository_policy != null ? toset(var.repository_names) : []

  repository = aws_ecr_repository.this[each.value].name
  policy     = var.repository_policy

  depends_on = [aws_ecr_repository.this]
}
