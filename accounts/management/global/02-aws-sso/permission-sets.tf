resource "aws_ssoadmin_permission_set" "administrator" {
  name             = "AdministratorAccess"
  description      = "Full administrator access to all AWS services"
  instance_arn     = local.instance_arn
  session_duration = "PT8H"

  tags = {
    Name = "AdministratorAccess"
  }
}

resource "aws_ssoadmin_managed_policy_attachment" "administrator" {
  instance_arn       = local.instance_arn
  managed_policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  permission_set_arn = aws_ssoadmin_permission_set.administrator.arn
}

resource "aws_ssoadmin_permission_set" "readonly" {
  name             = "ReadOnlyAccess"
  description      = "Read-only access to all AWS services"
  instance_arn     = local.instance_arn
  session_duration = "PT4H"

  tags = {
    Name = "ReadOnlyAccess"
  }
}

resource "aws_ssoadmin_managed_policy_attachment" "readonly" {
  instance_arn       = local.instance_arn
  managed_policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
  permission_set_arn = aws_ssoadmin_permission_set.readonly.arn
}

resource "aws_ssoadmin_permission_set" "developer" {
  name             = "DeveloperAccess"
  description      = "Developer access for sandbox and development environments"
  instance_arn     = local.instance_arn
  session_duration = "PT4H"

  tags = {
    Name = "DeveloperAccess"
  }
}

resource "aws_ssoadmin_permission_set_inline_policy" "developer" {
  inline_policy      = data.aws_iam_policy_document.developer.json
  instance_arn       = local.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.developer.arn
}

resource "aws_ssoadmin_permission_set" "eks_cluster_admin" {
  name             = "EKSClusterAdmin"
  description      = "Full EKS cluster administrative access"
  instance_arn     = local.instance_arn
  session_duration = "PT8H"

  tags = {
    Name = "EKSClusterAdmin"
  }
}

resource "aws_ssoadmin_permission_set_inline_policy" "eks_cluster_admin" {
  inline_policy      = data.aws_iam_policy_document.eks_cluster_admin.json
  instance_arn       = local.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.eks_cluster_admin.arn
}

resource "aws_ssoadmin_permission_set" "eks_developer" {
  name             = "EKSDeveloper"
  description      = "EKS developer access for application deployment"
  instance_arn     = local.instance_arn
  session_duration = "PT4H"

  tags = {
    Name = "EKSDeveloper"
  }
}

resource "aws_ssoadmin_permission_set_inline_policy" "eks_developer" {
  inline_policy      = data.aws_iam_policy_document.eks_developer.json
  instance_arn       = local.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.eks_developer.arn
}

resource "aws_ssoadmin_permission_set" "terraform_execution" {
  name             = "TerraformExecution"
  description      = "Terraform infrastructure management"
  instance_arn     = local.instance_arn
  session_duration = "PT8H"

  tags = {
    Name = "TerraformExecution"
  }
}

resource "aws_ssoadmin_managed_policy_attachment" "terraform_execution" {
  instance_arn       = local.instance_arn
  managed_policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  permission_set_arn = aws_ssoadmin_permission_set.terraform_execution.arn
}

resource "aws_ssoadmin_permission_set" "infrastructure_admin" {
  name             = "InfrastructureAdmin"
  description      = "Administrative access for infrastructure accounts"
  instance_arn     = local.instance_arn
  session_duration = "PT8H"

  tags = {
    Name = "InfrastructureAdmin"
  }
}

resource "aws_ssoadmin_managed_policy_attachment" "infrastructure_admin" {
  instance_arn       = local.instance_arn
  managed_policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  permission_set_arn = aws_ssoadmin_permission_set.infrastructure_admin.arn
}

resource "aws_ssoadmin_permission_set" "security_admin" {
  name             = "SecurityAdmin"
  description      = "Administrative access for security accounts"
  instance_arn     = local.instance_arn
  session_duration = "PT8H"

  tags = {
    Name = "SecurityAdmin"
  }
}

resource "aws_ssoadmin_managed_policy_attachment" "security_admin" {
  instance_arn       = local.instance_arn
  managed_policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  permission_set_arn = aws_ssoadmin_permission_set.security_admin.arn
}
