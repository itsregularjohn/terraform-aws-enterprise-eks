output "bastion_instance_id" {
  description = "Bastion host instance ID for SSM access"
  value       = module.bastion_host.instance_id
}

output "bastion_security_group_id" {
  description = "Security group ID for the bastion host"
  value       = module.bastion_host.security_group_id
}
