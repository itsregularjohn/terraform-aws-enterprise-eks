resource "aws_iam_role" "terraform_execution" {
  name = "TerraformExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = [
            "arn:aws:iam::${local.management_account_id}:root",
            "arn:aws:iam::${local.production_account_id}:root"
          ]
        }
        Action = "sts:AssumeRole"
        Condition = {
          StringEquals = {
            "sts:ExternalId" = "terraform-deployment"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "terraform_admin_access" {
  role       = aws_iam_role.terraform_execution.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
