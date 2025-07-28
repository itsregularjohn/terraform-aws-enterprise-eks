output "redis_url" {
  description = "Primary endpoint address of the ElastiCache replication group"
  value       = aws_elasticache_replication_group.this.primary_endpoint_address
}

output "ingress_sg" {
  description = "Security group that allows inbound traffic to ElastiCache"
  value       = aws_security_group.ingress
}

output "egress_sg" {
  description = "Security group that allows outbound traffic to ElastiCache"
  value       = aws_security_group.egress
}

output "replication_group_id" {
  description = "ID of the ElastiCache replication group"
  value       = aws_elasticache_replication_group.this.replication_group_id
}

output "subnet_group_name" {
  description = "Name of the ElastiCache subnet group"
  value       = aws_elasticache_subnet_group.this.name
}
