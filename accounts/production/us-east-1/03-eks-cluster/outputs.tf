output "cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = module.eks_cluster.cluster_endpoint
  sensitive   = true
}

output "cluster_name" {
  description = "EKS cluster name"
  value       = module.eks_cluster.cluster_name
}

output "cluster_arn" {
  description = "EKS cluster ARN"
  value       = module.eks_cluster.cluster_arn
}

output "cluster_certificate_authority_data" {
  description = "EKS cluster certificate authority data"
  value       = module.eks_cluster.cluster_certificate_authority_data
}

output "oidc_provider_arn" {
  description = "EKS OIDC provider ARN"
  value       = module.eks_cluster.oidc_provider_arn
}

output "node_security_group_id" {
  description = "Security group ID for EKS nodes"
  value       = module.eks_cluster.node_security_group_id
}