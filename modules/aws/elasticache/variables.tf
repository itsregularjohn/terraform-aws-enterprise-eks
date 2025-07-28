variable "vpc_id" {
  description = "ID of the VPC where ElastiCache will be deployed"
  type        = string
}

variable "vpc_name" {
  description = "Name prefix for ElastiCache resources"
  type        = string
}

variable "description" {
  description = "Description for the ElastiCache replication group"
  type        = string
}

variable "node_type" {
  description = "The compute and memory capacity of the nodes in the node group (shard)"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the ElastiCache subnet group"
  type        = list(string)
}

variable "target_security_group" {
  description = "Security group ID that should have access to ElastiCache"
  type        = string
  default     = ""
}
