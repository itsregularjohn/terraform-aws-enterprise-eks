resource "aws_organizations_organizational_unit" "security" {
  name      = "Security"
  parent_id = data.aws_organizations_organization.main.roots[0].id

  tags = {
    Name = "Security OU"
    Type = "Foundational"
  }
}

resource "aws_organizations_organizational_unit" "infrastructure" {
  name      = "Infrastructure"
  parent_id = data.aws_organizations_organization.main.roots[0].id

  tags = {
    Name = "Infrastructure OU"
    Type = "Foundational"
  }
}

resource "aws_organizations_organizational_unit" "workloads" {
  name      = "Workloads"
  parent_id = data.aws_organizations_organization.main.roots[0].id

  tags = {
    Name = "Workloads OU"
    Type = "Application"
  }
}

resource "aws_organizations_organizational_unit" "sandbox" {
  name      = "Sandbox"
  parent_id = data.aws_organizations_organization.main.roots[0].id

  tags = {
    Name = "Sandbox OU"
    Type = "Experimental"
  }
}

resource "aws_organizations_organizational_unit" "exceptions" {
  name      = "Exceptions"
  parent_id = data.aws_organizations_organization.main.roots[0].id

  tags = {
    Name = "Exceptions OU"
    Type = "Procedural"
  }
}

resource "aws_organizations_organizational_unit" "transitional" {
  name      = "Transitional"
  parent_id = data.aws_organizations_organization.main.roots[0].id

  tags = {
    Name = "Transitional OU"
    Type = "Procedural"
  }
}

resource "aws_organizations_organizational_unit" "policy_staging" {
  name      = "Policy Staging"
  parent_id = data.aws_organizations_organization.main.roots[0].id

  tags = {
    Name = "Policy Staging OU"
    Type = "Procedural"
  }
}

resource "aws_organizations_organizational_unit" "suspended" {
  name      = "Suspended"
  parent_id = data.aws_organizations_organization.main.roots[0].id

  tags = {
    Name = "Suspended OU"
    Type = "Procedural"
  }
}

resource "aws_organizations_organizational_unit" "individual_business_users" {
  name      = "Individual Business Users"
  parent_id = data.aws_organizations_organization.main.roots[0].id

  tags = {
    Name = "Individual Business Users OU"
    Type = "Advanced"
  }
}

resource "aws_organizations_organizational_unit" "deployments" {
  name      = "Deployments"
  parent_id = data.aws_organizations_organization.main.roots[0].id

  tags = {
    Name = "Deployments OU"
    Type = "Advanced"
  }
}

resource "aws_organizations_organizational_unit" "business_continuity" {
  name      = "Business Continuity"
  parent_id = data.aws_organizations_organization.main.roots[0].id

  tags = {
    Name = "Business Continuity OU"
    Type = "Advanced"
  }
}
