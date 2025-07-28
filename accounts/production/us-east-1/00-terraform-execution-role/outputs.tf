output "terraform_execution_role_arn" {
  description = "ARN of the TerraformExecutionRole"
  value       = aws_iam_role.terraform_execution.arn
}

output "terraform_execution_role_name" {
  description = "Name of the TerraformExecutionRole"
  value       = aws_iam_role.terraform_execution.name
}
