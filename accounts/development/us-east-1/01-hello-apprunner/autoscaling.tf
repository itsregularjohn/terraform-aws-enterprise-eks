resource "aws_apprunner_auto_scaling_configuration_version" "hello" {
  auto_scaling_configuration_name = "hello-app-autoscaling"

  max_concurrency = 10
  max_size        = 2
  min_size        = 1
}
