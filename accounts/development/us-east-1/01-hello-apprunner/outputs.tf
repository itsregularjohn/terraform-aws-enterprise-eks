output "service_arn" {
  description = "ARN of the App Runner service"
  value       = aws_apprunner_service.hello.arn
}

output "service_url" {
  description = "URL of the App Runner service"
  value       = aws_apprunner_service.hello.service_url
}

output "service_id" {
  description = "ID of the App Runner service"
  value       = aws_apprunner_service.hello.service_id
}

output "console_url" {
  description = "AWS Console URL for the App Runner service"
  value       = "https://${data.aws_region.current.name}.console.aws.amazon.com/apprunner/home#/services/dashboard?service_arn=${aws_apprunner_service.hello.arn}"
}

output "ecr_repository_url" {
  description = "ECR repository URL for the hello app"
  value       = "${local.services_account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com/hello"
}

output "service_status" {
  description = "App Runner service status and configuration"
  value = {
    status                = aws_apprunner_service.hello.status
    created_at           = aws_apprunner_service.hello.created_at
    updated_at           = aws_apprunner_service.hello.updated_at
    auto_scaling_config  = aws_apprunner_auto_scaling_configuration_version.hello.arn
    observability_config = aws_apprunner_observability_configuration.hello.arn
  }
}
