provider "aws" {
  region  = "us-east-1"
  profile = "terraform-showcase"

  assume_role {
    role_arn     = "arn:aws:iam::${local.development_account_id}:role/TerraformExecutionRole"
    session_name = "terraform-development-hello-apprunner"
    external_id  = "terraform-deployment"
  }
}

resource "aws_apprunner_observability_configuration" "hello" {
  observability_configuration_name = "hello-app-development"

  trace_configuration {
    vendor = "AWSXRAY"
  }
}

resource "aws_apprunner_service" "hello" {
  service_name = local.service_name

  source_configuration {
    authentication_configuration {
      access_role_arn = aws_iam_role.apprunner_ecr_access.arn
    }

    image_repository {
      image_configuration {
        port = "3000"
        runtime_environment_variables = {
          "NODE_ENV"    = "development"
          "APP_NAME"    = "hello"
          "AWS_REGION"  = data.aws_region.current.name
          "LOG_LEVEL"   = "debug"
        }
      }

      image_identifier      = "${local.services_account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com/hello:latest"
      image_repository_type = "ECR"
    }
  }

  observability_configuration {
    observability_enabled            = true
    observability_configuration_arn = aws_apprunner_observability_configuration.hello.arn
  }

  auto_scaling_configuration_arn = aws_apprunner_auto_scaling_configuration_version.hello.arn

  health_check_configuration {
    path                = "/healthz"
    healthy_threshold   = 3
    interval           = 10
    protocol           = "HTTP"
    timeout            = 5
    unhealthy_threshold = 3
  }

  instance_configuration {
    cpu    = "0.25 vCPU"
    memory = "0.5 GB"
    
    instance_role_arn = aws_iam_role.apprunner_instance.arn
  }
}
