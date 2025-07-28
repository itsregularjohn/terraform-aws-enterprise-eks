variable "vpc_name" {
  description = "Name of the VPC where the bastion host will be deployed"
  type        = string
}

variable "cluster_name" {
  description = "Name of the EKS cluster for kubectl configuration"
  type        = string
  default     = "production-cluster"
}

variable "private_subnets" {
  description = "List of private subnet IDs where the bastion host can be deployed"
  type        = list(string)
}

variable "log_archive_days" {
  description = "Number of days to wait before archiving to Glacier"
  type        = number
  default     = 30
}

variable "log_expire_days" {
  description = "Number of days to wait before deleting (5 years for compliance)"
  type        = number
  default     = 1827 # 5 years
}

variable "access_log_expire_days" {
  description = "Number of days to wait before deleting access logs (5 years for compliance)"
  type        = number
  default     = 1827 # 5 years
}

variable "kms_key_deletion_window" {
  description = "Waiting period for scheduled KMS Key deletion. Can be 7-30 days."
  type        = number
  default     = 7
}

variable "cloudwatch_logs_retention" {
  description = "Number of days to retain Session Logs in CloudWatch (5 years for compliance)"
  type        = number
  default     = 1827 # 5 years
}

variable "cloudwatch_log_group_name" {
  description = "Name of the CloudWatch Log Group for storing SSM Session Logs"
  type        = string
  default     = "/ssm/session"
}

variable "vpc_id" {
  description = "VPC ID to deploy endpoints into"
  type        = string
  default     = null
}

variable "subnet_ids" {
  description = "Subnet IDs to deploy VPC endpoints into"
  type        = set(string)
  default     = []
}

variable "vpc_endpoint_private_dns_enabled" {
  description = "Enable private DNS for VPC endpoints"
  type        = bool
  default     = true
}

variable "enable_log_to_s3" {
  description = "Enable Session Manager to log to S3"
  type        = bool
  default     = true
}

variable "enable_log_to_cloudwatch" {
  description = "Enable Session Manager to log to CloudWatch Logs"
  type        = bool
  default     = true
}

variable "linux_shell_profile" {
  description = "The shell profile to use for Linux-based machines"
  type        = string
  default     = ""
}

variable "windows_shell_profile" {
  description = "The shell profile to use for Windows-based machines"
  type        = string
  default     = ""
}

variable "instance_type" {
  description = "EC2 instance type for the bastion host"
  type        = string
  default     = "t3.micro"
}

variable "root_volume_size" {
  description = "Size of the root EBS volume in GB"
  type        = number
  default     = 20
}
