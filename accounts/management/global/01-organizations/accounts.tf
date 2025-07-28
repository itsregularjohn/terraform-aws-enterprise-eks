resource "aws_organizations_account" "production" {
  name  = "jp-terraform-showcase-production"
  email = "pedroalves0030+terraform-showcase-production@gmail.com"

  parent_id = aws_organizations_organizational_unit.workloads.id

  role_name = "OrganizationAccountAccessRole"

  tags = {
    Name        = "Production Account"
    Environment = "production"
    Type        = "Workload"
    Essential   = "true"
  }

  lifecycle {
    ignore_changes  = [role_name]
    prevent_destroy = true
  }
}

resource "aws_organizations_account" "sandbox" {
  name  = "jp-terraform-showcase-sandbox"
  email = "pedroalves0030+terraform-showcase-sandbox@gmail.com"

  parent_id = aws_organizations_organizational_unit.sandbox.id

  role_name = "OrganizationAccountAccessRole"

  tags = {
    Name        = "Sandbox Account"
    Environment = "sandbox"
    Type        = "Sandbox"
    Essential   = "true"
  }

  lifecycle {
    ignore_changes  = [role_name]
    prevent_destroy = true
  }
}

resource "aws_organizations_account" "log_archive" {
  count = local.enable_log_archive_account ? 1 : 0

  name  = "jp-terraform-showcase-log-archive"
  email = "pedroalves0030+terraform-showcase-log-archive@gmail.com"

  parent_id = aws_organizations_organizational_unit.security.id

  role_name = "OrganizationAccountAccessRole"

  tags = {
    Name        = "Log Archive Account"
    Environment = "log-archive"
    Type        = "Security"
    Essential   = "false"
  }

  lifecycle {
    ignore_changes  = [role_name]
    prevent_destroy = true
  }
}

resource "aws_organizations_account" "audit" {
  count = local.enable_audit_account ? 1 : 0

  name  = "jp-terraform-showcase-audit"
  email = "pedroalves0030+terraform-showcase-audit@gmail.com"

  parent_id = aws_organizations_organizational_unit.security.id

  role_name = "OrganizationAccountAccessRole"

  tags = {
    Name        = "Audit Account"
    Environment = "audit"
    Type        = "Security"
    Essential   = "false"
  }

  lifecycle {
    ignore_changes  = [role_name]
    prevent_destroy = true
  }
}

resource "aws_organizations_account" "monitoring" {
  count = local.enable_monitoring_account ? 1 : 0

  name  = "jp-terraform-showcase-monitoring"
  email = "pedroalves0030+terraform-showcase-monitoring@gmail.com"

  parent_id = aws_organizations_organizational_unit.infrastructure.id

  role_name = "OrganizationAccountAccessRole"

  tags = {
    Name        = "Monitoring Account"
    Environment = "monitoring"
    Type        = "Infrastructure"
    Essential   = "false"
  }

  lifecycle {
    ignore_changes  = [role_name]
    prevent_destroy = true
  }
}

resource "aws_organizations_account" "networking" {
  count = local.enable_networking_account ? 1 : 0

  name  = "jp-terraform-showcase-networking"
  email = "pedroalves0030+terraform-showcase-networking@gmail.com"

  parent_id = aws_organizations_organizational_unit.infrastructure.id

  role_name = "OrganizationAccountAccessRole"

  tags = {
    Name        = "Networking Account"
    Environment = "networking"
    Type        = "Infrastructure"
    Essential   = "false"
  }

  lifecycle {
    ignore_changes  = [role_name]
    prevent_destroy = true
  }
}

resource "aws_organizations_account" "backup" {
  count = local.enable_backup_account ? 1 : 0

  name  = "jp-terraform-showcase-backup"
  email = "pedroalves0030+terraform-showcase-backup@gmail.com"

  parent_id = aws_organizations_organizational_unit.infrastructure.id

  role_name = "OrganizationAccountAccessRole"

  tags = {
    Name        = "Backup Account"
    Environment = "backup"
    Type        = "Infrastructure"
    Essential   = "false"
  }

  lifecycle {
    ignore_changes  = [role_name]
    prevent_destroy = true
  }
}

resource "aws_organizations_account" "development" {
  count = local.enable_development_account ? 1 : 0

  name  = "jp-terraform-showcase-development"
  email = "pedroalves0030+terraform-showcase-development@gmail.com"

  parent_id = aws_organizations_organizational_unit.workloads.id

  role_name = "OrganizationAccountAccessRole"

  tags = {
    Name        = "Development Account"
    Environment = "development"
    Type        = "Workload"
    Essential   = "false"
  }

  lifecycle {
    ignore_changes  = [role_name]
    prevent_destroy = true
  }
}

resource "aws_organizations_account" "staging" {
  count = local.enable_staging_account ? 1 : 0

  name  = "jp-terraform-showcase-staging"
  email = "pedroalves0030+terraform-showcase-staging@gmail.com"

  parent_id = aws_organizations_organizational_unit.workloads.id

  role_name = "OrganizationAccountAccessRole"

  tags = {
    Name        = "Staging Account"
    Environment = "staging"
    Type        = "Workload"
    Essential   = "false"
  }

  lifecycle {
    ignore_changes  = [role_name]
    prevent_destroy = true
  }
}

resource "aws_organizations_account" "services" {
  count = local.enable_services_account ? 1 : 0

  name  = "jp-terraform-showcase-services"
  email = "pedroalves0030+terraform-showcase-services@gmail.com"

  parent_id = aws_organizations_organizational_unit.infrastructure.id

  role_name = "OrganizationAccountAccessRole"

  tags = {
    Name        = "Services Account"
    Environment = "services"
    Type        = "Infrastructure"
    Essential   = "false"
  }

  lifecycle {
    ignore_changes  = [role_name]
    prevent_destroy = true
  }
}
