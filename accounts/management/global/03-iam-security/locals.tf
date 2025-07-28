locals {
  group_memberships = {
    "billing-admins" = [
      "admin@example.com",
      "finance@example.com"
    ]
    "billing-viewers" = [
      "manager@example.com",
      "analyst@example.com"
    ]
    "organization-admins" = [
      "admin@example.com"
    ]
    "security-auditors" = [
      "security@example.com",
      "compliance@example.com"
    ]
    "terraform-operators" = [
      "devops@example.com",
      "automation@example.com"
    ]
  }
}
