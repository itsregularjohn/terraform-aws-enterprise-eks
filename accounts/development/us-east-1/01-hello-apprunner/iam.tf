resource "aws_iam_role" "apprunner_ecr_access" {
  name = "hello-apprunner-ecr-access-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "build.apprunner.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "apprunner_ecr_access" {
  role       = aws_iam_role.apprunner_ecr_access.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSAppRunnerServicePolicyForECRAccess"
}

resource "aws_iam_policy" "cross_account_ecr_access" {
  name        = "hello-cross-account-ecr-access"
  description = "Policy for accessing ECR repositories in services account"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:GetAuthorizationToken"
        ]
        Resource = [
          "arn:aws:ecr:${data.aws_region.current.name}:${local.services_account_id}:repository/hello",
          "arn:aws:ecr:${data.aws_region.current.name}:${local.services_account_id}:repository/hello/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cross_account_ecr_access" {
  role       = aws_iam_role.apprunner_ecr_access.name
  policy_arn = aws_iam_policy.cross_account_ecr_access.arn
}

resource "aws_iam_role" "apprunner_instance" {
  name = "hello-apprunner-instance-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "tasks.apprunner.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "apprunner_instance_policy" {
  name        = "hello-apprunner-instance-policy"
  description = "Policy granting Hello App runtime permissions"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "xray:PutTraceSegments",
          "xray:PutTelemetryRecords"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/apprunner/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "apprunner_instance_policy_attach" {
  role       = aws_iam_role.apprunner_instance.name
  policy_arn = aws_iam_policy.apprunner_instance_policy.arn
}
