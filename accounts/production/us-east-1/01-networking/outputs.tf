output "vpc_id" {
  description = "VPC ID for use in other modules"
  value       = module.networking.vpc_id
}

output "private_subnets" {
  description = "Private subnet IDs for EKS nodes"
  value       = module.networking.private_subnets
}

output "public_subnets" {
  description = "Public subnet IDs for load balancers"
  value       = module.networking.public_subnets
}
