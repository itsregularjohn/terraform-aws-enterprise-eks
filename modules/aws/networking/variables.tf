variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "cluster_name" {
  description = "Name of the EKS cluster (optional). When provided, adds Kubernetes-specific subnet tags"
  type        = string
  default     = null
}

variable "cidr_start" {
  description = "First two octets of the CIDR block (e.g., '10.0' for 10.0.0.0/16)"
  type        = string
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway for private subnets"
  type        = bool
  default     = true
}

variable "enable_vpn_gateway" {
  description = "Enable VPN Gateway"
  type        = bool
  default     = true
}

variable "azs" {
  description = "List of availability zones. If not provided, uses all available AZs in the region"
  type        = list(string)
  default     = null
}

variable "public_subnets" {
  description = "List of public subnet CIDR blocks. If not provided, uses default configuration"
  type        = list(string)
  default     = null
}

variable "private_subnets" {
  description = "List of private subnet CIDR blocks. If not provided, uses default configuration"
  type        = list(string)
  default     = null
}

variable "network_suffix" {
  description = "Network suffix for the VPC CIDR block"
  type        = string
  default     = "16"
}
