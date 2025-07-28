variable "vpc_name" {
  description = "Name of the VPC where the VPN Gateway is located"
  type        = string
}

variable "client_key" {
  description = "Secret key identifier for retrieving VPN configuration from AWS Secrets Manager (vpn/{client_key})"
  type        = string
}

variable "client_name" {
  description = "Name for the VPN client, used for tagging resources"
  type        = string
}
