locals {
  valid_repository_names = [
    for name in var.repository_names : 
    name if can(regex("^[a-z0-9]+(?:[._-][a-z0-9]+)*$", name))
  ]
  
  invalid_names = setsubtract(toset(var.repository_names), toset(local.valid_repository_names))
}
