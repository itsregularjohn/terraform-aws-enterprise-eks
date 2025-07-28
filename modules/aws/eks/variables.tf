variable "vpc_id" {
  description = "ID of the VPC where the EKS cluster will be deployed"
  type        = string
}

variable "private_subnets" {
  description = "List of private subnet IDs for the EKS cluster"
  type        = list(string)
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "example"
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.31"
}

variable "cluster_endpoint_public_access" {
  description = "Whether the Amazon EKS public API server endpoint is enabled"
  type        = bool
  default     = true
}

variable "enable_cluster_creator_admin_permissions" {
  description = "Whether to enable cluster creator admin permissions"
  type        = bool
  default     = true
}

variable "cloudwatch_log_group_retention_in_days" {
  description = "Number of days to retain log events in the specified log group"
  type        = number
  default     = 1827
}

variable "kms_key_arn" {
  description = "ARN of the KMS key to use for EKS cluster encryption. If not provided, module will create its own key."
  type        = string
  default     = null
}

variable "enable_secrets_encryption" {
  description = "Whether to enable EKS secrets encryption"
  type        = bool
  default     = true
}


variable "sso_terraform_role_arn" {
  description = "ARN of the SSO TerraformExecution role for EKS access"
  type        = string
}
